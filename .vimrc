"vim:foldmethod=marker
if has("mac")
  let g:os_bin_path = "darwin"
  let g:python2_host_prog = '/usr/local/bin/python'
  let g:python3_host_prog = '/usr/local/opt/python/bin/python3'
  let g:ruby_host_prog = $HOME . '/.frum/versions/2.7.5/bin/neovim-ruby-host'
  let g:node_host_prog = $HOME . '/.fnm/node-versions/v14.16.1/installation/lib/node_modules/neovim/bin/cli.js'
elseif has("wsl")
  let g:os_bin_path = "linux"
  let g:python2_host_prog = '/usr/local/bin/python'
  let g:python3_host_prog = '/home/linuxbrew/.linuxbrew/Cellar/python@3.9/3.9.2_1/bin/python3'
  let g:ruby_host_prog = 'rvm ruby-3.0.0 do neovim-ruby-host'
  let g:node_host_prog = '/home/linuxbrew/.linuxbrew/lib/node_modules/neovim/bin/cli.js'
elseif has("win64")
  if $MSYSTEM == "MSYS"
    let g:os_bin_path = "windows"
		let &shell = "/usr/bin/zsh"
  else
    let g:os_bin_path = "windows"
		let &shell = has('win64') ? 'powershell' : 'pwsh'
		set shellquote= shellpipe=\| shellxquote=
		set shellcmdflag=-NoLogo\ -NoProfile\ -ExecutionPolicy\ RemoteSigned\ -Command
		set shellredir=\|\ Out-File\ -Encoding\ UTF8
    " let g:python3_host_prog = 'c:\Python39\python3.exe'
    let g:ruby_host_prog = 'c:\tools\ruby30\bin\neovim-ruby-host.bat'
    "let g:node_host_prog = 'C:\Users\adrag\AppData\Roaming\npm\neovim-node-host'
  endif
endif

set guifont=Jetbrains\ Mono:h12
if exists('g:neovide')
  nnoremap <D-v> "+p
endif
let g:neovide_input_use_logo=v:true
let g:neovide_cursor_animation_length=0.0
let g:neovide_cursor_trail_length=0.0

if has("gui_vimr")
  set termguicolors
  set background=dark
  colorscheme monochrome2
endif

if &term =~ '^screen'
  execute "set <xUp>=\e[1;*A"
  execute "set <xDown>=\e[1;*B"
  execute "set <xRight>=\e[1;*C"
  execute "set <xLeft>=\e[1;*D"
endif
" home and end
let g:do_filetype_lua=1
let g:did_load_filetypes = 0

filetype off
set mouse=a
set history=10000 undolevels=10000
set shiftround
set noswapfile
set number
set whichwrap=<,>,h,l,b,s,~,[,]
set ignorecase smartcase gdefault
set linebreak breakindent breakindentopt=sbr showbreak=…
set fillchars=diff:⣿,vert:\|
set statusline=%<%f\ (%{&ft},%{&ff})\ (%{&ts},%{&sts},%{&sw},%{&et?'et':'noet'})\ %-4(%m%)%=%-19(%3l,%02c%03V,%o\|%B%)
set scrolljump=10
set virtualedit+=block
set novisualbell noerrorbells
set writeany
set iskeyword=@,-,>,48-57,128-167,224-235,_
set iskeyword-=.
set showtabline=0
set matchtime=3
set complete=.,w,b,u,t,i,d	" completion by Ctrl-N
set completeopt=menu,menuone,noselect "set completeopt=longest,menu,noinsert,noselect,menuone "sjl: set completeopt=longest,menuone,preview
set timeout
set ttimeout
set ttimeoutlen=0
if has("mac")
  set clipboard=unnamed "unnamed ",unnamedplus,autoselect
else 
  set clipboard=unnamedplus
endif
if has("wsl") || has("mac")
  set shell=bash
  set shellcmdflag=-lc
endif
set splitbelow splitright
set switchbuf=useopen
set grepprg=rg\ --no-ignore\ -H\ --no-heading\ --color\ never
set grepformat=%f:%l:%m
set nofoldenable
set smartindent autoindent expandtab tabstop=2 shiftwidth=2 softtabstop=2
set copyindent preserveindent

"set wildmode=list:longest,full
set wildmode=longest,list
set suffixes+=.lo,.moc,.la,.closure,.loT
let g:sh_noisk=1
let g:is_bash=1

let mapleader = ","
let maplocalleader = ","

set t_Co=256
set background=dark
colorscheme monochrome
if exists('g:neovide')
  colorscheme monochrome2
endif

" syntax enable
" syntax on
" filetype on
" filetype indent on
" filetype plugin on
" highlight fixes
highlight WHITE_ON_BLACK ctermfg=white
hi NonText cterm=NONE ctermfg=NONE

let g:loaded_tutor_mode_plugin = 1
let g:loaded_man = 1
let g:loaded_manpageview = 1
let g:loaded_manpageviewPlugin = 1
let g:loaded_getscriptPlugin = 1
let g:loaded_getscript = 1
let g:loaded_logiPat = 1
let g:loaded_sql_completion = 1
let g:loaded_sql_completion=1
let g:loaded_remote_plugins = 1
let g:loaded_gzip=1
let loaded_gzip=1
let g:loaded_shada_plugin = 1
let g:loaded_vimballPlugin=1
let g:loaded_netrwPlugin = 1
let g:loaded_rrhelper=1
let g:loaded_zipPlugin=1
let g:loaded_tarPlugin=1
let g:loaded_2html_plugin=1
let g:loaded_matchparen = 1

function! Cond(Cond, ...)
  let opts = get(a:000, 0, {})
  return a:Cond ? opts : extend(opts, { 'on': [], 'for': [] })
endfunction

" vim-plug
let g:plug_url_format='https://github.com/%s.git'
let g:plug_path = stdpath('data') . '/bundle'
call plug#begin(g:plug_path)
" languages
if !exists('g:vscode')
Plug 'mfussenegger/nvim-jdtls'
Plug 'ray-x/go.nvim', {'dir': stdpath('data') . '/bundle/go.nvim'}
Plug 'pangloss/vim-javascript', { 'dir': stdpath('data') . '/bundle/javascript', 'for': 'javascript' }
Plug 'gabrielelana/vim-markdown', { 'dir': stdpath('data') . '/bundle/markdown', 'for': ['md', 'markdown']}
Plug 'rust-lang/rust.vim', { 'dir': stdpath('data') . '/bundle/rust', 'for': 'rust' }
Plug 'sirtaj/vim-openscad', { 'dir': stdpath('data') . '/bundle/openscad' }
Plug 'pearofducks/ansible-vim', { 'dir': stdpath('data') . '/bundle/ansible-vim' }
Plug 'stephpy/vim-yaml', { 'dir': stdpath('data') . '/bundle/vim-yaml', 'for': 'yaml' }
Plug 'rhysd/vim-clang-format', { 'dir': stdpath('data') . '/bundle/vim-clang-format' }
Plug 'hashivim/vim-terraform', {'dir': stdpath('data') . '/bundle/vim-terraform'}
Plug 'leafgarland/typescript-vim', {'dir': stdpath('data') . '/bundle/typescript-vim' }
Plug 'ziglang/zig.vim'
Plug 'fedorenchik/fasm.vim'
Plug 'urbit/hoon.vim'
Plug 'simrat39/rust-tools.nvim'
" Plug 'neovimhaskell/haskell-vim', { 'dir': stdpath('data') . '/bundle/haskell-vim', 'for': 'haskell' }
" Plug 'jdonaldson/vaxe', { 'dir': stdpath('data') . '/bundle/vaxe' }
" Plug 'jansedivy/jai.vim', {'dir': stdpath('data') . '/bundle/jai' }
" Plug 'elmcast/elm-vim', { 'dir': stdpath('data') . '/bundle/elm-vim', 'for': 'elm' }
" Plug 'google/vim-jsonnet', {'dir': stdpath('data') . '/bundle/jsonnet', 'for': 'jsonnet' }
" Plug 'edwinb/idris2-vim' 
" Plug 'tomlion/vim-solidity'

lua <<EOF
vim.lsp.set_log_level("error")
EOF
" completion
Plug 'neovim/nvim-lspconfig'
Plug 'nvim-lua/lsp-status.nvim'
Plug 'scalameta/nvim-metals', {'branch': 'main'}
Plug 'nvim-lua/lsp_extensions.nvim'
Plug 'tami5/lspsaga.nvim', {'branch': 'main'}
Plug 'nvim-lua/popup.nvim'
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'
Plug 'nvim-telescope/telescope-fzy-native.nvim'
Plug 'nvim-telescope/telescope-ui-select.nvim'
Plug 'ray-x/lsp_signature.nvim'
" debugging
Plug 'mfussenegger/nvim-dap'
Plug 'leoluz/nvim-dap-go'
Plug 'rcarriga/nvim-dap-ui'
" syntax
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'nvim-treesitter/nvim-treesitter-textobjects'
Plug 'RRethy/nvim-treesitter-textsubjects'
Plug 'ms-jpq/coq_nvim', {'branch': 'coq'}
" tools
Plug 'tpope/vim-fugitive', { 'dir': stdpath('data') . '/bundle/fugitive' }
Plug 'rking/ag.vim', { 'dir': stdpath('data') . '/bundle/ag'}
Plug 'vim-scripts/a.vim', { 'dir': stdpath('data') . '/bundle/a', 'do': 'patch -p1 < ~/.vim/patches/a.patch' }
Plug 'antoinemadec/FixCursorHold.nvim'
let g:cursorhold_updatetime = 100
" vim
" Plug 'lukas-reineke/indent-blankline.nvim', { 'dir': stdpath('data') . '/bundle/indent-blankline.nvim' }
Plug 'vim-scripts/DetectIndent', { 'dir': stdpath('data') . '/bundle/detectindent' }
Plug 't9md/vim-choosewin', { 'dir': stdpath('data') . '/bundle/vim-choosewin' }
Plug 'tpope/vim-endwise', { 'dir': stdpath('data') . '/bundle/endwise' }
Plug 'echasnovski/mini.nvim'
Plug 'isa/vim-matchit', { 'dir': stdpath('data') . '/bundle/matchit' }
" textobj
Plug 'rhysd/clever-f.vim'
endif
call plug#end()

function! s:VSetSearch()
  let temp = @@
  norm! gvy
  let @/ = '\V' . substitute(escape(@@, '\'), '\n', '\\n', 'g')
  let @@ = temp
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

let g:save_cr_map = {}

" System clipboard interaction.
map <leader>y "*y

" Don't move the cursor
noremap <C-a> <Home>
noremap <C-e> <End>

silent! nunmap Y
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
" GRB: clear the search buffer when hitting return
nnoremap <cr> :nohlsearch<cr>
nnoremap <m-Down> :cnext<cr>zvzz
nnoremap <m-Up> :cprevious<cr>zvzz
" Use c-\ to do c-] but open it in a new split.
nnoremap <c-\> <c-w>v<c-]>zvzz
" quickfix
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
" terminal
nmap - <Plug>(choosewin)

" disable mistakes
lua <<EOF
vim.api.nvim_set_keymap("", "<F1>", "<nop>", {noremap = true})
for i=1,24 do
  for j, t in ipairs({"i", "c"}) do
    vim.api.nvim_set_keymap(t, "<F" .. i .. ">", "<nop>", {noremap = true})
    vim.api.nvim_set_keymap(t, "<S-F" .. i .. ">", "<nop>", {noremap = true})
  end
end
EOF

if !exists('g:vscode')
nnoremap <silent> gd          <cmd>lua vim.lsp.buf.definition()<CR>
nnoremap <Leader>T            :lua require'lsp_extensions'.inlay_hints()<cr>
nnoremap <silent> K           <cmd>lua vim.lsp.buf.signature_help()<CR>
" nnoremap <silent> gi          <cmd>lua vim.lsp.buf.implementation()<CR>
" nnoremap <silent> gr          <cmd>lua vim.lsp.buf.references()<CR>
nnoremap <silent> gr          <cmd>lua require'telescope.builtin'.lsp_references{}<CR> 
" <cmd>lua require'telescope.builtin'.lsp_workspace_symbols{}<CR> 
" <cmd>lua require'telescope.builtin'.lsp_document_symbols{}<CR> 
" nnoremap <silent> gsd         <cmd>lua vim.lsp.buf.document_symbol()<CR>
nnoremap <silent> gsd         <cmd>lua require'telescope.builtin'.lsp_document_symbols{}<CR>  
nnoremap <silent> gsw         <cmd>lua vim.lsp.buf.workspace_symbol()<CR>
nnoremap <silent> <leader>rn  <cmd>lua vim.lsp.buf.rename()<CR>
nnoremap <silent> <leader>f   <cmd>lua vim.lsp.buf.formatting()<CR>
nnoremap <silent> <leader>ca  <cmd>lua vim.lsp.buf.code_action()<CR>
nnoremap <silent> [c          :NextDiagnostic<CR>
nnoremap <silent> ]c          :PrevDiagnostic<CR>
nnoremap <silent> <space>d    :OpenDiagnostic<CR>

lua <<EOF
function hoon_def_search()
  require 'telescope.builtin'.grep_string({search='\\+(\\+|\\$|\\*)  '.. vim.fn.expand('<cword>') .. '( |$)', use_regex=true})
end
EOF
nnoremap <silent> <leader>d   <cmd>lua hoon_def_search()<CR>

" LspSaga bindings
nnoremap <silent> gh :Lspsaga lsp_finder<CR>
nnoremap <silent><leader>ca :Lspsaga code_action<CR>
nnoremap <silent>K :Lspsaga signature_help<CR>
nnoremap <silent> gs :Lspsaga hover_doc<CR>
nnoremap <silent> g<space> :Lspsaga preview_definition<CR>
nnoremap <silent> <leader>cd :Lspsaga show_line_diagnostics<CR>
nnoremap <silent> [e :Lspsaga diagnostic_jump_next<CR>
nnoremap <silent> ]e :Lspsaga diagnostic_jump_prev<CR>

let g:coq_settings = {
	    \ 'auto_start': 'shut-up', 
	    \ 'display.pum.fast_close': v:false,
	    \ 'display.icons.mode': 'none', 
	    \ 'clients.tags.enabled': v:false,  
	    \ 'clients.snippets.enabled': v:false,
	    \ 'clients.snippets.warn': {},
	    \ 'clients.paths.enabled': v:false, 
	    \ 'clients.tmux.enabled': v:false
      \}

lua <<EOF
  require'nvim-treesitter.configs'.setup {
      textsubjects = {
          enable = true,
          keymaps = {
              ['.'] = 'textsubjects-smart',
              [';'] = 'textsubjects-container-outer',
          }
      },
  }
  require('dap-go').setup()

  require('mini.comment').setup()
  require('mini.surround').setup( {
    -- Add custom surroundings to be used on top of builtin ones. For more
    -- information with examples, see `:h MiniSurround.config`.
    custom_surroundings = nil,

    -- Duration (in ms) of highlight when calling `MiniSurround.highlight()`
    highlight_duration = 500,

    -- Module mappings. Use `''` (empty string) to disable one.
    mappings = {
      add = 'ys', -- Add surrounding in Normal and Visual modes
      delete = 'ds', -- Delete surrounding
      find = '', -- Find surrounding (to the right)
      find_left = '', -- Find surrounding (to the left)
      highlight = '', -- Highlight surrounding
      replace = 'cs', -- Replace surrounding
      update_n_lines = '', -- Update `n_lines`
    },

    -- Number of lines within which surrounding is searched
    n_lines = 20,

    -- How to search for surrounding (first inside current line, then inside
    -- neighborhood). One of 'cover', 'cover_or_next', 'cover_or_prev',
    -- 'cover_or_nearest'. For more details, see `:h MiniSurround.config`.
    search_method = 'cover',
  })
  require('mini.bufremove').setup()

  local saga = require 'lspsaga'
  saga.init_lsp_saga()

  -- Setup lspconfig.

  local lspconfig = require'lspconfig'
  local configs = require'lspconfig.configs'
  local util = require'lspconfig/util'

  local coq = require 'coq'
  -- local metals   = require'metals'
  -- local setup    = require'metals.setup' 
  local M = {}

  M.on_attach = function()
    --require'completion'.on_attach();
    --setup.auto_commands()
  end

  lspconfig.pasls.setup{}
  lspconfig.prosemd_lsp.setup{}
  lspconfig.racket_langserver.setup{}
  lspconfig.zls.setup{
    flags = {
      debounce_text_changes = 250, 
    };
    on_attach = M.on_attach;
  }

  lspconfig.gopls.setup{
    on_attach = M.on_attach;
    root_dir = util.root_pattern("go.mod");
  }

  lspconfig.denols.setup{
    on_attach = M.on_attach;
    root_dir = util.root_pattern("deno.json");
  }
  lspconfig.haxe_language_server.setup{
  }
  lspconfig.leanls.setup{
  }
  lspconfig.solang.setup{
  }
  lspconfig.svls.setup{
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
  lspconfig.clojure_lsp.setup{
  }
  --lspconfig.clangd.setup{
  --  cmd = {"/usr/local/opt/llvm/bin/clangd", "--index-background"}
  --}
  lspconfig.intelephense.setup{
    on_attach = M.on_attach;
  }
  -- lspconfig.pyright.setup{
  --   on_attach = M.on_attach;
  -- }
  lspconfig.svls.setup{}
  lspconfig.pylsp.setup{
    on_attach = M.on_attach;
    on_init = function(client)
      client.config.settings = {
        pylsp = {

        }
      }
      client.notify('workspace/didChangeConfiguration')
    end, 
  }

  lspconfig.jdtls.setup{
    on_attach = M.on_attach;
    root_dir = util.root_pattern("pom.xml", "build.xml");
  }
  lspconfig.tsserver.setup{
    on_attach = M.on_attach;
  }

  local system_name
  if vim.fn.has("mac") == 1 then
    system_name = "macOS"
  elseif vim.fn.has("unix") == 1 then
    system_name = "Linux"
  elseif vim.fn.has('win32') == 1 then
    system_name = "Windows"
  else
    print("Unsupported system for sumneko")
  end
  local sumneko_root_path = vim.fn.stdpath('data')..'/lspconfig/sumneko_lua/lua-language-server'
  local sumneko_binary = sumneko_root_path.."/bin/"..system_name.."/lua-language-server"
  lspconfig.sumneko_lua.setup {
    cmd = {sumneko_binary, "-E", sumneko_root_path .. "/main.lua"};
    on_attach = M.on_attach;
    settings = {
      Lua = {
        runtime = {
          -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
          version = 'LuaJIT',
          -- Setup your lua path
          path = vim.split(package.path, ';'),
        },
        diagnostics = {
          -- Get the language server to recognize the `vim` global
          globals = {'vim'},
        },
        workspace = {
          -- Make the server aware of Neovim runtime files
          library = {
            [vim.fn.expand('$VIMRUNTIME/lua')] = true,
            [vim.fn.expand('$VIMRUNTIME/lua/vim/lsp')] = true,
          },
        },
      },
    };
  }

  lspconfig.sourcekit.setup{}
  lspconfig.solargraph.setup{
    on_attach = M.on_attach;
    settings = {
      solargraph = {
        diagnostics = false;
        formatting = true;
        autoformat = false;
      }
    };
  }
  lspconfig.terraformls.setup{
    on_attach = M.on_attach;
  }
--  lspconfig.metals.setup{
--    on_attach    = M.on_attach;
--    root_dir     = util.root_pattern("pom.xml", "build.sbt", "build.sc", ".git");
--    init_options = {
--      statusBarProvider            = "on";
--      inputBoxProvider             = true;
--      quickPickProvider            = true;
--      executeClientCommandProvider = true;
--      didFocusProvider             = true;
--      decorationProvider           = true;
--    };
--
--    on_init = setup.on_init;
--
--    handlers = {
--      ["textDocument/hover"]          = metals['textDocument/hover'];
--      ["metals/status"]               = metals['metals/status'];
--      ["metals/inputBox"]             = metals['metals/inputBox'];
--      ["metals/quickPick"]            = metals['metals/quickPick'];
--      ["metals/executeClientCommand"] = metals["metals/executeClientCommand"];
--      ["metals/publishDecorations"]   = metals["metals/publishDecorations"];
--      ["metals/didFocusTextDocument"] = metals["metals/didFocusTextDocument"];
--    };
--  }

  lspconfig.elmls.setup{
    on_attach    = M.on_attach;
  }
  lspconfig.html.setup{
    on_attach    = M.on_attach;
  }
  lspconfig.yamlls.setup{
    on_attach    = M.on_attach;
  }
  lspconfig.hoon_ls.setup{
    on_attach    = M.on_attach;
  }
  if 1 then
    lspconfig.zls.setup(coq.lsp_ensure_capabilities())
    lspconfig.gopls.setup(coq.lsp_ensure_capabilities())
    lspconfig.denols.setup(coq.lsp_ensure_capabilities())
    lspconfig.haxe_language_server.setup(coq.lsp_ensure_capabilities())
    lspconfig.leanls.setup(coq.lsp_ensure_capabilities())
    lspconfig.solang.setup(coq.lsp_ensure_capabilities())
    lspconfig.svls.setup(coq.lsp_ensure_capabilities())
    lspconfig.rust_analyzer.setup(coq.lsp_ensure_capabilities())
    lspconfig.ccls.setup(coq.lsp_ensure_capabilities())
    lspconfig.intelephense.setup(coq.lsp_ensure_capabilities())
    lspconfig.pyright.setup(coq.lsp_ensure_capabilities())
    lspconfig.jdtls.setup(coq.lsp_ensure_capabilities())
    lspconfig.tsserver.setup(coq.lsp_ensure_capabilities())
    lspconfig.sumneko_lua.setup(coq.lsp_ensure_capabilities())
    lspconfig.solargraph.setup(coq.lsp_ensure_capabilities())
    lspconfig.terraformls.setup(coq.lsp_ensure_capabilities())
    lspconfig.elmls.setup(coq.lsp_ensure_capabilities())
    lspconfig.html.setup(coq.lsp_ensure_capabilities())
    lspconfig.yamlls.setup(coq.lsp_ensure_capabilities())
  end

  require "lsp_signature".setup({
    bind = true, 
    doc_lines = 0, 
    floating_window = true, 
    floating_window_above_cur_line = true, 
    fix_pos = false,
    hint_enable = false, 
    use_lspsaga = false, 
    always_trigger = false, 
    toggle_key = nil, 
    handler_opts = {
      border = "rounded"
    }
  })

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
      -- prompt_prefix = ">",
      -- selection_caret = ">", 
      selection_strategy = "reset",
      sorting_strategy = "descending",
      layout_strategy = "horizontal",
      layout_config = {
        width = 0.75, 
        prompt_position = "bottom",
        preview_cutoff = 120,
      }, 
      file_ignore_patterns = {},
      use_less = true,
      grep_previewer = require'telescope.previewers'.vim_buffer_vimgrep.new,
      qflist_previewer = require'telescope.previewers'.vim_buffer_qflist.new,
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

lua <<EOF
  require'nvim-treesitter.install'.compilers = { "gcc" }
  require'nvim-treesitter.configs'.setup {
    highlight = {
      enable = true, -- false will disable the whole extension
      disable = {},  -- list of language that will be disabled
    },
    force_unix_shell = true, 
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

  require'lsp_extensions'.setup{
	  highlight = "Comment",
	  prefix = " > ",
	  aligned = false,
	  only_current_line = false, 
	  enabled = { "TypeHint", "ParameterHint", "ChainingHint" }
  }
EOF
endif

let g:ag_prg = "rg --vimgrep -L 2>/dev/null"
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
let g:choosewin_overlay_enable = 1
let g:choosewin_statusline_replace = 0
let g:choosewin_tabline_replace = 0
let g:choosewin_blink_on_land = 0
let g:choosewin_label = "1234567890"
let g:choosewin_tablabel = "ABCDEFGHIJKLMNOPQRTUVWYZ"
let g:choosewin_overlay_clear_multibyte = 1
let g:clang_format#command = "/usr/local/bin/clang-format"
let g:clang_format#detect_style_file = 1
let javaScript_fold=0
let g:vim_json_syntax_conceal = 0
let g:terraform_align = 1
let g:terraform_fmt_on_save = 1

command! -bar -nargs=0 W  silent! exec "write !sudo tee % >/dev/null"  | silent! edit!
command! -bar -nargs=0 WX silent! exec "write !chmod a+x % >/dev/null" | silent! edit!

" typos
command! -bang E e<bang>
command! -bang Q q<bang>
command! -bang QA qa<bang>
command! -bang Qa qa<bang>
command! -bang Wa wa<bang>
command! -bang WA wa<bang>
command! -bang Wq wq<bang>
command! -bang WQ wq<bang>

hi default hi_MarkInsertStop ctermbg=128 ctermfg=white cterm=bold
hi default hi_MarkChange ctermbg=160 ctermfg=231
hi default hi_MarkBeforeJump ctermbg=23 ctermfg=white cterm=undercurl,bold
lua <<EOF
local jump_ns = vim.api.nvim_create_namespace("jump_ns")
local change_ns = vim.api.nvim_create_namespace("change_ns")
local insert_ns = vim.api.nvim_create_namespace("insert_ns")

function mark_on_move()
  local bufnr = vim.api.nvim_get_current_buf()
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

function mark_on_changed()
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
end

function mark_on_insert_stop()
  local bufnr = vim.api.nvim_get_current_buf()
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
  autocmd CursorMoved * silent! lua mark_on_move()
  autocmd BufModifiedSet,TextChangedP,TextChangedI,TextChanged * silent! lua mark_on_changed()
  autocmd InsertLeave * silent! lua mark_on_insert_stop()
augroup END

augroup all_buffers
  au!
  autocmd BufNewFile,BufRead *.Jenkinsfile set filetype=groovy
  autocmd BufNewFile,BufRead *.ino set filetype=cpp
  autocmd BufNewFile,BufRead *.pde set filetype=cpp
  autocmd VimLeavePre * execute 'silent! 1,' . bufnr('$') . 'bwipeout!'
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

augroup settings
  au!
  autocmd FileType python setlocal et ts=4 sw=4 tw=120
  autocmd FileType java setlocal et ts=2 sw=2
  autocmd FileType ruby,haml,eruby,yaml,html,sass set ai sw=2 sts=2 et
  autocmd FileType javascript setlocal ai sw=4 ts=4 sts=4 et
  autocmd FileType c set ts=4 sw=4 sts=4 commentstring=//\ %s
  autocmd FileType cpp set ts=4 sw=4 sts=4 commentstring=//\ %s
  autocmd FileType openscad set ts=4 sw=4 sts=4 commentstring=//\ %s
  autocmd FileType css set expandtab ts=4 sw=4 sts=4
  autocmd FileType scss set expandtab ts=4 sw=4 sts=4
  autocmd FileType text,markdown,mkd,pandoc,mail setlocal textwidth=1000
  autocmd FileType qf setlocal colorcolumn=0 nolist nocursorline nowrap
  autocmd FileType go set noexpandtab ts=4 sw=4 sts=4
  autocmd FileType sh set iskeyword=35,36,45,46,48-57,64,65-90,97-122,_
augroup END

" completions
if !exists('g:vscode')
augroup completions
  au!
  autocmd FileType c setlocal omnifunc=v:lua.vim.lsp.omnifunc
  autocmd FileType cpp setlocal omnifunc=v:lua.vim.lsp.omnifunc
  autocmd FileType python setlocal omnifunc=v:lua.vim.lsp.omnifunc
  autocmd FileType ruby setlocal omnifunc=v:lua.vim.lsp.omnifunc
  autocmd FileType haskell setlocal omnifunc=v:lua.vim.lsp.omnifunc
  autocmd FileType php setlocal omnifunc=v:lua.vim.lsp.omnifunc
  autocmd FileType java setlocal omnifunc=v:lua.vim.lsp.omnifunc
  autocmd FileType scala,sbt lua require('metals').initialize_or_attach({})
  autocmd FileType rust setlocal omnifunc=v:lua.vim.lsp.omnifunc
  autocmd FileType javascript setlocal omnifunc=v:lua.vim.lsp.omnifunc
  autocmd FileType typescript setlocal omnifunc=v:lua.vim.lsp.omnifunc
  autocmd FileType go setlocal omnifunc=v:lua.vim.lsp.omnifunc
  autocmd BufEnter,BufWinEnter,TabEnter *.rs :lua require'lsp_extensions'.inlay_hints{}
  autocmd CursorHold,CursorHoldI *.rs :lua require'lsp_extensions'.inlay_hints{ only_current_line = true }
augroup END
endif

augroup mappings
  au!
augroup END

let hostfile=$HOME . '.vim/hosts/' . hostname() . ".vim"
if filereadable(hostfile)
  exe 'source ' . hostfile
endif

