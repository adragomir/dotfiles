augroup IndentFinder
	au! IndentFinder
	au BufRead *.* execute system('python -c "import indent_finder; indent_finder.main()" --vim-output "' . expand('%') . '"' )
augroup End
