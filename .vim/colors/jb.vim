set background=dark
hi clear
if exists("syntax_on")
    syntax reset
endif
let g:colors_name="jb"

let s:none = ['none', 'none']
let s:back = ['#062329']
let s:gutters = ['#062329']
let s:gutter_fg = ['#062329']
let s:gutters_active = ['#062329']
let s:builtin = ['#ffffff']
let s:selection = ['#0e01d9'] "['#0000ff']
let s:search = ['#f085a6']
let s:text = ['#d1b897']
let s:comments = ['#6bc267'] " ['#3fdf1f'] "['#6bc267'] "['#7fd470'] "['#44b340']
let s:punctuation = ['#8cde94']
let s:keywords = ['#ffffff']
let s:variables = ['#d1b897'] "['#c1d1e3']
let s:functions = ['#ffffff']
let s:methods = ['#c1d1e3']
let s:strings = ['#46b5a2'] "['#2ec09c']
let s:constants = ['#7ad0c6']
let s:macros = ['#8cde94']
let s:numbers = ['#7ad0c6']
let s:white = ['#ffffff']
let s:black = ['#000000']
let s:error = ['#ff0000']
let s:warning = ['#ffaa00']
let s:highlight_line = ['#0b3335']
let s:line_fg = ['#126367']

" Arguments: group, fg, bg, attr, guisp
function! s:Hi(group, fg, ...)
  " foreground
  let fg = a:fg
  " background
  if a:0 >= 1
    let bg = a:1
  else
    let bg = s:none
  endif

  " attr
  if a:0 >= 2 && strlen(a:2)
    let attr = a:2
  else
    let attr = 'none'
  endif
 
  " attr
  if a:0 >= 3 && strlen(a:3)
    let guisp = a:3
  else
    let guisp = 'none'
  endif

  let histring = [ 'hi', a:group]
  call add(histring, 'guifg=' . fg[0])
  if len(fg) > 1
    call add(histring, 'ctermfg=' . fg[1])
  endif

  call add(histring, 'guibg=' . bg[0])
  if len(bg) > 1
    call add(histring, 'ctermbg=' . bg[1])
  endif
  call add(histring, 'gui=' . attr)
  call add(histring, 'cterm=' . attr)
  call add(histring, 'guisp=' . guisp)

  execute join(histring, ' ')
endfunction

" Vim editor colors
"    s:Hi(GROUP, FOREGROUND, BACKGROUND, ATTRIBUTE, SPECIAL)
call s:Hi('Normal', s:text, s:back, 'none')
call s:Hi('Cursor', s:back, ['#9ceda3'], 'none') "#90C090
call s:Hi('ErrorMsg', ['0xFFBB00'], s:back, 'none')
call s:Hi('IncSearch', s:black, s:search, 'none')
call s:Hi('Search', s:none, ['#769594'], 'bold')
call s:Hi('LineNr', s:line_fg, s:back, 'none')
call s:Hi('CursorLineNr', ['#ffffff'], s:back, 'none')
call s:Hi('MatchParen', s:text, s:none, 'underline')
call s:Hi('MoreMsg', s:text, s:back, 'none')
call s:Hi('NonText', s:text, s:back, 'none')
call s:Hi('Question', ['#3bd0c1'], s:back, 'none')
call s:Hi('SpecialKey', s:text, s:none, 'underline')
call s:Hi('StatusLine', s:black, ['#d7bd96'], 'bold')
call s:Hi('StatusLineNC', ['#646464'], ['#d2d2d2'], 'bold')
call s:Hi('Title', s:none, s:none, 'bold')
call s:Hi('Visual', s:none, s:selection, 'none')
call s:Hi('VisualNOS', s:none, s:selection, 'none')
call s:Hi('WarningMsg', s:warning, s:back, 'none')
call s:Hi('WildMenu', s:none, s:selection, 'none')
call s:Hi('Pmenu', s:text, ['#6c6c6c'], 'none')
call s:Hi('PmenuSel', s:text, s:selection, 'none')

highlight link Searchlight Incsearch

" Legacy groups for official git.vim and diff.vim syntax
hi! link diffAdded DiffAdd
hi! link diffChanged DiffChange
hi! link diffRemoved DiffDelete

call s:Hi('Constant', s:constants, s:none, 'none')
call s:Hi('String', s:strings, s:none, 'none')
call s:Hi('Character', s:text, s:none, 'none')
call s:Hi('Number', s:numbers, s:none, 'none')
call s:Hi('Boolean', s:constants, s:none, 'none')
call s:Hi('Float', s:constants, s:none, 'none')
call s:Hi('Identifier', s:variables, s:none, 'none')
call s:Hi('Function', s:functions, s:none, 'none')
call s:Hi('Statement', s:builtin, s:none, 'none')
call s:Hi('Conditional', s:builtin, s:none, 'none')
call s:Hi('Repeat', s:builtin, s:none, 'none')
call s:Hi('Label', s:builtin, s:none, 'none')
call s:Hi('Operator', s:keywords, s:none, 'none')
call s:Hi('Keyword', s:keywords, s:none, 'none')
call s:Hi('Exception', s:variables, s:none, 'none')
call s:Hi('PreProc', s:macros, s:none, 'none')
call s:Hi('Include', s:text, s:none, 'none')
call s:Hi('Define', s:macros, s:none, 'none')
call s:Hi('Macro', s:macros, s:none, 'none')
call s:Hi('PreCondit', s:macros, s:none, 'none')
call s:Hi('Type', s:punctuation, s:none, 'none')
call s:Hi('StorageClass', s:builtin, s:none, 'none')
call s:Hi('Structure', s:keywords, s:none, 'none')
call s:Hi('Typedef', s:keywords, s:none, 'none')
call s:Hi('Special', s:text, s:none, 'none')
call s:Hi('SpecialChar', s:text, s:none, 'none')
call s:Hi('Tag', s:text, s:none, 'none')
call s:Hi('Delimiter', s:punctuation, s:none, 'none')
call s:Hi('Comment', s:comments, s:none, 'none')
call s:Hi('SpecialComment', s:comments, s:none, 'none')
call s:Hi('Debug', s:text, s:none, 'none')
call s:Hi('Underlined', s:none, s:none, 'underline')
call s:Hi("Conceal", s:text, s:back, 'none')
call s:Hi('Ignore', s:text, s:none, 'none')
call s:Hi('Error', s:error, s:back, 'undercurl', s:error[0])
call s:Hi('Todo', s:none, s:back, 'none')

" Neovim Treesitter:
call s:Hi('TSError', s:error, s:none, 'none')
call s:Hi('TSPunctDelimiter', s:text, s:none, 'none')
call s:Hi('TSPunctBracket', s:text, s:none, 'none')
call s:Hi('TSPunctSpecial', s:text, s:none, 'none')
" Constant
call s:Hi('TSConstant', s:constants, s:none, 'none')
call s:Hi('TSConstBuiltin', s:constants, s:none, 'none')
call s:Hi('TSConstMacro', s:constants, s:none, 'none')
call s:Hi('TSStringRegex', s:constants, s:none, 'none')
call s:Hi('TSString', s:strings, s:none, 'none')
call s:Hi('TSStringEscape', s:strings, s:none, 'none')
call s:Hi('TSCharacter', s:strings, s:none, 'none')
call s:Hi('TSNumber', s:constants, s:none, 'none')
call s:Hi('TSBoolean', s:constants, s:none, 'none')
call s:Hi('TSFloat', s:constants, s:none, 'none')
call s:Hi('TSAnnotation', s:constants, s:none, 'none')
call s:Hi('TSAttribute', s:constants, s:none, 'none')
call s:Hi('TSNamespace', s:constants, s:none, 'none')
" Functions
call s:Hi('TSFuncBuiltin', s:functions, s:none, 'none')
call s:Hi('TSFunction', s:functions, s:none, 'none')
call s:Hi('TSFuncMacro', s:functions, s:none, 'none')
call s:Hi('TSParameter', s:functions, s:none, 'none')
call s:Hi('TSParameterReference', s:functions, s:none, 'none')
call s:Hi('TSMethod', s:functions, s:none, 'none')
call s:Hi('TSField', s:functions, s:none, 'none')
call s:Hi('TSProperty', s:functions, s:none, 'none')
call s:Hi('TSConstructor', s:functions, s:none, 'none')
" Keywords
call s:Hi('TSConditional', s:keywords, s:none, 'none')
call s:Hi('TSRepeat', s:keywords, s:none, 'none')
call s:Hi('TSLabel', s:keywords, s:none, 'none')
call s:Hi('TSKeyword', s:keywords, s:none, 'none')
call s:Hi('TSKeywordFunction', s:keywords, s:none, 'none')
call s:Hi('TSKeywordOperator', s:keywords, s:none, 'none')
call s:Hi('TSOperator', s:keywords, s:none, 'none')
call s:Hi('TSException', s:keywords, s:none, 'none')
call s:Hi('TSType', s:keywords, s:none, 'none')
call s:Hi('TSTypeBuiltin', s:keywords, s:none, 'none')
call s:Hi('TSStructure', s:keywords, s:none, 'none')
call s:Hi('TSInclude', s:keywords, s:none, 'none')
" Variable
call s:Hi('TSVariable', s:text, s:none, 'none')
call s:Hi('TSVariableBuiltin', s:text, s:none, 'none')
" Text
call s:Hi('TSText', s:text, s:none, 'none')
call s:Hi('TSStrong', s:text, s:none, 'none')
call s:Hi('TSEmphasis', s:text, s:none, 'none')
call s:Hi('TSUnderline', s:text, s:none, 'none')
call s:Hi('TSTitle', s:text, s:none, 'none')
call s:Hi('TSLiteral', s:text, s:none, 'none')
call s:Hi('TSURI', s:text, s:none, 'none')
" Tags
call s:Hi('TSTag', s:text, s:none, 'none')
call s:Hi('TSTagDelimiter', s:punctuation, s:none, 'none')

" Markdown:
call s:Hi('markdownBold', s:text, s:none, 'bold')
call s:Hi('markdownCode', s:text, s:none, 'none')
call s:Hi('markdownRule', s:text, s:none, 'bold')
call s:Hi('markdownCodeDelimiter', s:punctuation, s:none, 'none')
call s:Hi('markdownHeadingDelimiter', s:punctuation, s:none, 'none')
call s:Hi('markdownFootnote', s:text, s:none, 'none')
call s:Hi('markdownFootnoteDefinition', s:text, s:none, 'none')
call s:Hi('markdownUrl', s:text, s:none, 'underline')
call s:Hi('markdownLinkText', s:text, s:none, 'none')
call s:Hi('markdownEscape', s:text, s:none, 'none')

