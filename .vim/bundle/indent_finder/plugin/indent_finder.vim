
augroup IndentFinder
  au! IndentFinder
  au BufRead *.* let b:indent_finder_result = system('python2.6 -c "import indent_finder; indent_finder.main()" --vim-output "' . expand('%') . '"' )
  au BufRead *.* execute b:indent_finder_result
augroup End

