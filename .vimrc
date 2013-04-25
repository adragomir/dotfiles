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
let no_buffers_menu=1
set noautochdir
set history=10000             " number of history items
set shiftround
"set autowriteall
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
set whichwrap=<,>,h,l,b,s,~,[,]
set shortmess=aTI             " supress some file messages
set sidescrolloff=4           " minchars to show around cursor
set selectmode=mouse,key      " select model
set keymodel=startsel         ",stopsel
set autoread                  " read outside modified files
set encoding=UTF-8            " file encoding
set modeline
"set modelines=0
set t_ti=
set t_te=
set formatoptions=tcqjn1     " auto format -ro
set colorcolumn=+1
"set guioptions=cr+bie"M"m	  " aA BAD
set guioptions=ci+Mgrbe       " NEVER EVER put ''a in here
set synmaxcol=800
"set guioptions=+
" visual cues
set ignorecase                " ignore case when searching
set smartcase                 " ignore case when searching
set hlsearch                  " highlight last search
set incsearch                 " show matches while searching
set gdefault

set laststatus=2              " always show status line
"set cursorcolumn
"set cursorline
set showbreak=…
set fillchars=diff:⣿,vert:\|
set noshowcmd                   " show number of selected chars/lines in status
set showmatch                 " briefly jump to matching brace
set matchtime=1               " show matching brace time (1/10 seconds)
set showmode                  " show mode in status when not in normal mode
set nostartofline             " don't move to start of line after commands
set statusline=%-2(%M\ %)%5l,%-5v%<%F\ %m%=[tab:%{&ts},%{&sts},%{&sw},%{&et?'et':'noet'}]\ [byte:\ %3b]\ [offset:\ %5o]\ %(%-5([%R%H%W]\ %)\ %10([%Y]{&fileformat}\ %)\ %L\ lines%)
set undolevels=10000
set numberwidth=5
set pumheight=10
set viminfo=%,h,'1000,"1000,:1000,n~/.vim/tmp/.viminfo,!
set scrolljump=10
set virtualedit+=block
set novisualbell
set noerrorbells
set tildeop
set t_vb=
set winaltkeys=no
set writeany
set iskeyword=:,@,48-57,128-167,224-235,_
set listchars=tab:▸\ ,eol:¬,extends:❯,precedes:❮,trail:.
set showtabline=2
set matchtime=3
set complete=.,w,b,u,t,i	" completion by Ctrl-N
set completeopt=menu,menuone,longest "sjl: set completeopt=longest,menuone,preview
set ttyfast
set timeout
set ttimeout
set timeoutlen=500
set ttimeoutlen=100
"set noesckeys
set guipty
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
set shellcmdflag=-lc
" 	When off a buffer is unloaded when it is |abandon|ed.
set hidden
set splitbelow                " split windows below current one
set splitright
set title
set linebreak
set dictionary=/usr/share/dict/words
set exrc
set gcr=a:blinkon0
set switchbuf=usetab
" settings: line endings
"set ff=unix
"set ffs=unix
" settings: grep
set grepprg=ag
set grepformat=%f:%l:%m
" settings: tabs and indentin
set nofoldenable
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
set suffixes+=.lo,.o,.moc,.la,.closure,.loT
set suffixes+=.bak,~,.o,.h,.info,.swp,.obj
set suffixes+=class,.6

" }}}

" wildmenu settings {{{
set wildmenu
set wildmode=list:longest,full
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

" }}}

" pathogen {{{

" disabled plugins {{{
" manpageview {{{
let g:loaded_manpageview = 1
let g:loaded_manpageviewPlugin = 1
" }}}
" }}}

let g:pathogen_disabled = ['vimside', 'javacomplete', 'numbers']

call pathogen#helptags()
call pathogen#infect() 
" }}}

" mapleader {{{
let mapleader = ","
let maplocalleader = ","
" }}}

" look & feel {{{
set t_Co=256
set background=dark
" solarized
" set t_Co=16
" let g:solarized_termtrans=1
" let g:solarized_termcolors=256
" let g:solarized_italic=0
colorscheme ir_black

if has("gui_running")
    set mouse=a
    " behave mswin
    set selectmode=mouse "key,mouse
    set mousemodel=popup
    set keymodel=startsel ",stopsel
    set selection=exclusive

    " source $VIMRUNTIME/mswin.vim
    " mswin.vim, INLINE
    " backspace and cursor keys wrap to previous/next line
    set backspace=indent,eol,start whichwrap+=<,>,[,]

    if has("macunix")
      " mac
      set guifont=Source\ Code\ Pro\ Light:h13
      set antialias
      set fuoptions=maxvert,maxhorz
    else
      " normal linuxes, gui mode
    endif
else
  if $TERM_PROGRAM =~ 'iTerm.*'
    let &t_SI = "\<Esc>]50;CursorShape=1\x7"
    let &t_EI = "\<Esc>]50;CursorShape=0\x7" 
  endif
endif

" }}}

" gui settings {{{
" }}}

" syntax highlighting {{{
syntax enable
syntax on
filetype on
filetype indent on
filetype plugin on
highlight WHITE_ON_BLACK ctermfg=white
hi SignColor guibg=red
autocmd BufEnter * :syntax sync fromstart
" }}}

"}}}

" my functions {{{
function! CursorPing()
    set cursorline cursorcolumn
    redraw
    sleep 50m
    set nocursorline nocursorcolumn
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

" }}}

" settings after functions {{{ 
set guitablabel=%{GuiTabLabel()}
"set guitablabel=MyTabLine()
set tabline=%!MyTabLine()
" }}}

" key mappings {{{
" System clipboard interaction.  Mostly from:
map \ :call CursorPing()<cr>
map <leader>y "*y

nnoremap <leader>ev :vsplit $MYVIMRC<cr>

" Highlight Group(s)
nnoremap <F8> :echo "hi<" . synIDattr(synID(line("."),col("."),1),"name") . '> trans<'
                        \ . synIDattr(synID(line("."),col("."),0),"name") . "> lo<"
                        \ . synIDattr(synIDtrans(synID(line("."),col("."),1)),"name") . ">"<cr>

" Select entire buffer
nnoremap vaa ggvGg_
nnoremap Vaa ggVG

" clean whitespace
nnoremap <leader>w :%s/\s\+$//<cr>:let @/=''<cr>

" Send visual selection to gist.github.com as a private, filetyped Gist
" Requires the gist command line too (brew install gist)
vnoremap <leader>G :w !gist -p -t %:e \| pbcopy<cr>

" GRB: clear the search buffer when hitting return
nnoremap <CR> :nohlsearch<CR><CR>
nnoremap <silent> <Leader>/ :nohlsearch<CR>

" Open a Quickfix window for the last search.
nnoremap <silent> <leader>/ :execute 'vimgrep /'.@/.'/g %'<CR>:copen<CR>

" Ack for the last search.
nnoremap <silent> <leader>? :execute "Ack! '" . substitute(substitute(substitute(@/, "\\\\<", "\\\\b", ""), "\\\\>", "\\\\b", ""), "\\\\v", "", "") . "'"<CR>

" Fix linewise visual selection of various text objects
nnoremap VV V
nnoremap Vit vitVkoj
nnoremap Vat vatV
nnoremap Vab vabV
nnoremap VaB vaBV

nnoremap <m-Down> :cnext<cr>zvzz
nnoremap <m-Up> :cprevious<cr>zvzz

noremap j gj
noremap k gk
nnoremap D d$
nnoremap * *<c-o>

" Use c-\ to do c-] but open it in a new split.
nnoremap <c-\> <c-w>v<c-]>zvzz

nnoremap / /\v
vnoremap / /\v

" Fuck you, help key.
noremap  <F1> :set invfullscreen<CR>
inoremap <F1> <ESC>:set invfullscreen<CR>a
" Kill window instead of man page
nnoremap K :q<cr>
inoremap # X<BS>#

" Keep search matches in the middle of the window.
nnoremap n nzzzv
nnoremap N Nzzzv

" Same when jumping around
nnoremap g; g;zz
nnoremap g, g,zz
nnoremap <c-o> <c-o>zz

noremap H ^
noremap L g_ "or $?

" Heresy
inoremap <c-a> <esc>I
inoremap <c-e> <esc>A

" whole hog
" map <up> <nop>
" map <down> <nop>
" map <left> <nop>
" map <right> <nop>
" imap <up> <nop>
" imap <down> <nop>
" imap <left> <nop>
" imap <right> <nop>

vnoremap * :<C-u>call <SID>VSetSearch()<CR>//<CR><c-o>
vnoremap # :<C-u>call <SID>VSetSearch()<CR>??<CR><c-o>

nnoremap <silent> Q <nop>

"nnoremap ; :
" no Ex mode
nnoremap Q gqip
vnoremap Q gq

nnoremap <leader>' ""yls<c-r>={'"': "'", "'": '"'}[@"]<cr><esc>

" emacs bindings, like the shell
cnoremap <c-a> <home>
cnoremap <c-e> <home>

nnoremap <leader>z zMzvzz

map <silent> <F5> :CtrlPBuffer<CR>
imap <silent> <F5> <C-O>:CtrlPBuffer<CR>

"inoremap <C-space> <C-p>

" quicker window switching
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

nnoremap <leader>. :lcd %:p:h<CR>

nnoremap <silent> <leader>hh :execute 'match InterestingWord1 /\<<c-r><c-w>\>/'<cr>
nnoremap <silent> <leader>h1 :execute 'match InterestingWord1 /\<<c-r><c-w>\>/'<cr>
nnoremap <silent> <leader>h2 :execute '2match InterestingWord2 /\<<c-r><c-w>\>/'<cr>
nnoremap <silent> <leader>h3 :execute '3match InterestingWord3 /\<<c-r><c-w>\>/'<cr>

" ; is an alias for :
"nnoremap ; :

" Thank you vi
"nnoremap Y y$

" sudo write this
cmap w!! w !sudo tee % >/dev/null

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

map <Leader>s :call ToggleScratch()<CR>

" make word back / forward to be cooloer
"noremap W b
"noremap b W

" Disable recording
"nmap q <esc>
"vmap q <esc>

" tab keys
if has("gui_running")
  if has("gui_macvim")
    let macvim_skip_cmd_opt_movement = 1
    let macvim_hig_shift_movement = 0
  endif

  noremap h <Esc>:tabprev<Cr>
  noremap l <Esc>:tabnext<Cr>
  noremap n <Esc>:tabnew<Cr>
  noremap c <Esc>:tabclose<Cr>

  if has("macunix")
    " can use D
    " backspace in Visual mode deletes selection
    vnoremap <BS> d

    " Cut
    vnoremap <D-X> "+x
    " Copy
    vnoremap <special> <D-C> "+y
    " Paste
    map <D-V>		"+gP
    cmap <D-V>		<C-R>+

    " Pasting blockwise and linewise selections is not possible in Insert and
    " Visual mode without the +virtualedit feature.  They are pasted as if they
    " were characterwise instead.
    " Uses the paste.vim autoload script.

    exe 'inoremap <script> <D-V>' paste#paste_cmd['i']
    exe 'vnoremap <script> <D-V>' paste#paste_cmd['v']

    " Use CTRL-Q to do what CTRL-V used to do
    noremap <C-Q>		<C-V>

    " CTRL-A is Select all
    noremap <D-A> gggH<C-O>G
    inoremap <D-A> <C-O>gg<C-O>gH<C-O>G
    cnoremap <D-A> <C-C>gggH<C-O>G
    onoremap <D-A> <C-C>gggH<C-O>G
    snoremap <D-A> <C-C>gggH<C-O>G
    xnoremap <D-A> <C-C>ggVG

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

    map <D-t> :tabnew<CR>
    map <D-n> :new<CR>
    map <D-S-t> :browse tabe<CR>
    map <D-S-n> :browse split<CR>
    map <D-]> :tabn<CR>
    map <D-[> :tabp<CR>
    imap <D-]> <C-o>:tabn<CR>
    imap <D-[> <C-o>:tabp<CR>

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

    map <D-M-Right> :tabn<CR>
    map <D-M-Left> :tabp<CR>
    imap <D-M-Right> <C-o>:tabn<CR>
    imap <D-M-Left> <C-o>:tabp<CR>

    noremap <silent> <D-`> :maca selectNextWindow:<CR>
    inoremap <silent> <D-`> <C-O>:maca selectNextWindow:<CR>
    noremap <silent> <D-d> :bd<CR>
    inoremap <silent> <D-d> <C-O>:bd<CR>
  else
    " use C
    " backspace in Visual mode deletes selection
    vnoremap <BS> d

    " CTRL-X and SHIFT-Del are Cut
    vnoremap <C-X> "+x
    " CTRL-C and CTRL-Insert are Copy
    vnoremap <special> <C-C> "+y
    " CTRL-V and SHIFT-Insert are Paste
    map <C-V>		"+gP
    cmap <C-V>		<C-R>+

    " Pasting blockwise and linewise selections is not possible in Insert and
    " Visual mode without the +virtualedit feature.  They are pasted as if they
    " were characterwise instead.
    " Uses the paste.vim autoload script.

    exe 'inoremap <script> <C-V>' paste#paste_cmd['i']
    exe 'vnoremap <script> <C-V>' paste#paste_cmd['v']

    " Use CTRL-Q to do what CTRL-V used to do
    noremap <C-Q>		<C-V>

    " CTRL-A is Select all
    noremap <C-A> gggH<C-O>G
    inoremap <C-A> <C-O>gg<C-O>gH<C-O>G
    cnoremap <C-A> <C-C>gggH<C-O>G
    onoremap <C-A> <C-C>gggH<C-O>G
    snoremap <C-A> <C-C>gggH<C-O>G
    xnoremap <C-A> <C-C>ggVG

    vnoremap <special> <C-x> "+x
    vnoremap <special> <C-c> "+y
    cnoremap <special> <C-c> <C-Y>
    nnoremap <special> <C-v> "+gP
    cnoremap <special> <C-v> <C-R>+
    execute 'vnoremap <script> <special> <C-v>' paste#paste_cmd['v']
    execute 'inoremap <script> <special> <C-v>' paste#paste_cmd['i']

    nnoremap <silent> <special> <C-a> :if &slm != ""<Bar>exe ":norm gggH<C-O>G"<Bar> else<Bar>exe ":norm ggVG"<Bar>endif<CR>
    vmap <special> <C-a> <Esc><C-a>
    imap <special> <C-a> <Esc><C-a>
    cmap <special> <C-a> <C-C><C-a>
    omap <special> <C-a> <Esc><C-a>

    map <M-t> :tabnew<CR>
    map <M-n> :new<CR>
    map <M-S-t> :browse tabe<CR>
    map <M-S-n> :browse split<CR>
    map <M-]> :tabn<CR>
    map <M-[> :tabp<CR>
    imap <M-]> <C-o>:tabn<CR>
    imap <M-[> <C-o>:tabp<CR>

    map <M-1> 1gt
    map <M-2> 2gt
    map <M-3> 3gt
    map <M-4> 4gt
    map <M-5> 5gt
    map <M-6> 6gt
    map <M-7> 7gt
    map <M-8> 8gt
    map <M-9> 9gt
    map <M-0> 10gt

    imap <M-1> <C-o>1gt<CR>
    imap <M-2> <C-o>2gt<CR>
    imap <M-3> <C-o>3gt<CR>
    imap <M-4> <C-o>4gt<CR>
    imap <M-5> <C-o>5gt<CR>
    imap <M-6> <C-o>6gt<CR>
    imap <M-7> <C-o>7gt<CR>
    imap <M-8> <C-o>8gt<CR>
    imap <M-9> <C-o>9gt<CR>
    imap <M-0> <C-o>10gt<CR>
  endif
else
  " terminal
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

  imap 1 1gt
  imap 2 2gt
  imap 3 3gt
  imap 4 4gt
  imap 5 5gt
  imap 6 6gt
  imap 7 7gt
  imap 8 8gt
  imap 9 9gt
  imap 0 10gt

  noremap h <Esc>:tabprev<Cr>
  noremap l <Esc>:tabnext<Cr>
  noremap n <Esc>:tabnew<Cr>
  noremap c <Esc>:tabclose<Cr>
  noremap { <Esc>:tabprev<Cr>
  noremap } <Esc>:tabnext<Cr>
  noremap d <Esc>:tabnew<Cr>
endif

" completion
" inoremap <expr> <CR>  pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
" inoremap <expr> <C-n> pumvisible() ? '<C-n>' : '<C-n><C-r>=pumvisible() ? "\<lt>Down>" : ""<CR>'
" snoremap <expr> <C-p> pumvisible() ? '<C-n>' : '<C-p><C-r>=pumvisible() ? "\<lt>Up>" : ""<CR>'
" inoremap <expr> <M-,> pumvisible() ? '<C-n>' : '<C-x><C-o><C-n><C-p><C-r>=pumvisible() ? "\<lt>Down>" : ""<CR>'
" }}}

" abbreviations {{{
iabbrev mdy <C-r>=strftime("%Y-%m-%d %H:%M:%S")
iabbrev fpritnf fprintf
iabbrev fro for
iabbrev pritnf printf
iabbrev stirng string
iabbrev teh the
" }}}

" settings {{{

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

" python syntax settings {{{
let g:pymode_rope = 0
let g:pymode_lint = 0
let python_highlight_all = 1
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
" let g:SuperTabDefaultCompletionType = '<c-n>'
" }}}

" ctrl-p settings {{{
let g:ctrlp_custom_ignore = {
  \ 'dir':  '\.git$\|\.hg$\|\.svn\|tmp\|target\|test-output\|build\|vendor\|.settings\|storm-local\|logs\|cloudera\|dev-support\|jdiff$',
  \ 'file': '\.exe$\|\.so$\|\.dll$|\.class$|\.jar$',
  \ }
let g:ctrlp_working_path_mode = 0
let g:ctrlp_cache_dir = "$HOME/.vim/tmp"
let g:ctrlp_switch_buffer = 2
let g:ctrlp_reuse_window = 'netrw\|help\|quickfix'
let g:ctrlp_max_files = 0
" }}}

" jedi {{{
let g:jedi#auto_initialization = 0
" }}}

" command-t settings {{{
let g:CommandTMaxFiles=400000
let g:CommandTMaxDepth=25
let g:CommandTMaxCachedDirectories=0
let g:CommandTMaxHeight=20
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

" ultisnips {{{
"let g:UltiSnipsExpandTrigger = "<C-/>"
"let g:UltiSnipsListSnippets = ""
" }}}

" powerline {{{
" let g:Powerline_symbols = 'compatible'
" let g:Powerline_cache_file = $HOME . '/.vim/tmp/Powerline_cache_file'
" let g:Powerline_mode_v = 'v'
" let g:Powerline_mode_V = 'V'
" let g:Powerline_mode_cv = 'cv'
" let g:Powerline_mode_s = 's'
" let g:Powerline_mode_S = 'S'
" let g:Powerline_mode_cs = 'cs'
" let g:Powerline_mode_i = 'i'
" let g:Powerline_mode_R = 'R'
" let g:Powerline_mode_n = 'n'
" let g:Powerline_stl_path_style = 'short'
" call Pl#Theme#InsertSegment('charcode', 'after', 'filetype')
" call Pl#Theme#RemoveSegment('tagbar:currenttag')
" call Pl#Theme#RemoveSegment('rvm:string')
" call Pl#Theme#RemoveSegment('syntastic:errors')
" call Pl#Theme#RemoveSegment('fugitive:branch')
"let g:Powerline_theme = 'adr'
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
let g:clang_snippets = 1
"let g:clang_snippets_engine = 'ultisnips'
let g:clang_debug = 1
if has("macunix")
  "let g:clang_library_path = $HOME . "/work/tools/libclang"
  let g:clang_library_path = "/usr/local/lib/libclang.dylib"
else
  let g:clang_library_path = "/usr/lib/"
endif
" }}}

" ensime / async {{{
let g:async = {'vim' : '$HOME/Applications/MacVim.app/Contents/MacOS/Vim'} 
let g:ensime = {'ensime-script': "/Users/adr/work/vim/scala_vim/MarcWeber-ensime/dist_2.9.2-SNAPSHOT/bin/server"}
" }}}

" simplenote {{{
source $HOME/.secrets/simplenote_credentials.vim
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

" localvimrc {{{
let g:localvimrc_name = ".lvimrc"
let g:localvimrc_ask = 0
" }}}

" eclim {{{
let g:EclimShowCurrentError = 0
let g:EclimMakeLCD = 1
let g:EclimMenus = 0
let g:EclimJavaImportExclude = [ "^com\.sun\..*", "^sun\..*", "^sunw\..*", "^java\.awt\..*" ]
let g:EclimJavaHierarchyDefaultAction = "tabnew"
let g:EclimJavaSearchSingleResult = "tabnew"
let g:EclimDefaultFileOpenAction = "edit"
let g:EclimXmlIndentDisabled = 1
let g:EclimXmlValidate = 0
let g:EclimSignLevel = 2
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

" ack {{{
let g:ackprg="ack -H --nocolor --nogroup --noenv --column"
" }}}

" syntastic {{{
"let g:syntastic_enable_signs = 1
"let g:syntastic_auto_loc_list=0
let g:syntastic_quiet_warnings=1
"let g:syntastic_stl_format = '[%E{Err: %fe #%e #%t}]'
let g:syntastic_disabled_filetypes = ['java']
let g:syntastic_echo_current_error = 0
let g:syntastic_mode_map = { 'mode': 'active',
                           \ 'active_filetypes': [],
                           \ 'passive_filetypes': ['puppet', 'java'] }
" }}}

" javacomplete {{{
" let g:first_nailgun_port=2114
" let g:javacomplete_ng="/Users/adr/dotfiles/bin/binary/ng"
" }}}

" }}}

" commands {{{
command! -bar -nargs=0 W  silent! exec "write !sudo tee % >/dev/null"  | silent! edit!
command! -bar -nargs=0 WX silent! exec "write !chmod a+x % >/dev/null" | silent! edit!

" typos
command! -bang E e<bang>
command! -bang Q q<bang>
command! -bang W w<bang>
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
  autocmd VimEnter * :nnoremap U <c-r>

  " remove all buffers on exit so we don't have them as hidden on reopen
  autocmd VimLeavePre * 1,255bwipeout
  " remove empty or otherwise dead buffers when moving away from them
  autocmd TabLeave    * call OnTabLeave()
  " move to last position on file
  autocmd BufReadPost *
    \ if line("'\"") > 0 && line("'\"") <= line("$") |
    \   exe "normal g`\"" |
    \ endif
  au BufReadPost *
      \ if line("'\"") > 0 && line("'\"") <= line("$") |
      \     execute 'normal! g`"zvzz' |
      \ endif

  au InsertEnter * :set listchars-=trail:⌴
augroup END

" Only show cursorline in the current window and in normal mode.
" augroup cline
"     au!
"     au WinLeave * set nocursorline
"     au WinEnter * set cursorline
"     au InsertEnter * set nocursorline
"     au InsertLeave * set cursorline
" augroup END

" indentations
augroup settings
  au!
  autocmd FileType python setlocal et ts=4 sw=4
  autocmd FileType java setlocal et ts=2 sw=2
  autocmd FileType ruby,haml,eruby,yaml,html,sass set ai sw=2 sts=2 et
  autocmd FileType javascript setlocal ai sw=4 ts=4 sts=4 et
  autocmd FileType c set ts=4 sw=4
  autocmd FileType text,markdown,mkd,pandoc,mail setlocal textwidth=80
  autocmd FileType puppet setlocal sw=2 ts=2 expandtab
  autocmd BufRead *.mkd  setlocal ai formatoptions=tcroqn2 comments=n:&gt;
  autocmd BufRead *.markdown  setlocal ai formatoptions=tcroqn2 comments=n:&gt;
  autocmd FileType qf setlocal colorcolumn=0 nolist nocursorline nowrap
augroup END

" completions
augroup completions
  au!
  autocmd FileType html setlocal omnifunc=htmlcomplete#CompleteTags
  autocmd FileType css setlocal omnifunc=csscomplete#CompleteCSS
  " autocmd FileType java setlocal omnifunc=javacomplete#Complete
  autocmd FileType ruby,eruby set omnifunc=rubycomplete#Complete
augroup END

augroup iskeywords
  au!
  autocmd FileType actionscript setlocal iskeyword-=:
augroup end

augroup comments
  autocmd FileType actionscript setlocal commentstring=//\ %s
augroup end

augroup mappings
  au!
  au FileType markdown nnoremap <buffer> <localleader>1 yypVr=
  au FileType markdown nnoremap <buffer> <localleader>2 yypVr-
  au FileType markdown nnoremap <buffer> <localleader>3 I### <ESC>
  autocmd FileType java map <leader>b :JavaSearchContext<CR>
  autocmd FileType java map <leader>1 :JavaCorrect<CR>
  autocmd FileType java map <leader>s :JavaImportOrganize<CR>
  autocmd FileType java map <leader>jh :JavaHierarchy<CR>
  autocmd FileType clojure let g:SuperTabDefaultCompletionType = "<c-x><c-o>"
  autocmd FileType java let g:SuperTabDefaultCompletionType = "<c-x><c-u>"
augroup END

" }}}

" hosts {{{
let hostfile=$HOME . '.vim/hosts/' . hostname() . ".vim"
if filereadable(hostfile)
    exe 'source ' . hostfile
endif
" }}}

