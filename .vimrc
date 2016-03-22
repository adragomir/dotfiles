"vim:foldmethod=marker
" set PATH correctly {{{
if has("macunix") && has("gui_running") " && system('ps xw | grep -c "[V]im -MMNo"') > 0
  " Get the value of $PATH from a login shell.
  if $SHELL =~ '/\(sh\|csh\|bash\|tcsh\|zsh\)$'
    let s:path = system("echo echo VIMPATH'${PATH}' | $SHELL -l")
    let $PATH = matchstr(s:path, 'VIMPATH\zs.\{-}\ze\n')
  endif
endif
"}}}

" settings {{{

" general settings {{{
set nocompatible              " use VI incompatible features
filetype off
let no_buffers_menu=1
set noautochdir
set history=10000             " number of history items
set conceallevel=0
set shiftround
" backup settings
set nobackup " do not keep backups after close
set nowritebackup " do not keep a backup while working
set noswapfile " don't keep swp files either
set backupcopy=yes " keep attributes of original file
set backupskip=/tmp/*,/private/tmp/*,$TMPDIR/*,$TMP/*,$TEMP/*
" ui settings
set ruler                     " show the cursor position all the time
set scrolloff=3               " start scrolling before end
set showcmd                   " show incomplete commands
set number                    " show line numbers
set relativenumber
set whichwrap=<,>,h,l,b,s,~,[,]
set shortmess=aTI             " supress some file messages
set sidescrolloff=4           " minchars to show around cursor
" set selectmode=mouse,key      " select model
" set keymodel=startsel         ",stopsel
set display+=lastline
set autoread                  " read outside modified files
set encoding=UTF-8            " file encoding
set modeline
set modelines=3
set regexpengine=0
set t_ti=
set t_te=
set foldmethod=manual
set formatoptions=tcqjn1     " auto format -ro
set colorcolumn=+1
set guioptions=ci+Mgrbe       " NEVER EVER put ''a in here
set synmaxcol=600
set foldlevelstart=99
" visual cues
set ignorecase                " ignore case when searching
set smartcase                 " ignore case when searching
set hlsearch                  " highlight last search
set incsearch                 " show matches while searching
set gdefault
set nojoinspaces
"set cursorline
set laststatus=2              " always show status line

if has('patch-7.4.338')
  set breakindent
  set breakindentopt=sbr
endif
set showbreak=…
set fillchars=diff:⣿,vert:\|
set noshowcmd                   " show number of selected chars/lines in status
"set showmatch                 " briefly jump to matching brace
"set matchtime=1               " show matching brace time (1/10 seconds)
set statusline=%<%f\ (%{&ft},%{&ff})\ (%{&ts},%{&sts},%{&sw},%{&et?'et':'noet'})\ %-4(%m%)%=%-19(%3l,%02c%03V,%o%)
set undolevels=10000
set numberwidth=5
set pumheight=15
set viminfo=h,'10000,\"1000,n$HOME/.vim/tmp/.viminfo
set scrolljump=10
set virtualedit+=block
set novisualbell
set noerrorbells
set nostartofline
set tildeop
set t_vb=
set winaltkeys=no
set writeany
set iskeyword=@,48-57,128-167,224-235,_
"set listchars=tab:▸\ ,eol:¬,extends:❯,precedes:❮,trail:.
set showtabline=2
set matchtime=3
set complete=.,w,b,u,t,i,d	" completion by Ctrl-N
set completeopt=menu,menuone "sjl: set completeopt=longest,menuone,preview
if !has('nvim')
  set ttyfast
endif
set ttymouse=xterm
set timeout
set ttimeout
set timeoutlen=1000
set ttimeoutlen=0
if !has('nvim')
  set guipty
endif
set clipboard=unnamed "unnamed ",unnamedplus,autoselect
set undofile
set undoreload=10000
set undodir=~/.vim/tmp/undo/
set backupdir=~/.vim/tmp/backup/ " store backups under ~/.vim/backup
set directory=~/.vim/tmp/swap/ " keep swp files under ~/.vim/swap
set backup
" settings: windows and buffers
"set noequalalways
set guiheadroom=0
set shell=bash
set shellcmdflag=-lc
" 	When off a buffer is unloaded when it is |abandon|ed.
set hidden
set splitbelow                " split windows below current one
set splitright
set linebreak
set dictionary=/usr/share/dict/words
set noexrc " don't read dotfiles in folders
set gcr=a:blinkon0
set switchbuf=useopen
" settings: line endings
" settings: grep
if executable("ag")
  set grepprg=ag\ --nogroup\ --nocolor
endif
set grepformat=%f:%l:%m
" settings: tabs and indentin
set nofoldenable
set autoindent
"set nocindent
set lazyredraw
set smartindent
" don't delete past the end of line
set selection=old
set copyindent
"set indentexpr=
set expandtab
set tabstop=2
set shiftwidth=2
set softtabstop=2
set cmdheight=2
set suffixes+=.lo,.o,.moc,.la,.closure,.loT
set suffixes+=.bak,~,.o,.h,.info,.swp,.obj
set suffixes+=class,.6
let g:did_install_default_menus = 1
" }}}

" wildmenu settings {{{
set wildmenu
"set wildmode=list:longest,full
set wildmode=longest,list
set wildignore+=.svn,CVS,.git,.hg
set wildignore+=*.aux,*.out,*.toc " latex files
set wildignore+=*.o,*.d,*.obj,*.dylib,*.so,*.exe,*.manifest,*.a,*.mo,*.la " objects
set wildignore+=*.class,*.jar
set wildignore+=.classpath,.project,.settings
set wildignore+=*.jpg,*.jpeg,*.png*,*.gif,*.tiff,*.xmp
set wildignore+=*.sw?,*.bak
set wildignore+=*.6,*.out
set wildignore+=.DS_Store
set wildignore+=*.pyc,*.class,*.luac
set wildignore+=*.erbc,*.scssc
set wildignore+=*.zip,*.tar,*.gz,*.rar
set wildignore+=vendor/rails/**
set wildignore+=vendor/cache/**
set wildignore+=*.gem
set wildignore+=log/**
set wildignore+=tmp/**
set wildignore+=*sass-cache*
set wildignore+=target,target/classes,classes
set wildignore+=.idea

let g:sh_noisk=1
let g:is_bash=1
" }}}

" pathogen {{{

" disabled plugins {{{
" manpageview {{{
let g:loaded_manpageview = 1
let g:loaded_manpageviewPlugin = 1
" }}}
let g:loaded_getscript = 1
let g:loaded_sql_completion = 1
let g:loaded_sql_completion=1
let g:loaded_vimball=1
let g:loaded_netrwPlugin = 1
" }}}

"let g:pathogen_disabled = ['command-t', 'ios', 'gundo', 'vim-rails', 'scriptease', 'vim-expand-region']
"call pathogen#infect() 
"call pathogen#helptags()

" vim-plug
let g:plug_url_format='https://github.com/%s.git'
source $HOME/.vim/autoload/plug.vim

call plug#begin('~/.vim/bundle')
" languages
Plug 'Rip-Rip/clang_complete', { 'dir': '~/.vim/bundle/clang_complete' }
Plug 'tpope/vim-fireplace', { 'dir': '~/.vim/bundle/fireplace' }
Plug 'fatih/vim-go', { 'dir': '~/.vim/bundle/vim-go' }
Plug 'benmills/vim-golang-alternate', { 'dir': '~/.vim/bundle/golang-alternate', 'do': 'patch -p1 < ~/.vim/patches/golang-alternate.patch' }
Plug 'othree/html5.vim', { 'dir': '~/.vim/bundle/html5' }
Plug 'pangloss/vim-javascript', { 'dir': '~/.vim/bundle/javascript' }
Plug 'elzr/vim-json', { 'dir': '~/.vim/bundle/json' }
Plug 'plasticboy/vim-markdown', { 'dir': '~/.vim/bundle/markdown' }
Plug 'derekwyatt/vim-scala', { 'dir': '~/.vim/bundle/scala' }
Plug 'wting/rust.vim', { 'dir': '~/.vim/bundle/rust' }
Plug 'sirtaj/vim-openscad', { 'dir': '~/.vim/bundle/openscad' }
Plug 'ajf/puppet-vim', { 'dir': '~/.vim/bundle/puppet-vim' }
Plug 'davidhalter/jedi-vim', { 'dir': '~/.vim/bundle/jedi-vim' }
Plug 'klen/python-mode', { 'dir': '~/.vim/bundle/python-mode', 'for': 'python' }
Plug 'kien/rainbow_parentheses.vim', { 'dir': '~/.vim/bundle/rainbow_parentheses' }
Plug 'pearofducks/ansible-vim', { 'dir': '~/.vim/bundle/ansible-vim' }
Plug 'kchmck/vim-coffee-script', { 'dir': '~/.vim/bundle/vim-coffee-script' }
Plug 'ebfe/vim-racer', { 'dir': '~/.vim/bundle/vim-racer' }
Plug 'tpope/vim-rails', { 'dir': '~/.vim/bundle/vim-rails' }
Plug 'vim-ruby/vim-ruby', { 'dir': '~/.vim/bundle/vim-ruby' }
"Plug 'sudar/vim-arduino-syntax', { 'dir': '~/.vim/bundle/vim-arduino-syntax' }
Plug 'stephpy/vim-yaml', { 'dir': '~/.vim/bundle/vim-yaml' }
Plug 'guns/vim-clojure-static', { 'dir': '~/.vim/bundle/vimclojure-static' }
Plug 'guns/vim-sexp', { 'dir': '~/.vim/bundle/vim-sexp', 'for': ['clojure', 'lisp', 'scheme']}
Plug 'tpope/vim-sexp-mappings-for-regular-people', { 'dir': '~/.vim/bundle/vim-sexp-mappings-for-regular-people', 'for': ['clojure', 'lisp', 'scheme'] }
Plug 'rhysd/vim-clang-format', { 'dir': '~/.vim/bundle/vim-clang-format' }
Plug 'Glench/Vim-Jinja2-Syntax', { 'dir': '~/.vim/bundle/vim-jinja2-syntax' }
Plug 'eagletmt/ghcmod-vim', { 'dir': '~/.vim/bundle/ghcmod-vim' }
Plug 'eagletmt/neco-ghc', { 'dir': '~/.vim/bundle/neco-ghc' }
Plug 'neovimhaskell/haskell-vim', { 'dir': '~/.vim/bundle/haskell-vim' }
Plug 'lukerandall/haskellmode-vim', { 'dir': '~/.vim/bundle/haskellmode-vim' }
Plug 'enomsg/vim-haskellConcealPlus', { 'dir': '~/.vim/bundle/vim-haskellConcealPlus' }
Plug 'elmcast/elm-vim', { 'dir': '~/.vim/bundle/elm-vim' }
Plug 'elixir-lang/vim-elixir', { 'dir': '~/.vim/bundle/vim-elixir'}
Plug 'megaannum/vimside', { 'dir': '~/.vim/bundle/vimside' }
" Haxe
Plug 'jdonaldson/vaxe', { 'dir': '~/.vim/bundle/vaxe' }
" tools
Plug 'tpope/vim-fugitive', { 'dir': '~/.vim/bundle/fugitive' }
Plug 'ctrlpvim/ctrlp.vim', { 'dir': '~/.vim/bundle/ctrlp' }
Plug 'rking/ag.vim', { 'dir': '~/.vim/bundle/ag'}
Plug 'tpope/vim-tbone', { 'dir': '~/.vim/bundle/tbone' }
Plug 'lyuts/vim-rtags', { 'dir': '~/.vim/bundle/vim-rtags' }
" vim
Plug 'vim-scripts/a.vim', { 'dir': '~/.vim/bundle/a', 'do': 'patch -p1 < ~/.vim/patches/a.patch' }
"Plug 'tpope/vim-rsi', { 'dir': '~/.vim/bundle/rsi' }
Plug 'tpope/vim-abolish', { 'dir': '~/.vim/bundle/abolish' }
Plug 'tpope/vim-classpath', { 'dir': '~/.vim/bundle/classpath' }
Plug 'tpope/vim-commentary', { 'dir': '~/.vim/bundle/commentary' }
Plug 'tpope/vim-dispatch', { 'dir': '~/.vim/bundle/dispatch' }
Plug 'tpope/vim-endwise', { 'dir': '~/.vim/bundle/endwise' }
Plug 'vim-scripts/DetectIndent', { 'dir': '~/.vim/bundle/detectindent' }
Plug 'edsono/vim-matchit', { 'dir': '~/.vim/bundle/matchit' }
Plug 'tpope/vim-obsession', { 'dir': '~/.vim/bundle/obsession' }
Plug 'thinca/vim-quickrun', { 'dir': '~/.vim/bundle/quickrun' }
Plug 'tpope/vim-repeat', { 'dir': '~/.vim/bundle/repeat' }
Plug 'mtth/scratch.vim', { 'dir': '~/.vim/bundle/scratch' }
Plug 'ervandew/supertab', { 'dir': '~/.vim/bundle/supertab' }
Plug 'tpope/vim-surround', { 'dir': '~/.vim/bundle/surround' }
Plug 'scrooloose/syntastic', { 'dir': '~/.vim/bundle/syntastic', 'do': 'git am ~/.vim/patches/syntastic.patch' }
Plug 'godlygeek/tabular', { 'dir': '~/.vim/bundle/tabular' }
Plug 'kana/vim-textobj-user', { 'dir': '~/.vim/bundle/textobj-user' }
Plug 'wellle/targets.vim', { 'dir': '~/.vim/bundle/targets.vim' }
Plug 'tpope/vim-unimpaired', { 'dir': '~/.vim/bundle/unimpaired' }
Plug 'terryma/vim-expand-region', { 'dir': '~/.vim/bundle/vim-expand-region' }
Plug 'Shougo/vimproc', { 'dir': '~/.vim/bundle/vimproc', 'do': 'make' }
Plug 't9md/vim-choosewin', { 'dir': '~/.vim/bundle/vim-choosewin' }
Plug 'tmux-plugins/vim-tmux-focus-events', { 'dir': '~/.vim/bundle/vim-tmux-focus-events' }
Plug 'mhinz/vim-sayonara', { 'dir': '~/.vim/bundle/vim-sayonara' }
Plug 'jansedivy/jai.vim', {'dir': '~/.vim/bundle/jai' }

call plug#end()

" }}}

" disable plugins in runtime

" mapleader {{{
let mapleader = ","
let maplocalleader = ","
" }}}

" look & feel {{{
set t_Co=256
set background=dark
colorscheme monochrome
" }}}

" gui settings {{{
if has("gui_running")
  set mouse=a
  " backspace and cursor keys wrap to previous/next line
  set backspace=indent,eol,start
  set whichwrap+=<,>,[,]

  if has("macunix")
    " mac
    set guifont=Inconsolata:h14
    set antialias
    set fuoptions=maxvert,maxhorz
  else
    " normal linuxes, gui mode
  endif
else
  set mouse=a
  set backspace=indent,eol,start
endif
" }}}

" syntax highlighting {{{
syntax enable
syntax on
filetype on
filetype indent on
filetype plugin on
highlight WHITE_ON_BLACK ctermfg=white
hi NonText cterm=NONE ctermfg=NONE
hi SignColor guibg=red
au BufEnter * :syntax sync fromstart
" }}}

"}}}

" my functions {{{
function! DashUnderCursor()
  let term = expand('<cword>')
  let mft = &ft
  call DashSearch(term, mft)
endfunction

function! DashSearch(term, keyword) "{{{
  let keyword = a:keyword

  if !empty(keyword)
    let keyword = keyword . ':'
  endif

  silent execute '!open dash://' . shellescape(keyword . a:term)
  redraw!
endfunction

function! GetBufferList()
  redir =>buflist
  silent! ls
  redir END
  return buflist
endfunction

function! BufferIsOpen(bufname)
  let buflist = GetBufferList()
  for bufnum in map(filter(split(buflist, '\n'), 'v:val =~ "'.a:bufname.'"'), 'str2nr(matchstr(v:val, "\\d\\+"))')
    if bufwinnr(bufnum) != -1
      return 1
    endif
  endfor
  return 0
endfunction

function! ToggleQuickfix()
  if BufferIsOpen("Quickfix List")
    cclose
  else
    call OpenQuickfix()
  endif
endfunction

function! OpenQuickfix()
  cgetfile tmp/quickfix
  topleft cwindow
  if &ft == "qf"
      cc
  endif
endfunction

function! s:VSetSearch()
  let temp = @@
  norm! gvy
  let @/ = '\V' . substitute(escape(@@, '\'), '\n', '\\n', 'g')
  let @@ = temp
endfunction

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

" Visual mode functions
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

function! ToggleScratch()
  if expand('%') == g:ScratchBufferName
    quit
  else
    Sscratch
  endif
endfunction

function! s:VSetSearch()
  let temp = @@
  norm! gvy
  let @/ = '\V' . substitute(escape(@@, '\'), '\n', '\\n', 'g')
  let @@ = temp
endfunction

function! RestoreRegister()
  if &clipboard == 'unnamed'
    let @* = s:restore_reg
  elseif &clipboard == 'unnamedplus'
    let @+ = s:restore_reg
  else
    let @" = s:restore_reg
  endif
  return ''
endfunction

function! ReplaceWithRegister()
    let s:restore_reg = @"
    return "p@=RestoreRegister()\<cr>"
endfunction
xnoremap <silent> <expr> p ReplaceWithRegister()

function! MapSearch(rhs_pattern, bang)
    let mode = ( a:0 >= 1 ? a:1 : '' )
    let more = &more
    setl nomore
    redir => maps
	exe "silent ".mode."map"
    redir end
    let &l:more = more
    let list = split(maps, "\n")
    let rhs_list  = ( a:bang == "" ? map(copy(list), 'matchstr(v:val, ''.\s\+\S\+\s\+\zs.*'')') :
		\ map(copy(list), 'matchstr(v:val, ''.\s\+\zs\S\+\s\+.*'')') )
    let i = 0
    let i_list = []
    for rhs in rhs_list
	if rhs =~ a:rhs_pattern
	    call add(i_list, i)
	endif
	let i+=1
    endfor

    let found_maps = []
    for i in i_list
	call add(found_maps, list[i])
    endfor
    if len(found_maps) > 0
	echo join(found_maps, "\n")
    else
	echohl WarningMsg
	echo "No such map"
	echohl Normal
    endif
endfunction

function! Kwbd(kwbdStage)
  if(a:kwbdStage == 1)
    if(!buflisted(winbufnr(0)))
      bd!
      return
    endif
    let s:kwbdBufNum = bufnr("%")
    let s:kwbdWinNum = winnr()
    windo call Kwbd(2)
    execute s:kwbdWinNum . 'wincmd w'
    let s:buflistedLeft = 0
    let s:bufFinalJump = 0
    let l:nBufs = bufnr("$")
    let l:i = 1
    while(l:i <= l:nBufs)
      if(l:i != s:kwbdBufNum)
        if(buflisted(l:i))
          let s:buflistedLeft = s:buflistedLeft + 1
        else
          if(bufexists(l:i) && !strlen(bufname(l:i)) && !s:bufFinalJump)
            let s:bufFinalJump = l:i
          endif
        endif
      endif
      let l:i = l:i + 1
    endwhile
    if(!s:buflistedLeft)
      if(s:bufFinalJump)
        windo if(buflisted(winbufnr(0))) | execute "b! " . s:bufFinalJump | endif
      else
        enew
        let l:newBuf = bufnr("%")
        windo if(buflisted(winbufnr(0))) | execute "b! " . l:newBuf | endif
      endif
      execute s:kwbdWinNum . 'wincmd w'
    endif
    if(buflisted(s:kwbdBufNum) || s:kwbdBufNum == bufnr("%"))
      execute "bd! " . s:kwbdBufNum
    endif
    if(!s:buflistedLeft)
      set buflisted
      set bufhidden=delete
      set buftype=
      setlocal noswapfile
    endif
  else
    if(bufnr("%") == s:kwbdBufNum)
      let prevbufvar = bufnr("#")
      if(prevbufvar > 0 && buflisted(prevbufvar) && prevbufvar != s:kwbdBufNum)
        b #
      else
        bn
      endif
    endif
  endif
endfunction

command! K call Kwbd(1)

" }}}

" settings after functions {{{ 
set guitablabel=%{GuiTabLabel()}
set tabline=%!MyTabLine()
" }}}

" key mappings {{{

" home and end
if $TERM =~ '^screen-256color'
  set t_Co=256
  nmap <Esc>OH <Home>
  imap <Esc>OH <Home>
  cmap <esc>OH <Home>
  nmap <Esc>OF <End>
  imap <Esc>OF <End>
  cmap <Esc>OF <End>
endif

" System clipboard interaction.
map <leader>y "*y

" re-select old stuff
noremap gV `<v'>
noremap g> `<v'>
noremap g< `<v'>
noremap g] `[v']
noremap g[ `[v']

" fix movement keys
noremap j gj
noremap k gk
noremap <up> gk
noremap <down> gj
nnoremap D d$
nnoremap * *<c-o>

" remap: Kill window instead of man page
nnoremap K :q<cr>
" remap: mistake, move visual
vnoremap J j
vnoremap K k
" remap: mistake, hit u
vnoremap u <nop>
" nnoremap <BS> "_x
nnoremap <Del> "_x
" vnoremap <BS> "_x
" vnoremap <Del> "_x

" Keep search matches in the middle of the window.
nnoremap n nzzzv
nnoremap N Nzzzv

" Same when jumping around
nnoremap g; g;zz
nnoremap g, g,zz
nnoremap <c-o> <c-o>zz

" Heresy
inoremap <c-a> <esc>I
inoremap <c-e> <esc>A
" emacs bindings, like the shell
cnoremap <c-a> <home>
cnoremap <c-e> <end>

" whole hog
" map <up> <nop>
" map <down> <nop>
" map <left> <nop>
" map <right> <nop>
" imap <up> <nop>
" imap <down> <nop>
" imap <left> <nop>
" imap <right> <nop>

" ag word
nnoremap <silent> <leader>/ :Ag<cr>
vnoremap <silent> <leader>/ :AgVisual<cr>

" command: debug highlight groups
nnoremap <F8> :echo "hi<" . synIDattr(synID(line("."),col("."),1),"name") . '> trans<'
                        \ . synIDattr(synID(line("."),col("."),0),"name") . "> lo<"
                        \ . synIDattr(synIDtrans(synID(line("."),col("."),1)),"name") . ">"<cr>

" command:  clean whitespace
nnoremap <leader>w :%s/\s\+$//<cr>:let @/=''<cr>

" command: send to gist
vnoremap <leader>G :w !gist -p -t %:e \| pbcopy<cr>

" GRB: clear the search buffer when hitting return
function! MapCR()
  nnoremap <cr> :nohlsearch<cr>
endfunction
call MapCR()



nnoremap <m-Down> :cnext<cr>zvzz
nnoremap <m-Up> :cprevious<cr>zvzz

" Use c-\ to do c-] but open it in a new split.
nnoremap <c-\> <c-w>v<c-]>zvzz

" quickfix
nnoremap <leader>q :call ToggleQuickfix()<cr>
nnoremap <leader>Q :cc<cr>

" remap: always go to character, with ' and `
nnoremap ' `
xnoremap ' `
map <leader>' ``
map <leader>. `.
map <leader>] `]
map <leader>> `>
map <leader>` `^

nnoremap - $
xnoremap - $
onoremap - $

" vaporize delete without overwriting the default register
nnoremap vd "_d
xnoremap x  "_d
nnoremap vD "_D

inoremap <C-u> <esc>mzgUiw`za

vnoremap * :<C-u>call <SID>VSetSearch()<CR>//<CR><c-o>
vnoremap # :<C-u>call <SID>VSetSearch()<CR>??<CR><c-o>

nnoremap <silent> Q <nop>

map <silent> <F5> :CtrlPBuffer<CR>
imap <silent> <F5> <C-O>:CtrlPBuffer<CR>

map <silent> <F6> :CtrlP /Users/adr/Documents/personal/notes/<CR>
imap <silent> <F6> <C-O>:CtrlP /Users/adr/Documents/personal/notes/<CR>

imap <c-c> <Esc>
" quicker window switching
nnoremap <C-h> <c-w>h
nnoremap <C-j> <c-w>j
nnoremap <C-k> <c-w>k
nnoremap <C-l> <c-w>l

" Thank you vi
"nnoremap Y y$

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
inoremap <C-Space> <C-o>m`
inoremap <silent> <Home> <C-o>:call HomeKey()<CR>
nnoremap <silent> <Home> :call HomeKey()<CR>
noremap <Space> m`

" switch cpp/h
nmap <MapLocalLeader>h :AT<CR>
map <Leader>s :call ToggleScratch()<CR>

" make word back / forward to be cooloer
"noremap W b
"noremap b W

" Disable recording
" nmap q <nop>
" vmap q <nop>

set pastetoggle=<f1>

" terminal
map <leader>1 1gt
map <leader>2 2gt
map <leader>3 3gt
map <leader>4 4gt
map <leader>5 5gt
map <leader>6 6gt
map <leader>7 7gt
map <leader>8 8gt
map <leader>9 9gt
map <leader>0 10gt

noremap <leader>h <Esc>:tabprev<Cr>
noremap <leader>l <Esc>:tabnext<Cr>
noremap <leader>n <Esc>:tabnew<Cr>
noremap <leader>d <Esc>:tabclose<Cr>
noremap <leader>t <Esc>:tabnew<Cr>

map <leader>r :w\|:silent !reload-chrome<cr>

" noremap p "0p
" noremap P "0P
" vnoremap p "0p
" vnoremap P "0P
noremap c "_c
noremap cc "_cc
noremap C "_C

nmap -  <Plug>(choosewin)

nnoremap <silent><F3> :MaximizerToggle<CR>
vnoremap <silent><F3> :MaximizerToggle<CR>gv
inoremap <silent><F3> <C-o>:MaximizerToggle<CR>

noremap ( <nop>
noremap ) <nop>
noremap { <nop>
noremap } <nop>
noremap ]] <nop>
noremap ][ <nop>
noremap [[ <nop>
noremap [] <nop>

" }}}

" abbreviations {{{
" }}}

" plugin settings {{{

" java plugin settings {{{
let java_mark_braces_in_parens_as_errors=0
let java_highlight_all=1
let java_highlight_debug=1
let java_ignore_javadoc=1
let java_highlight_java_lang_ids=1
let java_highlight_functions="style"
" }}}

" sparkup {{{
let g:sparkupExecuteMapping = '<c-e>'
let g:sparkupNextMapping = '<c-s>'
" }}}

" expand-region {{{
" let g:expand_region_text_objects = {
"       \ 'iw'  :1,
"       \ 'iW'  :1,
"       \ 'i"'  :1,
"       \ 'i''' :1,
"       \ 'i]'  :1,
"       \ 'ib'  :1,
"       \ 'iB'  :1,
"       \ 'il'  :0,
"       \ 'ip'  :1,
"       \ 'ie'  :0,
"       \ }
" }}}

" match paren settings {{{
let g:loaded_matchparen = 1
let g:matchparen_timeout = 10
let g:matchparen_insert_timeout = 10
" }}}
"
" python syntax settings {{{
let g:pymode_syntax = 1
let g:pymode_folding = 0
let g:pymode_warning = 0
let g:pymode_motion = 0
let g:pymode_syntax_all = 1
let g:pymode_syntax_indent_errors = g:pymode_syntax_all
let g:pymode_rope = 0
let g:pymode_rope_enable_autoimport = 0
let g:pymode_rope_auto_project = 0
let g:pymode_rope_lookup_project = 0
let g:pymode_lint = 0
let python_highlight_all = 1
let g:pymode_rope_guess_project = 0
let g:pymode_rope_vim_completion = 0
" }}}

" taglist settings {{{
let Tlist_Ctags_Cmd = "/usr/local/bin/ctags"
let Tlist_Compact_Format = 1
let Tlist_File_Fold_Auto_Close = 1
let Tlist_Use_Right_Window = 1
let Tlist_Exit_OnlyWindow = 1
let Tlist_WinWidth = 0 
" }}}

" supertab settings {{{
" let g:SuperTabCrMapping = 0
" let g:SuperTabMappingForward = '<c-space>'
" let g:SuperTabMappingBackward = '<s-c-space>'
let g:SuperTabDefaultCompletionType = "context"
let g:SuperTabDefaultCompletionTypeDiscovery = [
        \ "&completefunc:<c-x><c-u>",
        \ "&omnifunc:<c-x><c-o>",
        \ ]
let g:SuperTabContextDefaultCompletionType = "<c-n>"
" let g:SuperTabDefaultCompletionType = '<c-n>'
" }}}

" targets.vim {{{ 
let g:targets_nlNL = '    '
let g:targets_pairs = '()b {}b []b <>b'
let g:targets_quotes = '" '' `'
let g:targets_separators = ', . ; : + - = ~ _ / |'
let g:targets_argTrigger = ','
let g:targets_argOpening = '[([]'
let g:targets_argClosing = '[])]'

" }}}

" ctrl-p settings {{{
let g:ctrlp_user_command = 'ag %s -U -l --nocolor -g ""'
let g:ctrlp_custom_ignore = {
  \ 'dir':  '\.git$\|\.hg$\|\.svn\|tmp\|target\|test-output\|build\|.settings\|storm-local\|logs\|cloudera\|dev-support\|jdiff$',
  \ 'file': '\.exe$\|\.so$\|\.dll$|\.class$|\.jar$',
  \ }
let g:ctrlp_working_path_mode = 0
let g:ctrlp_cache_dir = "$HOME/.vim/tmp"
let g:ctrlp_switch_buffer = 2
let g:ctrlp_reuse_window = 'netrw\|help\|quickfix'
let g:ctrlp_max_files = 0
" }}}

" jedi {{{
let g:jedi#use_tabs_not_buffers = 0
let g:jedi#show_call_signatures = 0
let g:jedi#completions_enabled = 1
let g:jedi#auto_initialization = 1
let g:jedi#auto_vim_configuration = 0
let g:jedi#goto_definitions_command = "<leader>d"
let g:jedi#completions_command = "<C-x><C-o>"
" }}}

" textobjectify settings {{{
" let g:loaded_textobjectify = 1
let g:textobjectify_onthefly = 0
let g:textobjectify = {
            \'(': {'left': '(', 'right': ')', 'same': 0, 'seek': 1, 'line': 0},
            \')': {'left': '(', 'right': ')', 'same': 0, 'seek': 2, 'line': 0},
            \'{': {'left': '{', 'right': '}', 'same': 0, 'seek': 1, 'line': 0},
            \'}': {'left': '{', 'right': '}', 'same': 0, 'seek': 2, 'line': 0},
            \'[': {'left': '\[', 'right': '\]', 'same': 0, 'seek': 1, 'line': 0},
            \']': {'left': '\[', 'right': '\]', 'same': 0, 'seek': 2, 'line': 0},
            \'<': {'left': '<', 'right': '>', 'same': 0, 'seek': 1, 'line': 0},
            \'>': {'left': '<', 'right': '>', 'same': 0, 'seek': 2, 'line': 0},
            \'"': {'left': '"', 'right': '"', 'same': 1, 'seek': 1, 'line': 0},
            \"'": {'left': "'", 'right': "'", 'same': 1, 'seek': 1, 'line': 0},
            \'`': {'left': '`', 'right': '`', 'same': 1, 'seek': 1, 'line': 0},
            \' ': {'left': ' ', 'right': ' ', 'same': 1, 'seek': 0, 'line': 0},
            \'V': {'left': '^\s*\(if\|for\|function\|try\|while\)\>',
                \'right': '^\s*end', 'same': 0, 'seek': 1, 'line': 1},
            \"\<cr>": {'left': '\%^', 'right': '\%$', 'same': 0, 'seek': 0,
            \'line': 0},
            \}
" }}}

" go settings {{{
let g:godef_split = 0
let g:go_play_open_browser = 0
let g:go_fmt_fail_silently = 1
let g:go_fmt_autosave = 0
let g:go_disable_autoinstall = 1
let g:go_gocode_bin=expand("~/.gocode/bin/gocode")
let g:go_goimports_bin=expand("~/.gocode/bin/goimports")
let g:go_godef_bin=expand("~/.gocode/bin/godef")
let g:go_oracle_bin=expand("~/.gocode/bin/oracle")
let g:go_golint_bin=expand("~/.gocode/bin/golint")
let g:go_errcheck_bin=expand("~/.gocode/bin/errcheck")
" }}}

" ruby settings {{{
let g:rubycomplete_debug = 1
let g:rubycomplete_buffer_loading = 1
let g:rubycomplete_classes_in_global = 1
let g:rubycomplete_rails = 1
" }}}

" rails settings {{{
let g:rails_debug = 1
" }}}

" omni cpp complete {{{
let OmniCpp_GlobalScopeSearch = 1
let OmniCpp_NamespaceSearch = 2
let OmniCpp_DisplayMode = 1
let OmniCpp_ShowScopeInAbbr = 1
let OmniCpp_ShowPrototypeInAbbr = 1
let OmniCpp_ShowAccess = 1
let OmniCpp_DefaultNamespaces = ["std", "_GLIBCXX_STD"]
" }}}

" choosewin {{{
let g:choosewin_overlay_enable = 1
let g:choosewin_statusline_replace = 0
let g:choosewin_tabline_replace = 0
let g:choosewin_blink_on_land = 0
let g:choosewin_label = "1234567890"
let g:choosewin_tablabel = "ABCDEFGHIJKLMNOPQRTUVWYZ"

let g:choosewin_overlay_clear_multibyte = 1
" }}}

" tex {{{
let g:tex_ignore_makefile = 1
let g:tex_flavor = "/usr/texbin/pdftex"
" }}}

" clang_complete {{{
"let g:clang_complete_copen = 1
"let g:clang_user_options='|| exit 0'
let g:clang_complete_auto = 0
let g:clang_use_library = 1
let g:clang_complete_macros = 1
let g:clang_periodic_quickfix = 0
let g:clang_close_preview = 1
let g:clang_snippets = 0
let g:clang_debug = 1
if has("macunix")
  "let g:clang_library_path = "/usr/local/opt/llvm/lib/"
  let g:clang_library_path = "/usr/local/opt/llvm/lib/"
  " let g:clang_library_path = "/usr/local/Cellar/llvm/3.5.1/lib/"
else
  let g:clang_library_path = "/usr/lib/"
endif
" }}}
" clang format {{{
let g:clang_format#command = "/usr/local/bin/clang-format-3.6"
let g:clang_format#detect_style_file = 1
" }}}

" vimside {{{

" }}}

" clojure {{{
let g:slimv_loaded = 1
"let vimclojure#SplitPos = "right"
let vimclojure#FuzzyIndent=1
let vimclojure#HighlightBuiltins=1
let vimclojure#HighlightContrib=1
let vimclojure#DynamicHighlighting=1
let vimclojure#ParenRainbow=1
let vimclojure#WantNailgun = 1
let vimclojure#NailgunClient = expand("$HOME") . "/bin/darwin/ng"
let vimclojure#NailgunPort = "2113"
let vimclojure#ParenRainbow = 1
let g:paredit_mode = 0
" }}}

" haskell {{{
let g:necoghc_enable_detailed_browse = 1
" }}}

" mru {{{
let MRU_File = $HOME . '/.vim/tmp/.vim_mru_files'
" }}}

" javascript {{{
let javaScript_fold=1
" }}}

" factor {{{
let g:FactorRoot="$HOME/temp/source/other/factor"
" }}}

" tabular {{{
let g:no_default_tabular_maps=1
" }}}

" netrw {{{
let g:netrw_browsex_viewer="open"
" }}}

" gist {{{
let g:gist_clip_command = 'pbcopy'
let g:gist_open_browser_after_post = 1
" }}}

" molokai theme {{{
let g:molokai_original = 0
" }}}

let g:vim_json_syntax_conceal = 0

" ack {{{
let g:ackprg="ack -H --nocolor --nogroup --noenv --column"
" }}}

" rust racer {{{
let g:racer_cmd = $HOME . "/bin/darwin/racer"
let $RUST_SRC_PATH="/usr/local/Cellar/rust/NIGHTLY/rust/src"
" }}}

" syntastic {{{
"let g:syntastic_enable_signs = 1
"let g:syntastic_auto_loc_list=0
let g:syntastic_check_on_open=0
let g:syntastic_check_on_wq=0
let g:syntastic_quiet_messages = {'level': 'warnings'}
"let g:syntastic_stl_format = '[%E{Err: %fe #%e #%t}]'
let g:syntastic_disabled_filetypes = ['java', 'css', 'scss', 'html']
let g:syntastic_echo_current_error = 0
let g:syntastic_mode_map = { 'mode': 'passive',
                           \ 'active_filetypes': [],
                           \ 'passive_filetypes': ['puppet', 'java', 'scala', 'clojure', 'html'] }
"let g:syntastic_javascript_checkers = ['jshint']
" }}}


" javacomplete {{{
" let g:first_nailgun_port=2114
" let g:javacomplete_ng="/Users/adr/dotfiles/bin/binary/ng"
" }}}

" }}}

" abbreviations {{{
nnoremap <F7> "=strftime("(%Y-%m-%d %H:%M)")<CR>P
" }}}
" commands {{{
command! -bar -nargs=0 W  silent! exec "write !sudo tee % >/dev/null"  | silent! edit!
command! -bar -nargs=0 WX silent! exec "write !chmod a+x % >/dev/null" | silent! edit!

" typos
command! -bang E e<bang>
command! -bang Q q<bang>
" command! -bang W w<bang>
command! -bang QA qa<bang>
command! -bang Qa qa<bang>
command! -bang Wa wa<bang>
command! -bang WA wa<bang>
command! -bang Wq wq<bang>
command! -bang WQ wq<bang>
" }}}

" auto commands {{{

augroup all_buffers

  au!
  " Has to be an autocommand because repeat.vim eats the mapping otherwise :(
  " au VimEnter * :nnoremap U <c-r>

  au BufNewFile,BufRead *.ino set filetype=cpp
  au BufNewFile,BufRead *.pde set filetype=cpp
  " remove all buffers on exit so we don't have them as hidden on reopen
  au VimLeavePre * execute 'silent! 1,' . bufnr('$') . 'bwipeout!'

  " remove empty or otherwise dead buffers when moving away from them
  au TabLeave    * call OnTabLeave()

  " move to last position on file
  au BufReadPost *
    \ if line("'\"") > 0 && line("'\"") <= line("$") |
    \   exe "normal g`\"" |
    \ endif
  au BufReadPost *
      \ if line("'\"") > 0 && line("'\"") <= line("$") |
      \     execute 'normal! g`"zvzz' |
      \ endif

  autocmd! CmdwinEnter * :unmap <cr>
  autocmd! CmdwinLeave * :call MapCR()
  autocmd! WinEnter,BufWinEnter *
    \ if &ft == "qf" |
    \     execute ':silent! unmap <cr>' |
    \ else |
    \     execute ':silent! call MapCR()' |
    \ endif
  autocmd! WinLeave * 
    \ if &ft == "qf" |
    \     execute ':silent! unmap <cr>' |
    \ else |
    \     execute ':silent! call MapCR()' |
    \ endif
augroup END

" indentations
augroup settings
  au!
  au FileType python setlocal et ts=4 sw=4
  au FileType java setlocal et ts=2 sw=2
  au FileType ruby,haml,eruby,yaml,html,sass set ai sw=2 sts=2 et
  au FileType javascript setlocal ai sw=4 ts=4 sts=4 et
  au FileType c set ts=4 sw=4 sts=4 commentstring=//\ %s
  au FileType openscad set ts=4 sw=4 sts=4 commentstring=//\ %s
  au FileType css set expandtab ts=4 sw=4 sts=4
  au FileType scss set expandtab ts=4 sw=4 sts=4
  au FileType text,markdown,mkd,pandoc,mail setlocal textwidth=1000
  au FileType puppet setlocal sw=2 ts=2 expandtab
  au BufRead *.mkd  setlocal ai formatoptions=tcroqn2 comments=n:&gt;
  au BufRead *.markdown  setlocal ai formatoptions=tcroqn2 comments=n:&gt;
  au BufRead gopack.config  set comments=n:#
  au FileType qf setlocal colorcolumn=0 nolist nocursorline nowrap
  au FileType go set noexpandtab ts=4 sw=4 sts=4
  au FileType sh set iskeyword=35,36,45,46,48-57,64,65-90,97-122,_
  au BufRead,BufNewFile gopack.config setfiletype toml
augroup END

augroup endwiseadr
  au!
  au FileType go
    \ let b:endwise_addition = '}' |
    \ let b:endwise_words = 'func,for,switch,if,else,range,select' |
    \ let b:endwise_pattern = '^\s*\zs\%(func\|for\|switch\|if\|else\|range\|select\)\>\%(.*\)$' |
    \ let b:endwise_syngroups = 'goConditional,goRepeat,goType,goDeclaration'
augroup END

" completions
augroup completions
  au!
  au FileType html setlocal omnifunc=htmlcomplete#CompleteTags
  au FileType haskell setlocal omnifunc=necoghc#omnifunc
  au FileType css setlocal omnifunc=csscomplete#CompleteCSS
  au FileType ruby,eruby set omnifunc=rubycomplete#Complete
augroup END

augroup comments
  au FileType actionscript setlocal commentstring=//\ %s
augroup end

augroup mappings
  au!
  au FileType markdown nnoremap <buffer> <localleader>1 yypVr=
  au FileType markdown nnoremap <buffer> <localleader>2 yypVr-
  au FileType markdown nnoremap <buffer> <localleader>3 I### <ESC>
  au FileType clojure let g:SuperTabDefaultCompletionType = "<c-x><c-o>"
  au FileType go let g:SuperTabDefaultCompletionType = "<c-x><c-o>"
  au FileType go nmap <Leader>i <Plug>(go-import)
  au FileType go nmap <Leader>gd <Plug>(go-doc)
  au FileType go nmap <Leader>gv <Plug>(go-doc-vertical)
  au FileType go nmap <leader>r <Plug>(go-run)
  au FileType go nmap <leader>b <Plug>(go-build)
  au FileType go nmap <leader>t <Plug>(go-test)
  au FileType go nmap gd <Plug>(go-def)
  au FileType java let g:SuperTabDefaultCompletionType = "<c-x><c-u>"
augroup END

" }}}

" hosts {{{
let hostfile=$HOME . '.vim/hosts/' . hostname() . ".vim"
if filereadable(hostfile)
    exe 'source ' . hostfile
endif
" }}}

