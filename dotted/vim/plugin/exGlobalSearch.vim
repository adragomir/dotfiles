"=============================================================================
" File:        exGlobalSearch.vim
" Author:      Johnny
" Last Change: Wed 29 Oct 2006 01:05:03 PM EDT
" Version:     1.0
"=============================================================================
" You may use this code in whatever way you see fit.

if exists('loaded_exglobalsearch') || &cp
    finish
endif
let loaded_exglobalsearch=1

" -------------------------------------------------------------------------
"  variable part
" -------------------------------------------------------------------------
" Initialization <<<
" -------------------------------
" gloable varialbe initialization
" -------------------------------

" window height for horizon window mode
if !exists('g:exGS_window_height')
    let g:exGS_window_height = 20
endif

" window width for vertical window mode
if !exists('g:exGS_window_width')
    let g:exGS_window_width = 30
endif

" window height increment value
if !exists('g:exGS_window_height_increment')
    let g:exGS_window_height_increment = 30
endif

" window width increment value
if !exists('g:exGS_window_width_increment')
    let g:exGS_window_width_increment = 100
endif

" go back to edit buffer
" 'topleft','botright'
if !exists('g:exGS_window_direction')
    let g:exGS_window_direction = 'botright'
endif

" use vertical or not
if !exists('g:exGS_use_vertical_window')
    let g:exGS_use_vertical_window = 0
endif

" go back to edit buffer
if !exists('g:exGS_backto_editbuf')
    let g:exGS_backto_editbuf = 1
endif

" go and close exTagSelect window
if !exists('g:exGS_close_when_selected')
    let g:exGS_close_when_selected = 0
endif

" set edit mode
" 'none', 'append', 'replace'
if !exists('g:exGS_edit_mode')
    let g:exGS_edit_mode = 'replace'
endif

" -------------------------------
" local variable initialization
" -------------------------------

" title
let s:exGS_select_title = '__exGS_SelectWindow__'
let s:exGS_stack_title = '__exGS_StackWindow__'
let s:exGS_quick_view_title = '__exGS_QuickViewWindow__'
let s:exGS_short_title = 'Select'

" general
let s:exGS_fold_start = '<<<<<<'
let s:exGS_fold_end = '>>>>>>'
let s:exGS_ignore_case = 1
let s:exGS_need_search_again = 0

" select variable
let s:exGS_need_update_select_window = 0
let s:exGS_select_idx = 1

" stack variable
let s:exGS_need_update_stack_window = 0
let s:exGS_stack_idx = 1
let s:exGS_search_state_tmp = {'pattern':'', 'result':'', 'result_idx':-1 }
let s:exGS_search_stack_list = []

" quick view variable
let s:exGS_need_update_quick_view_window = 0
let s:exGS_quick_view_idx = 1
let s:exGS_picked_search_result = ''
let s:exGS_quick_view_search_pattern = ''

" >>>

" -------------------------------------------------------------------------
"  function part
" -------------------------------------------------------------------------

" --exGS_OpenWindow--
" Open exGlobalSearch window 
function! s:exGS_OpenWindow( short_title ) " <<<
    if a:short_title != ''
        let s:exGS_short_title = a:short_title
    endif
    let title = '__exGS_' . s:exGS_short_title . 'Window__'
    " open window
    if g:exGS_use_vertical_window
        call g:ex_OpenWindow( title, g:exGS_window_direction, g:exGS_window_width, g:exGS_use_vertical_window, g:exGS_edit_mode, g:exGS_backto_editbuf, 'g:exGS_Init'.s:exGS_short_title.'Window', 'g:exGS_Update'.s:exGS_short_title.'Window' )
    else
        call g:ex_OpenWindow( title, g:exGS_window_direction, g:exGS_window_height, g:exGS_use_vertical_window, g:exGS_edit_mode, g:exGS_backto_editbuf, 'g:exGS_Init'.s:exGS_short_title.'Window', 'g:exGS_Update'.s:exGS_short_title.'Window' )
    endif
endfunction " >>>

" --exGS_ResizeWindow--
" Resize the window use the increase value
function! s:exGS_ResizeWindow() " <<<
    if g:exGS_use_vertical_window
        call g:ex_ResizeWindow( g:exGS_use_vertical_window, g:exGS_window_width, g:exGS_window_width_increment )
    else
        call g:ex_ResizeWindow( g:exGS_use_vertical_window, g:exGS_window_height, g:exGS_window_height_increment )
    endif
endfunction " >>>

" --exGS_ToggleWindow--
" Toggle the window
function! s:exGS_ToggleWindow( short_title ) " <<<
    " if need switch window
    if a:short_title != ''
        if s:exGS_short_title != a:short_title
            if bufwinnr('__exGS_' . s:exGS_short_title . 'Window__') != -1
                call g:ex_CloseWindow('__exGS_' . s:exGS_short_title . 'Window__')
            endif
            let s:exGS_short_title = a:short_title
        endif
    endif

    " toggle exGS window
    let title = '__exGS_' . s:exGS_short_title . 'Window__'
    if g:exGS_use_vertical_window
        call g:ex_ToggleWindow( title, g:exGS_window_direction, g:exGS_window_width, g:exGS_use_vertical_window, 'none', g:exGS_backto_editbuf, 'g:exGS_Init'.s:exGS_short_title.'Window', 'g:exGS_Update'.s:exGS_short_title.'Window' )
    else
        call g:ex_ToggleWindow( title, g:exGS_window_direction, g:exGS_window_height, g:exGS_use_vertical_window, 'none', g:exGS_backto_editbuf, 'g:exGS_Init'.s:exGS_short_title.'Window', 'g:exGS_Update'.s:exGS_short_title.'Window' )
    endif
endfunction " >>>

" --exGS_SwitchWindow
function! s:exGS_SwitchWindow( short_title ) " <<<
    let title = '__exGS_' . a:short_title . 'Window__'
    if bufwinnr(title) == -1
        call s:exGS_ToggleWindow(a:short_title)
    endif
endfunction " >>>

" --exGS_Goto--
"  goto select line
function! s:exGS_Goto() " <<<
    let line = getline('.')
    " get file name
    let idx = stridx(line, ":")
    let file_name = strpart(line, 0, idx) " escape(strpart(line, 0, idx), ' ')
    if findfile(file_name) == ''
        call g:ex_WarningMsg( file_name . ' not found' )
        return
    endif
    let line = strpart(line, idx+1)

    " get line number
    let idx = stridx(line, ":")
    let line_num  = eval(strpart(line, 0, idx))

    " start jump
    call g:ex_GotoEditBuffer()
    if bufnr('%') != bufnr(file_name)
        exe 'silent e ' . file_name
    endif
    call cursor(line_num, 1)

    " jump to the pattern if the code have been modified
    let pattern = strpart(line, idx+2)
    let pattern = '\V' . pattern
    if search(pattern, 'w') == 0
        call g:ex_WarningMsg('search pattern not found: ' . pattern)
    endif

    call g:ex_HighlightObjectLine()
    exe 'normal zz'

    " go back if needed
    let title = '__exGS_' . s:exGS_short_title . 'Window__'
    if !g:exGS_close_when_selected
        if !g:exGS_backto_editbuf
            let winnum = bufwinnr(title)
            if winnr() != winnum
                exe winnum . 'wincmd w'
            endif
            return
        endif
    else
        let winnum = bufwinnr(title)
        if winnr() != winnum
            exe winnum . 'wincmd w'
        endif
        close
        call g:ex_GotoEditBuffer()
    endif
endfunction " >>>


" --exGS_SetCase--
"  set if ignore case
function! s:exGS_SetIgnoreCase(ignore_case) " <<<
    let s:exGS_ignore_case = a:ignore_case
    let s:exGS_need_search_again = 1
    if a:ignore_case
        echomsg 'exGS ignore case'
    else
        echomsg 'exGS no ignore case'
    endif
endfunction " >>>

" ------------------------------
"  select window part
" ------------------------------

" --exGS_InitSelectWindow--
" Init exGlobalSearch window
function! g:exGS_InitSelectWindow() " <<<
    set number
    " syntax highlight
    syntax match exGS_SynFileName '^[^:]*:'
    syntax match exGS_SynSearchPattern '----------.\+----------'
    syntax match exGS_SynLineNumber '\d\+:'

    highlight def exGS_SynFileName gui=none guifg=Blue 
    highlight def exGS_SynSearchPattern gui=bold guifg=DarkRed guibg=LightGray
    highlight def exGS_SynLineNumber gui=none guifg=Brown 

    " key map
    nnoremap <buffer> <silent> <Return>   \|:call <SID>exGS_GotoInSelectWindow()<CR>
    nnoremap <buffer> <silent> <Space>   :call <SID>exGS_ResizeWindow()<CR>
    nnoremap <buffer> <silent> <ESC>   :call <SID>exGS_ToggleWindow('Select')<CR>

    nnoremap <buffer> <silent> <C-Up>   :call <SID>exGS_SwitchWindow('Stack')<CR>
    nnoremap <buffer> <silent> <C-Right>   :call <SID>exGS_SwitchWindow('Select')<CR>
    nnoremap <buffer> <silent> <C-Left>   :call <SID>exGS_SwitchWindow('QuickView')<CR>

    nnoremap <buffer> <silent> <Leader>r :call <SID>exGS_ShowPickedResultNormalMode('', 'replace', 'pattern')<CR>
    nnoremap <buffer> <silent> <Leader>a :call <SID>exGS_ShowPickedResultNormalMode('', 'append', 'pattern')<CR>
    nnoremap <buffer> <silent> <Leader>n :call <SID>exGS_ShowPickedResultNormalMode('', 'new', 'pattern')<CR>
    vnoremap <buffer> <silent> <Leader>r <ESC>:call <SID>exGS_ShowPickedResultVisualMode('', 'replace', 'pattern')<CR>
    vnoremap <buffer> <silent> <Leader>a <ESC>:call <SID>exGS_ShowPickedResultVisualMode('', 'append', 'pattern')<CR>
    vnoremap <buffer> <silent> <Leader>n <ESC>:call <SID>exGS_ShowPickedResultVisualMode('', 'new', 'pattern')<CR>

    nnoremap <buffer> <silent> <Leader>fr :call <SID>exGS_ShowPickedResultNormalMode('', 'replace', 'file')<CR>
    nnoremap <buffer> <silent> <Leader>fa :call <SID>exGS_ShowPickedResultNormalMode('', 'append', 'file')<CR>
    nnoremap <buffer> <silent> <Leader>fn :call <SID>exGS_ShowPickedResultNormalMode('', 'new', 'file')<CR>
    vnoremap <buffer> <silent> <Leader>fr <ESC>:call <SID>exGS_ShowPickedResultVisualMode('', 'replace', 'file')<CR>
    vnoremap <buffer> <silent> <Leader>fa <ESC>:call <SID>exGS_ShowPickedResultVisualMode('', 'append', 'file')<CR>
    vnoremap <buffer> <silent> <Leader>fn <ESC>:call <SID>exGS_ShowPickedResultVisualMode('', 'new', 'file')<CR>

    nnoremap <buffer> <silent> <Leader>gr :call <SID>exGS_ShowPickedResultNormalMode('', 'replace', '')<CR>
    nnoremap <buffer> <silent> <Leader>ga :call <SID>exGS_ShowPickedResultNormalMode('', 'append', '')<CR>
    nnoremap <buffer> <silent> <Leader>gn :call <SID>exGS_ShowPickedResultNormalMode('', 'new', '')<CR>
    vnoremap <buffer> <silent> <Leader>gr <ESC>:call <SID>exGS_ShowPickedResultVisualMode('', 'replace', '')<CR>
    vnoremap <buffer> <silent> <Leader>ga <ESC>:call <SID>exGS_ShowPickedResultVisualMode('', 'append', '')<CR>
    vnoremap <buffer> <silent> <Leader>gn <ESC>:call <SID>exGS_ShowPickedResultVisualMode('', 'new', '')<CR>

    " autocmd
    " au CursorMoved <buffer> :call g:ex_HighlightSelectLine()
endfunction " >>>

" --exGS_GotoSelectLine--
"  goto select line
function! s:exGS_GotoInSelectWindow() " <<<
    let s:exGS_select_idx = line(".")
    let s:exGS_search_stack_list[s:exGS_stack_idx].result_idx = line(".")
    call g:ex_HighlightConfirmLine()
    call s:exGS_Goto()
endfunction " >>>

" --exGS_UpdateSelectWindow--
" Update exGlobalSearch window 
function! g:exGS_UpdateSelectWindow() " <<<
    silent call cursor(s:exGS_select_idx, 1)
    call g:ex_HighlightConfirmLine()
endfunction " >>>

" --exGS_GetGlobalSearchResult--
" Get Global Search Result
" search_pattern = ''
" search_method = -s / -r / -w
"function! s:exGS_GetGlobalSearchResult(search_pattern, search_method) " <<<
"    " let user select edit mode
"    let edit_mode = confirm("Select display mode", "&Replace\n&Append\n&New\nCancle")
"    if edit_mode == 4
"        return
"    endif
"    " if this is the first time search, we need to treat it as new search, so
"    " we need push it to stack
"    if s:exGS_search_state_tmp.pattern == ''
"        let edit_mode = 3
"    endif
"
"    " let search_cmd = 'lid --file=' . g:exES_id_path . ' --result=grep ' . a:search_pattern
"    let search_cmd = 'lid --result=grep ' . a:search_method . ' ' . a:search_pattern
"    let search_result = system(search_cmd)
"
"    let gs_winnr = bufwinnr(g:exGS_select_title)
"    if gs_winnr == -1
"        " open window
"        let old_opt = g:exGS_select_backto_editbuf
"        let g:exGS_select_backto_editbuf = 0
"        call s:exGS_ToggleSelectWindow()
"        let g:exGS_select_backto_editbuf = old_opt
"    else
"        exe gs_winnr . 'wincmd w'
"    endif
"
"    let search_result = '---------------------------------------- ' . a:search_pattern . ' ----------------------------------------' . "\n" . search_result
"
"    " put result and solve it with different edit mode
"    if edit_mode == 1
"        echomsg "replace mode"
"
"        " clear screen and put new result
"        silent exec 'normal Gdgg'
"        let line_num = line('.')
"        silent put = search_result
"
"        " Init search state
"        let s:exGS_search_state_tmp = {'pattern':'', 'result':'', 'result_idx':-1, 'quick_view_result':'', 'quick_view_idx':-1 }
"        let s:exGS_search_state_tmp.pattern = a:search_pattern
"        let s:exGS_search_state_tmp.result = search_result
"        let s:exGS_search_state_tmp.result_idx = line_num+1
"        call s:exGS_SetStack( s:exGS_search_state_tmp )
"        silent call cursor(line_num+1,1)
"    elseif edit_mode == 2
"        echomsg "append mode"
"
"        " go to append position and append result
"        silent exec 'normal G'
"        let line_num = line('.')
"        silent put = search_result
"
"        " refresh search state
"        let s:exGS_search_state_tmp.pattern = s:exGS_search_state_tmp.pattern . '|' . a:search_pattern
"        let s:exGS_search_state_tmp.result = s:exGS_search_state_tmp.result . search_result
"        let s:exGS_search_state_tmp.result_idx = line_num+1
"        call s:exGS_SetStack( s:exGS_search_state_tmp )
"        silent call cursor(line_num+1,1)
"    elseif edit_mode == 3
"        echomsg "new " . a:search_pattern
"
"        " save the old one first
"        let reg_s = @s
"        silent exec 'normal gg"syG'
"        let s:exGS_search_state_tmp.result = reg_s
"        " TODO save quick view result too
"        let @s = reg_s
"        call s:exGS_SetStack( s:exGS_search_state_tmp )
"        " clear screen and put new result
"        silent exec 'normal Gdgg'
"        let line_num = line('.')
"        silent put = search_result
"
"        " Init search state
"        let s:exGS_search_state_tmp = {'pattern':'', 'result':'', 'result_idx':-1, 'quick_view_result':'', 'quick_view_idx':-1 }
"        let s:exGS_search_state_tmp.pattern = a:search_pattern
"        let s:exGS_search_state_tmp.result = search_result
"        let s:exGS_search_state_tmp.result_idx = line_num+1
"        call s:exGS_PushStack( s:exGS_search_state_tmp )
"        silent call cursor(line_num+1,1)
"    endif
"endfunction " >>>

" --exGS_GetGlobalSearchResult--
" Get Global Search Result
" search_pattern = ''
" search_method = -s / -r / -w
function! s:exGS_GetGlobalSearchResult(search_pattern, search_method) " <<<
    " TODO different mode, same things
    " open and goto search window first
    let gs_winnr = bufwinnr(s:exGS_select_title)
    if gs_winnr == -1
        " open window
        let old_opt = g:exGS_backto_editbuf
        let g:exGS_backto_editbuf = 0
        call s:exGS_ToggleWindow('Select')
        let g:exGS_backto_editbuf = old_opt
    else
        exe gs_winnr . 'wincmd w'
    endif

    " if the search pattern is same as the last one, open the window
    if a:search_pattern ==# s:exGS_search_state_tmp.pattern
        if !s:exGS_need_search_again
            return
        endif
    endif
    let s:exGS_need_search_again = 0

    " TODO file path
    " let search_cmd = 'lid --file=' . g:exES_ID . ' --result=grep ' . a:search_pattern
    if s:exGS_ignore_case && (match(a:search_pattern, '\u') == -1)
        echomsg 'search ' . a:search_pattern . '...(ignore case)'
        let search_cmd = 'lid --result=grep -i ' . a:search_method . ' ' . a:search_pattern
    else
        echomsg 'search ' . a:search_pattern . '...(no ignore case)'
        let search_cmd = 'lid --result=grep ' . a:search_method . ' ' . a:search_pattern
    endif
    let search_result = system(search_cmd)
    let search_result = '----------' . a:search_pattern . '----------' . "\n" . search_result

    " clear screen and put new result
    silent exec 'normal Gdgg'
    call g:ex_HighlightConfirmLine()
    let line_num = line('.')
    silent put = search_result

    " Init search state
    let s:exGS_search_state_tmp = {'pattern':'', 'result':'', 'result_idx':-1}
    let s:exGS_search_state_tmp.pattern = a:search_pattern
    let s:exGS_search_state_tmp.result = search_result
    let s:exGS_search_state_tmp.result_idx = line_num+1
    let s:exGS_select_idx = line_num+1
    call s:exGS_PushStack( s:exGS_search_state_tmp )
    silent call cursor( line_num+1, 1 )

    " TODO
    let s:exGS_need_update_stack_window = 1
endfunction " >>>

" ------------------------------
"  stack window part
" ------------------------------
" --exGS_InitStackWindow--
" Init exGlobalSearch select window
function! g:exGS_InitStackWindow() " <<<
    " key map
    nnoremap <buffer> <silent> <Return>   \|:call <SID>exGS_GetSearchResultFromStack()<CR>
    nnoremap <buffer> <silent> <Space>   :call <SID>exGS_ResizeWindow()<CR>
    nnoremap <buffer> <silent> <ESC>   :call <SID>exGS_ToggleWindow('Stack')<CR>

    nnoremap <buffer> <silent> <C-Up>   :call <SID>exGS_SwitchWindow('Stack')<CR>
    nnoremap <buffer> <silent> <C-Right>   :call <SID>exGS_SwitchWindow('Select')<CR>
    nnoremap <buffer> <silent> <C-Left>   :call <SID>exGS_SwitchWindow('QuickView')<CR>

    " autocmd
    au CursorMoved <buffer> :call g:ex_HighlightSelectLine()
endfunction " >>>

" --exGS_UpdateStackWindow--
" Update exGlobalSearch stack window 
function! g:exGS_UpdateStackWindow() " <<<
    " if need update stack window 
    if s:exGS_need_update_stack_window
        let s:exGS_need_update_stack_window = 0
        call s:exGS_ShowStackList()
    endif

    "silent call cursor(s:exGS_select_idx, 1)
    call g:ex_HighlightConfirmLine()
endfunction " >>>

" --exGS_PushStack--
" Push the result into stack
function! s:exGS_PushStack( search_state ) " <<<
    let list_len = len(s:exGS_search_stack_list)
    if list_len >= 20
        call remove(s:exGS_search_stack_list, 0)
    endif
    let search_state = copy(a:search_state)
    call add(s:exGS_search_stack_list,search_state)
endfunction " >>>

" --exGS_SetStack--
" Set current stack value
function! s:exGS_SetStack( search_state ) " <<<
    let s:exGS_search_stack_list[s:exGS_stack_idx] = copy( a:search_state )
endfunction " >>>

" --exGS_ShowStackList--
" Show the stack list in stack window
function! s:exGS_ShowStackList() " <<<
    " open and goto search window first
    let gs_winnr = bufwinnr(s:exGS_stack_title)
    if gs_winnr == -1
        " open window
        let old_opt = g:exGS_backto_editbuf
        let g:exGS_backto_editbuf = 0
        call s:exGS_ToggleWindow('Stack')
        let g:exGS_backto_editbuf = old_opt
    else
        exe gs_winnr . 'wincmd w'
    endif

    " show stack list
    " TODO show start entry
    silent exec 'normal Gdgg'
    let idx = 0
    for state in s:exGS_search_stack_list
        silent put = idx . ': ' . state.pattern
        let idx += 1
    endfor
endfunction " >>>

" --exGS_GetSearchResultFromStack--
" Get search result from current stack
function! s:exGS_GetSearchResultFromStack() " <<<
    let cur_line = getline(".")
    let idx = match(cur_line, '\S')
    let cur_line = strpart(cur_line, idx)
    let idx = match(cur_line, ':')
    let s:exGS_stack_idx = eval(strpart(cur_line, 0, idx))

    call g:ex_HighlightConfirmLine()
    call s:exGS_ToggleWindow('Select')
    silent exec 'normal Gdgg'
    silent put = s:exGS_search_stack_list[s:exGS_stack_idx].result
    silent call cursor( s:exGS_search_stack_list[s:exGS_stack_idx].result_idx, 1 )
endfunction " >>>

" ------------------------------
"  quick view window part
" ------------------------------
" --exGS_InitQuickViewWindow--
" Init exGlobalSearch select window
function! g:exGS_InitQuickViewWindow() " <<<
    set number
    set foldmethod=marker foldmarker=<<<<<<,>>>>>> foldlevel=1
    " syntax highlight
    syntax match exGS_SynFileName '^[^:]*:'
    syntax match exGS_SynSearchPattern '----------.\+----------'
    syntax match exGS_SynLineNumber '\d\+:'
    syntax match exGS_SynFoldStart '<<<<<<'
    syntax match exGS_SynFoldEnd '>>>>>>'

    highlight def exGS_SynFileName gui=none guifg=Blue 
    highlight def exGS_SynSearchPattern gui=bold guifg=DarkRed guibg=LightGray
    highlight def exGS_SynLineNumber gui=none guifg=Brown 
    highlight def exGS_SynFoldStart gui=none guifg=DarkGreen
    highlight def exGS_SynFoldEnd gui=none guifg=DarkGreen

    " key map
    nnoremap <buffer> <silent> <Return>   \|:call <SID>exGS_GotoInQuickViewWindow()<CR>
    nnoremap <buffer> <silent> <Space>   :call <SID>exGS_ResizeWindow()<CR>
    nnoremap <buffer> <silent> <ESC>   :call <SID>exGS_ToggleWindow('QuickView')<CR>

    nnoremap <buffer> <silent> <C-Up>   :call <SID>exGS_SwitchWindow('Stack')<CR>
    nnoremap <buffer> <silent> <C-Right>   :call <SID>exGS_SwitchWindow('Select')<CR>
    nnoremap <buffer> <silent> <C-Left>   :call <SID>exGS_SwitchWindow('QuickView')<CR>

    nnoremap <buffer> <silent> <Leader>r :call <SID>exGS_ShowPickedResultNormalMode('', 'replace', 'pattern')<CR>
    nnoremap <buffer> <silent> <Leader>a :call <SID>exGS_ShowPickedResultNormalMode('', 'append', 'pattern')<CR>
    nnoremap <buffer> <silent> <Leader>n :call <SID>exGS_ShowPickedResultNormalMode('', 'new', 'pattern')<CR>
    vnoremap <buffer> <silent> <Leader>r <ESC>:call <SID>exGS_ShowPickedResultVisualMode('', 'replace', 'pattern')<CR>
    vnoremap <buffer> <silent> <Leader>a <ESC>:call <SID>exGS_ShowPickedResultVisualMode('', 'append', 'pattern')<CR>
    vnoremap <buffer> <silent> <Leader>n <ESC>:call <SID>exGS_ShowPickedResultVisualMode('', 'new', 'pattern')<CR>

    nnoremap <buffer> <silent> <Leader>fr :call <SID>exGS_ShowPickedResultNormalMode('', 'replace', 'file')<CR>
    nnoremap <buffer> <silent> <Leader>fa :call <SID>exGS_ShowPickedResultNormalMode('', 'append', 'file')<CR>
    nnoremap <buffer> <silent> <Leader>fn :call <SID>exGS_ShowPickedResultNormalMode('', 'new', 'file')<CR>
    vnoremap <buffer> <silent> <Leader>fr <ESC>:call <SID>exGS_ShowPickedResultVisualMode('', 'replace', 'file')<CR>
    vnoremap <buffer> <silent> <Leader>fa <ESC>:call <SID>exGS_ShowPickedResultVisualMode('', 'append', 'file')<CR>
    vnoremap <buffer> <silent> <Leader>fn <ESC>:call <SID>exGS_ShowPickedResultVisualMode('', 'new', 'file')<CR>

    nnoremap <buffer> <silent> <Leader>gr :call <SID>exGS_ShowPickedResultNormalMode('', 'replace', '')<CR>
    nnoremap <buffer> <silent> <Leader>ga :call <SID>exGS_ShowPickedResultNormalMode('', 'append', '')<CR>
    nnoremap <buffer> <silent> <Leader>gn :call <SID>exGS_ShowPickedResultNormalMode('', 'new', '')<CR>
    vnoremap <buffer> <silent> <Leader>gr <ESC>:call <SID>exGS_ShowPickedResultVisualMode('', 'replace', '')<CR>
    vnoremap <buffer> <silent> <Leader>ga <ESC>:call <SID>exGS_ShowPickedResultVisualMode('', 'append', '')<CR>
    vnoremap <buffer> <silent> <Leader>gn <ESC>:call <SID>exGS_ShowPickedResultVisualMode('', 'new', '')<CR>

    " autocmd
    " au CursorMoved <buffer> :call g:ex_HighlightSelectLine()
endfunction " >>>

" --exGS_UpdateQuickViewWindow--
" Update exGlobalSearch stack window 
function! g:exGS_UpdateQuickViewWindow() " <<<
    silent call cursor(s:exGS_quick_view_idx, 1)
    call g:ex_HighlightConfirmLine()
endfunction " >>>

" --exGS_GotoInQuickViewWindow--
"  goto select line
function! s:exGS_GotoInQuickViewWindow() " <<<
    let s:exGS_quick_view_idx = line(".")
    " TODO save history idx
    "let s:exGS_search_stack_list[s:exGS_stack_idx].result_idx = line(".")
    call g:ex_HighlightConfirmLine()
    call s:exGS_Goto()
endfunction " >>>

" --exGS_CopyPickedLine--
" copy the quick view result with search pattern
function! s:exGS_CopyPickedLine( search_pattern, line_start, line_end, search_method ) " <<<
    if a:search_pattern == ''
        let search_pattern = @/
    else
        let search_pattern = a:search_pattern
    endif
    if search_pattern == ''
        let s:exGS_quick_view_search_pattern = ''
        call g:ex_WarningMsg('search pattern not exists')
        return
    else
        let s:exGS_quick_view_search_pattern = '----------' . search_pattern . '----------'
        let full_search_pattern = search_pattern
        if a:search_method == 'pattern'
            let full_search_pattern = '^.\+:\d\+:.*\zs' . search_pattern
        elseif a:search_method == 'file'
            let full_search_pattern = '\(.\+:\d\+:\)\&' . search_pattern
        endif
        " save current cursor position
        let save_cursor = getpos(".")
        " clear down lines
        if a:line_end < line('$')
            silent call cursor( a:line_end, 1 )
            silent exec 'normal jdG'
        endif
        " clear up lines
        if a:line_start > 1
            silent call cursor( a:line_start, 1 )
            silent exec 'normal kdgg'
        endif
        silent call cursor( 1, 1 )

        " clear the last search result
        let s:exGS_picked_search_result = ''
        silent exec 'v/' . full_search_pattern . '/d'

        " clear pattern result
        while search('----------.\+----------', 'w') != 0
            silent exec 'normal dd'
        endwhile

        " copy picked result
        let reg_q = @q
        silent exec 'normal gg"qyG'
        let s:exGS_picked_search_result = @q
        let @q = reg_q
        " recover
        silent exec 'normal u'

        " this two algorithm was slow
        " -------------------------
        " let cmd = 'let s:exGS_picked_search_result = s:exGS_picked_search_result . "\n" . getline(".")'
        " silent exec '1,$' . 'g/' . search_pattern . '/' . cmd
        " -------------------------
        " let cur_line = a:line_start - 1 
        " while search( search_pattern, 'W', a:line_end ) != 0
        "     if cur_line != line(".")
        "         let cur_line = line(".")
        "         let s:exGS_picked_search_result = s:exGS_picked_search_result . "\n" . getline(".")
        "     else
        "         continue
        "     endif
        " endwhile

        " go back to the original position
        silent call setpos(".", save_cursor)
    endif
endfunction " >>>

" --exGS_ShowPickedResult--
"  show the picked result in the quick view window
function! s:exGS_ShowPickedResult( search_pattern, line_start, line_end, edit_mode, search_method ) " <<<
    call s:exGS_CopyPickedLine( a:search_pattern, a:line_start, a:line_end, a:search_method )
    call s:exGS_SwitchWindow('QuickView')
    if a:edit_mode == 'replace'
        silent exec 'normal Gdgg'
        silent put = s:exGS_quick_view_search_pattern
        silent put = s:exGS_fold_start
        silent put = s:exGS_picked_search_result
        silent put = s:exGS_fold_end
    elseif a:edit_mode == 'append'
        silent exec 'normal G'
        silent put = ''
        silent put = s:exGS_quick_view_search_pattern
        silent put = s:exGS_fold_start
        silent put = s:exGS_picked_search_result
        silent put = s:exGS_fold_end
    elseif a:edit_mode == 'new'
        return
    endif
endfunction " >>>

" --exGS_ShowPickedResultNormalMode--
"  show the picked result in the quick view window
function! s:exGS_ShowPickedResultNormalMode( search_pattern, edit_mode, search_method ) " <<<
    let line_start = 1
    let line_end = line('$')
    call s:exGS_ShowPickedResult( a:search_pattern, line_start, line_end, a:edit_mode, a:search_method )
endfunction " >>>

" --exGS_ShowPickedResult--
"  show the picked result in the quick view window
function! s:exGS_ShowPickedResultVisualMode( search_pattern, edit_mode, search_method ) " <<<
    let line_start = 3
    let line_end = line('$')

    let tmp_start = line("'<")
    let tmp_end = line("'>")
    if line_start < tmp_start
        let line_start = tmp_start
    endif
    if line_end > tmp_end
        let line_end = tmp_end
    endif

    call s:exGS_ShowPickedResult( a:search_pattern, line_start, line_end, a:edit_mode, a:search_method )
endfunction " >>>

" -------------------------------------------------------------------------
" Command part
" -------------------------------------------------------------------------
command -nargs=1 GS call s:exGS_GetGlobalSearchResult('<args>', '-s')
command -nargs=1 GSW call s:exGS_GetGlobalSearchResult('<args>', '-w')
command -nargs=1 GSR call s:exGS_GetGlobalSearchResult('<args>', '-r')
command ExgsToggle call s:exGS_ToggleWindow('')
command ExgsSelectToggle call s:exGS_ToggleWindow('Select')
command ExgsStackToggle call s:exGS_ToggleWindow('Stack')
command ExgsQuickViewToggle call s:exGS_ToggleWindow('QuickView')

" quick view command
command -nargs=1 GSPR call s:exGS_ShowPickedResult('<args>', 'replace', '')
command -nargs=1 GSPA call s:exGS_ShowPickedResult('<args>', 'append', '')
command -nargs=1 GSPN call s:exGS_ShowPickedResult('<args>', 'new', '')

" Ignore case setting
command GSigc call s:exGS_SetIgnoreCase(1)
command GSnoigc call s:exGS_SetIgnoreCase(0)


finish
" vim600: set foldmethod=marker foldmarker=<<<,>>> foldlevel=1:
