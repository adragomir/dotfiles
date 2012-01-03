" exec vam#DefineAndBind('s:c','g:vim_addon_signs','{}')
if !exists('g:vim_addon_signs') | let g:vim_addon_signs = {} | endif | let s:c = g:vim_addon_signs

let s:c['next_id'] = get(s:c, 'next_id', 54674)

" for speed reasons never process more than 1000
let s:c['process_max'] = get(s:c, 'process_max', 1000)


" category: a unque name such as "quickfix" or "cursorpos"
" signs: list of the signs. a sign is a list [ bufnr, line, name ]
" To remove all signs pass an empty list
fun! vim_addon_signs#Push(category, signs)
  if !has('signs') | return | endif
  let sort_by_buf_nr = {}
  for i in a:signs[:s:c.process_max]
    let b = i[0]
    if !has_key(sort_by_buf_nr, b) | let sort_by_buf_nr[b] = [] | endif
    call add(sort_by_buf_nr[b], i[1:])
  endfor

  let next = s:c.next_id
  for bufnr in range(1, bufnr('$'))
    if !bufexists(bufnr) | continue | endif
    let bufdict = getbufvar(bufnr, "")
    let bufdict['placed_signs'] = get(bufdict, "placed_signs", {})
    let placed_signs = get(bufdict.placed_signs, a:category, {})
    let bufdict.placed_signs[a:category] = placed_signs
    let new_dict = {}
    for i in get(sort_by_buf_nr, bufnr, [])
      let key = string(i)
      let new_dict[key] = 1
      if has_key(placed_signs, key) | continue | endif
      " place new signs which wasn't placed yet
      " echom "placing sign ".key
      exec 'sign place ' . next . " line=" . i[0] . " name=".i[1]." buffer=".bufnr
      let placed_signs[key] = next
      let next += 1
    endfor
    " remove old signs
    for [k,id] in items(placed_signs)
      if !has_key(new_dict, k)
        " echom "unplacing sign ".k
        exec 'sign unplace '.id
        unlet placed_signs[k]
      endif
      unlet k id
    endfor
  endfor
  let s:c.next_id = next
endf

fun! vim_addon_signs#SignsFromLocationList(list, name)
  let r = []
  for l in a:list
    if has_key(l, 'bufnr')
      call add(r, [l.bufnr, l.lnum, a:name])
      if len(r) > s:c.process_max | break | endif
    endif
  endfor
  return r
endf

" return a unique sign number.
" The code above is not using it for performance reasons
fun! vim_addon_signs#UniqueSignNumber()
  let s:c.next_id += 1
  return s:c.next_id -1
endf
