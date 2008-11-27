function! ExpandTemplate(...)
	let s:template_name = GetWordBeforeCursor()
	let s:template_matched = 0
	if exists("g:template" . s:template_name)
		let s:template_matched = 1
		execute "normal a\<C-w>"
		let s:word = g:template{s:template_name}
		let s:line = line(".")
		let s:cur_pos = match(s:word, '[^\\]|')
		let s:cur_pos = s:cur_pos < 0 ? 0 : s:cur_pos
		let s:cur_pos = s:cur_pos + col(".") + (match(getline("."), '\s') < 0 ? 0 : 1)
		let s:word = substitute(s:word, '\([^\\]\)|', '\1', 'g')
		let s:word = substitute(s:word, '\\|', '|', 'g')
		execute "normal! a" . s:word
		" by CHELU
		" bug here when he line the tempalte is inserted on will be auto indented.
		" the cursor will be moved to the left N characters,
		" where N is the number of characters that were inserted on auto indent.
		" TODO 
		" - need to find how many character the text will be indented, or
		"   how to delay the indentation after or before template expansion
		call cursor(s:line, s:cur_pos)
		execute "normal! a"
	elseif exists("g:template_b" . s:template_name)
		let s:template_matched = 1
		execute "normal a\<C-w>"
		let s:word = substitute(g:template_b{s:template_name}, '%\([^%]\)', s:template_name . '\1', 'g')
		let s:line = line(".")
		let s:cur_pos = match(s:word, '[^\\]|')
		let s:cur_pos = s:cur_pos < 0 ? 0 : s:cur_pos
		let s:cur_pos = s:cur_pos + col(".") + (match(getline("."), '\s') < 0 ? 0 : 1)
		let s:word = substitute(s:word, '\([^\\]\)|', '\1', 'g')
		let s:word = substitute(s:word, '\\|', '|', 'g')
		execute "normal! a" . s:word
		call cursor(s:line, s:cur_pos)
		execute "normal! a"
	endif
	if (a:0 && a:1 == 1 && !s:template_matched)
		normal! a 
	endif
endfunction
 

