" Zen coding vim plugin
" Author: Thai Pangsakulyanont

" ------------------------ Customize Me
" Map Ctrl+E to expand abbreviation on insert mode
inoremap <c-e> <c-o>:python zencoding_vim.expand_abbreviation()<cr>

" Map Ctrl+L to expand abbreviation on insert mode but
" prompt for an abbreviation instead of scanning the line.
inoremap <c-l> <c-o>:python zencoding_vim.expand_abbreviation(prompt=True)<cr>

" On visual mode, ctrl+l wraps the selected text with
" an abbreviation.
vnoremap <c-l> :python zencoding_vim.wrap_with_abbreviation()<cr>

" Tab expander: pressing tab will expand the abbreviation.
" If an abbreviation could not be inserted, insert a tab instead.
inoremap <tab> <c-r>=ZenCodingTabExpander()<cr>


" ------------------------ Code
" Import modules first
let s:sfile = expand("<sfile>:p:h")
py import sys, vim
py sys.path.append (vim.eval('s:sfile'))
py import zencoding_vim

" Expands the abbr. Returns 1 if abbr is found and expanded.
" Returns 0 otherwise.
fun! ZenCodingExpandAbbr()

	let l:can_replace = 0
	python zencoding_vim.expand_abbreviation(set_return=True)
	return l:can_replace

endfun

" Remap <tab> to this function to use <tab> to expand.
" If abbr is not found then this just inserts a tab.
fun! ZenCodingTabExpander() 

	" If can expand abbr then don't tab.
	if ZenCodingExpandAbbr()
		return ""
	endi

	" If not then this just tabs.
	return "\<Tab>"

endfun
