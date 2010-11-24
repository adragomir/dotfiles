"
" File: clang_complete.vim
" Author: Xavier Deguillard <deguilx@gmail.com>
"
" Description: Use of clang to complete in C/C++.
"
" Configuration: Each project can have a .clang_complete at his root,
" containing the compiler options. This is usefull if
" you're using some non-standard include paths.
"
" Options: g:clang_complete_auto: if equal to 1, automatically complete
" after ->, ., ::
" Default: 1
" g:clang_complete_copen: if equal to 1, open quickfix window
" on error. WARNING: segfault on
" unpatched vim!
" Default: 0
"
" Todo: - Handle OVERLOAD when completing function arguments correctly.
" - Handle COMPLETION: Pattern correctly.
" - http://llvm.org/viewvc/llvm-project/llvm/trunk/utils/vim/vimrc
"

au FileType c,cpp call s:ClangCompleteInit()

let b:clang_exec = ''
let b:clang_parameters = ''
let b:clang_user_options = ''

function s:ClangCompleteInit()
    let l:local_conf = findfile(".clang_complete", '.;')
    let l:opts = split(system("cat " . l:local_conf), "\n")
    let b:clang_user_options = ''
    for l:opt in l:opts
        let l:opt = substitute(l:opt, '-I\(\w*\)',
                    \ '-I' . l:local_conf[:-16] . '\1', "g")
        let b:clang_user_options .= " " . l:opt
    endfor

    if !exists('g:clang_complete_auto')
        let g:clang_complete_auto = 1
    endif

    if !exists('g:clang_complete_copen')
        let g:clang_complete_copen = 0
    endif

    if g:clang_complete_auto == 1
        inoremap <expr> <C-X><C-U> LaunchCompletion()
        inoremap <expr> . CompleteDot()
        inoremap <expr> > CompleteArrow()
        inoremap <expr> : CompleteColon()
    endif

    let b:clang_exec = 'clang'
    let b:clang_parameters = '-x c'

    if &filetype == 'cpp'
        let b:clang_exec .= '++'
        let b:clang_parameters .= '++'
    endif

    if expand('%:e') =~ 'h*'
        let b:clang_parameters .= '-header'
    endif

    setlocal completefunc=ClangComplete
endfunction

function s:get_kind(proto)
    if a:proto == ""
        return 't'
    endif
    let l:ret = match(a:proto, '^\[#')
    let l:params = match(a:proto, '(')
    if l:ret == -1 && l:params == -1
        return 't'
    endif
    if l:ret != -1 && l:params == -1
        return 'v'
    endif
    if l:params != -1
        return 'f'
    endif
    return 'm'
endfunction

function s:ClangQuickFix(clang_output)
    let l:list = []
    for l:line in a:clang_output
        let l:erridx = stridx(l:line, "error:")
        if l:erridx == -1
            continue
        endif
        let l:bufnr = bufnr("%")
        let l:pattern = '\.*:\(\d*\):\(\d*\):'
        let tmp = matchstr(l:line, l:pattern)
        let l:lnum = substitute(tmp, l:pattern, '\1', '')
        let l:col = substitute(tmp, l:pattern, '\2', '')
        let l:text = l:line
        let l:type = 'E'
        let l:item = {
                    \ "bufnr": l:bufnr,
                    \ "lnum": l:lnum,
                    \ "col": l:col,
                    \ "text": l:text[l:erridx + 7:],
                    \ "type": l:type }
        let l:list = add(l:list, l:item)
    endfor
    call setqflist(l:list)
" The following line cause vim to segfault. A patch is ready on vim
" mailing list but not currently upstream, I will update it as soon
" as it's upstream. If you want to have error reporting will you're
" coding, you could open at hand the quickfix window, and it will be
" updated.
" http://groups.google.com/group/vim_dev/browse_thread/thread/5ff146af941b10da
    if g:clang_complete_copen == 1
        copen
    endif
endfunction

function ClangComplete(findstart, base)
    if a:findstart
        let l:line = getline('.')
        let l:start = col('.') - 1
        while l:start > 0 && l:line[start - 1] =~ '\i'
            let l:start -= 1
        endwhile
        return start
    else
        let l:buf = getline(1, '$')
        let l:tempfile = system("mktemp --tmpdir=" . expand('%:p:h')
                    \. " --suffix=" . expand('%:t'))
        let l:tempfile = l:tempfile[:-2] " Suppress the '\n' at the end of the filename.
        call writefile(l:buf, l:tempfile)

        let l:command = b:clang_exec . " -cc1 -fsyntax-only -code-completion-at="
                    \ . l:tempfile . ":" . line('.') . ":" . col('.') . " " . l:tempfile
                    \ . " " . b:clang_parameters . " " . b:clang_user_options . " -o -"
        let l:clang_output = split(system(l:command), "\n")
        call delete(l:tempfile)
        if v:shell_error
            call s:ClangQuickFix(l:clang_output)
            return {}
        endif
        if l:clang_output == []
            return {}
        endif
        for l:line in l:clang_output
            if l:line[:11] == 'COMPLETION: '
                let l:value = l:line[12:]

                if l:value !~ '^' . a:base
                    continue
                endif

                let l:colonidx = stridx(l:value, " : ")
                let l:word = value[:l:colonidx - 1]
                let l:proto = value[l:colonidx + 3:]
                let l:kind = s:get_kind(l:proto)
                let l:proto = substitute(l:proto, '[#', "", "g")
                let l:proto = substitute(l:proto, '#]', ' ', "g")
                let l:proto = substitute(l:proto, '#>', "", "g")
                let l:proto = substitute(l:proto, '<#', "", "g")
" TODO: add a candidate for each optional parameter
                let l:proto = substitute(l:proto, '{#', "", "g")
                let l:proto = substitute(l:proto, '#}', "", "g")

                let l:item = {
                            \ "word": l:word,
                            \ "menu": l:proto,
                            \ "info": l:proto,
                            \ "dup": 1,
                            \ "kind": l:kind }

                if complete_add(l:item) == 0
                    return {}
                endif
                if complete_check()
                    return {}
                endif

            elseif l:line[:9] == 'OVERLOAD: '
" An overload candidate. Use a crazy hack to get vim to
" display the results. TODO: Make this better.
                let l:value = l:line[10:]
                let l:item = {
                            \ "word": " ",
                            \ "menu": l:value,
                            \ "kind": "f",
                            \ "info": l:line,
                            \ "dup": 1}

" Report a result.
                if complete_add(l:item) == 0
                    return {}
                endif
                if complete_check()
                    return {}
                endif

            endif
        endfor
    endif
endfunction

function InComment()
    return match(synIDattr(synID(line("."), col(".") - 1, 1), "name"),
                \'\C\<cComment\|\<cCppString\|\<cIncluded\|\<cString\|cInclude')
                \ >= 0
endfunction

function LaunchCompletion()
    if InComment()
        return ""
    else
        return "\<C-X>\<C-U>"
    endif
endfunction

function CompleteDot()
    return '.' . LaunchCompletion()
endfunction

function CompleteArrow()
    if getline('.')[col('.') - 2] != '-'
        return '>'
    endif
    return '>' . LaunchCompletion()
endfunction

function CompleteColon()
    if getline('.')[col('.') - 2] != ':'
        return ':'
    endif
    return ':' . LaunchCompletion()
endfunction

