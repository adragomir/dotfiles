if !has('python')
  echo "Error: +python support is required."
  finish
endif

python << EOF
if not '__ensime__' in globals():
  print 'hello'
  __ensime__ = True
  import vim, sys
  VIMENSIMEPATH = vim.eval('expand("<sfile>:p:h")')
  sys.path.append(VIMENSIMEPATH)

  from ensime import Client, get_ensime_dir

  class ProjectState(object):

      def __init__(self):
          object.__setattr__(self, '_ProjectState__state', {})

      def __getattr__(self, name):
          try:
              return self.__state[self.get_ident()][name]
          except KeyError:
              raise AttributeError(name)

      def __setattr__(self, name, value):
          self.__state.setdefault(self.get_ident(), {})[name] = value

      def __delattr__(self, name):
          del self.__state.setdefault(self.get_ident(), {})[name]

      def all(self, name):
          keys = self.__state.keys()
          return [self.__state[k][name] for k in keys]

      def get_ident(self):
          return get_ensime_dir(filename())

  class Printer(object):

      def out(self, arg):
          vim.command('echom "ensime: %s"' % arg)
      def err(self, arg):
          vim.command('echohl Error | echom "ensime: %s"' % arg)

  def cursor_offset():
      return int(vim.eval("""LocationOfCursor()"""))

  def filename():
      return vim.eval("""fnameescape(expand("%:p"))""")

  def ensime_start():
      if hasattr(state, 'ensimeclient'):
          printer.err("ensime instance already runned")
      else:
          try:
              currentfiledir = vim.eval("expand('%:p:h')")
              state.ensimeclient = Client(printer)
              state.ensimeclient.connect(currentfiledir)
              state.omniresult = None
          except RuntimeError as msg:
              printer.err(msg)

  def ensime_stop(ensimeclient=None):
      ensimeclient = ensimeclient or state.ensimeclient
      try:
          if ensimeclient is not None:
              ensimeclient.disconnect()
              ensimeclient = None
          else:
              printer.err("no instance running")
      except (ValueError, RuntimeError) as msg:
          printer.err(msg)

  def ensime_stop_all():
      for client in state.all('ensimeclient'):
          ensime_stop(client)

  def omnicompletion(findstart):
      if findstart:
          vim.command("w")
          result = state.ensimeclient.completions(filename(), cursor_offset())
          if not result:
              vim.command("return -1")
          else:
              state.omniresult = result
              position = int(vim.eval("col('.')")) - len(result['prefix']) - 1
              vim.command("return %d" % position)
      else:
          result = state.omniresult
          completions = [{
              'word': x['name'].encode('utf-8'),
            } for x in result['completions']]
          vim.command("return %s" % completions)

  state = ProjectState()
  printer = Printer()
EOF

function! LocationOfCursor()
  let pos = col('.') -1
  let line = getline('.')
  let bc = strpart(line,0,pos)
  let ac = strpart(line, pos, len(line)-pos)
  let col = getpos('.')[2]
  let linesTillC = getline(1, line('.')-1)+[getline('.')[:(col-1)]]
  return len(join(linesTillC,"\n"))
endfunction

function! EnsimeStart()
  py ensime_start()
  autocmd VimLeavePre * call EnsimeStopAll()
endfunction

function! EnsimeStop()
  py ensime_stop()
endfunction

function! EnsimeStopAll()
  py ensime_stop_all()
endfunction

function! EnsimeTypecheckFile()
  py vim.command("w")
  py state.ensimeclient.typecheck(filename())
endfunction

function! EnsimeTypecheckAll()
  py vim.command("w")
  py state.ensimeclient.typecheck_all()
endfunction

function! EnsimeTypeAtPoint()
  py state.ensimeclient.touch_source(filename())
  py state.ensimeclient.type_at_point(filename(), cursor_offset())
endfunction

function! EnsimeSymbolAtPoint()
  py state.ensimeclient.touch_source(filename())
  py state.ensimeclient.symbol_at_point(filename(), cursor_offset())
endfunction

function! EnsimeOmniCompletion(findstart, base)
  if a:findstart
    py omnicompletion(True)
  else
    py omnicompletion(False)
  endif
endfunction

set omnifunc=EnsimeOmniCompletion
command! Ensime call EnsimeStart()
command! EnsimeTypecheckFile call EnsimeTypecheckFile()
command! EnsimeTypecheckAll call EnsimeTypecheckAll()
command! EnsimeTypeAtPoint call EnsimeTypeAtPoint()
command! EnsimeSymbolAtPoint call EnsimeSymbolAtPoint()
