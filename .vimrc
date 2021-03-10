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

if has("nvim")
  if has("mac")
    let g:os_bin_path = "darwin"
    let g:python2_host_prog = '/usr/local/bin/python'
    let g:python3_host_prog = '/usr/local/opt/python/bin/python3'
    let g:ruby_host_prog = 'rvm ruby-2.6.3 do neovim-ruby-host'
    let g:node_host_prog = $HOME . '/.nvm/versions/node/v10.19.0/lib/node_modules/neovim/bin/cli.js'
  elseif has("wsl")
    let g:os_bin_path = "linux"
    let g:python2_host_prog = '/usr/local/bin/python'
    let g:python3_host_prog = '/usr/local/opt/python/bin/python3'
    let g:ruby_host_prog = 'rvm ruby-3.0.0 do neovim-ruby-host'
    let g:node_host_prog = '/home/linuxbrew/.linuxbrew/lib/node_modules/neovim/bin/cli.js'
  elseif has("win64")
    let g:os_bin_path = "windows"
    let g:python2_host_prog = '/usr/local/bin/python'
    let g:python3_host_prog = 'c:\Python39\python3.exe'
    let g:ruby_host_prog = 'c:\tools\ruby30\ruby.exe'
    let g:node_host_prog = 'c:\Program\ Files\node\node.exe'
  endif
endif

" settings {{{
if &term =~ '^screen'
  "tmux will send xterm-style keys when its xterm-keys option is on
  execute "set <xUp>=\e[1;*A"
  execute "set <xDown>=\e[1;*B"
  execute "set <xRight>=\e[1;*C"
  execute "set <xLeft>=\e[1;*D"
endif

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
"set relativenumber
set whichwrap=<,>,h,l,b,s,~,[,]
set shortmess=aTIc             " supress some file messages
set sidescrolloff=4           " minchars to show around cursor
set display+=lastline
set autoread                  " read outside modified files
set autowrite
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
if has("nvim")
  set guicursor=
endif
set synmaxcol=600
set foldlevelstart=99
" visual cues
set ignorecase                " ignore case when searching
set smartcase                 " ignore case when searching
set hlsearch                  " highlight last search
set incsearch                 " show matches while searching
set gdefault
set nojoinspaces
set laststatus=2              " always show status line

set breakindent
set breakindentopt=sbr
set showbreak=…
set fillchars=diff:⣿,vert:\|
set noshowcmd                   " show number of selected chars/lines in status
set showmatch
set statusline=%<%f\ (%{&ft},%{&ff})\ (%{&ts},%{&sts},%{&sw},%{&et?'et':'noet'})\ %-4(%m%)%=%-19(%3l,%02c%03V,%o\|%B%)
set undolevels=10000
set numberwidth=5
set pumheight=0
if !has('nvim')
  if has('windows')
    set viminfo=h,'10000,\"1000,n$HOME/.vim/tmp/.viminfo
  else
    set viminfo=h,'10000,\"1000,n$HOME/.vim/tmp/.viminfo
  endif
endif
set scrolljump=10
set virtualedit+=block
set novisualbell
set noerrorbells
set nostartofline
set tildeop
set vb t_vb=
set t_ut=
set winaltkeys=no
set writeany
set iskeyword=@,-,>,48-57,128-167,224-235,_
set iskeyword-=.
set inccommand=nosplit
set showtabline=0
set matchtime=3
set complete=.,w,b,u,t,i,d	" completion by Ctrl-N
set completeopt=menu,noinsert,noselect,menuone "sjl: set completeopt=longest,menuone,preview
if !has('nvim')
  set ttyfast
endif
if !has('nvim')
  set ttymouse=xterm
endif
set timeout
set ttimeout
set timeoutlen=1000
set ttimeoutlen=0
if !has('nvim')
  set guipty
endif
if has("mac")
  set clipboard=unnamed "unnamed ",unnamedplus,autoselect
else 
  set clipboard=unnamedplus
endif
set undofile
set undoreload=10000
" settings: windows and buffers
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
if executable("rg")
  set grepprg=rg\ --no-ignore\ -H\ --no-heading\ --color\ never
endif
set grepformat=%f:%l:%m
" settings: tabs and indentin
set nofoldenable
set smartindent
set autoindent
set lazyredraw
" don't delete past the end of line
set selection=old
set copyindent
set preserveindent
set expandtab
set tabstop=2
set shiftwidth=2
set softtabstop=2
set cmdheight=2
let g:did_install_default_menus = 1
set mouse=a
set backspace=indent,eol,start
" }}}

" wildmenu settings {{{
set wildmenu
"set wildmode=list:longest,full
set wildmode=longest,list
set wildignore+=.svn,CVS,*/.git/*,.hg
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

set suffixes+=.lo,.o,.moc,.la,.closure,.loT
set suffixes+=.bak,~,.o,.h,.info,.swp,.obj
set suffixes+=class,.6

let g:sh_noisk=1
let g:is_bash=1
" }}}

" disabled plugins {{{
" manpageview {{{
let g:loaded_manpageview = 1
let g:loaded_manpageviewPlugin = 1
" }}}
let g:loaded_getscriptPlugin = 1
let g:loaded_getscript = 1
let g:loaded_logiPat = 1
let g:loaded_sql_completion = 1
let g:loaded_sql_completion=1
let g:loaded_gzip=1
let g:loaded_vimballPlugin=1
let g:loaded_netrwPlugin = 1
let g:loaded_rrhelper=1
let g:loaded_zipPlugin=1
let g:loaded_tarPlugin=1
let g:loaded_2html_plugin=1
" }}}

" vim-plug
let g:plug_url_format='https://github.com/%s.git'
"source $HOME/.vim/autoload/plug.vim

let g:plug_path = stdpath('data') . '/bundle'
call plug#begin(g:plug_path)
" languages
Plug 'fatih/vim-go', { 'dir': stdpath('data') . '/bundle/vim-go', 'for': 'go' }
if has('nvim')
  Plug 'jodosha/vim-godebug', { 'dir': stdpath('data') . '/bundle/vim-godebug', 'for': 'go' }
end
"Plug 'othree/html5.vim', { 'dir': stdpath('data') . '/bundle/html5', 'for': 'html' }
Plug 'pangloss/vim-javascript', { 'dir': stdpath('data') . '/bundle/javascript', 'for': 'javascript' }
Plug 'gabrielelana/vim-markdown', { 'dir': stdpath('data') . '/bundle/markdown', 'for': ['md', 'markdown']}
Plug 'rust-lang/rust.vim', { 'dir': stdpath('data') . '/bundle/rust', 'for': 'rust' }
Plug 'sirtaj/vim-openscad', { 'dir': stdpath('data') . '/bundle/openscad' }
Plug 'python-mode/python-mode', { 'branch': 'develop', 'dir': stdpath('data') . '/bundle/python-mode', 'for': 'python' }
Plug 'pearofducks/ansible-vim', { 'dir': stdpath('data') . '/bundle/ansible-vim' }
Plug 'vim-ruby/vim-ruby', { 'dir': stdpath('data') . '/bundle/vim-ruby', 'for': 'ruby' }
Plug 'stephpy/vim-yaml', { 'dir': stdpath('data') . '/bundle/vim-yaml', 'for': 'yaml' }
Plug 'rhysd/vim-clang-format', { 'dir': stdpath('data') . '/bundle/vim-clang-format' }
"Plug 'Glench/Vim-Jinja2-Syntax', { 'dir': stdpath('data') . '/bundle/vim-jinja2-syntax' }
Plug 'neovimhaskell/haskell-vim', { 'dir': stdpath('data') . '/bundle/haskell-vim', 'for': 'haskell' }
Plug 'elmcast/elm-vim', { 'dir': stdpath('data') . '/bundle/elm-vim', 'for': 'elm' }
Plug 'jdonaldson/vaxe', { 'dir': stdpath('data') . '/bundle/vaxe' }
Plug 'jansedivy/jai.vim', {'dir': stdpath('data') . '/bundle/jai' }
Plug 'hashivim/vim-terraform', {'dir': stdpath('data') . '/bundle/vim-terraform'}
Plug 'leafgarland/typescript-vim', {'dir': stdpath('data') . '/bundle/typescript-vim' }
Plug 'ziglang/zig.vim'
Plug 'fedorenchik/fasm.vim'
Plug 'google/vim-jsonnet', {'dir': stdpath('data') . '/bundle/jsonnet', 'for': 'jsonnet' }
Plug 'edwinb/idris2-vim' 
"Plug 'google/ijaas', {'dir': stdpath('data') . '/bundle/ijaas', 'rtp': 'vim' }

" completion
Plug 'neovim/nvim-lspconfig'
Plug 'nvim-lua/lsp-status.nvim'
Plug 'nvim-lua/completion-nvim'
Plug 'scalameta/nvim-metals', {'branch': 'main'}
Plug 'nvim-lua/lsp_extensions.nvim'

" tools
Plug 'tpope/vim-fugitive', { 'dir': stdpath('data') . '/bundle/fugitive' }
Plug 'rking/ag.vim', { 'dir': stdpath('data') . '/bundle/ag'}
Plug 'vim-scripts/a.vim', { 'dir': stdpath('data') . '/bundle/a', 'do': 'patch -p1 < ~/.vim/patches/a.patch' }

" vim
Plug 'vim-scripts/DetectIndent', { 'dir': stdpath('data') . '/bundle/detectindent' }
Plug 't9md/vim-choosewin', { 'dir': stdpath('data') . '/bundle/vim-choosewin' }
Plug 'tmux-plugins/vim-tmux-focus-events', { 'dir': stdpath('data') . '/bundle/vim-tmux-focus-events' }

Plug 'tpope/vim-commentary', { 'dir': stdpath('data') . '/bundle/commentary' }
Plug 'tpope/vim-dispatch', { 'dir': stdpath('data') . '/bundle/dispatch' }
Plug 'tpope/vim-endwise', { 'dir': stdpath('data') . '/bundle/endwise' }
Plug 'tpope/vim-obsession', { 'dir': stdpath('data') . '/bundle/obsession' }
Plug 'tpope/vim-repeat', { 'dir': stdpath('data') . '/bundle/repeat' }
Plug 'tpope/vim-surround', { 'dir': stdpath('data') . '/bundle/surround' }

Plug 'isa/vim-matchit', { 'dir': stdpath('data') . '/bundle/matchit' }
Plug 'mtth/scratch.vim', { 'dir': stdpath('data') . '/bundle/scratch' }
Plug 'ervandew/supertab', { 'dir': stdpath('data') . '/bundle/supertab' }
Plug 'godlygeek/tabular', { 'dir': stdpath('data') . '/bundle/tabular' }
Plug 'Shougo/vimproc', { 'dir': stdpath('data') . '/bundle/vimproc', 'do': 'make' }

Plug 'kana/vim-textobj-user', { 'dir': stdpath('data') . '/bundle/textobj-user' }
Plug 'kana/vim-textobj-function', {'dir': stdpath('data') . '/bundle/vim-textobj-function' }
Plug 'Julian/vim-textobj-brace', {'dir': stdpath('data') . '/bundle/vim-textobj-brace' }
Plug 'glts/vim-textobj-comment', {'dir': stdpath('data') . '/bundle/vim-textobj-comment' }
Plug 'beloglazov/vim-textobj-quotes', {'dir': stdpath('data') . '/bundle/vim-textobj-quotes' }
Plug 'rhysd/clever-f.vim'

Plug 'rbgrouleff/bclose.vim', {'dir': stdpath('data') . '/bundle/bclose' }
Plug 'jmcantrell/vim-virtualenv', {'dir': stdpath('data') . '/bundle/vim-virtualenv', 'for': 'python' }

Plug 'nvim-lua/popup.nvim'
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-lua/telescope.nvim'
Plug 'nvim-telescope/telescope.nvim'
Plug 'nvim-telescope/telescope-fzy-native.nvim'
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
call plug#end()
" }}}

" mapleader {{{
let mapleader = ","
let maplocalleader = ","
" }}}

" look & feel {{{
set t_Co=256
set background=dark
colorscheme monochrome
" }}}

" syntax highlighting {{{
syntax enable
syntax on
filetype on
filetype indent on
filetype plugin on
" highlight fixes
highlight WHITE_ON_BLACK ctermfg=white
hi NonText cterm=NONE ctermfg=NONE
"hi SignColor guibg=red
hi clear SpellBad                                                
hi SpellBad cterm=underline                                      
hi clear SpellRare                                               
hi SpellRare cterm=underline                                     
hi clear SpellCap                                                
hi SpellCap cterm=underline                                      
hi clear SpellLocal
hi SpellLocal cterm=underline
autocmd BufEnter * :syntax sync fromstart
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

function! UselessBuffer(...)
  let l:bufname = a:0 == 1 ? a:1 : '%'

  if (getbufvar(l:bufname, '&mod') == 0 && index(['', '[No Name]', '[No File]'], bufname(l:bufname)) >= 0)
    return 1
  end
  return 0
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

function! ToggleSideEffects()
    if mapcheck("dd", "n") == ""
        noremap dd "_dd
        noremap D "_D
        noremap d "_d
        noremap X "_X
        noremap x "_x
        vnoremap p "_dP
        echo 'side effects off'
    else
        unmap dd
        unmap D
        unmap d
        unmap X
        unmap x
        vunmap p
        echo 'side effects on'
    endif
endfunction
nnoremap ,, :call ToggleSideEffects()<CR>

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

function! SaveMap(key)
  return maparg(a:key, 'n', 0, 1)
endfunction

function! RestoreMap(map)
  if !empty(a:map)
    let l:tmp = ""
    let l:tmp .= a:map.noremap ? 'nnoremap' : 'nmap'
    let l:tmp .= join(map(['buffer', 'expr', 'nowait', 'silent'], 'a:map[v:val] ? "<" . v:val . ">": ""'))
    let l:tmp .= a:map.lhs . ' '
    let l:tmp .= substitute(a:map.rhs, '<SID>', '<SNR>' . a:map.sid . '_', 'g')
    execute l:tmp
  endif
endfunction

function! FzyCommand(choice_command, vim_command) abort
  let l:callback = {
              \ 'window_id': win_getid(),
              \ 'filename': tempname(),
              \  'vim_command':  a:vim_command
              \ }

  function! l:callback.on_exit(job_id, data, event) abort
    bdelete!
    call win_gotoid(self.window_id)
    if filereadable(self.filename)
      try
        let l:selected_filename = readfile(self.filename)[0]
        exec self.vim_command . l:selected_filename
      catch /E684/
      endtry
    endif
    call delete(self.filename)
  endfunction

  botright 10 new
  let l:term_command = a:choice_command . ' | fzy > ' .  l:callback.filename
  silent call termopen(l:term_command, l:callback)
  setlocal nonumber norelativenumber
  startinsert
endfunction

nnoremap <leader>e :call FzyCommand('rg . --files --color=never --glob ""', ":e ")<cr>

function! SynStack ()
    for i1 in synstack(line("."), col("."))
        let i2 = synIDtrans(i1)
        let n1 = synIDattr(i1, "name")
        let n2 = synIDattr(i2, "name")
        echo n1 "->" n2
    endfor
endfunction
map gm :call SynStack()<CR>
" }}}

" key mappings {{{
let g:save_cr_map = {}

" home and end
if $TERM =~ '^screen-256color'
  set t_Co=256
  noremap <C-a> <Home>
  noremap <C-e> <End>
  " nmap <Esc>OH <Home>
  " imap <Esc>OH <Home>
  " cmap <esc>OH <Home>
  " nmap <Esc>OF <End>
  " imap <Esc>OF <End>
  " cmap <Esc>OF <End>
endif

" System clipboard interaction.
map <leader>y "*y

" Don't move the cursor
vnoremap y myy`y
vnoremap Y myY`y

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

nnoremap K <nop>
" remap: mistake, move visual
vnoremap J j
vnoremap K k
" remap: mistake, hit u
vnoremap u <nop>
nnoremap <Del> "_x

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
inoremap <c-c> <Esc>

" emacs bindings, like the shell
cnoremap <c-a> <home>
cnoremap <c-e> <end>
cnoremap <expr> %% expand('%:h').'/'

" DELETE 
nnoremap + <nop>
nnoremap r <nop>
nnoremap R <nop>
nnoremap L <nop>
nnoremap M <nop>
nnoremap \| <nop>
nnoremap ( <nop>
nnoremap ) <nop>
nnoremap [ <nop>
nnoremap ] <nop>
nnoremap { <nop>
nnoremap } <nop>
nnoremap ]] <nop>
nnoremap [[ <nop>
nnoremap [] <nop>
nnoremap ][ <nop>

" ag word
nnoremap <silent> <leader>/ :Ag<cr>
vnoremap <silent> <leader>/ :AgVisual<cr>

" command:  clean whitespace
nnoremap <leader>w :%s/\s\+$//<cr>:let @/=''<cr>

" GRB: clear the search buffer when hitting return
nnoremap <cr> :nohlsearch<cr>

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

" vaporize delete without overwriting the default register
" nnoremap vd "_d
" xnoremap x  "_d
" nnoremap vD "_D
" noremap c "_c
" noremap cc "_cc
" noremap C "_C
vnoremap p "_dP

inoremap <C-u> <esc>mzgUiw`za

vnoremap * :<C-u>call <SID>VSetSearch()<CR>//<CR><c-o>
vnoremap # :<C-u>call <SID>VSetSearch()<CR>??<CR><c-o>

nnoremap <silent> Q <nop>

" quicker window switching
nnoremap <C-h> <c-w>h
nnoremap <C-j> <c-w>j
nnoremap <C-k> <c-w>k
nnoremap <C-l> <c-w>l

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

" terminal
map <leader>r :w\|:silent !reload-chrome<cr>

nmap -  <Plug>(choosewin)

nnoremap <leader>cf :let @*=expand("%:p")<CR>

" disable mistakes
noremap <f1> <nop>
inoremap <f1> <nop>
inoremap <f2> <nop>
inoremap <f3> <nop>
inoremap <f4> <nop>
inoremap <f5> <nop>
inoremap <f6> <nop>
inoremap <f7> <nop>
inoremap <f8> <nop>
inoremap <f9> <nop>
inoremap <f10> <nop>
inoremap <f11> <nop>
inoremap <f12> <nop>
inoremap <S-f1> <S-nop>
inoremap <S-f2> <S-nop>
inoremap <S-f3> <S-nop>
inoremap <S-f4> <S-nop>
inoremap <S-f5> <S-nop>
inoremap <S-f6> <S-nop>
inoremap <S-f7> <S-nop>
inoremap <S-f8> <S-nop>
inoremap <S-f9> <S-nop>
inoremap <S-f10> <S-nop>
inoremap <S-f11> <S-nop>
inoremap <S-f12> <S-nop>
" }}}


nnoremap <silent> gd          <cmd>lua vim.lsp.buf.definition()<CR>
nnoremap <Leader>T            :lua require'lsp_extensions'.inlay_hints()<cr>
nnoremap <silent> K           <cmd>lua vim.lsp.buf.signature_help()<CR>
nnoremap <silent> gi          <cmd>lua vim.lsp.buf.implementation()<CR>
"nnoremap <silent> gr          <cmd>lua vim.lsp.buf.references()<CR>
nnoremap <silent> gr          <cmd>lua require'telescope.builtin'.lsp_references{}<CR> 
" <cmd>lua require'telescope.builtin'.lsp_workspace_symbols{}<CR> 
" <cmd>lua require'telescope.builtin'.lsp_document_symbols{}<CR> 
"nnoremap <silent> gsd         <cmd>lua vim.lsp.buf.document_symbol()<CR>
nnoremap <silent> gsd         <cmd>lua require'telescope.builtin'.lsp_document_symbols{}<CR>  
nnoremap <silent> gsw         <cmd>lua vim.lsp.buf.workspace_symbol()<CR>
nnoremap <silent> <leader>rn  <cmd>lua vim.lsp.buf.rename()<CR>
nnoremap <silent> <leader>f   <cmd>lua vim.lsp.buf.formatting()<CR>
nnoremap <silent> <leader>ca  <cmd>lua vim.lsp.buf.code_action()<CR>
nnoremap <silent> [c          :NextDiagnostic<CR>
nnoremap <silent> ]c          :PrevDiagnostic<CR>
nnoremap <silent> <space>d    :OpenDiagnostic<CR>

lua << EOF
  local lspconfig = require'lspconfig'
  local configs = require'lspconfig/configs'
  local util = require'lspconfig/util'
  local metals   = require'metals'
  local setup    = require'metals.setup' 
  local M = {}

  M.on_attach = function()
    require'completion'.on_attach();
    setup.auto_commands()
  end

  lspconfig.zls.setup{
    on_attach = M.on_attach;
  }

  lspconfig.gopls.setup{
    on_attach = M.on_attach;
    root_dir = util.root_pattern("go.mod");
  }
  lspconfig.rust_analyzer.setup{
    on_attach = M.on_attach;
  }
  lspconfig.ccls.setup{
    on_attach = M.on_attach;
    cmd = {"ccls"};
    settings = {
      ccls = {
        clang = {
          extraArgs = {
              "-isystem/usr/local/include", 
              "-isystem/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/../include/c++/v1", 
              "-isystem/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/lib/clang/11.0.3/include", 
              "-isystem/Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX.sdk/usr/include", 
              "-isystem/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/include", 
              "-isystem/Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX.sdk/System/Library/Frameworks}", 
          }, 
          resourceDir = "/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/lib/clang/11.0.3"
        }
      }
    };
  }
  --lspconfig.clangd.setup{
  --  cmd = {"/usr/local/opt/llvm/bin/clangd", "--index-background"}
  --}
  lspconfig.intelephense.setup{
    on_attach = M.on_attach;
  }
  lspconfig.pyls_ms.setup{
    on_attach = M.on_attach;
    cmd = { "dotnet", "exec", vim.fn.stdpath('data') .. "/lspconfig/pyls_ms/Microsoft.Python.languageServer.dll" };
  }
  lspconfig.jdtls.setup{
    on_attach = M.on_attach;
    root_dir = util.root_pattern("pom.xml", "build.xml");
  }
  lspconfig.tsserver.setup{
    on_attach = M.on_attach;
  }
  lspconfig.sumneko_lua.setup{
    cmd = { vim.fn.stdpath('data') .. "/lspconfig/sumneko_lua/lua-language-server/bin/macOS/lua-language-server", "-E", vim.env.HOME .. "/.cache/nvim/lspconfig/sumneko_lua/lua-language-server/main.lua" };
    on_attach = M.on_attach;
  }
   lspconfig.solargraph.setup{
    on_attach = M.on_attach;
  }
  lspconfig.terraformls.setup{
    on_attach = M.on_attach;
  }
  lspconfig.metals.setup{
    on_attach    = M.on_attach;
    root_dir     = util.root_pattern("pom.xml", "build.sbt", "build.sc", ".git");
    init_options = {
      statusBarProvider            = "on";
      inputBoxProvider             = true;
      quickPickProvider            = true;
      executeClientCommandProvider = true;
      didFocusProvider             = true;
      decorationProvider           = true;
    };

    on_init = setup.on_init;

    handlers = {
      ["textDocument/hover"]          = metals['textDocument/hover'];
      ["metals/status"]               = metals['metals/status'];
      ["metals/inputBox"]             = metals['metals/inputBox'];
      ["metals/quickPick"]            = metals['metals/quickPick'];
      ["metals/executeClientCommand"] = metals["metals/executeClientCommand"];
      ["metals/publishDecorations"]   = metals["metals/publishDecorations"];
      ["metals/didFocusTextDocument"] = metals["metals/didFocusTextDocument"];
    };
  }

  lspconfig.ocamllsp.setup{
    on_attach    = M.on_attach;
    root_dir = util.root_pattern(".merlin");
  }

  lspconfig.hls.setup{
    on_attach    = M.on_attach;
  }

  lspconfig.elmls.setup{
    on_attach    = M.on_attach;
  }
  lspconfig.html.setup{
    on_attach    = M.on_attach;
  }
  lspconfig.yamlls.setup{
    on_attach    = M.on_attach;
  }
EOF

" abbreviations {{{
" }}}

" telescope {{{
lua << EOF
  require('telescope').setup{
    extensions = {
      fzy_native = {
        override_generic_sorter = true,
        override_file_sorter = true,
      }
    }, 
    defaults = {
      vimgrep_arguments = {
        'rg',
        '--color=never',
        '--no-heading',
        '--with-filename',
        '--line-number',
        '--column',
        '--smart-case'
      },
      prompt_position = "bottom",
      prompt_prefix = ">",
      selection_strategy = "reset",
      sorting_strategy = "descending",
      layout_strategy = "horizontal",
      layout_defaults = {
        -- TODO add builtin options.
      },
      --file_sorter =  require'telescope.sorters'.get_fuzzy_file,
      file_ignore_patterns = {},
      --generic_sorter =  require'telescope.sorters'.get_generic_fuzzy_sorter,
      shorten_path = true,
      winblend = 0,
      width = 0.75,
      preview_cutoff = 120,
      results_height = 1,
      results_width = 0.8,
      border = {},
      borderchars = { '─', '│', '─', '│', '╭', '╮', '╯', '╰'},
      color_devicons = false,
      use_less = true,
      set_env = { ['COLORTERM'] = 'truecolor' }, -- default { }, currently unsupported for shells like cmd.exe / powershell.exe
      --file_previewer = require'telescope.previewers'.vim_buffer_cat.new, -- For buffer previewer use `require'telescope.previewers'.vim_buffer_cat.new`
      --grep_previewer = require'telescope.previewers'.vimgrep.new, -- For buffer previewer use `require'telescope.previewers'.vim_buffer_vimgrep.new`
      --qflist_previewer = require'telescope.previewers'.qflist.new, -- For buffer previewer use `require'telescope.previewers'.vim_buffer_qflist.new`
      file_previewer = require'telescope.previewers'.vim_buffer_cat.new, -- For buffer previewer use `require'telescope.previewers'.vim_buffer_cat.new`
      grep_previewer = require'telescope.previewers'.vim_buffer_vimgrep.new, -- For buffer previewer use `require'telescope.previewers'.vim_buffer_vimgrep.new`
      qflist_previewer = require'telescope.previewers'.vim_buffer_qflist.new, -- For buffer previewer use `require'telescope.previewers'.vim_buffer_qflist.new`
    }
  }
  require('telescope').load_extension('fzy_native')
EOF

nmap <C-p> <cmd>lua require('telescope.builtin').find_files()<cr> 
nmap <leader>g <cmd>lua require('telescope.builtin').live_grep()<cr> 
nmap <leader>5 <cmd>lua require('telescope.builtin').buffers()<cr> 
nmap <leader>6 <cmd>lua require('telescope.builtin').find_files({cwd= $HOME . '/Dropbox/personal/notes/'})<cr> 
nmap <F12> <cmd>lua require('telescope.builtin.lsp').document_symbols()<cr>
nmap <leader>7 <cmd>lua require('telescope.builtin.lsp').workspace_symbols()<cr> 
" }}}

" treesitter {
lua <<EOF
  require'nvim-treesitter.configs'.setup {
    highlight = {
      enable = true, -- false will disable the whole extension
      disable = {},  -- list of language that will be disabled
    },
    incremental_selection = {
      enable = true, 
      keymaps = {
        init_selection = "gnn",
        node_incremental = "grn",
        scope_incremental = "grc",
        node_decremental = "grm"
      }
    }
  }
EOF
" }}}

" lsp_extensions {{{
lua <<EOF
require'lsp_extensions'.setup{
	highlight = "Comment",
	prefix = " > ",
	aligned = false,
	only_current_line = false, 
	enabled = { "TypeHint", "ParameterHint", "ChainingHint" }
}
EOF
" }}}

" tadaa {{{
let g:vimade = {}
let g:vimade.fadelevel = 0.4
let g:vimade.enablesigns = 1
" }}}


" completion-nvim {{{
let g:completion_enable_auto_popup = 1
let g:completion_enable_auto_hover = 1
let g:completion_enable_auto_signature = 1
let g:completion_enable_auto_paren = 1
" }}}

" ag plugin settings {{{
let g:ag_prg = "rg --vimgrep -L 2>/dev/null"
" }}}

" match paren settings {{{
let g:loaded_matchparen = 1
let g:matchparen_timeout = 10
let g:matchparen_insert_timeout = 10
" }}}


" jsonnet settings {{{
let g:jsonnet_fmt_on_save = 0
let g:jsonnet_fmt_options = '-n 2 --max-blank-lines 0 --no-pad-arrays --no-pad-objects'
" }}}

" markdown {{{
let g:markdown_enable_spell_checking = 0
" }}}

" python syntax settings {{{
let g:pymode_syntax = 0
let g:pymode_folding = 0
let g:pymode_indent = 0
let g:pymode_warning = 0
let g:pymode_motion = 0
let g:pymode_syntax_all = 1
let g:pymode_syntax_indent_errors = g:pymode_syntax_all
let g:pymode_rope = 0
let g:pymode_rope_enable_autoimport = 0
let g:pymode_rope_auto_project = 0
let g:pymode_rope_lookup_project = 0
let g:pymode_lint = 0
let python_highlight_all = 0
let g:pymode_rope_guess_project = 0
let g:pymode_rope_vim_completion = 0
let g:pymode_doc_bind = ''
let g:pymode_rope_goto_definition_bind = "<C-]>"
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

" }}}


" go settings {{{
let g:godef_split = 0
let g:go_play_open_browser = 0
let g:go_fmt_fail_silently = 0
let g:go_fmt_autosave = 1
let g:go_disable_autoinstall = 1
let g:go_doc_keywordprg_enabled = 0
let g:go_def_mode = 'gopls'
let g:go_def_mapping_enabled = 0
let g:go_bin_path = expand("~/.gocode/bin")
let g:go_diagnostics_enabled = 0
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

" clang format {{{
let g:clang_format#command = "/usr/local/bin/clang-format-3.6"
let g:clang_format#detect_style_file = 1
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


" textobj-user {{{
call textobj#user#plugin('chunk', {
  \ '-' : {
  \      'select-a' : 'ab', '*select-a-function*' : 'textobj#chunk#select_a',
  \      'select-i' : 'ib', '*select-i-function*' : 'textobj#chunk#select_i',
  \   },
  \ })
" }}}

" netrw {{{
let g:netrw_browsex_viewer="open"
" }}}

" gist {{{
let g:gist_clip_command = 'pbcopy'
let g:gist_open_browser_after_post = 1
" }}}

let g:vim_json_syntax_conceal = 0

" echodoc {{{
let g:echodoc#enable_at_startup = 1
let g:echodoc#type = 'signature'"
" }}}

let g:terraform_align = 1
let g:terraform_fmt_on_save = 1

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

autocmd FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o

hi default hi_MarkInsertStop ctermbg=137 cterm=undercurl,bold
hi default hi_MarkChange ctermbg=160 cterm=undercurl,bold
hi default hi_MarkBeforeJump ctermbg=184 cterm=undercurl,bold

lua <<EOF
local jump_ns = vim.api.nvim_create_namespace("jump_ns")
local change_ns = vim.api.nvim_create_namespace("change_ns")
local insert_ns = vim.api.nvim_create_namespace("insert_ns")

function mark_on_move()
  vim.api.nvim_buf_clear_namespace(bufnr, jump_ns, 0, -1)
  local pos = vim.api.nvim_buf_get_mark(bufnr, '`')
  local pos1 = {pos[1] - 1, pos[2]}
  local pos2 = {pos[1] - 1, pos[2]}
  local lines = vim.api.nvim_buf_get_lines(bufnr, pos1[1], pos2[1]+1, true)
  local length = lines[1]:len()
  if pos1[2] == length then
    pos1[2] = pos1[2] - 1
  end
  vim.highlight.range(bufnr, jump_ns, "hi_MarkBeforeJump", pos1, pos2, "c", true)
end

function mark_on_change_or_insert()
  local bufnr = vim.api.nvim_get_current_buf()

  vim.api.nvim_buf_clear_namespace(bufnr, change_ns, 0, -1)
  local pos = vim.api.nvim_buf_get_mark(bufnr, '.')
  local pos1 = {pos[1] - 1, pos[2]}
  local pos2 = {pos[1] - 1, pos[2]}
  local lines = vim.api.nvim_buf_get_lines(bufnr, pos1[1], pos2[1]+1, true)
  local length = lines[1]:len()
  if pos1[2] == length then
    pos1[2] = pos1[2] - 1
  end
  vim.highlight.range(bufnr, change_ns, "hi_MarkChange", pos1, pos2, "c", true)

  vim.api.nvim_buf_clear_namespace(bufnr, insert_ns, 0, -1)
  local pos = vim.api.nvim_buf_get_mark(bufnr, '^')
  local pos1 = {pos[1] - 1, pos[2]}
  local pos2 = {pos[1] - 1, pos[2]}
  local lines = vim.api.nvim_buf_get_lines(bufnr, pos1[1], pos2[1]+1, true)
  local length = lines[1]:len()
  if pos1[2] == length then
    pos1[2] = pos1[2] - 1
  end
  vim.highlight.range(bufnr, insert_ns, "hi_MarkInsertStop", pos1, pos2, "c", true)
end

EOF

augroup marks
  autocmd!
  "autocmd TextYankPost * silent! lua vim.highlight.on_yank {higroup="IncSearch", timeout=-1}
  autocmd CursorMoved * silent! lua mark_on_move()
  autocmd BufModifiedSet,TextChangedP,TextChangedI,InsertLeave * silent! lua mark_on_change_or_insert()
augroup END

" auto commands {{{
augroup all_buffers
  au!

  autocmd BufNewFile,BufRead *.ino set filetype=cpp
  autocmd BufNewFile,BufRead *.pde set filetype=cpp
  " remove all buffers on exit so we don't have them as hidden on reopen
  autocmd VimLeavePre * execute 'silent! 1,' . bufnr('$') . 'bwipeout!'

  " move to last position on file
  autocmd BufReadPost *
    \ if line("'\"") > 0 && line("'\"") <= line("$") |
    \   exe "normal g`\"" |
    \ endif
  autocmd BufReadPost *
      \ if line("'\"") > 0 && line("'\"") <= line("$") |
      \     execute 'normal! g`"zvzz' |
      \ endif

  autocmd! CmdwinEnter * 
    \ let g:save_cr_map = SaveMap('<cr>') |
    \ execute ':silent! :unmap <cr>'
  autocmd! CmdwinLeave *
    \ execute ':call RestoreMap(g:save_cr_map)'
  autocmd! WinEnter,BufWinEnter *
    \ if &ft == "qf" |
    \     let g:save_cr_map = SaveMap('<cr>') |
    \     execute ':silent! unmap <cr>' |
    \ else |
    \     execute ':silent! call RestoreMap(g:save_cr_map)' |
    \ endif
  autocmd! WinLeave * 
    \ if &ft == "qf" |
    \     execute ':call RestoreMap(g:save_cr_map)' |
    \ endif
augroup END

" indentations
augroup settings
  au!
  autocmd FileType python setlocal et ts=4 sw=4 tw=120
  autocmd FileType java setlocal et ts=2 sw=2
  autocmd FileType ruby,haml,eruby,yaml,html,sass set ai sw=2 sts=2 et
  autocmd FileType javascript setlocal ai sw=4 ts=4 sts=4 et
  autocmd FileType c set ts=4 sw=4 sts=4 commentstring=//\ %s
  autocmd FileType cpp set ts=4 sw=4 sts=4 commentstring=//\ %s
  "autocmd FileType fasm set ts=4 sts=4 sw=4 commentstring=; %s
  autocmd FileType openscad set ts=4 sw=4 sts=4 commentstring=//\ %s
  autocmd FileType css set expandtab ts=4 sw=4 sts=4
  autocmd FileType scss set expandtab ts=4 sw=4 sts=4
  autocmd FileType text,markdown,mkd,pandoc,mail setlocal textwidth=1000
  autocmd BufRead *.mkd  setlocal ai formatoptions=tcroqn2 comments=n:&gt;
  autocmd BufRead *.markdown  setlocal ai formatoptions=tcroqn2 comments=n:&gt;
  autocmd BufRead gopack.config  set comments=n:#
  autocmd FileType qf setlocal colorcolumn=0 nolist nocursorline nowrap
  autocmd FileType go set noexpandtab ts=4 sw=4 sts=4
  autocmd FileType sh set iskeyword=35,36,45,46,48-57,64,65-90,97-122,_
augroup END

augroup endwiseadr
  au!
  autocmd FileType go
    \ let b:endwise_addition = '}' |
    \ let b:endwise_words = 'func,for,switch,if,else,range,select' |
    \ let b:endwise_pattern = '^\s*\zs\%(func\|for\|switch\|if\|else\|range\|select\)\>\%(.*\)$' |
    \ let b:endwise_syngroups = 'goConditional,goRepeat,goType,goDeclaration'
augroup END

" completions

augroup completions
  au!
  autocmd FileType c setlocal omnifunc=v:lua.vim.lsp.omnifunc
  autocmd FileType cpp setlocal omnifunc=v:lua.vim.lsp.omnifunc
  autocmd FileType python setlocal omnifunc=v:lua.vim.lsp.omnifunc
  autocmd FileType ruby setlocal omnifunc=v:lua.vim.lsp.omnifunc
  autocmd FileType haskell setlocal omnifunc=v:lua.vim.lsp.omnifunc
  autocmd FileType php setlocal omnifunc=v:lua.vim.lsp.omnifunc
  autocmd FileType java setlocal omnifunc=v:lua.vim.lsp.omnifunc
  autocmd FileType scala setlocal omnifunc=v:lua.vim.lsp.omnifunc
  autocmd FileType rust setlocal omnifunc=v:lua.vim.lsp.omnifunc
  autocmd FileType javascript setlocal omnifunc=v:lua.vim.lsp.omnifunc
  autocmd FileType typescript setlocal omnifunc=v:lua.vim.lsp.omnifunc
  autocmd FileType go setlocal omnifunc=v:lua.vim.lsp.omnifunc
  autocmd BufEnter,BufWinEnter,TabEnter *.rs :lua require'lsp_extensions'.inlay_hints{}
  autocmd CursorHold,CursorHoldI *.rs :lua require'lsp_extensions'.inlay_hints{ only_current_line = true }
augroup END

augroup mappings
  au!
augroup END

" }}}

" host specific customizations {{{
let hostfile=$HOME . '.vim/hosts/' . hostname() . ".vim"
if filereadable(hostfile)
  exe 'source ' . hostfile
endif
" }}}

