if !exists('g:completion_function_config') | let g:completion_function_config = {} | endif
let s:config = g:completion_function_config

" last_chosen keep a list of names so that when you enter a different buffer
" having same filetype the same comcpletion func can be assigned
let s:config['last_chosen'] = get(s:config, 'last_chosen', {})
let s:config['functions'] = get(s:config, 'functions', {})
let s:last_chosen = s:config['last_chosen']

" return next available function in order matching scope (filetype)
" if f cannot be found return first func
fun! vim_addon_completion#NextFunc(f)
  let list = filter(copy(s:config['functions']), '!has_key(v:val,"scope") || v:val["scope"] =~ '.string(substitute(&filetype,'\.','\|','g')))
  let c = keys(list)
  let idx = (index(c, a:f) + 1) % len(c)
  return c[idx]
endf

fun! vim_addon_completion#Get(type)
  let v = a:type.'func'
  exec 'return &'.v
endf

" opts: dict with keys
"             'type': "omni" or "complete"
"   optional: 'regex':   Only show items matching regex
"   optional: 'user' : any_val Function was called by user (update dict last_chosen)
"   optional: 'first': don't ask user, choose first
"   optional: 'silent': Don't show echoe message if no completions match
fun! vim_addon_completion#ChooseFunc(opts)

  let items = values(s:config['functions'])
  " filter by filetype
  call filter(items, '!has_key(v:val,"scope") || v:val["scope"] =~ '.string(substitute(&filetype,'\.','\|','g')))
  " filter by given regex or name:
  if has_key(a:opts,'regex')
    let regex = a:opts['regex']
    call filter(items, 'v:val["func"] =~ '.string(a:opts['regex']))
  endif

  " let user choose an item if there are more than 1 left:
  if len(items) > 1
    if get(a:opts, 'first', 0)
      let items = items[:0]
    else
      let list = []
      for i in items
        call add(list, i['func'].' '.get(i,'scope','').' '.get(i,'description',''))
      endfor
      let idx = tlib#input#List("si",'choose '.a:opts['type'].'func: ', list) - 1
      let items = [items[idx]]
    endif
  endif
  if len(items) == 0
    if !get(a:opts, 'silent', 0)
      echoe "no completion functions available!"
    endif
    return
  else
    let item = items[0]
    if &filetype != '' && has_key(a:opts,'user')
      let s:last_chosen[&filetype] = item['func']
    endif
    call vim_addon_completion#SetCompletionFunc(a:opts['type'], item['func'])

    " set other completion function to the next available if it wasn't set by
    " user explicitely
    let other = a:opts['type'] == 'complete' ? 'omni' : 'complete'
    let of = vim_addon_completion#Get(other)
    if of == ''
      let next = vim_addon_completion#NextFunc(item['func'])
      call vim_addon_completion#SetCompletionFunc(other, next)
      if &filetype != '' && has_key(a:opts,'user')
        let s:last_chosen[&filetype] = item['func']
      endif
    endif
  endif
endf

fun! vim_addon_completion#StoreCompletionFunc(type)
  let fu = vim_addon_completion#Get(a:type)
  if fu != '' && !has_key(s:config['functions'], fu)
    let d = {'func' : fu}
    if &filetype != ''
      let d['scope'] = &filetype
    end
    call vim_addon_completion#RegisterCompletionFunc(d)
  endif
endf

fun! vim_addon_completion#SetCompletionFunc(type, func)
  let i = s:config['functions'][a:func]
  " be smart: If the current completion function isn't known save that
  " the user can switch back
  call vim_addon_completion#StoreCompletionFunc(a:type)

  " set oompletion function
  exec 'setlocal '.a:type.'func='.i['func']
  if has_key(i,'completeopt')
    exec 'setlocal completeopt='.i['completeopt']
  endif
endf

fun! vim_addon_completion#ChooseFuncWrapper(type, ...)
  let dict = a:0 > 0 ? a:1 : {}
  if type(dict) != type({})
    throw "passing regex is supported this way now: {'regex': value}"
  endif
  let dict['user'] = 1
  let dict['type'] = a:type
  call vim_addon_completion#ChooseFunc(dict)
endf

fun! vim_addon_completion#Var()
  call vam#DefineAndBind('res', a:scope.':completion_functions', '{}')
  return res
endf

" scope either g or b which means global or buffer
" dict has keys:
"   func: string. This is called
"   description: long description (optional)
"   scope: filetype. This function will only be shown selecting a completion
"         function when editing that filetype
"   completeopt: complete options
"
fun! vim_addon_completion#RegisterCompletionFunc(dict)
  let s:config['functions'][a:dict['func']] = a:dict
endf

" if no function is set set one
fun! vim_addon_completion#SetFuncFirstTime(type)
  let fun = vim_addon_completion#Get(a:type)
  if fun == ''
    call vim_addon_completion#ChooseFunc({'user' : 1, 'type': a:type})
  endif
  return "\<c-x>".(a:type == 'omni' ? "\<c-o>" : "\<c-u>")
endf

" cycle function
fun! vim_addon_completion#Cycle(type)
  let next=vim_addon_completion#NextFunc(vim_addon_completion#Get(a:type))
  exec 'set '.a:type.'func='.next
  " echoe works in innsert mode. You can continue typing even if there is a
  " press enter
  echoe 'set '.a:type.' to '.next
  return ''
endf

" provide a function which translates a pattern into a regex and or glob
" pattern. You can implement camel case matching this way.
"
" may return {}
" if vim_regex is returned this pattern should be matched against names as
" well to determine wether an item must be added to the completion list
" users can implement camel case matching or similar
" identifier: a name of the completion invoking this function.
"             You may want to customize only some completions, not all
"
fun! vim_addon_completion#AdditionalCompletionMatchPatterns(pat, identifier, ...)
  let opts = a:0 > 0 ? a:1 : {}
  let start = get(opts,'match_beginning_of_string', 1)

  if exists('g:vim_addon_completion_Pattern_To')
    return call(g:vim_addon_completion_Pattern_To, [a:pat, a:identifier, opts])
  else
    " default: provide camel case matching
    " don't know how to make CamelCase matching using glob
    " glob may be used by some plugins
    return {
          \ 'vim_regex': (start ? '^' : '').vim_addon_completion#AdvancedCamelCaseMatching(a:pat)
          \ }
  endif
endf

" abc also matches axxx_bxxx_cxxx
" ABC also matches AxxxBxxxxCxxx
" ABC also matches ABxxCxx
function! vim_addon_completion#AdvancedCamelCaseMatching(expr)
  let result = ''
  if len(a:expr) > 5 " vim can't cope with to many \( ? and propably we no longer want this anyway
    return 'noMatchDoh'
  endif
  for index in range(0,len(a:expr))
    let c = a:expr[index]
    if c =~ '\u'
      let result .= c.'\u*\l*_\='
    elseif c =~ '\l'
      let result .= c.'\l*\%(\l\)\@!_\='
    else
      let result .= c
    endif
  endfor
  return result
endfunction

" same as ctrl-n but smarter because its using AdvancedCamelCaseMatching
" or more dump because its only taking the current buffer into acocunt
" only complete vars which are longer than 3 chars.
fun! vim_addon_completion#CompleteWordsInBuffer(findstart, base)
  if a:findstart
    let [bc,ac] = vim_addon_completion#BcAc()
    let s:match_text = matchstr(bc, '\zs[^\t#$,().&[\]/{}\''`";: ]*$')
    let s:start = len(bc)-len(s:match_text)
    return s:start
  else
    
    let words = {}
    for w in split(join(getline(1, line('$'))," "),'[/#$,''"`; \&()[\t\]{}.,+*:]\+')
      let words[w] = 1
    endfor

    let patterns = vim_addon_completion#AdditionalCompletionMatchPatterns(a:base
        \ , "ocaml_completion", { 'match_beginning_of_string': 1})
    let additional_regex = get(patterns, 'vim_regex', "")

    let r = []
    for t in keys(words)
      if len(t) >= 4
        if t =~ '^'.a:base || (additional_regex != '' && t =~ additional_regex)
          call add(r, {'word': t})
        endif
      endif
    endfor
    return r
  endif
endf

" before cursor after cursor
function! vim_addon_completion#BcAc()
  let pos = col('.') -1
  let line = getline('.')
  return [strpart(line,0,pos), strpart(line, pos, len(line)-pos)]
endfunction

fun! vim_addon_completion#CompleteUsing(func_name)
  call vim_addon_completion#StoreCompletionFunc('omni')
  exec 'setlocal omnifunc='.a:func_name
  return "\<c-x>\<c-o>"
endf
