" set completfunc
command! -nargs=* CFComplete call vim_addon_completion#ChooseFuncWrapper('complete',<f-args>)

" set omnifunc
command! -nargs=* OFComplete call vim_addon_completion#ChooseFuncWrapper('omni',<f-args>)

" this is causing flickering in ensime.
" inoremap <c-x><c-o> <c-r>=vim_addon_completion#SetFuncFirstTime('omni')<cr>
" inoremap <c-x><c-u> <c-r>=vim_addon_completion#SetFuncFirstTime('complete')<cr>

" so assigt omni function if user didn't do so. (later than ftplugin/* or au
" commands)
" using |InsertEnter somehow sucks. I dont' know a better way ..
augroup VIM_ADDON_COMPLETION
  au!
  autocmd InsertEnter * if &omnifunc=='' |  call vim_addon_completion#ChooseFuncWrapper('omni', {'silent': 1, 'first':1}) | endif
                      \ | if &completefunc=='' | call vim_addon_completion#ChooseFuncWrapper('complete', {'silent': 1, 'first': 1}) |endif
augroup end

inoremap <c-x>1 <c-r>=vim_addon_completion#Cycle('omni')<cr>
inoremap <c-x>2 <c-r>=vim_addon_completion#Cycle('complete')<cr>
