"=============================================================================
" File:        exSymbolTable.vim
" Author:      Yu Jianrong
" Last Change: 2006-11-22
" Version:     0.1
"  
" Copyright (c) 2006, Yu Jianrong
" All rights reserved.
"=============================================================================
"

if exists('loaded_exsymboltable') || &cp
    finish
endif
let loaded_exsymboltable=1

" -------------------------------------------------------------------------
"  variable part
" -------------------------------------------------------------------------

" Initialization <<<

" -------------------------------
" gloable varialbe initialization
" -------------------------------

" window height for horizon window mode
if !exists('g:exSL_window_height')
    let g:exSL_window_height = 20
endif

" window width for vertical window mode
if !exists('g:exSL_window_width')
    let g:exSL_window_width = 30
endif

" window height increment value
if !exists('g:exSL_window_height_increment')
    let g:exSL_window_height_increment = 30
endif

" window width increment value
if !exists('g:exSL_window_width_increment')
    let g:exSL_window_width_increment = 100
endif

" go back to edit buffer
" 'topleft','botright'
if !exists('g:exSL_window_direction')
    let g:exSL_window_direction = 'botright'
endif

" use vertical or not
if !exists('g:exSL_use_vertical_window')
    let g:exSL_use_vertical_window = 1
endif

" set edit mode
" 'none', 'append', 'replace'
if !exists('g:exSL_edit_mode')
    let g:exSL_edit_mode = 'replace'
endif

" set tag select command
if !exists('g:exSL_SymbolSelectCmd')
    let g:exSL_SymbolSelectCmd = 'ts'
endif

" -------------------------------
" local variable initialization
" -------------------------------
" title
let s:exSL_select_title = "__exSL_SelectWindow__"
let s:exSL_quick_view_title = "__exSL_QuickViewWindow__"
let s:exSL_short_title = 'Select'
let s:exSL_cur_title = ''

" general
let s:exSL_ignore_case = 0
let s:exSL_backto_editbuf = 0
let s:exSL_picked_search_result = 0

" select
let s:exSL_select_idx = 1
let s:exSL_get_symbol_file = 1

" quick view
let s:exSL_quick_view_idx = 1

" >>>


" -------------------------------------------------------------------------
"  function part
" -------------------------------------------------------------------------

" --exSL_OpenWindow--
" Open exSymbolSelect window 
function! s:exSL_OpenWindow( short_title ) " <<<
    if a:short_title != ''
        let s:exSL_short_title = a:short_title
    endif
    let title = '__exSL_' . s:exSL_short_title . 'Window__'
    " open window
    if g:exSL_use_vertical_window
        call g:ex_OpenWindow( title, g:exSL_window_direction, g:exSL_window_width, g:exSL_use_vertical_window, g:exSL_edit_mode, s:exSL_backto_editbuf, 'g:exSL_Init'.s:exSL_short_title.'Window', 'g:exSL_Update'.s:exSL_short_title.'Window' )
    else
        call g:ex_OpenWindow( title, g:exSL_window_direction, g:exSL_window_height, g:exSL_use_vertical_window, g:exSL_edit_mode, s:exSL_backto_editbuf, 'g:exSL_Init'.s:exSL_short_title.'Window', 'g:exSL_Update'.s:exSL_short_title.'Window' )
    endif
endfunction " >>>

" --exSL_ResizeWindow--
" Resize the window use the increase value
function! s:exSL_ResizeWindow() " <<<
    if g:exSL_use_vertical_window
        call g:ex_ResizeWindow( g:exSL_use_vertical_window, g:exSL_window_width, g:exSL_window_width_increment )
    else
        call g:ex_ResizeWindow( g:exSL_use_vertical_window, g:exSL_window_height, g:exSL_window_height_increment )
    endif
endfunction " >>>

" --exSL_ToggleWindow--
" Toggle the window
function! s:exSL_ToggleWindow( short_title ) " <<<
    " read the file first
    if s:exSL_get_symbol_file
        let s:exSL_get_symbol_file = 0
        if exists('g:exES_Symbol')
            let s:exSL_select_title = g:exES_Symbol
        else
            call g:ex_WarningMsg('not found symbol file')
        endif
    endif

    " assignment the title
    if s:exSL_short_title == 'Select'
        let s:exSL_cur_title = s:exSL_select_title
    elseif s:exSL_short_title == 'QuickView'
        let s:exSL_cur_title = s:exSL_quick_view_title
    endif

    " if need switch window
    if a:short_title != ''
        if s:exSL_short_title != a:short_title
            if bufwinnr(s:exSL_cur_title) != -1
                call g:ex_CloseWindow(s:exSL_cur_title)
            endif
            let s:exSL_short_title = a:short_title

            " assignment the title
            if s:exSL_short_title == 'Select'
                let s:exSL_cur_title = s:exSL_select_title
            elseif s:exSL_short_title == 'QuickView'
                let s:exSL_cur_title = s:exSL_quick_view_title
            endif
        endif
    endif

    " toggle exSL window
    let title = s:exSL_cur_title
    if g:exSL_use_vertical_window
        call g:ex_ToggleWindow( title, g:exSL_window_direction, g:exSL_window_width, g:exSL_use_vertical_window, 'none', s:exSL_backto_editbuf, 'g:exSL_Init'.s:exSL_short_title.'Window', 'g:exSL_Update'.s:exSL_short_title.'Window' )
    else
        call g:ex_ToggleWindow( title, g:exSL_window_direction, g:exSL_window_height, g:exSL_use_vertical_window, 'none', s:exSL_backto_editbuf, 'g:exSL_Init'.s:exSL_short_title.'Window', 'g:exSL_Update'.s:exSL_short_title.'Window' )
    endif
endfunction " >>>

" --exSL_SwitchWindow
function! s:exSL_SwitchWindow( short_title ) " <<<
    " assignment the title
    if a:short_title == 'Select'
        let s:exSL_cur_title = s:exSL_select_title
    elseif a:short_title == 'QuickView'
        let s:exSL_cur_title = s:exSL_quick_view_title
    endif

    if bufwinnr(s:exSL_cur_title) == -1
        call s:exSL_ToggleWindow(a:short_title)
    endif
endfunction " >>>

" --exSL_SetCase--
"  set if ignore case
function! s:exSL_SetIgnoreCase(ignore_case) " <<<
    let s:exSL_ignore_case = a:ignore_case
    if a:ignore_case
        echomsg 'exSL ignore case'
    else
        echomsg 'exSL no ignore case'
    endif
endfunction " >>>

" --exSL_GetSymbolListResult--
" search result directly
function! s:exSL_GetSymbolListResult( symbol ) " <<<
    " open symbol select window
    let sl_winnr = bufwinnr(s:exSL_select_title)
    if sl_winnr == -1
        call s:exSL_ToggleWindow('Select')
    else
        exe sl_winnr . 'wincmd w'
    endif

    let symbol_pattern = a:symbol
    if s:exSL_ignore_case && (match(a:symbol, '\u') == -1)
        echomsg 'parsing ' . a:symbol . '...(ignore case)'
        let symbol_pattern = a:symbol
    else
        echomsg 'parsing ' . a:symbol . '...(no ignore case)'
        let symbol_pattern = '\C' . a:symbol
    endif

    if search(symbol_pattern, 'w') == 0
        call g:ex_WarningMsg('File not found')
    endif
endfunction " >>>

" --exSL_QuickSearch--
" use quick search
function! s:exSL_QuickSearch() " <<<
    " open symbol select window
    let sl_winnr = bufwinnr(s:exSL_select_title)
    if sl_winnr == -1
        call s:exSL_ToggleWindow('Select')
    else
        exe sl_winnr . 'wincmd w'
    endif

    silent exe 'redraw'
endfunction " >>>

" --exSL_CopyPickedLine--
" copy the quick view result with search pattern
function! s:exSL_CopyPickedLine( search_pattern ) " <<<
    if a:search_pattern == ''
        let search_pattern = @/
    else
        let search_pattern = a:search_pattern
    endif
    if search_pattern == ''
        call g:ex_WarningMsg('search pattern not exists')
        return
    else
        " save current cursor position
        let save_cursor = getpos(".")
        silent call cursor( 1, 1 )

        " copy picked result
        let s:exSL_picked_search_result = ''
        let cmd = 'let s:exSL_picked_search_result = s:exSL_picked_search_result . "\n" . getline(".")'
        silent exec 'g/' . search_pattern . '/' . cmd

        " go back to the original position
        silent call setpos(".", save_cursor)
    endif
endfunction " >>>

" --exSL_ShowPickedResult--
"  show the picked result in the quick view window
function! s:exSL_ShowPickedResult( search_pattern ) " <<<
    " assignment the title
    if s:exSL_short_title == 'Select'
        call g:ex_HighlightConfirmLine()
        let s:exSL_select_idx = line('.')
        let s:exSL_quick_view_idx = 1
    elseif s:exSL_short_title == 'QuickView'
        call g:ex_HighlightConfirmLine()
        let s:exSL_quick_view_idx = line('.')
    endif

    " copy picked result
    call s:exSL_CopyPickedLine( a:search_pattern )
    call s:exSL_SwitchWindow('QuickView')
    silent exec 'normal Gdgg'
    silent put = s:exSL_picked_search_result
    silent exec 'normal ggdd'
endfunction " >>>

" --exSL_GetAndShowPickedResult--
"  show the picked result in the quick view window
function! s:exSL_GetAndShowPickedResult() " <<<
    " get search pattern
    let reg_a = @a
    exe 'normal "ayiw'
    let search_pattern = @a
    let @a = reg_a

    " copy picked result
    let s:exSL_quick_view_idx = 1
    call s:exSL_SwitchWindow("Select")
    call s:exSL_CopyPickedLine( '\<'.search_pattern.'\>' )
    call s:exSL_SwitchWindow('QuickView')
    silent exec 'normal Gdgg'
    silent put = s:exSL_picked_search_result
    silent exec 'normal ggdd'
endfunction " >>>

" ------------------------------
"  select window part
" ------------------------------

" --exSL_InitSelectWindow--
" Init exSymbolList window
function! g:exSL_InitSelectWindow() " <<<
    " set buffer no modifiable
    silent! setlocal nomodifiable
    silent! setlocal nonumber
    
    " key map
    nnoremap <buffer> <silent> <Return>   \|:call <SID>exSL_ShowPickedResult(getline('.'))<CR>
    nnoremap <buffer> <silent> <Space>   :call <SID>exSL_ResizeWindow()<CR>
    nnoremap <buffer> <silent> <ESC>   :call <SID>exSL_ToggleWindow('Select')<CR>
    nnoremap <buffer> <silent> <C-Left>   :call <SID>exSL_SwitchWindow('QuickView')<CR>
    nnoremap <buffer> <silent> <C-Right>   :call <SID>exSL_SwitchWindow('Select')<CR>

    nnoremap <buffer> <silent> <Leader>r :call <SID>exSL_ShowPickedResult('')<CR>
    nnoremap <buffer> <silent> <Leader>gg :call <SID>exSL_GotoResultInSelectWindow()<CR>

    " autocmd
    au CursorMoved <buffer> :call g:ex_HighlightSelectLine()
endfunction " >>>

" --exSL_UpdateSelectWindow--
" Update exSymbolList window
function! g:exSL_UpdateSelectWindow() " <<<
    call cursor( s:exSL_select_idx, 1)
    call g:ex_HighlightConfirmLine()
endfunction " >>>

" --exSL_GotoResultInSelectWindow--
" Goto result position
function! s:exSL_GotoResultInSelectWindow() " <<<
    call g:ex_HighlightConfirmLine()
    let s:exSL_select_idx = line('.')
    let symbol_key_word = getline('.')
    call s:exSL_ToggleWindow('Select')
    exec (g:exSL_SymbolSelectCmd . " " . symbol_key_word)
endfunction " >>>

" ------------------------------
"  quick view window part
" ------------------------------
" --exSL_InitQuickViewWindow--
" Init exSymbolList window
function! g:exSL_InitQuickViewWindow() " <<<
    silent! setlocal nonumber
    
    " key map
    nnoremap <buffer> <silent> <Return>   \|:call <SID>exSL_GotoResultInQuickViewWindow()<CR>
    nnoremap <buffer> <silent> <Space>   :call <SID>exSL_ResizeWindow()<CR>
    nnoremap <buffer> <silent> <ESC>   :call <SID>exSL_ToggleWindow('QuickView')<CR>
    nnoremap <buffer> <silent> <C-Left>   :call <SID>exSL_SwitchWindow('QuickView')<CR>
    nnoremap <buffer> <silent> <C-Right>   :call <SID>exSL_SwitchWindow('Select')<CR>

    nnoremap <buffer> <silent> <Leader>r :call <SID>exSL_ShowPickedResult('')<CR>

    " autocmd
    au CursorMoved <buffer> :call g:ex_HighlightSelectLine()
endfunction " >>>

" --exSL_UpdateQuickViewWindow--
" Update exSymbolList window
function! g:exSL_UpdateQuickViewWindow() " <<<
    call cursor( s:exSL_quick_view_idx, 1)
    call g:ex_HighlightConfirmLine()
endfunction " >>>

" --exSL_GotoResultInQuickViewWindow--
" Goto result position
function! s:exSL_GotoResultInQuickViewWindow() " <<<
    call g:ex_HighlightConfirmLine()
    let s:exSL_quick_view_idx = line('.')
    let symbol_key_word = getline('.')
    call s:exSL_ToggleWindow('QuickView')
    exec (g:exSL_SymbolSelectCmd . " " . symbol_key_word)
endfunction " >>>


" -------------------------------------------------------------------------
" Command part
" -------------------------------------------------------------------------
command -nargs=1 SL call s:exSL_GetSymbolListResult('<args>')
command ExslSelectToggle call s:exSL_ToggleWindow('Select')
command ExslQuickViewToggle call s:exSL_ToggleWindow('QuickView')
command ExslQuickSearch call s:exSL_QuickSearch()
command ExslToggle call s:exSL_ToggleWindow('')
command ExslGoDirectly call s:exSL_GetAndShowPickedResult()

" quick view command
command -nargs=1 SLPR call s:exSL_ShowPickedResult('<args>')

" Ignore case setting
command SLigc call s:exSL_SetIgnoreCase(1)
command SLnoigc call s:exSL_SetIgnoreCase(0)

finish
" vim600: set foldmethod=marker foldmarker=<<<,>>> foldlevel=1:
