" StlShowFunc_dbg.vim :	a ftplugin for DrChip's internal debugger files
" Author:	Charles E. Campbell, Jr.
" Date:		Aug 23, 2006
" Version:  2b	ASTRO-ONLY
" ---------------------------------------------------------------------
"  Load Once: {{{1
if exists("b:loaded_StlShowFunc_dbg")
 finish
endif
let b:loaded_StlShowFunc_dbg= "v2b"

" ---------------------------------------------------------------------
" StlShowFunc_dbg: show function name associated with line under cursor {{{1
fun! StlShowFunc_dbg()
"  call Dfunc("StlShowFunc_dbg() mode=".mode())
  if mode() != 'n'
"   call Dret("StlShowFunc_dbg")
   return
  endif

  " initialization:
  if !exists("b:dbgshowfunc_funcline")
   let b:dbgshowfunc_funcline= -2
   let s:funcname            = ""
  endif

  " determine searchpairpos for {}
  let stopline= line(".") - 200
  if stopline <= 0 | let stopline= 1 | endif
  let [funcline,funccol] = searchpairpos('{$','','}$','Wbn','',stopline)
"  call Decho("funcline=".funcline." funccol=".funccol." b:dbgshowfunc_funcline=".b:dbgshowfunc_funcline." stopline=".stopline." curline=".line("."))

  if funcline == 0 || funccol == 0
   " occurs when searchpairpos() fails
   let b:dbgshowfunc_funcline= -2
   call StlSetFunc("")
"   call Dret("StlShowFunc_dbg : b:dbgshowfunc_funcline=".b:dbgshowfunc_funcline)
   return
  endif

  if funcline != b:dbgshowfunc_funcline
   let b:dbgshowfunc_funcline= funcline
   let funcname              = substitute(getline(funcline),'^|*\(\h\w*\)(.*$','\1','e')
"   call Decho("funcname<".funcname."> s:funcname<".s:funcname.">")
   if !exists("s:funcname") || funcname != s:funcname
	let s:funcname= funcname
	call StlSetFunc(funcname)
   endif
  else
   let s:funcname= ""
  endif
"  call Dret("StlShowFunc_dbg : b:dbgshowfunc_funcline=".b:dbgshowfunc_funcline)
endfun

" ---------------------------------------------------------------------
"  Enable FtPlugin: {{{1
StlShowFunc "dbg"
augroup STLSHOWFUNC
 au CursorMoved tmp* call StlShowFunc_dbg()
augroup END

" ---------------------------------------------------------------------
"  Modelines: {{{1
" vim: fdm=marker
