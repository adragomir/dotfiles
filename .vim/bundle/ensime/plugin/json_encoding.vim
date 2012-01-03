" Vim was ahead of its time :-) It spoke JSON before the Web discovered it -
" Well almost.
" Vim does not know about:
" true,false,null
" 
" Thus those values are represented as Vim functions.
"
" Because it can parse JSON natively when assigning true, false, null to
" values this is probably the fastest way to interface with external tools.
" The default implementation assigns:
" true  -> 1 (=vim value for true)
" false -> 0 (=vim value for false)
" null  -> 0 (=vims return value for procedures which is semantically similar to null - Yes, this is an arbitrary choice)
fun! json_encoding#NULL()
  " return function("json_encoding#NULL")
  return {'json_special_value': 'null'}
endf
fun! json_encoding#True()
  " return function("json_encoding#True")
  return {'json_special_value': 'true'}
endf
fun! json_encoding#False()
  " return function("json_encoding#False")
  return {'json_special_value': 'false'}
endf
fun! json_encoding#ToJSONBool(i)
  return  a:i ? json_encoding#True() : json_encoding#False()
endf

" optional arg: if true then append \n to , of top level dict
fun! json_encoding#Encode(thing, ...)
  let nl = a:0 > 0 ? (a:1 ? "\n" : "") : ""
  if type(a:thing) == type("")
    return '"'.escape(a:thing,'"').'"'
  elseif type(a:thing) == type({}) && !has_key(a:thing, 'json_special_value')
    let pairs = []
    for [Key, Value] in items(a:thing)
      call add(pairs, json_encoding#Encode(Key).':'.json_encoding#Encode(Value))
      unlet Key | unlet Value
    endfor
    return "{".nl.join(pairs, ",".nl)."}"
  elseif type(a:thing) == type(0)
    return a:thing
  elseif type(a:thing) == type([])
    return '['.join(map(copy(a:thing), "json_encoding#Encode(v:val)"),",").']'
    return 
  elseif string(a:thing) == string(json_encoding#NULL())
    return "null"
  elseif string(a:thing) == string(json_encoding#True())
    return "true"
  elseif string(a:thing) == string(json_encoding#False())
    return "false"
  else
    throw "unexpected new thing: ".string(a:thing)
  endif
endf

" if you want json_encoding#Encode(json_encoding#Decode(str)) == str
" then you have to assign true to json_encoding#True() etc.
" I don't have a use case so I use Vim encoding
fun! json_encoding#Decode(s)
  let true = 1
  let false = 0
  let null = 0
  return eval(a:s)
endf

fun! json_encoding#DecodePreserve(s)
  let true = json_encoding#True()
  let false = json_encoding#False()
  let null = json_encoding#NULL()
  return eval(a:s)
endf

" usage example: echo json_encoding#Encode({'method': 'connection-info', 'id': 0, 'params': [3]})
