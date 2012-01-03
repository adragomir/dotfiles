if has("macunix") && has("gui_running") && system('ps xw | grep -c "[V]im -psn"') > 0
  " Get the value of $PATH from a login shell.
  if $SHELL =~ '/\(sh\|csh\|bash\|tcsh\|zsh\)$'
    let s:path = system("echo echo VIMPATH'${PATH}' | $SHELL -l")
    let $PATH = matchstr(s:path, 'VIMPATH\zs.\{-}\ze\n')
  endif
endif

set runtimepath+=$HOME/.vim/andrei

" general settings
set nocompatible              " use VI incompatible features
let no_buffers_menu=1
set noautochdir
set history=10000             " number of history items
"set autowriteall

" backup settings
set nobackup " do not keep backups after close
set nowritebackup " do not keep a backup while working
set noswapfile " don't keep swp files either
set backupdir=~/.vim/backup " store backups under ~/.vim/backup
set backupcopy=yes " keep attributes of original file
set backupskip=/tmp/*,$TMPDIR/*,$TMP/*,$TEMP/*
set directory=~/.vim/swap,~/tmp,. " keep swp files under ~/.vim/swap

" ui settings
set ruler                     " show the cursor position all the time
set scrolloff=3               " start scrolling before end
set showcmd                   " show incomplete commands
set number                    " show line numbers
set wildmenu
set wildignore=*.o,*.obj,*.pyc,*.d,*.swp,*.bak,*.hi,*.6,*.out,*.bak,*.exe,*.jpg,*.jpeg,*.png,*.gif,*.class,*.dll,*.so,*.dylib,.svn,CVS,.git,.hg,*.a,*.mo,*.la,*.so,*.obj,*.swp,*.jpg,*.png,*.xpm,*.gif
set wildmode=list:longest,full
set whichwrap=<,>,h,l,b,s,~,[,]
set shortmess=aTI             " supress some file messages
set sidescrolloff=4           " minchars to show around cursor

if has("gui_running")
    set mouse=a
endif
set selectmode=mouse,key      " select model
set keymodel=startsel         ",stopsel
set autoread                  " read outside modified files
set encoding=UTF-8            " file encoding
set formatoptions=tcroqn1     " auto format
"set guioptions=cr+bie"M"m	  " aA BAD
set guioptions=ci+Mgrbe       " NEVER EVER put ''a in here
"set guioptions=+

" visual cues
set ignorecase                " ignore case when searching
set smartcase                 " ignore case when searching
set hlsearch                  " highlight last search
set incsearch                 " show matches while searching
set laststatus=2              " always show status line
"set cursorline
set showbreak=>               " character to show that a line is wrapped
set showcmd                   " show number of selected chars/lines in status
set showmatch                 " briefly jump to matching brace
set matchtime=1               " show matching brace time (1/10 seconds)
set showmode                  " show mode in status when not in normal mode
set nostartofline             " don't move to start of line after commands
set statusline=%-2(%M\ %)%5l,%-5v%<%F\ %m%=[tab:%{&ts},%{&sts},%{&sw},%{&et?'et':'noet'}]\ [byte:\ %3b]\ [offset:\ %5o]\ %(%-5([%R%H%W]\ %)\ %10([%Y]%{ShowFileFormatFlag(&fileformat)}\ %)\ %L\ lines%)
set undolevels=10000
set pumheight=10
set viminfo=%,h,'1000,"1000,:1000,n~/.viminfo
set scrolljump=10
set virtualedit=block
set novisualbell
set noerrorbells
set t_vb=
set winaltkeys=no
set writeany
set iskeyword=@,48-57,128-167,224-235,_
set listchars=tab:>.,trail:.,extends:>,precedes:<,eol:$
set showtabline=2
set matchtime=0
set complete=.,w,b,u,t,i	" completion by Ctrl-N
set completeopt=menu,menuone,longest
set ttyfast
set gdefault
"set notimeout
"set ttimeout
set timeoutlen=500
set ttimeoutlen=200

" GRB: clear the search buffer when hitting return
nnoremap <CR> :nohlsearch<CR>/<BS>
nnoremap <silent> <Leader>/ :nohlsearch<CR>

nnoremap / /\v
vnoremap / /\v

" Sudo write {{{
command! -bar -nargs=0 W  silent! exec "write !sudo tee % >/dev/null"  | silent! edit!
" }}}
" Write and make file executable {{{
command! -bar -nargs=0 WX silent! exec "write !chmod a+x % >/dev/null" | silent! edit!
" }}}

"
set guipty
set clipboard= "unnamed ",unnamedplus,autoselect

" vim 7.3
set undofile
set undodir=/Users/adragomi/.vim/tmp/vimundos

" settings: windows and buffers
"set noequalalways
set guiheadroom=0
" 	When off a buffer is unloaded when it is |abandon|ed.
set hidden
set splitbelow                " split windows below current one
set title
set exrc
set gcr=a:blinkon0

set switchbuf=usetab

" settings: line endings
"set ff=unix
"set ffs=unix

" settings: grep
set grepprg=$HOME/bin/ack\ --noenv
set grepformat=%f:%l:%m

" settings: tabs and indentin
set autoindent
set nocindent
set nosmartindent
set copyindent
"set smarttab
"set indentexpr=
set expandtab
set tabstop=2
set shiftwidth=2
set softtabstop=2

set cmdheight=2
set laststatus=2

call pathogen#helptags()
call pathogen#infect() 

" key mappings
let mapleader = ","
let maplocalleader = ","
 
" look & feel
if has("gui_running") && has("macunix")
  set guifont=Inconsolata:h13
  set antialias
endif

"nnoremap <silent> Q
"nnoremap <silent> gQ

"nnoremap ; :
" no Ex mode
"map Q gq
nnoremap <leader>' ""yls<c-r>={'"': "'", "'": '"'}[@"]<cr><esc>

if has("gui_running")
  " behave mswin
  set fuoptions=maxvert,maxhorz
  set selectmode=mouse "key,mouse
  set mousemodel=popup
  set keymodel=startsel ",stopsel
  set selection=exclusive

  " source $VIMRUNTIME/mswin.vim
  " mswin.vim, INLINE
  " backspace and cursor keys wrap to previous/next line
  set backspace=indent,eol,start whichwrap+=<,>,[,]

  " backspace in Visual mode deletes selection
  vnoremap <BS> d

  " CTRL-X and SHIFT-Del are Cut
  vnoremap <D-X> "+x
  vnoremap <S-Del> "+x

  " CTRL-C and CTRL-Insert are Copy
  vnoremap <special> <D-C> "+y
  vnoremap <C-Insert> "+y

  " CTRL-V and SHIFT-Insert are Paste
  map <D-V>		"+gP
  map <S-Insert>		"+gP

  cmap <D-V>		<C-R>+
  cmap <S-Insert>		<C-R>+

  " Pasting blockwise and linewise selections is not possible in Insert and
  " Visual mode without the +virtualedit feature.  They are pasted as if they
  " were characterwise instead.
  " Uses the paste.vim autoload script.

  exe 'inoremap <script> <D-V>' paste#paste_cmd['i']
  exe 'vnoremap <script> <D-V>' paste#paste_cmd['v']

  imap <S-Insert>		<D-V>
  vmap <S-Insert>		<D-V>

  " Use CTRL-Q to do what CTRL-V used to do
  noremap <C-Q>		<C-V>

  " For CTRL-V to work autoselect must be off.
  " On Unix we have two selections, autoselect can be used.
  if !has("unix")
    set guioptions-=a
  endif

  " CTRL-A is Select all
  noremap <D-A> gggH<C-O>G
  inoremap <D-A> <C-O>gg<C-O>gH<C-O>G
  cnoremap <D-A> <C-C>gggH<C-O>G
  onoremap <D-A> <C-C>gggH<C-O>G
  snoremap <D-A> <C-C>gggH<C-O>G
  xnoremap <D-A> <C-C>ggVG
  " end mswin.vim


  "source $VIMRUNTIME/macmap.vim.old
  " macmap.vim.old INLINE
  vnoremap <special> <D-x> "+x
  vnoremap <special> <D-c> "+y
  cnoremap <special> <D-c> <C-Y>
  nnoremap <special> <D-v> "+gP
  cnoremap <special> <D-v> <C-R>+
  execute 'vnoremap <script> <special> <D-v>' paste#paste_cmd['v']
  execute 'inoremap <script> <special> <D-v>' paste#paste_cmd['i']

  nnoremap <silent> <special> <D-a> :if &slm != ""<Bar>exe ":norm gggH<C-O>G"<Bar> else<Bar>exe ":norm ggVG"<Bar>endif<CR>
  vmap <special> <D-a> <Esc><D-a>
  imap <special> <D-a> <Esc><D-a>
  cmap <special> <D-a> <C-C><D-a>
  omap <special> <D-a> <Esc><D-a>
  " end macmap.vim
endif
set t_Co=256
map H ^
map L $

let g:molokai_original = 1
"let g:solarized_termcolors=256
set background=dark
colorscheme solarized

" syntax highlighting
syntax enable
syntax on
filetype on
filetype indent on
filetype plugin on
hi SignColor guibg=red
autocmd BufEnter * :syntax sync fromstart

" enable autosaving
"set updatecount=0 updatetime=500
"autocmd CursorHold,CursorHoldI * silent! wall

" suffixes
set suffixes+=.lo,.o,.moc,.la,.closure,.loT

" my functions

function! WordFrequency() range
  let all = split(join(getline(a:firstline, a:lastline)), '\A\+')
  let frequencies = {}
  for word in all
    let frequencies[word] = get(frequencies, word, 0) + 1
  endfor
  new
  setlocal buftype=nofile bufhidden=hide noswapfile tabstop=20
  for [key,value] in items(frequencies)
    call append('$', key."\t".value)
  endfor
  sort i
endfunction
command! -range=% WordFrequency <line1>,<line2>call WordFrequency()

function! OnTabLeave()
  if UselessBuffer('%')
    bwipeout
  endif
endfunction

function! UselessBuffer(...)
  let l:bufname = a:0 == 1 ? a:1 : '%'

  if (getbufvar(l:bufname, '&mod') == 0 && index(['', '[No Name]', '[No File]'], bufname(l:bufname)) >= 0)
    return 1
  end
  return 0
endfunction

function! Tabnew()
  if (!UselessBuffer('%'))
    tabnew
  endif
endfunction

" tab settings
function! IndentingGeneralSettings()
  set autoindent nocindent nosmartindent
  set indentexpr=
endfunction

function! IndentingSetTabsize(size)
  let &tabstop     = a:size
  let &shiftwidth  = a:size
  let &softtabstop = a:size
endfunction

function! IndentingSetSpaces(size)
  set expandtab
  call IndentingGeneralSettings()
  call IndentingSetTabsize(a:size)
endfunction

function! IndentingSetTabs()
  set noexpandtab
  call IndentingGeneralSettings()
  call IndentingSetTabsize(4)
endfunction

function! SwapUp()
  if ( line( '.' ) > 1 )
    let cur_col = virtcol(".")
    if ( line( '.' ) == line( '$' ) )
      normal ddP
    else
      normal ddkP
    endif
    execute "normal " . cur_col . "|"
  endif
endfunction

function! SwapDown()
  if ( line( '.' ) < line( '$' ) )
    let cur_col = virtcol(".")
    normal ddp
    execute "normal " . cur_col . "|"
  endif
endfunction

function! MoveCursor(move, mode)
	if (a:move == 'h')
		if (a:mode == '0')
			normal 0
		elseif (a:mode =~ '^\^')
			if (a:mode == '^g')
				normal g^
			elseif (a:mode == '^n')
				normal ^
			endif
		endif
	elseif (a:move == 'e')
		if (a:mode =~ '^\$')
			if (a:mode == '$g')
				normal g$
			elseif (a:mode == '$n')
				normal $
			endif
		endif
	endif
endfunction

function! HomeKey()
	let oldmode = mode()
	let oldcol = col('.')
	call MoveCursor('h', '^n')
	let newcol = col('.')
	if (oldcol == newcol)
		if (&wrap != 1) || (newcol <= winwidth(0) - 20)
			call MoveCursor('h', '0')
			let lastcol = col('.')
			if (newcol == lastcol)
				if (newcol == oldcol)
					normal i
				else
					call MoveCursor('h', '^n')
				endif
			else
				call MoveCursor('h', '0')
			endif
		endif
	endif
endfunction

function! EndKey()
	call MoveCursor('e', '$g')
endfunction

function! StrMatchNo(haystack, needle)
	let LastMatch = match(a:haystack, a:needle)
	if LastMatch > -1
		let Result = 1
		while LastMatch > -1
			let LastMatch = match(a:haystack, a:needle, LastMatch+1)
			if LastMatch > -1
				let Result = Result + 1
			endif
		endwhile
	else
		let Result = 0
	endif
	return Result
endfunction

function! ConditionalExecute(action)
	if a:action == "write"
		if &modified == 1
			silent write
		endif
	elseif a:action == "quit"
		new
		execute "normal! \<C-w>\<C-w>"
		silent quit
	endif
endfunction

function! InsertBrace()
	if strpart(getline("."), col(".")-1, 1) != " "
		let s:seq = " "
	else
		let s:seq = ""
	endif
	let s:seq = s:seq . "{\<CR>}\<Left>\<CR>\<Up>\<Tab>"
	execute "normal a" . s:seq
endfunction

" calls KeyMapExec for all combinations of modes and modifiers
function! KeyMap(modes, special, modifiers, key, action)
  if a:modes == ""
    if a:modifiers == ""
      call KeyMapExec(a:modes, a:special, a:modifiers, a:key, a:action)
    else
      for j in range(len(a:modifiers))
        call KeyMapExec(a:modes, a:special, a:modifiers[j], a:key, a:action)
      endfor
    endif
  else
    for i in range(len(a:modes))
      if a:modifiers == ""
        call KeyMapExec(a:modes[i], a:special, a:modifiers, a:key, a:action)
      else
        for j in range(len(a:modifiers))
          call KeyMapExec(a:modes[i], a:special, a:modifiers[j], a:key, a:action)
        endfor
      endif
    endfor
  endif
endfunction

" mode:     n,i,v
" modifier: C,D,L,M,S
" key:      a,<F2>,<Left>, etc
" action:   \o/
function! KeyMapExec(mode, special, modifier, key, action)
  if a:modifier=="D" && !has("macunix")
    return
  end
  " arg
  let s:arg = substitute(" <silent> ", "<>", "", "")

  " if no <CR>s or only one <CR> at end, use <C-o> to better preserve cursor position
  "   examples:
  "     gt
  "     :bd<CR>
  " otherwise, use <Esc> and a
  "   examples:
  "     :s/a/b/<CR>:s/c/d/<CR>
  "     :s/e/f/<CR>dd
  let crs = len(split(a:action, "<CR>"))
  if crs == 0 || (crs == 1 && a:action =~ '<CR>$')
    let s:pre = "<C-o>"
    let s:post = ""
  else
    let s:pre = "<Esc>"
    let s:post = "a"
  endif

  " put what to map in s:key
  let s:key = substitute(a:key, '[<>]', '', 'g')
  if a:modifier == ""
    let s:key = a:key
  elseif a:modifier == "L"
    let s:key = "<Leader>" . a:key
  else " C,D,M,S
    let s:key = "<" . a:modifier . "-" . s:key . ">"
  end

  	" put map in s:map
  let s:map = a:mode . "noremap" . a:special .  s:key . " "
  if a:mode == "i"
    let s:map .= s:pre . a:action . s:post
  else
    let s:map .= a:action
  endif

  " \o/\O/\o/
  "echo s:map
  execute s:map

endfunction

function! OpenFileUnderCursor()
	let FileName = expand("<cfile>")
	if (!filereadable(FileName))
		if (filereadable("./" . FileName))
			let FileName = "./" . FileName
		else
			let cpwd = substitute(getcwd(), '\([^/]\)$', '\1/', '')
			let fpwd = substitute(FileName, '^.\{-}\(/.*/\).*$', '\1', '')
			if (match(cpwd, fpwd . '$'))
				let FileName = substitute(FileName, '^.*/\(.*\)$', '\1', '')
			endif
		endif
	endif
	let OldPath = getcwd()
	silent cd %:p:h
	if (filereadable(FileName))
	execute "silent sp +e " . FileName
	else
		echohl error
		echo "File '" . FileName . "' not found."
		echohl normal
	endif
	execute "silent cd " . OldPath
endfunction

function! GetSynUnder()
	return synIDattr(synID(line('.'), col('.'), 1), 'name')
endfunction

function! GetCharUnder()
	return strpart(getline('.'), col('.') - 1, 1)
endfunction

function! GetCharBefore(offset)
	return strpart(getline('.'), col('.') - (a:offset + 1), 1)
endfunction

function! GetCharAfter()
	return strpart(getline('.'), col('.'), 1)
endfunction

function! AtEnd()
	return col('$') == col('.')
endfunction

function! GetStringBeforeCursor(offset)
	return strpart(getline('.'), 0, col('.') - a:offset)
endfunction

function! GetStringAfterCursor()
	return strpart(getline("."), col("."))
endfunction

function! GetWordBeforeCursor(keep_spaces)
	let regexp = '^.*\(\<\w\+\)'
	if !a:keep_spaces
		let regexp .= '\s*'
	endif
	let regexp .= '$'
	return substitute(GetStringBeforeCursor(0), regexp, '\1', '')
endfunction

function! GetExactWordBeforeCursor(offset)
  let x = matchlist(GetStringBeforeCursor(a:offset), '\(\w\w*\)\s*$')
  if len(x) > 0
    return x[1]
  else
    return GetStringBeforeCursor(a:offset)
  end
	"return substitute(GetStringBeforeCursor(a:offset), '^.*\(\w\w*\)\s*$', '\1', '')
endfunction

function! GetFirstWord()
	return substitute(getline('.'), '^\W*\(\<\w\+\).*$', '\1', '')
endfunction

function! GetStringBeforeWord()
	return substitute(GetStringBeforeCursor(), '^.*\(\W\{-1,}\)\<\w\{-1,}\W*$', '\1', '')
endfunction

function! GetWordBeforeParen()
	return substitute(GetStringBeforeCursor(), '^.\{-}\(\<\w\{-1,}\)\s*(.*$', '\1', '')
endfunction

function! UpcaseWordBeforeCursor()
	let Line = substitute(GetStringBeforeCursor(), '^\(.*\)\(\<\w\{-1,}\)\(\W*\)$', '\1\U\2\E\3', '')
	call setline(".", Line . GetStringAfterCursor())
endfunction

function! GetWordUnder()
	let WordBeginning = substitute(GetStringBeforeCursor(), '^.*\<\(\w\{-1,}\)$', '\1', '')
	if match(GetStringAfterCursor(), '\w') == 0
		let WordEnd = substitute(GetStringAfterCursor(), '^\<\(\w\{-1,}\)\>.*$', '\1', '')
	else
		let WordEnd = ''
	endif
	let Word = WordBeginning . WordEnd
	return Word
endfunction

function! CountOccurances(haystack, needle)
	let occurances = 0
	let lastpos = 0
	let firstiter = 1
	while lastpos > -1
		if firstiter
			let lastpos = match(a:haystack, a:needle, lastpos)
		else
			let lastpos = match(a:haystack, a:needle, lastpos + 1)
		endif
		let firstiter = 0
		if lastpos > -1
			let occurances = occurances + 1
		endif
	endwhile
	return occurances
endfunction

function! InsideTag()
	let str = GetStringBeforeCursor(0) . GetCharUnder()
	return str =~ '^.*<[^/>]*$'
endfunction

function! InsideQuote(char)
	let str = GetStringBeforeCursor(0) . GetCharUnder()
	if !InsideTag()
		let tags_complete = CountOccurances(str, '<[^/>]*>')
		let tags_incomplete = CountOccurances(str, '<\w')
		let tags = tags_incomplete - tags_complete
		return (CountOccurances(str, a:char) - tags) % 2 != 0
	else
		return CountOccurances(str, a:char) % 2 != 0
	endif
endfunction

function! ExpandTemplate(ignore_quote)
	if a:ignore_quote || GetSynUnder() == 'htmlString' || (!InsideQuote("'") && !InsideQuote('"'))
		let cword = GetExactWordBeforeCursor(1)
		if exists('g:template' . &ft . cword)
			return "\<C-W>" . g:template{&ft}{cword}
		elseif exists('g:template_' . cword)
			return "\<C-W>" . g:template_{cword}
		endif
	endif
	return ExpandTag(' ')
endfunction

function! ExpandTag(char)
	if a:char == '>'
		if GetCharUnder() == '>'
			return "\<Right>"
		elseif GetCharBefore(1) == '>' && (&ft == 'php' || &ft == 'html')
			if &ft == 'php' && GetCharBefore(2) == '?'
				return '>'
			endif
			return "\<CR>\<CR>\<Up>\<Tab>"
		endif
	endif
	let sbefore = GetStringBeforeCursor(0)
	if GetCharUnder() == '>'
		return a:char
	endif
	if sbefore =~ '^.*<\w\+\S*$' && (&ft == 'php' || &ft == 'html')
		let cword = GetExactWordBeforeCursor(1)
		let sbefore1 = strpart(sbefore, 0, strlen(sbefore) - 1)
		if cword !~ '>' && CountOccurances(sbefore1, '<') > CountOccurances(sbefore1, '>')
			let cleft = repeat("\<Left>", len(cword) + 4)
			let retval = ''
			let close_tag = '></' . cword . '>' . cleft
			if cword == 'input' || cword == 'label' || cword == 'br' || cword == 'hr'
				let retval .= ">\<Left>"
			else
				let retval .= close_tag
			endif
			if a:char == ' '
				let retval = ' ' . retval
			else
				let retval .= "\<Right>"
			endif
			return retval
		endif
		return a:char
	endif
	return a:char
endfunction

" Visual mode functions
function! Enclose(mode, indent)
	if a:mode == '{'
		let start = '{'
		let end = '}'
	elseif a:mode == '/'
		let start = '/**'
		let end = '/**/'
	endif
	let extra = ''
	if a:indent
		let extra = "\<BS>"
	endif
	call cursor(line("'<"), col("'<"))
	execute "normal! O" . extra . start
	call cursor(line("'>"), col("'>"))
	execute "normal! o" . extra . end
endfunction

function! ColonComplete()
	normal! a:
endfunction

function! ShowFileFormatFlag(var) 
	if ( a:var == 'dos' ) 
		return '[DOS]' 
	elseif ( a:var == 'mac' ) 
		return '[MAC]' 
	else 
		return '[UNIX]' 
	endif 
endfunction

function! InsertDateTime()
	execute "normal a" . strftime("%A, %Y-%m-%d %H:%M:%S")
endfunction

function! GuiTabLabel()
	let label = v:lnum
	let bufnrlist = tabpagebuflist(v:lnum)

	" Add '+' if one of the buffers in the tab page is modified
	for bufnr in bufnrlist
        if getbufvar(bufnr, "&modified")
            let label .= '+'
            break
        endif
	endfor

	" Append the number of windows in the tab page if more than one
	let wincount = tabpagewinnr(v:lnum, '$')
	if wincount > 1
		let label .= wincount
	endif
	if label != ''
		let label .= ' '
	endif

	let guifname = bufname(bufnrlist[tabpagewinnr(v:lnum) - 1])"MyTabLabel(bufnrlist[tabpagewinnr(v:lnum) - 1]) "
  let guifname = substitute(guifname, '^\(.*\)/\([^/]*\)$', '\2', '')
	" Append the buffer name
	return label . guifname
endfunction

function! MyTabLine()
  let s = ""
  for i in range(tabpagenr('$'))
    " select the highlighting
    if i + 1 == tabpagenr()
      let s .= '%#TabLineSel#'
    else
      let s .= '%#TabLine#'
    endif

    " set the tab page number (for mouse clicks)
    let s .= '%' . (i + 1) . 'T'

    " the label is made by MyTabLabel()
    let s .= ' %{MyTabLabel(' . (i + 1) . ')} '
  endfor

  " after the last tab fill with TabLineFill and reset tab page nr
  let s .= '%#TabLineFill#%T'

  " right-align the label to close the current tab page
  if tabpagenr('$') > 1
    let s .= '%=%#TabLine#%999Xclose'
  endif

  return s
endfunction

function! MyTabLabel(n)
  let buflist = tabpagebuflist(a:n)
  let winnr = tabpagewinnr(a:n)
  let guifname = bufname(buflist[winnr - 1])
  let guifname = substitute(guifname, '^\(.*\)/\([^/]*\)$', '\2', '')
  return '[' . string(a:n) . ']' . guifname
endfunction

function! OpenAllBuffersInTabs()
ruby << EOF
	require 'pp'
	numtabs = VIM::evaluate("tabpagenr('$')")
	buffers = []
	for i in 0..(VIM::Buffer.count - 1)
		buffers << VIM::Buffer[i]
	end
	buffers.each { |b|
		
	}
	puts numtabs
EOF
endfunction

function! GuiEnter()
set columns=150 lines=49
" open tabs for all the open buffers
let g:GuiEnter_tablist = []
for i in range(tabpagenr('$'))
   call extend(g:GuiEnter_tablist, tabpagebuflist(i + 1))
endfor
ruby << EOF
	require 'pp'
	numtabs = VIM::evaluate("tabpagenr('$')")
	buffers = []
	for i in 0..(VIM::Buffer.count - 1)
		buffers << VIM::Buffer[i]
	end
	puts numtabs
EOF
endfunction

" helper function to toggle hex mode
function! ToggleHex()
  " hex mode should be considered a read-only operation
  " save values for modified and read-only for restoration later,
  " and clear the read-only flag for now
  let l:modified=&mod
  let l:oldreadonly=&readonly
  let &readonly=0
  let l:oldmodifiable=&modifiable
  let &modifiable=1
  if !exists("b:editHex") || !b:editHex
    " save old options
    let b:oldft=&ft
    let b:oldbin=&bin
    " set new options
    setlocal binary " make sure it overrides any textwidth, etc.
    let &ft="xxd"
    " set status
    let b:editHex=1
    " switch to hex editor
    %!xxd
  else
    " restore old options
    let &ft=b:oldft
    if !b:oldbin
      setlocal nobinary
    endif
    " set status
    let b:editHex=0
    " return to normal editing
    %!xxd -r
  endif
  " restore values for modified and read only state
  let &mod=l:modified
  let &readonly=l:oldreadonly
  let &modifiable=l:oldmodifiable
endfunction

function! ContextSettings()
	"set indentexpr=none
	let l:NBuffers = bufnr('$')
	if l:NBuffers > 1 && bufexists(1) && buflisted(1) && !getbufvar(1, "&bufsecret")
		:bw 1
	endif
endfunction

function! OpenNewTabOnFileOpen()
	let fName = expand('<afile>')
	if fName != ""
		exe 'tablast | tabe <afile>'
	else
		exe 'tablast | tabnew'
	endif
endfunction

function! ToggleScratch()
  if expand('%') == g:ScratchBufferName
    quit
  else
    Sscratch
  endif
endfunction

" files & folders functions

function! PathToShortHome(path)
  return substitute(a:path, $HOME, "~", "")
endfunction

function! CwdShort()
  return substitute(PathToShortHome(getcwd()), "\\", "/", "g")
endfunction
 
function! FizzyReIndexCwd()
  call FizzyReIndex(getcwd())
endfunction
function! FizzyReIndex(dir)
  " if (a:dir =~ 'work\/projects\/\w\w*')
    echo "reindexing " . a:dir
    FizzyFileRenewCache
    FizzyDirRenewCache
  " endif
endfunction

let g:CWD = ""
function! Cd(cd)
  exec 'cd ' . escape(a:cd, " ")
  let g:CWD = getcwd()
  return getcwd()
endfunction
function! CdReset()
  if g:CWD == ""
    let g:CWD = getcwd()
  else
    call Cd(g:CWD)
  end
endfunction

function! GetRoot(path)
  let oldcwd = getcwd()
  call Cd(a:path)
  let root = Slashify(Cd("/"))
  call Cd(oldcwd)
  return root
endfunction

function! Slashify(str)
  return substitute(a:str, "\\", "/", "g")
endfunction

function! GetCwdCurrent()
  return expand("%:p:h")
endfunction

function! CwdCurrent()
  call Cd(GetCwdCurrent())
endfunction

function! CwdUp()
  let dirname = Slashify(expand('%:p:h'))
  let cwd     = Slashify(getcwd())
  let root    = GetRoot(cwd)
  if (stridx(dirname, cwd) == -1 || cwd == GetRoot(cwd))
    call Cd(dirname)
  else
    call Cd(substitute(cwd, "[^/]*$", "", ""))
  end
endfunction

function! CwdDown()
  let dirname = Slashify(expand('%:p:h'))
  let cwd     = Slashify(getcwd())

  if cwd == GetRoot(cwd)
    let cwd = substitute(cwd, "/$", "", "")
  end
  if stridx(dirname, cwd) == -1
    call Cd(dirname)
  else
    if (dirname == cwd)
      call Cd("/")
    else
      let dirname = substitute(dirname, cwd . "/", "", "")
      call Cd(cwd . "/" . substitute(dirname, "/.*", "", ""))
    end
  end
endfunction

function! CreateNewFile(newfile)
  "call inputsave()
  "let newfilename= input("Please give file name: ")
  "call inputrestore()
  let crtbufdir = expand("%:p:h")
  if a:newfile == ""
    return
  endif
  exec "e " . crtbufdir . "/" . a:newfile
endfunction

function! CreateNewFile(newfile)
  "call inputsave()
  "let newfilename= input("Please give file name: ")
  "call inputrestore()
  let crtbufdir = expand("%:p:h")
  if a:newfile == ""
    return
  endif
  exec "e " . crtbufdir . "/" . a:newfile
endfunction

function! BrowserFromCurrentDir()
  " Explore deletes the quote register. Need to revive the mofo!
  " TODO check if still the case
  let g:OLDQUOTEREGISTER = @"
  let dirname = Slashify(expand('%:p:h'))
  call Tabnew()
  exec "Explore"
  let @" = g:OLDQUOTEREGISTER
endfunction

function! BrowserFromCurrentFilePath()
  let g:OLDQUOTEREGISTER = @"
  let dirname = Slashify(expand('%:p:h'))
  call Tabnew()
  exec "Explore " . dirname
  let @" = g:OLDQUOTEREGISTER
endfunction

function! MoveTabLeft()
  let newtabnr = tabpagenr() - 2
  if newtabnr == -1
    let newtabnr = v:lnum
  end
  exec ":tabmove " . newtabnr
endfunction

function! MoveTabRight()
  let newtabnr = tabpagenr()
  if newtabnr == v:lnum
    let newtabnr = 0
  end
  exec ":tabmove " . newtabnr
endfunction

" ConqueTerm wrapper
function! StartTerm()
  execute 'ConqueTerm ' . $SHELL . ' --login'
  setlocal listchars=tab:\ \ 
endfunction


highlight WHITE_ON_BLACK ctermfg=white

"map <silent> ;; :call DemoCommand()<CR>
"vmap <silent> ;; :<C-U>call DemoCommand(1)<CR>

function! DemoCommand (...)
  " Remember how everything was before we did this...
  let orig_buffer = getline('w0','w$')
  let orig_match  = matcharg(1)

  " Select either the visual region, or the current paragraph...
  if a:0
    let @@ = join(getline("'<","'>"), "\n")
  else
    silent normal vipy
  endif

  " Highlight the selection in red to give feedback...
  let matchid = matchadd('WHITE_ON_RED','\%V')
  redraw
  sleep 500m

  " Remove continuations and convert shell commands, then execute...
  let command = @@
  let command = substitute(command, '^\s*".\{-}\n', '',     'g')
  let command = substitute(command, '\n\s*\\',      ' ',    'g')
  let command = substitute(command, '^\s*>\s',      ':! ',  '' )
  execute command

  " If the buffer changed, hold the highlighting an extra second...
  if getline('w0','w$') != orig_buffer
    redraw
    sleep 1000m
  endif

  " Remove the highlighting...
  call matchdelete(matchid)
endfunction

call KeyMap('n', '', '', '<F3>', ':e %:p:s,.h$,.X123X,:s,.cpp$,.h,:s,.X123X$,.cpp,<CR>')
call KeyMap('i', '<silent>', '', '<S-Space>', ':call ExpandTemplate(1)<CR>')
call KeyMap('ni', '', 'D', 'q', ':q<CR>')
call KeyMap('ni', '', 'D', 'Q', ':q!<CR>')
call KeyMap('ni', '<silent>', 'D', 'w', ':call ConditionalExecute("write")<CR>')
call KeyMap('n', '<silent>', 'D', 'a', 'gggH<C-O>G')
call KeyMap('i', '<silent>', 'D', 'a', '<C-O>gg<C-O>gH<C-O>G')
call KeyMap('n', '<silent>', 'D', 'y', '<C-R>')
call KeyMap('i', '<silent>', 'D', 'y', '<C-O><C-R>')
call KeyMap('ni', '<silent>', 'D', '`', ':maca selectNextWindow:<CR>')
call KeyMap('ni', '<silent>', 'D', 'W', ':write!<CR>')
call KeyMap('ni', '<silent>', 'D', '!', ':!!<CR>')
call KeyMap('ni', '<silent>', 'D', '"', ':@:<CR>')
call KeyMap('ni', '<silent>', '', '<F9>', ':Tlist<CR>')
call KeyMap('ni', '<silent>', 'D', 'd', ':bd<CR>')
call KeyMap('ni', '<silent>', 'D', 'e', ':call OpenFileUnderCursor()<CR>')
call KeyMap('v', '<silent>', '', '<Tab>', '>gv')
call KeyMap('v', '<silent>', '', '<S-Tab>', '<gv')
call KeyMap('i', '<silent>', 'D', "'", ':call ExpandTemplate()<CR>')
call KeyMap('i', '<silent>', 'C', 'z', ':u<CR>')
call KeyMap('ni', '<silent>', 'D', 's', ':set scb<CR>')
call KeyMap('ni', '<silent>', 'D', 'S', ':set noscb<CR>')
call KeyMap('ni', '<silent>', 'D', 'u', 'guaw')
call KeyMap('ni', '<silent>', 'D', 'U', 'gUaw')
call KeyMap('ni', '<silent>', 'D', 'E', ':e .<CR>')
call KeyMap('ni', '<silent>', 'D', 'Up', ':call SwapUp()<CR>')
call KeyMap('ni', '<silent>', 'D', 'Down', ':call SwapDown()<CR>')
call KeyMap('ni', '<silent>', 'C', 'Space', '<C-p>')
call KeyMap('ni', '<silent>', 'D', 'Space', '<C-X><C-O>')
call KeyMap('ni', '<silent>', 'S', '<F2>', ':call Vm_toggle_sign()<CR>')
call KeyMap('ni', '<silent>', '', '<F5>', ':BufExplorer<CR>')

" fuzzyfinder
call KeyMap('n', '<silent>', 'DL', 'r', ':call Tabnew()<CR>:FufFile **/<CR>')

" files & folders mapping
call KeyMap('n', '<silent>',  'CDLM', '-',       ':call CwdUp()<CR>')
call KeyMap('n', '<silent>',  'CDLM', '=',       ':call CwdDown()<CR>')
call KeyMap('n', '<silent>',  'CDLM', '0',       ':call CwdCurrent()<CR>')

" directory browsing
call KeyMap('n','<silent>', 'DL', 'e', ':call BrowserFromCurrentDir()<CR>')      " open a file browser in a new tab
call KeyMap('n','<silent>', 'DL', 'E', ':call BrowserFromCurrentFilePath()<CR>') " open a file browser in a new tab
call KeyMap('n','<silent>', 'DL', 'F', ':Ack<space>') " open a file browser in a new tab

inoremap <C-space> <C-p>

" quicker window switching
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

nnoremap <leader>. :lcd %:p:h<CR>

" ; is an alias for :
"nnoremap ; :

" Thank you vi
"nnoremap Y y$

" sudo write this
cmap w!! w !sudo tee % >/dev/null

"""""""""" macvim
if has("gui_macvim")
  let macvim_skip_cmd_opt_movement = 1
  let macvim_hig_shift_movement = 0
endif

" disable middle mouse pasting
map  <MiddleMouse>  <Nop>
map  <2-MiddleMouse>  <Nop>
map  <3-MiddleMouse>  <Nop>
map  <4-MiddleMouse>  <Nop>
imap  <MiddleMouse>  <Nop>
imap  <2-MiddleMouse>  <Nop>
imap  <3-MiddleMouse>  <Nop>
imap  <4-MiddleMouse>  <Nop>

inoremap <S-Space> <Space>
inoremap <S-CR> <C-o>O
inoremap <C-CR> <C-o>o
inoremap <C-S-CR> <CR><C-o>O
inoremap <silent> <Home> <C-o>:call HomeKey()<CR>
nnoremap <silent> <Home> :call HomeKey()<CR>

" switch cpp/h
nmap <MapLocalLeader>h :AT<CR>
nmap ,h :AT<CR>

map <Leader>s :call ToggleScratch()<CR>

" make word back / forward to be cooloer
"noremap W b
"noremap b W

" Disable recording
"nmap q <esc>
"vmap q <esc>

" tab keys
if has("gui_running")
  map <D-t> :tabnew<CR>
  map <D-n> :new<CR>
  map <D-S-t> :browse tabe<CR>
  map <D-S-n> :browse split<CR>
  map <D-]> :tabn<CR>
  map <D-[> :tabp<CR>
  imap <D-]> <C-o>:tabn<CR>
  imap <D-[> <C-o>:tabp<CR>
endif

if has("gui_running")
  imap <D-1> <C-o>1gt<CR>
  imap <D-2> <C-o>2gt<CR>
  imap <D-3> <C-o>3gt<CR>
  imap <D-4> <C-o>4gt<CR>
  imap <D-5> <C-o>5gt<CR>
  imap <D-6> <C-o>6gt<CR>
  imap <D-7> <C-o>7gt<CR>
  imap <D-8> <C-o>8gt<CR>
  imap <D-9> <C-o>9gt<CR>
  imap <D-0> <C-o>10gt<CR>
endif

if has("gui_running")
  map <D-1> 1gt
  map <D-2> 2gt
  map <D-3> 3gt
  map <D-4> 4gt
  map <D-5> 5gt
  map <D-6> 6gt
  map <D-7> 7gt
  map <D-8> 8gt
  map <D-9> 9gt
  map <D-0> 10gt
else
  map 1 1gt
  map 2 2gt
  map 3 3gt
  map 4 4gt
  map 5 5gt
  map 6 6gt
  map 7 7gt
  map 8 8gt
  map 9 9gt
  map 0 10gt
endif

" working with tabs
if has("gui_running")
  map <D-M-Right> :tabn<CR>
  map <D-M-Left> :tabp<CR>
  imap <D-M-Right> <C-o>:tabn<CR>
  imap <D-M-Left> <C-o>:tabp<CR>
endif

if !has("gui_running")
  noremap h <Esc>:tabprev<Cr>
  noremap l <Esc>:tabnext<Cr>
  noremap n <Esc>:tabnew<Cr>
  noremap c <Esc>:tabclose<Cr>
  noremap { <Esc>:tabprev<Cr>
  noremap } <Esc>:tabnext<Cr>
  noremap d <Esc>:tabnew<Cr>
else
  " working with tabs
  noremap h <Esc>:tabprev<Cr>
  noremap l <Esc>:tabnext<Cr>
  noremap n <Esc>:tabnew<Cr>
  noremap c <Esc>:tabclose<Cr>
endif

" completion
inoremap <expr> <CR> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
inoremap <expr> <C-n> pumvisible() ? '<C-n>' : '<C-n><C-r>=pumvisible() ? "\<lt>Down>" : ""<CR>' 
inoremap <expr> <M-,> pumvisible() ? '<C-n>' : '<C-x><C-o><C-n><C-p><C-r>=pumvisible() ? "\<lt>Down>" : ""<CR>'

" macros 
map ]xx :Explore<cr>2jp<c-w>H20<c-w><

" abbreviations
iabbrev mdy <C-r>=strftime("%Y-%m-%d %H:%M:%S")
iabbrev fi if
iabbrev fpritnf fprintf
iabbrev fro for
iabbrev pritnf printf
iabbrev stirng string
iabbrev teh the

" python syntax settings
let python_highlight_all = 1

" taglist settings
let Tlist_Ctags_Cmd = "/usr/bin/ctags"
let Tlist_Compact_Format = 1
let Tlist_File_Fold_Auto_Close = 1
let Tlist_Use_Right_Window = 1
let Tlist_Exit_OnlyWindow = 1
let Tlist_WinWidth = 0 

" ruby settings
let g:rubycomplete_buffer_loading = 1
let g:rubycomplete_classes_in_global = 1
let g:rubycomplete_rails = 1

" enhanced commentify
let g:EnhCommentifyBindInNormal = 'yes'
let g:EnhCommentifyBindInVisual = 'yes'

" fuzzy settings
let g:fuzzy_path_display = 'path'

" NERD commenter
let g:NERDMapleader = '<space>'
let g:NERDRemoveExtraSpaces = 1
let g:NERDSpaceDelims = 0
let g:NERDMenuMode=0
let g:NERDCustomDelimiters = {
  \ 'puppet': { 'left': '#' }
  \ }

" omni cpp complete
let OmniCpp_GlobalScopeSearch = 1
let OmniCpp_NamespaceSearch = 2
let OmniCpp_DisplayMode = 1
let OmniCpp_ShowScopeInAbbr = 1
let OmniCpp_ShowPrototypeInAbbr = 1
let OmniCpp_ShowAccess = 1
let OmniCpp_DefaultNamespaces = ["std", "_GLIBCXX_STD"]

" tex
let g:tex_ignore_makefile = 1
let g:tex_flavor = "/usr/texbin/pdftex"

" clang
"let g:clang_complete_copen = 1
"let g:clang_user_options='|| exit 0'
let g:clang_complete_auto = 1
let g:clang_complete_macros = 1
let g:clang_debug = 1
let g:clang_use_library = 1
let g:clang_library_path = "/Developer/usr/clang-ide/lib/"

" ensime / async
let g:async = {'vim' : '$HOME/Applications/MacVim.app/Contents/MacOS/Vim'} 
let g:ensime = {'ensime-script': "/Users/adragomi/work/vim/scala_vim/MarcWeber-ensime/dist_2.9.2-SNAPSHOT/bin/server"}

" clojure
let vimclojure#NailgunClient = "$HOME/bin/ng"
"let vimclojure#SplitPos = "right"
let vimclojure#HightlightBuiltins = 1
let vimclojure#WantNailgun = 0
let vimclojure#NailgunPort = "2200"
let vimclojure#ParenRainbow = 1

" javascript
let javaScript_fold=1

" factor
let g:FactorRoot="$HOME/temp/svn_other_projects/factor"

" netrw
let g:netrw_browsex_viewer="open"

let g:gist_clip_command = 'pbcopy'
let g:gist_open_browser_after_post = 1

let g:molokai_original = 1

let g:loaded_delimitMate = 1
" ack
let g:ackprg="ack -H --nocolor --nogroup --noenv --column"

" yankring
let g:yankring_history_dir = "$HOME/.vim/tmp"
let g:yankring_default_menu_mode = 0

"easymotion
let g:EasyMotion_mapping_e = '<Leader>ee'
let g:EasyMotion_keys = 'abcdefghijklmnopqrstuvwxyz'

"syntastic
let g:syntastic_enable_signs = 1
let g:syntastic_auto_loc_list=0
let g:syntastic_quiet_warnings=1
let g:syntastic_stl_format = '[%E{Err: %fe #%e #%t}]'

set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

" auto commands
command! -nargs=1 -complete=file C :call CreateNewFile(<f-args>)

" remove all buffers on exit so we don't have them as hidden on reopen
autocmd VimLeavePre * 1,255bwipeout

" let the javacomplete find its own port 
let g:first_nailgun_port=2114
let g:javacomplete_ng="/Users/adragomi/dotfiles/bin/binary/ng"

autocmd Filetype python setlocal expandtab tabstop=4 shiftwidth=4
autocmd Filetype java setlocal expandtab tabstop=2 shiftwidth=2
autocmd FileType ruby,haml,eruby,yaml,html,javascript,sass set ai sw=2 sts=2 et

autocmd Filetype html setlocal omnifunc=htmlcomplete#CompleteTags
autocmd Filetype css setlocal omnifunc=csscomplete#CompleteCSS
autocmd Filetype java setlocal omnifunc=javacomplete#Complete
autocmd Filetype java map <leader>b :JavaCompleteGoToDefinition<CR>
autocmd Filetype java map <leader>s :JavaCompleteReplaceWithImport<CR>

autocmd Filetype c set ts=4 sw=4

autocmd FileType ruby,eruby set omnifunc=rubycomplete#Complete
autocmd FileType text,markdown,mkd,pandoc setlocal textwidth=120
autocmd FileType puppet setlocal sw=2 ts=2 expandtab
autocmd BufReadPost *
  \ if line("'\"") > 0 && line("'\"") <= line("$") |
  \   exe "normal g`\"" |
  \ endif
augroup mkd
    autocmd BufRead *.mkd  set ai formatoptions=tcroqn2 comments=n:&gt;
    autocmd BufRead *.markdown  set ai formatoptions=tcroqn2 comments=n:&gt;
augroup END

autocmd BufRead *.f  set ft=forth

" remove empty or otherwise dead buffers when moving away from them
autocmd TabLeave    * call OnTabLeave()

set guitablabel=%{GuiTabLabel()}
"set guitablabel=MyTabLine()
set tabline=%!MyTabLine()

"let g:user_zen_settings = {
  "'php' : {
    "'extends' : 'html',
    "'filters' : 'c',
  "},
  "'xml' : {
    "'extends' : 'html',
  "},
  "'haml' : {
    "'extends' : 'html',
  "},
"}


" autocmds to automatically enter hex mode and handle file writes properly
if has("autocmd")
  " vim -b : edit binary using xxd-format!
  augroup Binary
    autocmd!
    autocmd BufReadPre *.bin,*.hex setlocal binary
    autocmd BufReadPost *
          \ if &binary | Hexmode | endif
    autocmd BufWritePre *
          \ if exists("b:editHex") && b:editHex && &binary |
          \  let oldro=&ro | let &ro=0 |
          \  let oldma=&ma | let &ma=1 |
          \  exe "%!xxd -r" |
          \  let &ma=oldma | let &ro=oldro |
          \  unlet oldma | unlet oldro |
          \ endif
    autocmd BufWritePost *
          \ if exists("b:editHex") && b:editHex && &binary |
          \  let oldro=&ro | let &ro=0 |
          \  let oldma=&ma | let &ma=1 |
          \  exe "%!xxd" |
          \  exe "set nomod" |
          \  let &ma=oldma | let &ro=oldro |
          \  unlet oldma | unlet oldro |
          \ endif
  augroup END

  autocmd! BufWritePost *
    \ if &diff == 1 |
    \ :diffupdate | 
    \ endif
endif

" hosts {{{
let hostfile=$HOME . '.vim/hosts/' . hostname() . ".vim"
if filereadable(hostfile)
    exe 'source ' . hostfile
endif
" }}}

let g:ctk_defoutput = "$HOME/.vim/tmp/output"
