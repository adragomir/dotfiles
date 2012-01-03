" exec vam#DefineAndBind('s:c','g:vim_addon_signs','{}')
if !exists('g:vim_addon_signs') | let g:vim_addon_signs = {} | endif | let s:c = g:vim_addon_signs

if get(s:c, 'provide_qf_command', 1)
  if has('signs')
    sign define qf_error text=! linehl=ErrorMsg
  endif
  command! -nargs=0 -bar UpdateQuickfixSigns call vim_addon_signs#Push("my_quick_fix_errors", vim_addon_signs#SignsFromLocationList(getqflist(), "qf_error"))

  augroup VIM_ADDON_SIGNS
    au!
    autocmd QuickFixCmdPost * UpdateQuickfixSigns
  augroup end

endif

if get(s:c, 'provide_el_command', 1)
  if has('signs')
    sign define qf_error text=! linehl=ErrorMsg
  endif
  command! -nargs=0 -bar UpdateLocationlistSigns call vim_addon_signs#Push("my_quick_fix_errors", vim_addon_signs#SignsFromLocationList(getloclist(), "qf_error"))
endif
