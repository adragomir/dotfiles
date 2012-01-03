if !exists('g:ensime') | let g:ensime = {} | endif | let s:c = g:ensime

setlocal omnifunc=ensime#Completion

" M-. or Control+Left-Click
exec 'noremap <buffer> '. s:c.ensime_map_leader .'. :call ensime#TypeAtCursor()<cr>'
