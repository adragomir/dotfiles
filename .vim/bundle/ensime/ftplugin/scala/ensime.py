""" ensime client"""

import vim
import os
import select
import socket
import subprocess
import tempfile
import threading
import sexpr
import time

__all__ = ('Client', 'get_ensime_dir')

def get_ensime_dir(cwd):
    """ Return closest dir form ``cwd`` with .ensime file in it"""
    if not os.path.isdir(cwd):
        cwd = os.path.dirname(cwd)
    path = os.path.abspath(cwd)
    if not os.path.isdir(path):
        raise RuntimeError("%s is not a directory" % path)
    if os.path.exists(os.path.join(path, ".ensime")):
        return path
    par = os.path.dirname(path)
    if par == path:
        return None
    if os.access(par, os.R_OK) and os.access(par, os.X_OK):
        return get_ensime_dir(par)
    else:
        return None

class SocketPoller(threading.Thread):
    """ Thread which reads data from socket"""

    def __init__(self, enclosing):
        self.enclosing  = enclosing
        self.ensime_sock = enclosing.ensime_sock
        self.printer    = enclosing.printer
        threading.Thread.__init__(self)

    def read_length(self):
        msg_len = ""
        while len(msg_len) < 6:
            chunk = self.ensime_sock.recv(6 - len(msg_len))
            if chunk == "":
                raise RuntimeError("socket connection broken (read)")
            msg_len = msg_len + chunk

        return int(msg_len, 16)

    def read_msg(self, msg_len):
        msg = ""
        while len(msg) < msg_len:
            chunk = self.ensime_sock.recv(msg_len - len(msg))
            if chunk == "":
                raise RuntimeError("socket connection broken (read)")
            msg = msg + chunk
        return msg.decode('utf-8')

    def run(self):
        while not self.enclosing.shutdown:
            try:
                msg_len = self.read_length()
                msg = self.read_msg(msg_len)
                parsed = sexpr.parse(msg)
                # dispatch to handler or just print unhandled
                self.enclosing.on(parsed)
            except Exception as e:
                msg = unicode(e).encode('utf8').replace('"', '\\"')
                self.printer.err('exception in reader thread: %s' % msg)

def ensime_home():
    result = os.getenv("ENSIMEHOME")
    if not result:
        cwd = os.path.dirname(__file__)
        result = os.path.join(cwd, '..', '..', 'dist')
    return result

class Client(object):

    ENSIMESERVER = "bin/server"
    ENSIMEWD = ensime_home()

    def __init__(self, printer):
        self.ensimeproc = None
        self.ensimeport = None
        self.ensime_sock = None
        self.last_message_id = 1
        self.lock = threading.Lock()
        self.waiting_lock = threading.Lock()
        self.poller = None
        self.DEVNULL = open("/dev/null", "w")
        self.printer = printer
        self.started = False
        self.shutdown  = False

        # mapping from message id to event or result of RPC,
        # oh... we need futures for that
        self.waiting = {}

    def on(self, message):
        handler_name = 'on_' + message[0][1:].replace('-', '_')

        if hasattr(self, handler_name):
            handler = getattr(self, handler_name)
            handler(message)

        elif message[0] == ":background-message":
            if message[1] in (105,):
                return self.on_message(message[2])

        elif message[0] == ":return":
            _, data, num = message
            with self.waiting_lock:
                if num in self.waiting:
                    handler = self.waiting.pop(num)
                    if callable(handler):
                        return handler(data)
                    else: # threading.Event
                        self.waiting[num] = data
                        handler.set()
                        return True

        else:
            self.printer.out(message)

    def on_clear_all_scala_notes(self, message):
        vim.eval('setqflist([])')

    def on_indexer_ready(self, message):
        self.printer.out('indexer ready')

    def on_full_typecheck_finished(self, message):
        self.printer.out('full typecheck finished')

    def on_compiler_ready(self, message):
        self.printer.out('compiler ready')

    def on_scala_notes(self, message):
        with open('/Users/adr/output.txt', 'ab+') as f:
            f.write("%s\n\n" % message)
        notes = sexpr.to_mapping(message[1])['notes']
        for note in notes:
            note = sexpr.to_mapping(note)
            if note.get('severity') == 'error':
                print note
                command = 'caddexpr "%(file)s:%(line)s:%(col)s:%(msg)s"' % note
                print command
                try:
                    vim.command(command)
                except vim.error as e:
                    self.printer.err(e)

    def on_message(self, msg):
        self.printer.out(msg)

    def fresh_msg_id(self):
        with self.lock:
            self.last_message_id += 1
            return self.last_message_id

    def connect(self, cwd):
        if self.shutdown:
            raise RuntimeError(
                "cannot reconnect client once it has been disconnected")
        if self.started:
            raise RuntimeError("client already running")
        if self.ENSIMEWD is None:
            raise RuntimeError("environment variable ENSIMEHOME is not set")
        ensime_dir = get_ensime_dir(cwd)
        if ensime_dir is None:
            raise RuntimeError(
                "could not find '.ensime' file in any parent directory")
        tfname = tempfile.NamedTemporaryFile(
            prefix="ensimeportinfo",delete=False).name
        self.ensimeproc = subprocess.Popen([self.ENSIMESERVER, tfname],
                cwd=self.ENSIMEWD, stdin=None, stdout=self.DEVNULL,
                stderr=self.DEVNULL, shell=False, env=None)
        self.printer.out("waiting for port number...")

        while True:
            with open(tfname, 'r') as fh:
                line = fh.readline()
                if line != '':
                    self.ensimeport = int(line.strip())
                    break
                time.sleep(1)

        self.started = True
        self.printer.out("port number is %d." % self.ensimeport)
        self.ensime_sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
        self.ensime_sock.connect(("127.0.0.1", self.ensimeport))
        self.poller = SocketPoller(self)
        self.poller.start()

        def print_result(data):
            if data[0] == ':ok':
                result = sexpr.to_mapping(data[1])
                project_name = result['project-name']
                if project_name:
                    self.printer.out('initialized %s' % project_name)
                else:
                    self.printer.out('initialized')
            else:
                self.printer.err('cannot initialize project: %s' % data)
            return True

        self.async_call_cb(print_result, "init-project", {"root-dir": ensime_dir})

    def typecheck(self, filename):
        def print_result(data):
            with open('/Users/adr/output.txt', 'ab+') as f:
                f.write("%s\n\n" % data[1])

            if data[0] == ':ok':
                self.printer.out('typecheck done')
            else:
                self.printer.err('error while doing typecheck: %s' % data)
            return True
        self.async_call_cb(print_result, "typecheck-file", filename)

    def typecheck_all(self):
        def print_result(data):
            with open('/Users/adr/output.txt', 'ab+') as f:
                f.write("%s\n\n" % data[1])
            if data[0] == ':ok':
                self.printer.out('typecheck done')
            else:
                self.printer.err('error while doing typecheck: %s' % data)
            return True
        self.async_call_cb(print_result, "typecheck-all")

    def type_at_point(self, filename, offset):
        def print_result(data):
            with open('/Users/adr/output.txt', 'ab+') as f:
                f.write("%s\n\n" % data[1])
            if data[0] == ':ok':
                result = sexpr.to_mapping(data[1])
                self.printer.out(result['full-name'])
            else:
                self.printer.err('error while determining type: %s' % data)
            return True
        self.async_call_cb(print_result, "type-at-point", filename, offset)

    def symbol_at_point(self, filename, offset):
        def print_result(data):
            with open('/Users/adr/output.txt', 'ab+') as f:
                f.write("%s\n\n" % data[1])
            if data[0] == ':ok':
                result = sexpr.to_mapping(data[1])
                self.printer.out(result['full-name'])
            else:
                self.printer.err('error while determining symbol: %s' % data)
            return True
        self.async_call_cb(print_result, "symbol-at-point", filename, offset)

    def completions(self, filename, offset):
        data = self.sync_call("completions", filename, offset, 0, True, True)
        with open('/Users/adr/output.txt', 'ab+') as f:
            f.write("%s\n\n" % data[1])
        if data[0] == ":ok":
            result = sexpr.to_mapping(data[1])
            result.setdefault('completions', [])
            result['completions'] = [
                sexpr.to_mapping(x) for x in result['completions']]
            return result
        else:
            self.printer.err(data)

    def touch_source(self, filename, sync=True):
        if sync:
            self.sync_call("patch-source", filename, [])
        else:
            self.async_call("patch-source", filename, [])

    def sync_call(self, procname, *args):
        """ Make RPC synchronously"""
        with self.waiting_lock:
            event = threading.Event()
            m_id = self.swank_send(rpc(procname, *args))
            self.waiting[m_id] = event

        if not event.wait(5):
            self.printer.err("timeout on completion")

        else:
            with self.waiting_lock:
                data = self.waiting.pop(m_id)
            return data

    def async_call_cb(self, callback, procname, *args):
        """ Make RPC asynchronously"""
        with self.waiting_lock:
            m_id = self.swank_send(rpc(procname, *args))
            self.waiting[m_id] = callback

    def async_call(self, procname, *args):
        self.swank_send(rpc(procname, *args))

    def swank_send(self, message):
        """ Compose swant rpc message and send it to the socket"""
        if self.ensime_sock != None:
            m_id = self.fresh_msg_id()
            full_msg = "(:swank-rpc %s %d)" % (message, m_id)
            msg_len = len(full_msg)
            as_hex = hex(msg_len)[2:]
            as_hex_padded = (6-len(as_hex))*"0" + as_hex
            self.ensime_sock.sendall(as_hex_padded + full_msg)
        return m_id

    def disconnect(self):
        """ Disconnect from Ensime"""
        self.printer.out("disconnecting...")
        self.shutdown = True
        self.swank_send(rpc("shutdown-server"))
        self.printer.out("disconnected")
        if self.ensimeproc is not None:
            self.ensimeproc.kill()
        self.ensimeport = None

    def __del__(self):
        self.disconnect()

def rpc(procname, *args):
    return sexpr.serialize([sexpr.atom('swank:%s' % procname)] + list(args))
