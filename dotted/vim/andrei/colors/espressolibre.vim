" Vim color file
" Name: espressolibregui.vim
" Author: Andrei Dragomir <adragomir@gmail.com>
" Last Change:  $Date: 2003/06/02 19:28:15 $
" cool help screens
" :he group-name
" :he highlight-groups
" :he cterm-color
" Vim color file
" Name:       herald.vim
" Author:     Fabio Cevasco <h3rald@h3rald.com>
" Version:    0.2.0
" Notes:      Supports 8, 16, 256 and 16,777,216 (RGB) color modes

hi clear

if exists("syntax_on")
	syntax reset
endif

let colors_name = "espressolibregui"

set background=dark

if has("gui_running")

	" -> Text; Miscellaneous
	hi Normal         guibg=#2A211C guifg=#BDAE9D gui=none
	hi SpecialKey     guibg=#2A211C guifg=#BFBFBF gui=none
	hi VertSplit      guibg=#000000 guifg=#696567 gui=none
	hi SignColumn     guibg=#2A211C guifg=#BF81FA gui=none
	hi NonText        guibg=#2A211C guifg=#696567 gui=none
	hi Directory      guibg=#2A211C guifg=#FFEE68 gui=none 
	hi Title          guibg=#2A211C guifg=#6DF584 gui=bold

	" -> Cursor
    hi Cursor         guibg=#889AFF gui=none
	"hi CursorIM       guibg=#000000 guifg=#1F1F1F gui=none
	"hi CursorColumn   guibg=#000000 guifg=#1F1F1F gui=none
	hi CursorLine     guibg=#3A312C gui=none

	" -> Folding
	hi FoldColumn     guibg=#001336 guifg=#003DAD gui=none
	hi Folded         guibg=#001336 guifg=#003DAD gui=none

	" -> Line info  
	hi LineNr         guibg=#2A211C guifg=#696567 gui=none
	hi StatusLine     guibg=#000000 guifg=#696567 gui=none
	hi StatusLineNC   guibg=#25365a guifg=#696567 gui=none

	" -> Messages
	hi ErrorMsg       guibg=#A32024 guifg=#D0D0D0 gui=none
	hi Question       guibg=#1F1F1F guifg=#FFA500 gui=none
	hi WarningMsg     guibg=#FFA500 guifg=#000000 gui=none
	hi MoreMsg        guibg=#1F1F1F guifg=#FFA500 gui=none
	hi ModeMsg        guibg=#1F1F1F guifg=#FFA500 gui=none

	" -> Search 
	hi Search         guibg=#C3DCFF gui=none 
	hi IncSearch      guibg=#C3DCFF gui=none

	" -> Diff
	hi DiffAdd        guibg=#006124 guifg=#ED9000 gui=none
	hi DiffChange     guibg=#0B294A guifg=#A36000 gui=none
	hi DiffDelete     guibg=#081F38 guifg=#ED9000 gui=none
	hi DiffText       guibg=#12457D guifg=#ED9000 gui=underline

	" -> Menu
	hi Pmenu          guibg=#140100 guifg=#660300 gui=none
	hi PmenuSel       guibg=#F17A00 guifg=#4C0200 gui=none
	hi PmenuSbar      guibg=#430300               gui=none
	hi PmenuThumb     guibg=#720300               gui=none
	hi PmenuSel       guibg=#F17A00 guifg=#4C0200 gui=none

	" -> Tabs
	hi TabLine        guibg=#000000 guifg=#696567 gui=none
	hi TabLineFill    guibg=#000000               gui=none
	hi TabLineSel     guibg=#1F1F1F guifg=#D0D0D0 gui=bold  

	" -> Visual Mode
	hi Visual         guibg=#C3DCFF gui=none
	hi VisualNOS      guibg=#C3DCFF gui=none

	" -> Code
	hi Comment        guibg=#2A211C guifg=#0066FF gui=none

	hi Constant       guibg=#2A211C guifg=#C5656B gui=none
	hi String         guibg=#2A211C guifg=#049B0A gui=none
    "Character
    hi Number         guibg=#2A211C guifg=#44AA43 gui=none
    hi Boolean        guibg=#2A211C guifg=#44AA43 gui=none
    hi Float          guibg=#2A211C guifg=#44AA43 gui=none

	hi Identifier     guibg=#2A211C guifg=#318495 gui=none
	hi Function       guibg=#2A211C guifg=#FF9358 gui=none

	hi Statement      guibg=#2A211C guifg=#43A8ED gui=none
    "Conditional
    "Repeat
    "Label
	hi Operator       guibg=#2A211C guifg=#3694ED gui=none
	hi Keyword        guibg=#2A211C guifg=#43A8ED gui=none
	hi Exception      guibg=#2A211C guifg=#43A8ED gui=none

	hi PreProc        guibg=#2A211C guifg=#9AFF87 gui=none
    "Include
    "Define
    "Macro
    "PreCondit
    
	hi Type           guibg=#2A211C guifg=#43A8ED gui=none
    "hi StorageClass
    "Structure
    "Typedef
    "
    
	hi Special        guibg=#2A211C guifg=#FFEE68 gui=none
	hi SpecialChar    guibg=#2A211C guifg=#FFEE68 gui=none
	hi Tag            guibg=#2A211C guifg=#FFEE68 gui=none
	hi Delimiter      guibg=#2A211C guifg=#3694ED gui=none
    "SpecialComment
    "Debug

	hi Error          guibg=#990000 guifg=#FFFFFF gui=none
	hi Todo           guibg=#2A211C guifg=#FC4234 gui=bold
	hi Ignore         guibg=#2A211C guifg=#BDAE9D gui=none
	hi Underlined     guibg=#2A211C guifg=#FC4234 gui=underline

	hi MatchParen     guibg=#889AFF gui=none

endif

" Spellcheck formatting
if has("spell")
	hi SpellBad   guisp=#FC4234 gui=undercurl
	hi SpellCap   guisp=#70BDF1 gui=undercurl
	hi SpellLocal guisp=#FFEE68 gui=undercurl
	hi SpellRare  guisp=#6DF584 gui=undercurl
endif
