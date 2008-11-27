#!/usr/bin/python

import os
import sys

if os.name == 'posix':

	def become_daemon(ourHomeDir='.',outLog='/dev/null',errLog='/dev/null'):
		"""
		Robustly turn us into a UNIX daemon, running in ourHomeDir.
		Modelled after the original code of this module and some
		sample code from the net.
		"""

		# first fork
		try:
			if os.fork() > 0:
				sys.exit(0)     # kill off parent
		except OSError, e:
			sys.stderr.write("fork #1 failed: (%d) %s\n" % (e.errno, e.strerror))
			sys.exit(1)
		os.setsid()
		os.chdir(ourHomeDir)
		os.umask(0)
		# second fork
		try:
			if os.fork() > 0:
				sys.exit(0)
		except OSError, e:
			sys.stderr.write("fork #2 failed: (%d) %s\n" % (e.errno, e.strerror))
			sys.exit(1)

		si = open('/dev/null', 'r')
		so = open(outLog, 'a+', 0)
		se = open(errLog, 'a+', 0)
		os.dup2(si.fileno(), sys.stdin.fileno())
		os.dup2(so.fileno(), sys.stdout.fileno())
		os.dup2(se.fileno(), sys.stderr.fileno())

else:

	def become_daemon(ourHomeDir='.',outLog=None,errLog=None):
		"""
		If we are not running under a POSIX system, just simulate
		the daemon mode by doing redirections and directory changeing
		"""

		os.chdir(ourHomeDir)
		os.umask(0)
		sys.stdin.close()
		sys.stdout.close()
		sys.stderr.close()
        	if errLog and outLog:
            		sys.stderr=open (errLog, 'a', 0)
            		sys.stdout=open (outLog, 'a', 0)
		elif errLog:
	    		sys.stderr=open (errLog, 'a', 0)
	    		sys.stdout=NullDevice ()
		elif outLog:
	    		sys.stdout=open (outLog, 'a', 0)
	    		sys.stderr=NullDevice ()
        	else:
	    		sys.stdout = NullDevice()
	    		sys.stderr = NullDevice()

	class NullDevice:
		"""
		A substitute for stdout and stderr that writes to nowhere.
		This is a substitute for /dev/null
		"""
	
		def write(self, s):
			pass

def main():
	from flup.server.fcgi_fork import WSGIServer
	from django.core.handlers.wsgi import WSGIHandler

	import getopt

	(opts, args) = getopt.getopt(sys.argv[1:], 'f:s:h:p:',
		['settings=','socket=','host=','port=',
		 'minspare=', 'maxspare=', 'maxchildren=',
		 'daemon', 'etclog=', 'errorlog=', 'workdir='])
	
	socket = None
	host = None
	port = None

	minspare = 1
	maxspare = 5
	maxchildren = 50

	daemon = None
	workdir = '.'
	etclog = '/dev/null'
	errorlog = '/dev/null'

	for (o, v) in opts:
		if o in ('-s', '--socket'):
			socket = v
		elif o in ('-h', '--host'):
			host = v
		elif o in ('-p', '--port'):
			port = int(v)
		elif o in ('-f', '--settings'):
			os.environ['DJANGO_SETTINGS_MODULE'] = v
		elif o in ('--minspare',):
			minspare = int(v)
		elif o in ('--maxspare',):
			maxspare = int(v)
		elif o in ('--maxchildren',):
			maxchildren = int(v)
		elif o in ('--daemon',):
			daemon = 1
		elif o in ('--errorlog',):
			errorlog = v
		elif o in ('--etclog',):
			etclog = v
		elif o in ('--workdir',):
			workdir = v

	# if we should run as a daemon, use the above function to turn us
	# into one reliably. This should correctly detach from the tty.
	if daemon:
		become_daemon(ourHomeDir=workdir,
			outLog=etclog, errLog=errorlog)

	if socket and not host and not port:
		WSGIServer(WSGIHandler(), minSpare=minspare, maxSpare=maxspare, maxChildren=maxchildren, bindAddress=socket).run()
	elif not socket and host and port:
		WSGIServer(WSGIHandler(), minSpare=minspare, maxSpare=maxspare, maxChildren=maxchildren, bindAddress=(host, port)).run()
	else:
		print "usage: django-fcgi.py [--settings=<settingsmodule>] --socket=<socketname>"
		print "   or: django-fcgi.py [--settings=<settingsmodule>] --host==<hostname> --port=<portnumber>"
		print
		print "   additional options are:"
		print "      --minspare=<minimum number of spare processes, default 1>"
		print "      --maxspare=<maximum number of spare processes, default 5>"
		print "      --maxchildren=<maximum number of child processes, default 50>"
		print
		print "      --daemon"
		print "      --etclog=<path for stdout log, default /dev/null>"
		print "      --errorlog=<path for stderr log, default /dev/null>"
		print "      --workdir=<path for working directory, default .>"

if __name__ == '__main__':

	# first patch our own version of socketpair into the sockets module
	# if we don't have it already (comes with Python 2.4)

	import socket
	if not hasattr(socket, 'socketpair'):
		import eunuchs.socketpair

		def socketpair():
			(p,c) = eunuchs.socketpair.socketpair()
			return (socket.fromfd(p,1,1), socket.fromfd(c,1,1))

		socket.socketpair = socketpair

	main()

