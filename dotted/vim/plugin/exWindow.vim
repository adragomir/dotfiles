"=============================================================================
" File:        exScript.vim
" Author:      Johnny
" Last Change: Wed 29 Oct 2006 01:05:03 PM EDT
" Version:     1.0
"=============================================================================
" You may use this code in whatever way you see fit.

if exists('loaded_exscript') || &cp
    finish
endif
let loaded_exscript=1

" -------------------------------------------------------------------------
"  variable part
" -------------------------------------------------------------------------
" Initialization <<<
" gloable variable initialization

" local script vairable initialization
let s:ex_editbuf_name = ''
let s:ex_editbuf_ftype = ''
let s:ex_editbuf_lnum = ''
let s:ex_editbuf_num = ''

" >>>

" -------------------------------------------------------------------------
"  function part
" -------------------------------------------------------------------------
" --ex_RecordCurrentBufNum--
" Record current buf num when leave
function! g:ex_RecordCurrentBufNum() " <<<
    let s:ex_editbuf_num = bufnr('%')
endfunction " >>>

" --ex_CreateWindow--
" Create window
" buffer_name : a string of the buffer_name
" window_direction : 'topleft', 'botright'
" use_vertical : 0, 1
" edit_mode : 'none', 'append', 'replace'
" init_func_name: 'none', 'function_name'
function! g:ex_CreateWindow( buffer_name, window_direction, window_size, use_vertical, edit_mode, init_func_name ) " <<<
    " If the window is open, jump to it
    let winnum = bufwinnr(a:buffer_name)
    if winnum != -1
        "Jump to the existing window
        if winnr() != winnum
            exe winnum . 'wincmd w'
        endif

        if a:edit_mode == 'append'
            exe 'normal! G'
        elseif a:edit_mode == 'replace'
            exe 'normal! ggdG'
        endif

        return
    endif

    " Create a new window. If user prefers a horizontal window, then open
    " a horizontally split window. Otherwise open a vertically split
    " window
    if a:use_vertical
        " Open a vertically split window
        let win_dir = 'vertical '
    else
        " Open a horizontally split window
        let win_dir = ''
    endif
    
    " If the tag listing temporary buffer already exists, then reuse it.
    " Otherwise create a new buffer
    let bufnum = bufnr(a:buffer_name)
    if bufnum == -1
        " Create a new buffer
        let wcmd = a:buffer_name
    else
        " Edit the existing buffer
        let wcmd = '+buffer' . bufnum
    endif

    " Create the ex_window
    exe 'silent! ' . win_dir . a:window_direction . ' 10' . ' split ' . wcmd
    exe win_dir . 'resize ' . a:window_size

    " Initialize the window
    if bufnum == -1
        call g:ex_InitWindow( a:init_func_name )
    endif

    " adjust with edit_mode
    if a:edit_mode == 'append'
        exe 'normal! G'
    elseif a:edit_mode == 'replace'
        exe 'normal! ggdG'
    endif

endfunction " >>>

" --ex_InitWindow--
" Init window
" init_func_name: 'none', 'function_name'
function! g:ex_InitWindow(init_func_name) " <<<
    setlocal filetype=ex_filetype

    " Folding related settings
    setlocal foldenable
    setlocal foldminlines=0
    setlocal foldmethod=manual
    setlocal foldlevel=9999

    " Mark buffer as scratch
    silent! setlocal buftype=nofile
    silent! setlocal bufhidden=hide
    silent! setlocal noswapfile
    silent! setlocal nobuflisted

    silent! setlocal nowrap

    " If the 'number' option is set in the source window, it will affect the
    " exTagSelect window. So forcefully disable 'number' option for the exTagSelect
    " window
    silent! setlocal nonumber
    set winfixheight
    set winfixwidth

    " Define hightlighting
    syntax match ex_SynError '^Error:.*'

    highlight def ex_SynSelectLine gui=none guifg=Black guibg=LightBlue
    highlight def ex_SynConfirmLine gui=none guifg=Black guibg=Orange
    highlight def ex_SynObjectLine gui=none guifg=Black guibg=Orange
    highlight def ex_SynError gui=none guifg=White guibg=Red 

    " Define the ex autocommands
    augroup ex_auto_cmds
        autocmd WinLeave * call g:ex_RecordCurrentBufNum()
    augroup end

    if a:init_func_name != 'none'
        exe 'call ' . a:init_func_name . '()'
    endif
endfunction " >>>

" --ex_OpenWindow--
"  Open window
" buffer_name : a string of the buffer_name
" window_direction : 'topleft', 'botright'
" use_vertical : 0, 1
" edit_mode : 'none', 'append', 'replace'
" backto_editbuf : 0, 1
" init_func_name: 'none', 'function_name'
" call_func_name: 'none', 'function_name'
function! g:ex_OpenWindow( buffer_name, window_direction, window_size, use_vertical, edit_mode, backto_editbuf, init_func_name, call_func_name ) " <<<
    " If the window is open, jump to it
    let winnum = bufwinnr(a:buffer_name)
    if winnum != -1
        " Jump to the existing window
        if winnr() != winnum
            exe winnum . 'wincmd w'
        endif

        if a:edit_mode == 'append'
            exe 'normal! G'
        elseif a:edit_mode == 'replace'
            exe 'normal! ggdG'
        endif

        return
    endif

    " Get the filename and filetype for the specified buffer
    let s:ex_editbuf_name = fnamemodify(bufname('%'), ':p')
    let s:ex_editbuf_ftype = getbufvar('%', '&filetype')
    let s:ex_editbuf_lnum = line('.')
    let s:ex_editbuf_num = bufnr('%')

    " Open window
    call g:ex_CreateWindow( a:buffer_name, a:window_direction, a:window_size, a:use_vertical, a:edit_mode, a:init_func_name )

    if a:call_func_name != 'none'
        exe 'call ' . a:call_func_name . '()'
    endif

    " highlight current line
    call g:ex_HighlightConfirmLine()

    if a:backto_editbuf
        " Need to jump back to the original window only if we are not
        " already in that window
        let winnum = bufwinnr(s:ex_editbuf_num)
        if winnr() != winnum
            exe winnum . 'wincmd w'
        endif
    endif
endfunction " >>>

" --ex_CloseWindow--
"  Close window
function! g:ex_CloseWindow( buffer_name ) " <<<
    "Make sure the window exists
    let winnum = bufwinnr(a:buffer_name)
    if winnum == -1
        call g:ex_WarningMsg('Error: ' . a:buffer_name . ' window is not open')
        return
    endif
    
    if winnr() == winnum
        let last_buf_num = bufnr('#') 
        " Already in the window. Close it and return
        if winbufnr(2) != -1
            " If a window other than the a:buffer_name window is open,
            " then only close the a:buffer_name window.
            close
        endif

        " Need to jump back to the original window only if we are not
        " already in that window
        let winnum = bufwinnr(last_buf_num)
        if winnr() != winnum
            exe winnum . 'wincmd w'
        endif
    else
        " Goto the a:buffer_name window, close it and then come back to the 
        " original window
        let cur_buf_num = bufnr('%')
        exe winnum . 'wincmd w'
        close
        " Need to jump back to the original window only if we are not
        " already in that window
        let winnum = bufwinnr(cur_buf_num)
        if winnr() != winnum
            exe winnum . 'wincmd w'
        endif
    endif
    call g:ex_ClearObjectHighlight()
endfunction " >>>

" --ex_ToggleWindow--
" Toggle window
function! g:ex_ToggleWindow( buffer_name, window_direction, window_size, use_vertical, edit_mode, backto_editbuf, init_func_name, call_func_name ) " <<<
    " If exTagSelect window is open then close it.
    let winnum = bufwinnr(a:buffer_name)
    if winnum != -1
        call g:ex_CloseWindow(a:buffer_name)
        return
    endif

    call g:ex_OpenWindow( a:buffer_name, a:window_direction, a:window_size, a:use_vertical, a:edit_mode, a:backto_editbuf, a:init_func_name, a:call_func_name )
endfunction " >>>

" --ex_ResizeWindow
"  Resize window use increase value
function! g:ex_ResizeWindow( use_vertical, original_size, increase_size ) " <<<
    if a:use_vertical
        let new_size = a:original_size
        if winwidth('.') <= a:original_size
            let new_size = a:original_size + a:increase_size
        endif
        silent exe 'vertical resize ' . new_size
    else
        let new_size = a:original_size
        if winheight('.') <= a:original_size
            let new_size = a:original_size + a:increase_size
        endif
        silent exe 'resize ' . new_size
    endif


endfunction " >>>

" --ex_ConvertFileName--
" Convert full file name into the format: file_name (directory)
function! g:ex_ConvertFileName(full_file_name) " <<<
    let idx = strridx(a:full_file_name, '\')
    if idx != -1
        return strpart(a:full_file_name, idx+1) . ' (' . strpart(a:full_file_name, 0, idx) . ')'
    else
        return a:full_file_name . ' (' . '.)'
    endif
endfunction ">>>

" --ex_GetFullFileName--
" Get full file name from converted format
function! g:ex_GetFullFileName(converted_line) " <<<
    if match(a:converted_line, '^\S\+\s(\S\+)$') == -1
        call g:ex_WarningMsg('format is wrong')
        return
    endif
    let idx_space = stridx(a:converted_line, ' ')
    let simple_file_name = strpart(a:converted_line, 0, idx_space)
    let idx_bracket_first = stridx(a:converted_line, '(')
    let file_path = strpart(a:converted_line, idx_bracket_first+1)
    let idx_bracket_last = stridx(file_path, ')')
    return strpart(file_path, 0, idx_bracket_last) . '\' . simple_file_name
endfunction " >>>

" --ex_Goto--
" Goto the position by file name and search pattern
function! g:ex_GotoSearchPattern(full_file_name, search_pattern) " <<<
    " check and jump to the buffer first
    let winnum = bufwinnr(s:ex_editbuf_num)
    if winnr() != winnum
        exe winnum . 'wincmd w'
    endif

    " start jump
    let file_name = escape(a:full_file_name, ' ')
    exe 'silent e ' . file_name

    " if search_pattern is digital, just set pos of it
    let line_num = strpart(a:search_pattern, 2, strlen(a:search_pattern)-4)
    let line_num = matchstr(line_num, '^\d\+$')
    if line_num
        call cursor(eval(line_num), 1)
    elseif search(a:search_pattern, 'w') == 0
        call g:ex_WarningMsg('search pattern not found')
        return 0
    endif

    " set the text at the middle
    exe 'normal zz'

    return 1
endfunction " >>>

" --ex_MatchTagFile()--
" Match tag and find file if it has
function! g:ex_MatchTagFile( tag_file_list, file_name ) " <<<
    let full_file_name = ''
    for tag_file in a:tag_file_list
        let tag_path = strpart( tag_file, 0, strridx(tag_file, '\') )
        let full_file_name = tag_path . a:file_name
        if findfile(full_file_name) != ''
            break
        endif
        let full_file_name = ''
    endfor

    if full_file_name == ''
        call g:ex_WarningMsg( a:file_name . ' not found' )
    endif

    return full_file_name
endfunction " >>>

" --ex_GotoExCommand--
" Goto the position by file name and search pattern
function! g:ex_GotoExCommand(full_file_name, ex_cmd) " <<<
    " check and jump to the buffer first
    let winnum = bufwinnr(s:ex_editbuf_num)
    if winnr() != winnum
        exe winnum . 'wincmd w'
    endif

    " start jump
    let file_name = escape(a:full_file_name, ' ')
    if bufnr('%') != bufnr(file_name)
        exe 'silent e ' . file_name
    endif

    " cursor jump
    " if ex_cmd is digital, just set pos of it
    if match( a:ex_cmd, '^\/\^' ) != -1
        let pattern = strpart(a:ex_cmd, 2, strlen(a:ex_cmd)-4)
        let pattern = '\V\^' . pattern . (pattern[len(pattern)-1] == '$' ? '\$' : '')
        if search(pattern, 'w') == 0
            call g:ex_WarningMsg('search pattern not found: ' . pattern)
            return 0
        endif
    elseif match( a:ex_cmd, '^\d\+' ) != -1
        silent exe a:ex_cmd
    endif

    " set the text at the middle
    exe 'normal zz'

    return 1
endfunction " >>>

" --ex_GotoTagNumber--
function! g:ex_GotoTagNumber(tag_number) " <<<
    " check and jump to the buffer first
    let winnum = bufwinnr(s:ex_editbuf_num)
    if winnr() != winnum
        exe winnum . 'wincmd w'
    endif

    silent exec a:tag_number . "tr!"

    " set the text at the middle
    exe 'normal zz'
endfunction " >>>

" --ex_GotoPos--
" Goto the pos by position list
function! g:ex_GotoPos(poslist) " <<<
    " check and jump to the buffer first
    let winnum = bufwinnr(s:ex_editbuf_num)
    if winnr() != winnum
        exe winnum . 'wincmd w'
    endif

    " TODO must have buffer number or buffer name
    call setpos('.', a:poslist)

    " set the text at the middle
    exe 'normal zz'
endfunction " >>>

" --ex_GotoEditBuffer--
function! g:ex_GotoEditBuffer() " <<<
    " check and jump to the buffer first
    let winnum = bufwinnr(s:ex_editbuf_num)
    if winnr() != winnum
        exe winnum . 'wincmd w'
    endif
endfunction " >>>

" --ex_HighlightConfirmLine--
" hightlight confirm line
function! g:ex_HighlightConfirmLine() " <<<
    " Clear previously selected name
    match none
    " Highlight the current line
    let pat = '/\%' . line('.') . 'l.*/'
    exe 'match ex_SynConfirmLine ' . pat
endfunction " >>>

" --ex_HighlightSelectLine--
" hightlight select line
function! g:ex_HighlightSelectLine() " <<<
    " Clear previously selected name
    2match none
    " Highlight the current line
    let pat = '/\%' . line('.') . 'l.*/'
    exe '2match ex_SynSelectLine ' . pat
endfunction " >>>

" --ex_HighlightObjectLine--
" hightlight object line
function! g:ex_HighlightObjectLine() " <<<
    " Clear previously selected name
    3match none
    " Highlight the current line
    let pat = '/\%' . line('.') . 'l.*/'
    exe '3match ex_SynObjectLine ' . pat
endfunction " >>>

" --ex_ClearObjectHighlight--
"  clear the object line hight light
function! g:ex_ClearObjectHighlight() " <<<
    " Clear previously selected name
    3match none
endfunction " >>>

" --ex_WarningMsg--
" Display a message using WarningMsg highlight group
function! g:ex_WarningMsg(msg) " <<<
    echohl WarningMsg
    echomsg a:msg
    echohl None
endfunction " >>>

finish
" vim600: set foldmethod=marker foldmarker=<<<,>>> foldlevel=1:
