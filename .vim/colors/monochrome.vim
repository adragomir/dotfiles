" Vim color scheme
"
" This file is generated, please check bin/generate.rb.
"
" Name: monochrome.vim
" Maintainer: Xavier Noria <fxn@hashref.com> 
" License: MIT

set background=dark

hi clear
if exists('syntax_on')
 syntax reset
endif

" Arguments: group, guifg, guibg, gui, guisp
function! s:Hi(group, fg, ...)
  " foreground
  let fg = a:fg
  " background
  if a:0 >= 1
    let bg = a:1
  else
    let bg = s:none
  endif
  " emphasis
  if a:0 >= 2 && strlen(a:2)
    let emstr = a:2
  else
    let emstr = 'none'
  endif

  let histring = [ 'hi', a:group,
        \ 'guifg=' . fg[0], 'ctermfg=' . fg[1],
        \ 'guibg=' . bg[0], 'ctermbg=' . bg[1],
        \ 'gui=' . emstr, 'cterm=' . emstr
        \ ]

  execute join(histring, ' ')
endfunction

let g:colors_name = 'monochrome'

call s:Hi('Error', ['#000000', 16], ['#ff0000', 196], 'NONE')
call s:Hi('Normal', ['#d0d0d0', 252], ['#000000', 16], 'NONE')
call s:Hi('Cursor', ['#000000', 16], ['#d0d0d0', 252], 'NONE')
call s:Hi('CursorLine', ['#d0d0d0', 252], ['#1c1c1c', 234], 'NONE')
call s:Hi('CursorLineNr', ['#ffffff', 15], ['#000000', 16], 'bold')
call s:Hi('FoldColumn', ['#a8a8a8', 248], ['#000000', 16], 'NONE')
call s:Hi('Folded', ['#d0d0d0', 252], ['#000000', 16], 'NONE')
call s:Hi('LineNr', ['#a8a8a8', 248], ['#000000', 16], 'NONE')
call s:Hi('Statement', ['#ffffff', 15], ['#000000', 16], 'bold')
call s:Hi('PreProc', ['#ffffff', 15], ['#000000', 16], 'bold')
call s:Hi('String', ['#ccfeb1', 'green'], ['#000000', 16], 'NONE')
call s:Hi('Comment', ['#767676', 243], ['#000000', 16], 'NONE')
call s:Hi('Constant', ['#d0d0d0', 252], ['#000000', 16], 'NONE')
call s:Hi('Type', ['#ffffff', 15], ['#000000', 16], 'bold')
call s:Hi('Function', ['#ffffff', 15], ['#000000', 16], 'NONE')
call s:Hi('Identifier', ['#d0d0d0', 252], ['#000000', 16], 'NONE')
call s:Hi('Special', ['#d0d0d0', 252], ['#000000', 16], 'NONE')
call s:Hi('MatchParen', ['#000000', 16], ['#d0d0d0', 252], 'NONE')
call s:Hi('rubyConstant', ['#d0d0d0', 252], ['#000000', 16], 'NONE')
call s:Hi('rubySharpBang', ['#767676', 243], ['#000000', 16], 'NONE')
call s:Hi('rubyStringDelimiter', ['#5f87af', 67], ['#000000', 16], 'NONE')
call s:Hi('rubyStringEscape', ['#5f87af', 67], ['#000000', 16], 'NONE')
call s:Hi('rubyRegexpEscape', ['#5f87af', 67], ['#000000', 16], 'NONE')
call s:Hi('rubyRegexpAnchor', ['#5f87af', 67], ['#000000', 16], 'NONE')
call s:Hi('rubyRegexpSpecial', ['#5f87af', 67], ['#000000', 16], 'NONE')
call s:Hi('perlSharpBang', ['#767676', 243], ['#000000', 16], 'NONE')
call s:Hi('perlStringStartEnd', ['#5f87af', 67], ['#000000', 16], 'NONE')
call s:Hi('perlStringEscape', ['#5f87af', 67], ['#000000', 16], 'NONE')
call s:Hi('perlMatchStartEnd', ['#5f87af', 67], ['#000000', 16], 'NONE')
call s:Hi('pythonEscape', ['#5f87af', 67], ['#000000', 16], 'NONE')
call s:Hi('javaScriptFunction', ['#ffffff', 15], ['#000000', 16], 'bold')
call s:Hi('elixirDelimiter', ['#5f87af', 67], ['#000000', 16], 'NONE')
call s:Hi('Search', ['none', 'none'], ['none', 'none'], 'underline')
call s:Hi('Visual', ['none', 'none'], ['#808080', 244], 'NONE')
call s:Hi('NonText', ['#a8a8a8', 248], ['#000000', 16], 'NONE')
call s:Hi('Directory', ['#ffffff', 15], ['#000000', 16], 'bold')
call s:Hi('Title', ['#ffffff', 15], ['#000000', 16], 'bold')
call s:Hi('markdownHeadingDelimiter', ['#ffffff', 15], ['#000000', 16], 'bold')
call s:Hi('markdownHeadingRule', ['#ffffff', 15], ['#000000', 16], 'bold')
call s:Hi('markdownLinkText', ['#5f87af', 67], ['#000000', 16], 'underline')
call s:Hi('Todo', ['#000000', 16], ['#ffff00', 226], 'bold')
call s:Hi('Pmenu', ['#ffffff', 15], ['#5f87af', 67], 'NONE')
call s:Hi('PmenuSel', ['#5f87af', 67], ['#ffffff', 15], 'NONE')
call s:Hi('helpSpecial', ['#d0d0d0', 252], ['#000000', 16], 'NONE')
call s:Hi('helpHyperTextJump', ['#5f87af', 67], ['#000000', 16], 'underline')
call s:Hi('helpNote', ['#d0d0d0', 252], ['#000000', 16], 'NONE')
call s:Hi('vimOption', ['#d0d0d0', 252], ['#000000', 16], 'NONE')
call s:Hi('vimGroup', ['#d0d0d0', 252], ['#000000', 16], 'NONE')
call s:Hi('vimHiClear', ['#d0d0d0', 252], ['#000000', 16], 'NONE')
call s:Hi('vimHiGroup', ['#d0d0d0', 252], ['#000000', 16], 'NONE')
call s:Hi('vimHiAttrib', ['#d0d0d0', 252], ['#000000', 16], 'NONE')
call s:Hi('vimHiGui', ['#d0d0d0', 252], ['#000000', 16], 'NONE')
call s:Hi('vimHiGuiFgBg', ['#d0d0d0', 252], ['#000000', 16], 'NONE')
call s:Hi('vimHiCTerm', ['#d0d0d0', 252], ['#000000', 16], 'NONE')
call s:Hi('vimHiCTermFgBg', ['#d0d0d0', 252], ['#000000', 16], 'NONE')
call s:Hi('vimSynType', ['#d0d0d0', 252], ['#000000', 16], 'NONE')
call s:Hi('vimCommentTitle', ['#767676', 243], ['#000000', 16], 'NONE')
call s:Hi('SpellRare', ['none', 'none'], ['none', 'none'], 'underline')
call s:Hi('SpellBad', ['none', 'none'], ['none', 'none'], 'underline')

"hi WHITE_ON_BLACK ctermfg=white

