" CWiki 0.1a by Alex Kunin <alexkunin@gmail.com>
"
" The plugin enhances syntax/folding/mappings of the current buffer,
" converting current buffer to simple yet useful single-file wiki.
"
" Hopefully, more info can be found here soon: http://code.google.com/p/cwiki/

if exists("b:did_ftplugin")
  finish
endif

let b:did_ftplugin = 1

function! s:GetLastSelection()
    let l:saved = @@
    silent exe "normal! `<" . visualmode() . "`>y"
    let l:result = @@
    let @@ = l:saved
    return l:result
endfunction

function! s:GetTab()
    return &l:expandtab ? repeat(' ', &l:tabstop) : "\t"
endfunction

let s:TitlePattern = '^++\(+\+\)\s*\(.\+\)\s*$'
let s:PropertyPattern = '^\s\+\([^ :]\{-\}\):\s*\(.\{-1,\}\)\s*$'

let s:Tag = {
    \ 'tag':'',
    \ 'level':0,
    \ 'index':0,
    \ 'lines':[],
    \ 'properties':{}
\ }

function! s:Tag.parseTitle(string)
    return get(matchlist(a:string, s:TitlePattern), 2, '')
endfunction

function! s:Tag.unserialize(lines, index)
    let i = match(a:lines, s:TitlePattern)

    if i == -1
        throw 's:Tag.unserialize(): no tags found'
    endif

    let l:matches = matchlist(a:lines[i], s:TitlePattern)
    let l:result = deepcopy(self)
    let l:result.index = a:index
    let l:result.level = strlen(l:matches[1])
    let l:result.tag = l:matches[2]
    let i += 1

    while i < len(a:lines) && a:lines[i] == ''
        let i += 1
    endwhile

    while i < len(a:lines) && match(a:lines[i], s:PropertyPattern) != -1
        let l:matches = matchlist(a:lines[i], s:PropertyPattern)
        let l:result.properties[l:matches[1]] = l:matches[2]
        let i += 1
    endwhile

    while i < len(a:lines) && a:lines[i] == ''
        let i += 1
    endwhile

    let j = len(a:lines) - 1

    while i <= j && a:lines[j] == ''
        let j -= 1
    endwhile

    if i <= j
        let l:result.lines = a:lines[i : j]
    endif

    return l:result
endfunction

function! s:Tag.serialize()
    let l:result = []

    call add(l:result, '++' . repeat('+', self.level) . ' ' . self.tag)
    call add(l:result, '')

    if !empty(self.properties)
        call extend(l:result, map(sort(keys(self.properties)),
            \ 's:GetTab() . v:val . ": " . self.properties[v:val]'))
        call add(l:result, '')
    endif

    if !empty(self.lines)
        call extend(l:result, self.lines)
        call add(l:result, '')
    endif

    return l:result
endfunction

let s:CWiki = {
    \ 'header':[],
    \ 'tags':{},
    \ 'tab':''
\ }

function! s:CWiki.init()
    let b:cwiki = deepcopy(self)

    let &l:foldmethod = 'expr'
    let &l:foldexpr = 'b:cwiki.foldExpr()'
    let &l:foldtext = 'b:cwiki.foldText()'

    nmap <silent> <buffer> <F3> :call b:cwiki.showSelector()<CR>
    nmap <silent> <buffer> <F5> :call b:cwiki.refresh()<CR>
    nmap <silent> <buffer> <C-]> :call b:cwiki.folowTagUnderCursor()<CR>
	vmap <silent> <buffer> <C-]> :<C-U>call b:cwiki.addTag(<SID>GetLastSelection())<CR>
endfunction

function! s:CWiki.foldExpr()
    let l:line = getline(v:lnum)
    return l:line[0:2] == '+++' ? l:line[3] == '+' ? '>2' : '>1' : '='
endfunction

function! s:CWiki.foldText()
    let l:tag = s:Tag.parseTitle(getline(v:foldstart))
    return l:tag == '' ? '' : l:tag . ' (' . len(self.tags[l:tag].lines) . ')'
endfunction

function! s:CWiki.jumpToTag(tag)
    let l:pos = getpos(".")

    call cursor(1, 1)
    if search('^+++\+\s\+' . a:tag . '\s*$')
        normal zoztm'
        return 1
    endif

    call setpos('.', l:pos)
    return 0
endfunction

function! s:CWiki.getTagAt(x, y)
    let l:synID = synID(a:y, a:x, 0)

    if !l:synID
        let l:synID = synID(line('.') - 1, col([ line('.') - 1, '$' ]) - 1, 0)
    endif

    if l:synID
        let l:matches = matchlist(synIDattr(synID, 'name'), '^tag_\(\d\+\)$')

        if !empty(l:matches)
            let l:index = str2nr(l:matches[1])

            for l:tagData in values(self.tags)
                if l:index == l:tagData.index
                    return l:tagData.tag
                endif
            endfor
        endif
    endif

    return ''
endfunction

function! s:CWiki.folowTagUnderCursor()
    let l:tag = self.getTagAt(col('.'), line('.'))
    if l:tag != ''
        call self.jumpToTag(l:tag)
    endif
endfunction

function! s:CWiki.unserialize(lines)
    let self.tags = {}
    let self.header = []
    let l:index = 0

    let i = match(a:lines, s:TitlePattern)

    if i == -1
        return
    elseif i > 0
        let self.header = a:lines[0:i - 1]
    endif

    while i < len(a:lines)
        let j = match(a:lines, s:TitlePattern, i + 1)
        let j = j == -1 ? len(a:lines) : j
        let l:tag = s:Tag.unserialize(a:lines[i : j - 1], l:index)
        let l:index += 1
        let self.tags[l:tag.tag] = l:tag
        let i = j
    endwhile
endfunction

function! s:CWiki.serialize()
    let l:lines = self.header

    if !exists('*s:CompareIndices')
        function! s:CompareIndices(i1, i2)
            return a:i1.index - a:i2.index
        endfunction
    endif

    for l:tag in map(sort(copy(values(self.tags)), '<SID>CompareIndices'), 'v:val.tag')
        call extend(l:lines, self.tags[l:tag].serialize())
    endfor

    return l:lines
endfunction

function! s:CWiki.setupSyntax()
    let l:tags = {}

    syntax clear
    syntax sync linebreaks=1

    syntax match CWikiTitle1 /^+++\s*\(.\{-\}\)\s*$/ contains=CWikiTitleMark
    syntax match CWikiTitle2 /^++++\s*\(.\{-\}\)\s*$/ contains=CWikiTitleMark
    syntax match CWikiTitle3 /^+++++\+\s*\(.\{-\}\)\s*$/ contains=CWikiTitleMark
    syntax match CWikiTitleMark /^+++\+/ contained
    "syntax match PreProc /^\s*\(.\{-\}\):\s*\(.\{-\}\)\s*$/ contains=Identifier
    "syntax match Identifier /\(.\{-\}\):/ contained

    for l:tagData in values(self.tags)
        let l:tags[l:tagData.tag] = l:tagData.index

        if has_key(l:tagData.properties, 'Synonyms')
            for l:synonym in split(l:tagData.properties.Synonyms, '\s*,\s\+')
                for l:synonymVariant in split(expand(l:synonym), "\n")
                    let l:tags[l:synonymVariant] = l:tagData.index
                endfor
            endfor
        endif
    endfor

    if !exists('*s:CompareTags')
        function s:CompareTags(i1, i2)
            return strlen(a:i1) - strlen(a:i2)
        endfunction
    endif

    for l:tag in sort(keys(l:tags), '<SID>CompareTags')
        execute 'syntax match tag_' . l:tags[l:tag] . ' /' . substitute( substitute(l:tag, '\s\+', '[ \\t\\n]\\+', 'gs'), '\/', '\\/', 'gs') . '/'
    endfor

    for i in map(values(self.tags), 'v:val.index')
        execute 'highlight link tag_' . i . ' CWikiWord'
    endfor

    highlight link CWikiTitle1 Title
    highlight link CWikiTitle2 Title
    highlight link CWikiTitle3 Title
    highlight link CWikiTitleMark Title
    highlight link CWikiWord Underlined
endfunction

function! s:CWiki.addTag(tag)
    call setline(line('$') + 1, [ '+++ ' . a:tag, '' ])
    call self.unserialize(getline(1, '$'))
    call self.setupSyntax()
    call self.jumpToTag(a:tag)
endfunction

function! s:CWiki.setProperty(tag, property, value)
    if self.jumpToTag(a:tag)
        let l:line = line('.') + 1
        let l:string = s:GetTab() . a:property . ': ' . a:value
        let l:appendBlankLine = 0

        while l:line <= line('$') && getline(l:line) == ''
            let l:line += 1
        endwhile

        if l:line <= line('$')
            let l:appendBlankLine = 1
            while 1
                let l:matches = matchlist(getline(l:line), '^\s*\(.\{-\}\):\s*\(.\{-\}\)\s+$')
                if empty(l:matches)
                    if a:value == ''
                        return
                    endif

                    call append(l:line - 1, '')
                    break
                else
                    let l:appendBlankLine = 0
                    if l:matches[1] == a:property
                        if a:value == ''
                            call cursor(l:line, 1)
                            normal dd
                            unlet self.tags[a:tag].properties[a:property]
                            return
                        endif
                        break
                    else
                        let l:line += 1
                    endif
                endif
            endwhile
        else
            if a:value == ''
                return
            endif

            call append(l:line - 1, '')
        endif

        call setline(l:line, l:string)
        let self.tags[a:tag].properties[a:property] = a:value

        if l:appendBlankLine
            call append(l:line, '')
        endif
    endif
endfunction

function! s:CWiki.refresh()
    call self.unserialize(getline(1, '$'))
    call self.setupSyntax()
endfunction

function! s:CWiki.showSelector()
    let i = search('^+++', 'bcnW')

    if !i
        let i = search('^+++', 'cnW')
    endif

    if i
        let l:tag = s:Tag.parseTitle(getline(i))
        let l:tags = sort(keys(self.tags))
        execute 'botright ' . max(map(copy(l:tags), 'strlen(substitute(v:val, ".", "x", "g"))')) . 'vsplit \[CWikiSelector\]'
        setlocal bufhidden=delete
        setlocal buftype=nofile
        setlocal modifiable
        setlocal noswapfile
        setlocal nowrap
        setlocal cursorline
        call setline(1, l:tags)
        call cursor(index(l:tags, l:tag) + 1, 1)
        normal zz

        function! b:Close(n)
            bdelete!
            execute a:n . 'wincmd w'
        endfunction

        function! b:Jump(n)
            let l:tag = getline('.')
            call b:Close(a:n)
            call b:cwiki.jumpToTag(l:tag)
        endfunction

        execute 'nmap <silent> <buffer> <F3> :call b:Close(' . bufwinnr('#') . ')<CR>'
        execute 'nmap <silent> <buffer> <CR> :call b:Jump(' . bufwinnr('#') . ')<CR>'
    endif
endfunction

call s:CWiki.init()
call b:cwiki.refresh()
