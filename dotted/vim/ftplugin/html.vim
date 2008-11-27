" Vim script file                                           vim600:fdm=marker:
" FileType:	HTML
" Maintainer:	Devin Weaver <vim@tritarget.com>
" Last Change:  $Date: 2002/11/19 23:06:35 $
" Version:      $Revision: 1.2 $
" Location:	http://tritarget.com/pub/vim/ftplugin/html.vim

" This is a wrapper script to add extra html support to xml documents.

" Only do this when not done yet for this buffer
if exists("b:did_ftplugin")
  finish
endif
" Don't set 'b:did_ftplugin = 1' because that is xml.vim's responsability.

if !exists("*HtmlAttribCallback")
function HtmlAttribCallback( xml_tag )
    if a:xml_tag ==? "table"
	return 0
    elseif a:xml_tag ==? "link"
	return 0
    else
	return 0
    endif
endfunction
endif

" On to loading xml.vim
runtime ftplugin/xml.vim

