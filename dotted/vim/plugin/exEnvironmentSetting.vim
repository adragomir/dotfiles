if exists('loaded_ex_environment_setting') || &cp
    finish
endif
let loaded_ex_environment_setting=1

" -------------------------------------------------------------------------
"  variable part
" -------------------------------------------------------------------------
" Initialization <<<
" gloable variable initialization
let g:exES_setted = 0

" >>>

" -------------------------------------------------------------------------
"  function part
" -------------------------------------------------------------------------

" --exES_WriteDefaultTemplate--
function! s:exES_WriteDefaultTemplate() " <<<
    let _cwd = substitute( getcwd(), "\\", "\/", "g" )
    let _project_name = strpart( _cwd, strridx(_cwd, "/")+1 )
    let _list = []

    silent call add(_list, 'PWD='._cwd)
    silent call add(_list, 'Project='._cwd.'/'._project_name.'.vimprojects')
    silent call add(_list, 'Tag='._cwd.'/tags')
    silent call add(_list, 'ID='._cwd.'/ID')
    silent call add(_list, 'Symbol='._cwd.'/symbol')

    silent put! = _list
    silent exec "w!"
endfunction " >>>


" --exES_SetEnvironment--
function! g:exES_SetEnvironment() " <<<
    " do not show it in buffer list
    silent! setlocal bufhidden=hide
    silent! setlocal noswapfile
    silent! setlocal nobuflisted

    let _file_name = bufname("%")
    if match(_file_name,"vimenvironment") != -1
        if empty( readfile(_file_name) )
            " if the file is empty, we creat a template for it
            call s:exES_WriteDefaultTemplate()
        endif
    endif

    " get environment value
    if g:exES_setted != 1
        let g:exES_setted = 1
"         let g:exES_PWD = ''
"         let project_file = ''
"         let tag_file = ''

        for Line in getline(1, '$')
            let SettingList = split(Line, "=")
            if len(SettingList)>=2
                exec "let g:exES_".SettingList[0]."='".escape(SettingList[1], ' ')."'"
            endif
        endfor

        if exists('*g:exES_UpdateEnvironment')
            call g:exES_UpdateEnvironment()
        endif
    endif
endfunction " >>>



" if it is vimenvironment files, set evironment first
au BufEnter *.vimenvironment call g:exES_SetEnvironment()


finish
" vim600: set foldmethod=marker foldmarker=<<<,>>> foldlevel=1:
