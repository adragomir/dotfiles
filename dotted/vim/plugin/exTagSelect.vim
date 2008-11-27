"=============================================================================
" File:        exTagSelect.vim
" Author:      Johnny
" Last Change: Wed 25 Oct 2006 01:05:03 PM EDT
" Version:     1.0
"=============================================================================
" You may use this code in whatever way you see fit.

if exists('loaded_extagselect') || &cp
    finish
endif
let loaded_extagselect=1

" -------------------------------------------------------------------------
"  variable part
" -------------------------------------------------------------------------

" Initialization <<<

" -------------------------------
" gloable varialbe initialization
" -------------------------------

" window height for horizon window mode
if !exists('g:exTS_window_height')
    let g:exTS_window_height = 20
endif

" window width for vertical window mode
if !exists('g:exTS_window_width')
    let g:exTS_window_width = 30
endif

" window height increment value
if !exists('g:exTS_window_height_increment')
    let g:exTS_window_height_increment = 30
endif

" window width increment value
if !exists('g:exTS_window_width_increment')
    let g:exTS_window_width_increment = 100
endif

" go back to edit buffer
" 'topleft','botright'
if !exists('g:exTS_window_direction')
    let g:exTS_window_direction = 'botright'
endif

" use vertical or not
if !exists('g:exTS_use_vertical_window')
    let g:exTS_use_vertical_window = 0
endif

" go back to edit buffer
if !exists('g:exTS_backto_editbuf')
    let g:exTS_backto_editbuf = 1
endif

" go and close exTagSelect window
if !exists('g:exTS_close_when_selected')
    let g:exTS_close_when_selected = 0
endif

" set edit mode
" 'none', 'append', 'replace'
if !exists('g:exTS_edit_mode')
    let g:exTS_edit_mode = 'replace'
endif

" -------------------------------
" local variable initialization
" -------------------------------

" title
let s:exTS_select_title = "__exTS_SelectWindow__"
let s:exTS_stack_title = "__exTS_StackWindow__"
let s:exTS_short_title = 'Select'

" general
let s:exTS_ignore_case = 0
let s:exTS_need_parse_again = 0
let s:exTS_tag_state_tmp = {'tag_name':'', 'tag_idx':-1, 'tag_list':[], 'max_tags':-1, 'output_result':'', 'entry_cursor_pos':[-1,-1,-1,-1], 'entry_file_name':'', 'stack_preview':''}
let s:exTS_tag_state_0 = {'tag_name':'exTS_StartPoint', 'tag_idx':-1, 'tag_list':[], 'max_tags':-1, 'output_result':'StartPoint', 'entry_cursor_pos':[-1,-1,-1,-1], 'entry_file_name':'', 'stack_preview':''}

" select variable
let s:exTS_tag_select_idx = 1
let s:exTS_cursor_idx = 0
let s:exTS_need_update_select_window = 0

" stack variable
let s:exTS_stack_idx = 0
let s:exTS_need_update_stack_window = 0
let s:exTS_stack_height = 0
let s:exTS_need_push_tag = 0

" >>>

" -------------------------------------------------------------------------
"  function part
" -------------------------------------------------------------------------

" --exTS_OpenWindow--
" Open exTagSelect window 
function! s:exTS_OpenWindow( short_title ) " <<<
    if a:short_title != ''
        let s:exTS_short_title = a:short_title
    endif
    let title = '__exTS_' . s:exTS_short_title . 'Window__'
    " open window
    if g:exTS_use_vertical_window
        call g:ex_OpenWindow( title, g:exTS_window_direction, g:exTS_window_width, g:exTS_use_vertical_window, g:exTS_edit_mode, g:exTS_backto_editbuf, 'g:exTS_Init'.s:exTS_short_title.'Window', 'g:exTS_Update'.s:exTS_short_title.'Window' )
    else
        call g:ex_OpenWindow( title, g:exTS_window_direction, g:exTS_window_height, g:exTS_use_vertical_window, g:exTS_edit_mode, g:exTS_backto_editbuf, 'g:exTS_Init'.s:exTS_short_title.'Window', 'g:exTS_Update'.s:exTS_short_title.'Window' )
    endif
endfunction " >>>

" --exTS_ResizeWindow--
" Resize the window use the increase value
function! s:exTS_ResizeWindow() " <<<
    if g:exTS_use_vertical_window
        call g:ex_ResizeWindow( g:exTS_use_vertical_window, g:exTS_window_width, g:exTS_window_width_increment )
    else
        call g:ex_ResizeWindow( g:exTS_use_vertical_window, g:exTS_window_height, g:exTS_window_height_increment )
    endif
endfunction " >>>

" --exTS_ToggleWindow--
" Toggle the window
function! s:exTS_ToggleWindow( short_title ) " <<<
    " if need switch window
    if a:short_title != ''
        if s:exTS_short_title != a:short_title
            if bufwinnr('__exTS_' . s:exTS_short_title . 'Window__') != -1
                call g:ex_CloseWindow('__exTS_' . s:exTS_short_title . 'Window__')
            endif
            let s:exTS_short_title = a:short_title
        endif
    endif

    " toggle exTS window
    let title = '__exTS_' . s:exTS_short_title . 'Window__'
    if g:exTS_use_vertical_window
        call g:ex_ToggleWindow( title, g:exTS_window_direction, g:exTS_window_width, g:exTS_use_vertical_window, 'none', g:exTS_backto_editbuf, 'g:exTS_Init'.s:exTS_short_title.'Window', 'g:exTS_Update'.s:exTS_short_title.'Window' )
    else
        call g:ex_ToggleWindow( title, g:exTS_window_direction, g:exTS_window_height, g:exTS_use_vertical_window, 'none', g:exTS_backto_editbuf, 'g:exTS_Init'.s:exTS_short_title.'Window', 'g:exTS_Update'.s:exTS_short_title.'Window' )
    endif
endfunction " >>>

" --exTS_SwitchWindow
function! s:exTS_SwitchWindow( short_title ) " <<<
    let title = '__exTS_' . a:short_title . 'Window__'
    if bufwinnr(title) == -1
        call s:exTS_ToggleWindow(a:short_title)
    endif
endfunction " >>>

" --exTS_SetCase--
"  set if ignore case
function! s:exTS_SetIgnoreCase(ignore_case) " <<<
    let s:exTS_ignore_case = a:ignore_case
    let s:exTS_need_parse_again = 1
    if a:ignore_case
        echomsg 'exTS ignore case'
    else
        echomsg 'exTS no ignore case'
    endif
endfunction " >>>

" ------------------------------
"  select window part
" ------------------------------

" --exTS_InitSelectWindow--
" Init exTagSelect window
function! g:exTS_InitSelectWindow() " <<<
    let s:exTS_tag_file_list = tagfiles()

    " syntax highlight
    syntax match exTS_SynFileName '^\S\+\s(.\+)$'
    syntax match exTS_SynTagName '^\S\+$'
    syntax match exTS_SynSearchPattern '^        \S.*$'

    highlight def exTS_SynFileName gui=none guifg=Blue 
    highlight def exTS_SynTagName gui=bold guifg=DarkRed guibg=LightGray
    highlight def exTS_SynSearchPattern gui=none guifg=Black 

    " key map
    nnoremap <buffer> <silent> <Return>   \|:call <SID>exTS_GotoTagSelectResult()<CR>
    nnoremap <buffer> <silent> <Space>   :call <SID>exTS_ResizeWindow()<CR>
    nnoremap <buffer> <silent> <ESC>   :call <SID>exTS_ToggleWindow('Select')<CR>
    nnoremap <buffer> <silent> <C-Left>   :call <SID>exTS_SwitchWindow('Select')<CR>
    nnoremap <buffer> <silent> <C-Right>   :call <SID>exTS_SwitchWindow('Stack')<CR>

    " autocmd
    au CursorMoved <buffer> :call s:exTS_SelectCursorMoved()
endfunction " >>>

" --exTS_UpdateSelectWindow--
" Update window
function! g:exTS_UpdateSelectWindow() " <<<
    if s:exTS_need_update_select_window
        let s:exTS_need_update_select_window = 0
        " clear window
        silent exe 'normal! Gdgg'
        silent put = s:exTS_tag_state_{s:exTS_stack_idx}.output_result
        silent exec 'normal ggdd'
    endif

    let tag_pattern = '^\s*' .  s:exTS_tag_state_{s:exTS_stack_idx}.tag_idx . ':'
    call search(tag_pattern, 'w')
    call g:ex_HighlightConfirmLine()
    let s:exTS_cursor_idx = line('.')
endfunction " >>>

" --exTS_SelectCursorMoved--
" call when cursor moved
function! s:exTS_SelectCursorMoved()
    let line_num = line('.')

    if line_num == s:exTS_cursor_idx
        call g:ex_HighlightSelectLine()
        return
    endif

    while match(getline('.'), '^\s\+\d\+:') == -1
        if line_num > s:exTS_cursor_idx
            if line('.') == line('$')
                break
            endif
            silent exec 'normal j'
        else
            if line('.') == 1
                break
            endif
            silent exec 'normal k'
        endif
    endwhile

    let s:exTS_cursor_idx = line('.')
    call g:ex_HighlightSelectLine()
endfunction

" --exTS_GetTagSelectResult--
"  Get the result of a word and use :ts record the result
function! s:exTS_GetTagSelectResult(tag, direct_jump) " <<<
    let in_tag = strpart( a:tag, match(a:tag, '\S') )
    if match(in_tag, '^\(\t\|\s\)') != -1
        return
    endif
    " if it is a new tag, push it into the tag stack and parse it.
    if in_tag !=# s:exTS_tag_state_{s:exTS_stack_idx}.tag_name && s:exTS_need_parse_again != 1
        let s:exTS_need_push_tag = 1
        let s:exTS_tag_select_idx = 1
    else
        let s:exTS_need_parse_again = 0
        let ts_winnr = bufwinnr(s:exTS_select_title)
        if ts_winnr == -1
            call s:exTS_ToggleWindow('Select')
        else
            exe ts_winnr . 'wincmd w'
        endif

        return
    endif

    " use lt to jump to the tag and go back.
    " this will help us to push tag to the vim_stack automatically
    let bufnr = bufnr('%')
    " save the entry point
    let cursor_pos = getpos(".")
    let stack_preview = getline(".")
    let stack_preview = strpart( stack_preview, match(stack_preview, '\S') )
    if a:direct_jump == 0
        let stack_preview = '[TS] ' . stack_preview
    else
        let stack_preview = '[DR] ' . stack_preview
    endif
    let s:exTS_tag_state_tmp.entry_file_name = bufname(bufnr)
    let s:exTS_tag_state_tmp.entry_cursor_pos = cursor_pos
    let s:exTS_tag_state_tmp.stack_preview = stack_preview
    if s:exTS_ignore_case && (match(in_tag, '\u') == -1)
        echomsg 'parsing ' . in_tag . '...(ignore case)'
        let tag_list = taglist('^'.in_tag.'$')
    else
        echomsg 'parsing ' . in_tag . '...(no ignore case)'
        let tag_list = taglist('^\C'.in_tag.'$')
    endif
    let result = ''
    if empty(tag_list)
        let result = 'Error detected while processing'
    endif

    " open window
    let ts_winnr = bufwinnr(s:exTS_select_title)
    if ts_winnr == -1
        let old_opt = g:exTS_backto_editbuf
        let g:exTS_backto_editbuf = 0
        call s:exTS_ToggleWindow('Select')
        let g:exTS_backto_editbuf = old_opt
    else
        exe ts_winnr . 'wincmd w'
    endif

    " clear window
    exe 'normal! Gdgg'
    call g:ex_HighlightConfirmLine()

    if match( result, 'Error detected while processing' ) != -1
        silent put = 'Error: tag not found ==> ' . in_tag
        return
    endif

    " Init variable
    let idx = 1
    let pre_tag_name = tag_list[0].name
    let pre_file_name = tag_list[0].filename
    " put different file name at first
    silent put = pre_tag_name
    silent put = g:ex_ConvertFileName(pre_file_name)
    " put search result
    for tag_info in tag_list
        if tag_info.name !=# pre_tag_name
            silent put = ''
            silent put = tag_info.name
            silent put = g:ex_ConvertFileName(tag_info.filename)
        elseif tag_info.filename !=# pre_file_name
            silent put = g:ex_ConvertFileName(tag_info.filename)
        endif
        " put search patterns
        let quick_view = ''
        if match( tag_info.cmd, '^\/\^' ) != -1
            let quick_view = strpart( tag_info.cmd, 2, strlen(tag_info.cmd)-4 )
            let quick_view = strpart( quick_view, match(quick_view, '\S') )
        elseif match( tag_info.cmd, '^\d\+' ) != -1
            let file_list = readfile(g:ex_MatchTagFile( s:exTS_tag_file_list, tag_info.filename))
            let line_num = eval(tag_info.cmd) - 1 
            let quick_view = file_list[line_num]
            let quick_view = strpart( quick_view, match(quick_view, '\S') )
        endif
        silent put = '        ' . idx . ': ' . quick_view
        let idx += 1
        let pre_tag_name = tag_info.name
        let pre_file_name = tag_info.filename
    endfor

    " copy full parsed text to register a
    let reg_a = @a
    exe 'normal gg'
    exe 'normal "ayG'

    " go to first then highlight
    exe 'normal gg'
    let tag_pattern = '^\s*1:'
    call search( tag_pattern, 'w')
    call g:ex_HighlightSelectLine()

    " after push stack if needed, re-init s:exTS_tag_state_tmp
    let s:exTS_tag_state_tmp.tag_name = in_tag
    let s:exTS_tag_state_tmp.tag_idx = 1
    let s:exTS_tag_state_tmp.output_result = @a
    let s:exTS_tag_state_tmp.max_tags = len(tag_list)
    let s:exTS_tag_state_tmp.tag_list = tag_list

    " restore register a
    let @a = reg_a
endfunction " >>>

" --exTS_GotoTagSelectResult--
" Goto result position
function! s:exTS_GotoTagSelectResult() " <<<
    " read current line as search pattern
    let cur_line = getline(".")
    if match(cur_line, '^        \S.*$') == -1
        call g:ex_WarningMsg('Pattern not found')
        return
    endif
    let idx = match(cur_line, '\S')
    let cur_line = strpart(cur_line, idx)
    let idx = match(cur_line, ':')
    let tag_idx = eval(strpart(cur_line, 0, idx))

    " close when selected if needed
    if g:exTS_close_when_selected
        let winnum = bufwinnr(s:exTS_select_title)
        if winnr() != winnum
            exe winnum . 'wincmd w'
        endif
        close
    endif

    " push tag state to tag stack
    if s:exTS_need_push_tag
        let s:exTS_need_push_tag = 0

        " set last stack_idx states
        let s:exTS_tag_state_{s:exTS_stack_idx}.entry_file_name = s:exTS_tag_state_tmp.entry_file_name 
        let s:exTS_tag_state_{s:exTS_stack_idx}.entry_cursor_pos = s:exTS_tag_state_tmp.entry_cursor_pos
        let s:exTS_tag_state_{s:exTS_stack_idx}.stack_preview = s:exTS_tag_state_tmp.stack_preview

        " push stack
        let s:exTS_tag_state_tmp.entry_file_name = ''
        let s:exTS_tag_state_tmp.entry_cursor_pos = [-1,-1,-1,-1]
        let s:exTS_tag_state_tmp.stack_preview = ''
        let s:exTS_tag_state_tmp.tag_idx = tag_idx
        call s:exTS_PushTagStack(s:exTS_tag_state_tmp)
    else
        let s:exTS_tag_state_{s:exTS_stack_idx}.tag_idx = tag_idx
    endif

    " jump by command
    let s:exTS_tag_select_idx = tag_idx
    call g:ex_GotoExCommand( g:ex_MatchTagFile( s:exTS_tag_file_list, s:exTS_tag_state_{s:exTS_stack_idx}.tag_list[tag_idx-1].filename ), s:exTS_tag_state_{s:exTS_stack_idx}.tag_list[tag_idx-1].cmd )
    "call g:ex_GotoExCommand( s:exTS_tag_state_{s:exTS_stack_idx}.tag_list[tag_idx-1].filename, s:exTS_tag_state_{s:exTS_stack_idx}.tag_list[tag_idx-1].cmd )

    " go back if needed
    if !g:exTS_close_when_selected
        if !g:exTS_backto_editbuf
            let winnum = bufwinnr(s:exTS_select_title)
            if winnr() != winnum
                exe winnum . 'wincmd w'
            endif
            return
        endif
    endif
endfunction " >>>

" --exTS_GoDirect--
function! s:exTS_GoDirect() " <<<
    let reg_a = @a
    exe 'normal "ayiw'
    call s:exTS_GetTagSelectResult(@a, 1)
    let @a = reg_a
endfunction " >>>

" -------------------------------------------------------------------------
"  tag stack function part
" -------------------------------------------------------------------------

" --exTS_InitStackWindow--
" Init exTagSelectStack window
function! g:exTS_InitStackWindow() " <<<
    " syntax highlight
    syntax match exTS_SynJumpMethodTS '\[TS]'
    syntax match exTS_SynJumpMethodDR '\[DR]'
    syntax match exTS_SynJumpSymbol '======>'
    syntax match exTS_SynStackTitle '#.\+TAG NAME.\+ENTRY POINT PREVIEW'

    highlight def exTS_SynJumpMethodTS gui=none guifg=Red 
    highlight def exTS_SynJumpMethodDR gui=none guifg=Blue 
    highlight def exTS_SynJumpSymbol gui=none guifg=DarkGreen
    highlight def exTS_SynStackTitle gui=bold guifg=Brown

    " map keys
    nnoremap <buffer> <silent> <Return>   \|:call <SID>exTS_Stack_GoDirect()<CR>
    nnoremap <buffer> <silent> <Space>   :call <SID>exTS_ResizeWindow()<CR>
    nnoremap <buffer> <silent> <ESC>   :call <SID>exTS_ToggleWindow('Stack')<CR>
    nnoremap <buffer> <silent> <C-Left>   :call <SID>exTS_SwitchWindow('Select')<CR>
    nnoremap <buffer> <silent> <C-Right>   :call <SID>exTS_SwitchWindow('Stack')<CR>

    " autocmd
    au CursorMoved <buffer> :call g:ex_HighlightSelectLine()
endfunction " >>>

" --exTS_UpdateStackWindow--
" Update stack window
function! g:exTS_UpdateStackWindow() " <<<
    if s:exTS_need_update_stack_window
        let s:exTS_need_update_stack_window = 0
        exe 'normal! Gdgg'
        call s:exTS_ShowTagStack()
    endif

    let pattern = s:exTS_stack_idx . ':'
    if search( pattern, 'w') == 0
        call g:ex_WarningMsg('Pattern not found')
        return
    endif
    call g:ex_HighlightConfirmLine()
endfunction " >>>

" --exTS_PushTagStack--
" Push tags into tag stack
function! s:exTS_PushTagStack( tag_state ) " <<<
    let s:exTS_stack_idx += 1
    let s:exTS_stack_height = s:exTS_stack_idx

    " assignt the exTS_stack_{idx}
    let s:exTS_tag_state_{s:exTS_stack_idx} = copy(a:tag_state)

    " need update the stack window
    let s:exTS_need_update_stack_window = 1

    return s:exTS_stack_idx
endfunction " >>>

" --exTS_ShowTagStack()--
" Show the tag stack list in current window
function! s:exTS_ShowTagStack() " <<<
    let tag_name = 'TAG NAME'
    let stack_preview = 'ENTRY POINT PREVIEW'
    let str_line = printf(" #  %-54s%s", tag_name, stack_preview)
    silent put = str_line
    let idx = 0
    while idx <= s:exTS_stack_height
        "silent put = idx . ': ' . s:exTS_tag_state_{idx}.tag_name . '  ====>  ' . s:exTS_tag_state_{idx}.stack_preview
        let str_line = printf("%2d: %-40s ======> %s", idx, s:exTS_tag_state_{idx}.tag_name, s:exTS_tag_state_{idx}.stack_preview)
        silent put = str_line
        let idx += 1
    endwhile
    silent exec 'normal ggdd'
endfunction " >>>


" --exTS_Stack_GotoTag--
" Go to idx tags
" jump_method : 'to_tag', to_entry
function! s:exTS_Stack_GotoTag( idx, jump_method ) " <<<
    let jump_method = a:jump_method
    " if idx < 0, return
    if a:idx < 0
        call g:ex_WarningMsg('at the top of exTagStack')
        let s:exTS_stack_idx = 0
        return
    endif
    let need_jump = 0
    if s:exTS_stack_idx != a:idx
        let s:exTS_stack_idx = a:idx
        let need_jump = 1
        " start point always use to_entry method
        if s:exTS_stack_idx == 0
            let jump_method = 'to_entry'
        endif
    endif

    " open and go to stack window first
    if bufwinnr(s:exTS_stack_title) == -1
        let old_setting = g:exTS_backto_editbuf
        let g:exTS_backto_editbuf = 0
        call s:exTS_ToggleWindow('Stack')
        let g:exTS_backto_editbuf = old_setting
    else
        call g:exTS_UpdateStackWindow()
    endif

    " start parsing
    if need_jump == 1
        let s:exTS_need_update_select_window = 1

        " go by tag_idx
        if jump_method == 'to_entry'
            call g:ex_GotoEditBuffer()
            silent exec 'e ' . s:exTS_tag_state_{s:exTS_stack_idx}.entry_file_name
            call setpos('.', s:exTS_tag_state_{s:exTS_stack_idx}.entry_cursor_pos)
        else
            let tag_idx = s:exTS_tag_state_{s:exTS_stack_idx}.tag_idx
            call g:ex_GotoExCommand( g:ex_MatchTagFile( s:exTS_tag_file_list, s:exTS_tag_state_{s:exTS_stack_idx}.tag_list[tag_idx-1].filename ), s:exTS_tag_state_{s:exTS_stack_idx}.tag_list[tag_idx-1].cmd )
            "call g:ex_GotoExCommand( s:exTS_tag_state_{s:exTS_stack_idx}.tag_list[tag_idx-1].filename, s:exTS_tag_state_{s:exTS_stack_idx}.tag_list[tag_idx-1].cmd )
        endif
        exe 'normal zz'
    endif

    " go back if needed
    if !g:exTS_close_when_selected
        if !g:exTS_backto_editbuf
            let winnum = bufwinnr(s:exTS_stack_title)
            if winnr() != winnum
                exe winnum . 'wincmd w'
            endif
            return
        endif
    else
        let winnum = bufwinnr(s:exTS_stack_title)
        if winnr() != winnum
            exe winnum . 'wincmd w'
        endif
        close
        call g:ex_GotoEditBuffer()
    endif
endfunction " >>>

" --exTS_Stack_GoDirect--
function! s:exTS_Stack_GoDirect() " <<<
    let cur_line = getline(".")
    let idx = match(cur_line, '\S')
    let cur_line = strpart(cur_line, idx)
    let idx = match(cur_line, ':')
    let stack_idx = eval(strpart(cur_line, 0, idx))
    call g:ex_HighlightConfirmLine()

    " if select idx > old idx, jump to tag. else jump to entry
    if stack_idx > s:exTS_stack_idx
        call s:exTS_Stack_GotoTag(stack_idx, 'to_tag')
    else
        call s:exTS_Stack_GotoTag(stack_idx, 'to_entry')
    endif
endfunction " >>>

" -------------------------------------------------------------------------
" Command part
" -------------------------------------------------------------------------
command -nargs=1 TS call s:exTS_GetTagSelectResult('<args>', 0)
command PopTagStack call s:exTS_Stack_GotoTag(s:exTS_stack_idx-1, 'to_entry')
command TAGS call call s:exTS_SwitchWindow('Stack')
command ExtsSelectToggle call s:exTS_ToggleWindow('Select')
command ExtsStackToggle call s:exTS_ToggleWindow('Stack')
command ExtsToggle call s:exTS_ToggleWindow('')
command ExtsGoDirectly call s:exTS_GoDirect()

" Ignore case setting
command TSigc call s:exTS_SetIgnoreCase(1)
command TSnoigc call s:exTS_SetIgnoreCase(0)

finish
" vim600: set foldmethod=marker foldmarker=<<<,>>> foldlevel=1:
