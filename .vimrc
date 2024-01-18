if has("mac")
  let g:os_bin_path = "darwin"
  let g:python2_host_prog = '/usr/local/bin/python2.7'
  let g:python3_host_prog = '/usr/local/opt/python@3.11/bin/python3.11'
  let g:ruby_host_prog = $HOME . '/.cache/frum/versions/2.7.5/bin/neovim-ruby-host'
  let g:node_host_prog = $HOME . '/.cache/fnm/node-versions/v16.20.0/installation/lib/node_modules/neovim/bin/cli.js'
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
    let g:ruby_host_prog = 'c:\tools\ruby30\bin\neovim-ruby-host.bat'
  endif
endif

if &term =~ '^screen'
  execute "set <xUp>=\e[1;*A"
  execute "set <xDown>=\e[1;*B"
  execute "set <xRight>=\e[1;*C"
  execute "set <xLeft>=\e[1;*D"
endif
let g:do_filetype_lua=1
let g:did_load_filetypes=1

function! GuiTabLabel(n)
  let tab_num = a:n
  let win_num = tabpagewinnr(a:n)
  return fnamemodify(getcwd(win_num, tab_num), ':t')
endfunction

function! MyTabLine()
  let s = ''
  for i in range(tabpagenr('$'))
    if i + 1 == tabpagenr()
      let s ..= '%#TabLineSel#'
    else
      let s ..= '%#TabLine#'
    endif
    let s ..= '%' .. (i + 1) .. 'T'
    let s ..= ' %{GuiTabLabel(' .. (i + 1) .. ')} '
  endfor
  let s ..= '%#TabLineFill#%T'
  if tabpagenr('$') > 1
    let s ..= '%=%#TabLine#%999Xclose'
  endif
  return s
endfunction

if has('gui_vimr')
  colorscheme jb
  "set guifont=Jetbrains\ Mono\ NL:h11
  set guifont=Consolas:h12
  set guicursor=a:block-blinkon0-VimrDefaultCursor
  set tabline=%!MyTabLine()
elseif exists('g:neovide') == 1
  set tabline=%!MyTabLine()
  "set guifont=Jetbrains\ Mono\ NL:h11
  set guifont=Consolas:h12
  let g:neovide_cursor_animation_length=0.0
  let g:neovide_cursor_trail_length=0.0
  let g:neovide_input_use_logo=1
  colorscheme jb
  cno <D-v> <C-r>+
  ino <D-v> <C-r>+
  vn <D-c> y
  set guicursor=a:block-blinkon0-Cursor
else 
  colorscheme jb
  set guicursor=a:block-blinkon0-Cursor
  "set guicursor=a:blinkon0
endif

filetype on
syntax on
set termguicolors
set shm+=I
set mouse=a
set sr
set noswf
set nu
" set fdc=1
set ww=<,>,h,l,b,s,~,[,]
set ic scs gd
set lbr bri briopt=sbr sbr=…
set stl=%<%f\ (%{&ft},%{&ff})\ (%{&ts},%{&sts},%{&sw},%{&et?'et':'noet'})\ %-4(%m%)%=%-19(%3l,%02c%03V,%o\|%B%)
set ve+=block
set novb noeb
set wa
set isk=@,-,>,48-57,128-167,224-235,_
set isk-=.
set showtabline=1
set matchtime=3
set complete=.,w,b,u,t,i,d
set completeopt=menu,menuone,noselect "set completeopt=longest,menu,noinsert,noselect,menuone "sjl: set completeopt=longest,menuone,preview
set to ttm=0
set timeoutlen=200
set ttimeoutlen=0
if has("mac")
  set cb=unnamed "unnamed,unnamedplus,autoselect
else 
  set cb=unnamedplus
endif
if has("wsl") || has("mac")
  set shell=bash
  set shellcmdflag=-lc
endif
set sb spr
set swb=useopen
set grepprg=rg\ --no-ignore\ -H\ --no-heading\ --color\ never
set grepformat=%f:%l:%m
set nofoldenable
set si ci pi ai et ts=2 sw=2 sts=2

"set wildmode=list:longest,full
set wildmode=longest,list
set suffixes+=.lo,.moc,.la,.closure,.loT
let g:is_bash=1

let mapleader = ","
let maplocalleader = ","
set t_Co=256
"set t_ut=
set background=dark

syntax enable
syntax on
filetype on
filetype indent on
filetype plugin on
set nospell

let g:loaded_perl_provider = 0
let g:loaded_tutor_mode_plugin = 1
let g:loaded_man = 1
let g:loaded_manpageview = 1
let g:loaded_manpageviewPlugin = 1
let g:loaded_sql_completion=1
let g:omni_sql_no_default_maps = 1
let g:loaded_remote_plugins = 1
let g:loaded_gzip=1
let g:loaded_spellfile_plugin=1
let g:loaded_shada_plugin = 1
let g:loaded_vimballPlugin=1
let g:loaded_netrwPlugin = 1
let g:netrw_banner=0
let g:netrw_altv=1
let g:netrw_browse_split=4
let g:loaded_netrwFileHandlers = 1
let g:loaded_zipPlugin=1
let g:loaded_zip=1
let g:loaded_tarPlugin=1
let g:loaded_2html_plugin=1
let g:loaded_matchparen = 1
let g:loaded_xmlformat = 1

" vim-plug
let g:plug_url_format='https://github.com/%s.git'
let g:plug_path = stdpath('data') . '/bundle'
call plug#begin(g:plug_path)
if !exists('g:vscode')
" lang
Plug 'https://git.sr.ht/~sircmpwn/hare.vim'
Plug 'simrat39/rust-tools.nvim'
Plug 'ray-x/guihua.lua'
Plug 'ray-x/go.nvim'
Plug 'rust-lang/rust.vim', { 'dir': stdpath('data') . '/bundle/rust', 'for': 'rust' }
Plug 'sirtaj/vim-openscad', { 'dir': stdpath('data') . '/bundle/openscad' }
Plug 'stephpy/vim-yaml', { 'for': 'yaml' }
Plug 'rhysd/vim-clang-format'
Plug 'hashivim/vim-terraform'
Plug 'ziglang/zig.vim'
Plug 'fedorenchik/fasm.vim'
Plug 'urbit/hoon.vim'
Plug 'karolbelina/uxntal.vim'
Plug 'rluba/jai.vim'
Plug 'mikesmithgh/kitty-scrollback.nvim'
" Plug 'pangloss/vim-javascript', { 'dir': stdpath('data') . '/bundle/javascript', 'for': 'javascript' }
" Plug 'leafgarland/typescript-vim'
" Plug 'neovimhaskell/haskell-vim', { 'dir': stdpath('data') . '/bundle/haskell-vim', 'for': 'haskell' }
" Plug 'jdonaldson/vaxe', { 'dir': stdpath('data') . '/bundle/vaxe' }
" Plug 'jansedivy/jai.vim', {'dir': stdpath('data') . '/bundle/jai' }
" Plug 'elmcast/elm-vim', { 'dir': stdpath('data') . '/bundle/elm-vim', 'for': 'elm' }
" Plug 'google/vim-jsonnet', {'dir': stdpath('data') . '/bundle/jsonnet', 'for': 'jsonnet' }
" Plug 'edwinb/idris2-vim' 
" Plug 'tomlion/vim-solidity'
lua <<EOF
vim.opt.runtimepath:append(',~/.config/nvim/lua')
vim.lsp.set_log_level('error')
EOF
" lsp
Plug 'neovim/nvim-lspconfig'
Plug 'williamboman/nvim-lsp-installer'
Plug 'nvim-lua/lsp-status.nvim'
Plug 'scalameta/nvim-metals', {'branch': 'main'}
Plug 'nvimdev/lspsaga.nvim', {'branch': 'main'}
Plug 'nvim-lua/popup.nvim'
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-pack/nvim-spectre'
Plug 'nvim-telescope/telescope.nvim'
Plug 'nvim-telescope/telescope-fzf-native.nvim', {'do': 'make'}
Plug 'nvim-telescope/telescope-ui-select.nvim'
Plug 'ray-x/lsp_signature.nvim'
Plug 'WhoIsSethDaniel/toggle-lsp-diagnostics.nvim'
"Plug 'ms-jpq/coq_nvim', {'branch': 'coq'}
Plug 'mfussenegger/nvim-lsp-compl'
Plug 'Decodetalkers/csharpls-extended-lsp.nvim'
" Plug 'vim-denops/denops.vim'
" Plug 'Shougo/ddc.vim'
" Plug 'Shougo/ddc-ui-native'
" Plug 'Shougo/ddc-source-around'
" Plug 'Shougo/ddc-matcher_head'
" Plug 'Shougo/ddc-filter-matcher_length'
" Plug 'Shougo/ddc-sorter_rank'
" Plug 'Shougo/ddc-source-nvim-lsp'
" Plug 'matsui54/ddc-buffer'
" debug
Plug 'mfussenegger/nvim-dap'
Plug 'theHamsta/nvim-dap-virtual-text'
Plug 'rcarriga/nvim-dap-ui'
Plug 'leoluz/nvim-dap-go'
Plug 'nvim-telescope/telescope-dap.nvim'
Plug 'mfussenegger/nvim-jdtls'
" syntax
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'nvim-treesitter/playground'
" Plug 'nvim-treesitter/nvim-treesitter-context'
Plug 'RRethy/nvim-treesitter-textsubjects'
" tools
Plug 'lambdalisue/suda.vim'
Plug 'kyazdani42/nvim-tree.lua'
Plug 'tpope/vim-fugitive', { 'dir': stdpath('data') . '/bundle/fugitive' }
"Plug 'duane9/nvim-rg', {'branch': 'adragomi'}
Plug 'jremmen/vim-ripgrep'
Plug 'vim-scripts/a.vim', { 'dir': stdpath('data') . '/bundle/a', 'do': 'patch -p1 < ~/.vim/patches/a.patch' }
Plug 'NMAC427/guess-indent.nvim'
Plug 'tkmpypy/chowcho.nvim'
Plug 'echasnovski/mini.nvim'
Plug 'isa/vim-matchit', { 'dir': stdpath('data') . '/bundle/matchit' }
"map <leader>m :AsyncRun -mode=term -pos=right -focus=0 -listed=0 ./build && jairun ./main<cr>
Plug 'skywind3000/asyncrun.vim'
Plug 'famiu/bufdelete.nvim'
" Plug 'github/copilot.vim'
endif
call plug#end()

" let g:copilot_no_tab_map = v:true
" imap <silent><script><expr> <C-J> copilot#Accept("\<CR>")

fu! MoveCursor(move, mode)
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
endf

fu! HomeKey()
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
endf

fu! EndKey()
  call MoveCursor('e', '$g')
endf

" Visual mode functions
fu! RestoreRegister()
  if &clipboard == 'unnamed'
    let @* = s:restore_reg
  elseif &clipboard == 'unnamedplus'
    let @+ = s:restore_reg
  else
    let @" = s:restore_reg
  endif
  return ''
endf

fu! ReplaceWithRegister()
    let s:restore_reg = @"
    return "p@=RestoreRegister()\<cr>"
endf
xn <silent> <expr> p ReplaceWithRegister()

fu! SaveMap(key)
  return maparg(a:key, 'n', 0, 1)
endf
fu! RestoreMap(map)
  if !empty(a:map)
    let l:tmp = ""
    let l:tmp .= a:map.noremap ? 'nn' : 'nmap'
    let l:tmp .= join(map(['buffer', 'expr', 'nowait', 'silent'], 'a:map[v:val] ? "<" . v:val . ">": ""'))
    let l:tmp .= a:map.lhs . ' '
    let l:tmp .= substitute(a:map.rhs, '<SID>', '<SNR>' . a:map.sid . '_', 'g')
    execute l:tmp
  endif
endf

nn K <nop>
vn u <nop>
nn + <nop>
" nn r <nop>
" nn R <nop>
nn L <nop>
nn M <nop>
nn \| <nop>
nn ( <nop>
nn ) <nop>
nn [ <nop>
nn ] <nop>
" nn { <nop>
" nn } <nop>
nn ]] <nop>
nn [[ <nop>
nn [] <nop>
nn ][ <nop>
nn <silent> Q <nop>
map <MiddleMouse>  <nop>
map <2-MiddleMouse>  <nop>
map <3-MiddleMouse>  <nop>
map <4-MiddleMouse>  <nop>
im <MiddleMouse>  <nop>
im <2-MiddleMouse>  <nop>
im <3-MiddleMouse>  <nop>
im <4-MiddleMouse>  <nop>
lua <<EOF
vim.api.nvim_set_keymap("", "<F1>", "<nop>", {noremap = true})
for i=1,24 do
  for j, t in ipairs({"i", "c"}) do
    vim.api.nvim_set_keymap(t, "<F" .. i .. ">", "<nop>", {noremap = true})
    vim.api.nvim_set_keymap(t, "<S-F" .. i .. ">", "<nop>", {noremap = true})
  end
end
EOF

" cutlass.nvim inline
lua <<EOF
local map = vim.api.nvim_set_keymap
local keymap_opts = { noremap = true, silent = true }
for _, mode in pairs({ "x", "n" }) do
  for _, lhs in pairs({ "x", "X" }) do
    if vim.fn.maparg(lhs, mode) == "" then
      map(mode, lhs, '"_' .. lhs, keymap_opts)
    end
  end
end

map("n", "<Del>", '"_x', keymap_opts)
map("x", "<Del>", '"_x', keymap_opts)
EOF

silent! nunmap Y
vn y myy`y
vn Y myY`y
no j gj
no k gk
no <up> gk
no <down> gj
nn D d$

vn J j
vn K k

nn <cr> :nohlsearch<cr>
nn <M-Right> :vertical resize +5<CR>
nn <M-Left> :vertical resize -5<CR>
nn <M-Down> :resize +3<CR>
nn <M-Up> :resize -3<CR>

nn ' `
xn ' `
map <leader>' ``
map <leader>. `.
nn gl `.
map <leader>] `]
map <leader>> `>
map <leader>` `^
nnoremap <expr> gp '`[' . strpart(getregtype(), 0, 1) . '`]'

vn p "_dP
vn r "_dP

nn <C-h> <c-w>h
nn <C-j> <c-w>j
nn <C-k> <c-w>k
nn <C-l> <c-w>l

" map <s-LEFT> :vertical resize +5 <Cr>
" map <s-RIGHT> :vertical resize -5 <Cr>
" map <s-UP> :resize +5 <Cr>
" map <s-DOWN> :resize -5 <Cr>

function! CloseOther(wid)
  if a:wid == 1
    " on left
    execute 2 .. "wincmd c"
  else
    execute 1 .. "wincmd c"
  endif
endfunction

nmap <c-w><left> :call CloseOther(winnr())<cr>
nmap <c-w><right> :call CloseOther(winnr())<cr>

no <Space> m`

ino <silent> <Home> <C-o>:call HomeKey()<CR>
nn <silent> <Home> :call HomeKey()<CR>
nn <silent> <leader>/ :Rg <cword><cr>
nm <MapLocalLeader>h :AT<CR>
nm - :Chowcho<CR>

if !exists('g:vscode')
nn <silent>gD          <cmd>lua vim.lsp.buf.declaration()<CR>
nn <silent>gd          <cmd>lua vim.lsp.buf.definition()<CR>
nn <silent>K           <cmd>lua vim.lsp.buf.signature_help()<CR>
nn <silent>gi          <cmd>lua vim.lsp.buf.implementation()<CR>
nn <silent>gr          <cmd>lua vim.lsp.buf.references()<CR>
"nn <silent>gr          <cmd>lua require'telescope.builtin'.lsp_references{}<CR> 
nn <silent>gsd         <cmd>lua vim.lsp.buf.document_symbol()<CR>
nn <silent>gsw         <cmd>lua vim.lsp.buf.workspace_symbol()<CR>
"nn <silent>gsd        <cmd>lua require'telescope.builtin'.lsp_document_symbols{}<CR>  
nn <silent><f12>       <cmd>lua require'telescope.builtin'.lsp_document_symbols{}<CR>  
nn <silent><c-f12>     <cmd>lua require'telescope.builtin'.lsp_workspace_symbols{}<CR>  
nn <silent><leader>rn  <cmd>lua vim.lsp.buf.rename()<CR>
nn <silent><leader>f   <cmd>lua vim.lsp.buf.format()<CR>
nn <silent><leader>ca  <cmd>lua vim.lsp.buf.code_action()<CR>
nn <silent>[c          :NextDiagnostic<CR>
nn <silent>]c          :PrevDiagnostic<CR>
nn <silent><space>d    :OpenDiagnostic<CR>
nn <silent><leader>sp   <cmd>lua require("spectre").open()<CR>

if has('gui_vimr') || exists('g:neovide') == 1
  nn <silent><D-t>  :tabnew<cr>
  nn <silent><D-w>  :tabclose<cr>
  nn <silent><D-]>  :tabnext<cr>
  nn <silent><D-[>  :tabprevious<cr>
  no <silent><D-1>  1gt
  no <silent><D-2>  2gt
  no <silent><D-3>  3gt
  no <silent><D-4>  4gt
  no <silent><D-5>  5gt
  no <silent><D-6>  6gt
  no <silent><D-7>  7gt
  no <silent><D-8>  8gt
  no <silent><D-9>  9gt

  ino <silent><D-1> 1gt
  ino <silent><D-2> 2gt
  ino <silent><D-3> 3gt
  ino <silent><D-4> 4gt
  ino <silent><D-5> 5gt
  ino <silent><D-6> 6gt
  ino <silent><D-7> 7gt
  ino <silent><D-8> 8gt
  ino <silent><D-9> 9gt
  ino <silent><D-t> <C-o>:tabnew<cr>
  ino <silent><D-w> <C-o>:tabclose<cr>
  ino <silent><D-]> <C-o>:tabnext<cr>
  ino <silent><D-[> <C-o>:tabprevious<cr>
endif

lua <<EOF
function hoon_def_search()
  require 'telescope.builtin'.grep_string({search='\\+(\\+|\\$|\\*)  '.. vim.fn.expand('<cword>') .. '( |$)', use_regex=true})
end
EOF

nn <silent><leader>d :ToggleDiag<CR>
nn <silent>gh :Lspsaga lsp_finder<CR>
nn <silent><leader>ca :Lspsaga code_action<CR>
nn <silent>gs :Lspsaga hover_doc<CR>
nn <silent>g<space> :Lspsaga preview_definition<CR>
nn <silent><leader>cd :Lspsaga show_line_diagnostics<CR>
nn <silent>[e :Lspsaga diagnostic_jump_next<CR>
nn <silent>]e :Lspsaga diagnostic_jump_prev<CR>

lua <<EOF
  require('spectre').setup()
  -- vim.g.coq_settings = {
  --   auto_start = 'shut-up',
  --   completion = {
  --     always = false
  --   },
  --   display = {
  --     pum = {
  --       fast_close = false
  --     }, 
  --     icons = {
  --       mode = 'none'
  --     } 
  --   }, 
  --   keymap = { 
  --     pre_select = true,
  --     recommended = false, 
  --     bigger_preview = '', 
  --     jump_to_mark = '',
  --     eval_snips = '', 
  --     manual_complete = '', 
  --     ["repeat"] = ''
  --   },
  --   clients = {
  --     tags = { enabled = false },
  --     snippets = {
  --       enabled = false, 
  --       warn = {}, 
  --     },
  --     paths = { enabled = false },
  --     tmux = { enabled = false },
  --   },
  -- }

  require('chowcho').setup {
    icon_enabled = false, -- required 'nvim-web-devicons' (default: false)
    text_color = '#FFFFFF',
    bg_color = '#555555',
    active_border_color = '#0A8BFF',
    border_style = 'default', -- 'default', 'rounded',
    use_exclude_default = false,
  }
  require("nvim-tree").setup({
    prefer_startup_root = true, 
    sync_root_with_cwd = true, 
    respect_buf_cwd = true, 
    renderer = {
      highlight_opened_files = "name", 
      icons = {
        show = {
          file = false,
          folder = false,
          folder_arrow = false,
          git = false, 
        }
      }, 
    }, 
    update_focused_file = {
      enable = true,
      update_root = false,
      ignore_list = {
          "fzf", "help", "qf",
          "lspinfo", "undotree"
      }
    },
  })
  require("nvim-lsp-installer").setup {}
  --require'toggle_lsp_diagnostics'.init({ start_on = false })

  require'nvim-treesitter.configs'.setup {
      textsubjects = {
          enable = true,
          prev_selection = ',', 
          keymaps = {
              ['.'] = 'textsubjects-smart',
          }
      },
  }
  require('dap-go').setup()
  require("dapui").setup()
  local dap = require('dap')
  dap.adapters.codelldb = {
    type = 'server',
    port = "${port}",
    executable = {
      -- CHANGE THIS to your path!
      command = '/Users/adragomi/work/tools/codelldb/adapter/codelldb',
      args = {"--port", "${port}"},
      -- On windows you may have to uncomment this:
      -- detached = false,
    }
  }
  dap.adapters.lldb = {
    type = 'executable',
    command = '/usr/local/opt/llvm@16/bin/lldb-vscode',
    name = 'lldb'
  }

  -- dap.configurations.cpp = {
  --   {
  --     name = "Launch file",
  --     type = "codelldb",
  --     request = "launch",
  --     program = function()
  --       return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
  --     end,
  --     cwd = '${workspaceFolder}',
  --     stopOnEntry = false,
  --   },
  -- }
  -- dap.configurations.c = dap.configurations.cpp
  -- dap.configurations.rust = dap.configurations.cpp
  -- dap.configurations.rust.initCommands = function()
  --   -- Find out where to look for the pretty printer Python module
  --   local rustc_sysroot = vim.fn.trim(vim.fn.system('rustc --print sysroot'))
  --   local script_import = 'command script import "' .. rustc_sysroot .. '/lib/rustlib/etc/lldb_lookup.py"'
  --   local commands_file = rustc_sysroot .. '/lib/rustlib/etc/lldb_commands'
  --   local commands = {}
  --   local file = io.open(commands_file, 'r')
  --   if file then
  --     for line in file:lines() do
  --       table.insert(commands, line)
  --     end
  --     file:close()
  --   end
  --   table.insert(commands, 1, script_import)
  --   return commands
  -- end
  --
  -- dap.configurations.jai = dap.configurations.cpp
  -- dap.configurations.jai.initCommands = function()
  --   local commands = {}
  --   table.insert(commands, 1, 'command script import "' .. vim.env.HOME .. '/.config/lldb/jaitype.jai"')
  --   return commands
  -- end
  dap.configurations.scala = {
    {
      type = "scala",
      request = "launch",
      name = "RunOrTest",
      metals = {
        runType = "runOrTestFile",
        --args = { "firstArg", "secondArg", "thirdArg" }, -- here just as an example
      },
    },
    {
      type = "scala",
      request = "launch",
      name = "Test Target",
      metals = {
        runType = "testTarget",
      },
    },
  }

  local dap, dapui = require("dap"), require("dapui")
  local keymap_restore = {}
  dap.listeners.after.event_initialized["dapui_config"] = function()
    dapui.open()
  end
  dap.listeners.before.event_terminated["dapui_config"] = function()
    dapui.close()
  end
  dap.listeners.before.event_exited["dapui_config"] = function()
    dapui.close()
  end
  dap.listeners.after.event_initialized['me'] = function()
    for _, buf in pairs(vim.api.nvim_list_bufs()) do
      local keymaps = vim.api.nvim_buf_get_keymap(buf, 'n')
      for _, keymap in pairs(keymaps) do
        if keymap.lhs == "K" then
          table.insert(keymap_restore, keymap)
          vim.api.nvim_buf_del_keymap(buf, 'n', 'K')
        end
      end
    end
    vim.api.nvim_set_keymap('n', 'K', '<Cmd>lua require("dap.ui.widgets").hover()<CR>', { silent = true })
  end

  dap.listeners.after.event_terminated['me'] = function()
    for _, keymap in pairs(keymap_restore) do
      vim.api.nvim_buf_set_keymap(
        keymap.buffer,
        keymap.mode,
        keymap.lhs,
        keymap.rhs,
        { silent = keymap.silent == 1 }
      )
    end
    keymap_restore = {}
  end

  require('mini.comment').setup()
  require('mini.bracketed').setup({
    diagnostic = { suffix = 'd', options = { severity = vim.diagnostic.severity.ERROR, } },
    jump       = { suffix = 'j', options = {} },
    location   = { suffix = 'l', options = {} },
    quickfix   = { suffix = 'q', options = {} },
    treesitter = { suffix = 't', options = {} },
    yank       = { suffix = 'y', options = {} }, 
  })
  require('mini.surround').setup( {
    custom_surroundings = nil,
    highlight_duration = 500,
    mappings = {
      add = 'ys',
      delete = 'ds',
      find = '',
      find_left = '',
      highlight = '',
      replace = 'cs',
      update_n_lines = '',
    },
    n_lines = 20,
    search_method = 'cover',
  })
  require('mini.align').setup({
    modifiers = {
      [':'] = function(steps, opts)
        opts.split_pattern = ':+'
        table.insert(steps.pre_justify, MiniAlign.gen_step.trim())
        table.insert(steps.pre_justify, MiniAlign.gen_step.pair())
        opts.merge_delimiter = ' '
      end,
      ['='] = function(steps, opts)
        opts.split_pattern = '=+'
        table.insert(steps.pre_justify, MiniAlign.gen_step.trim())
        table.insert(steps.pre_justify, MiniAlign.gen_step.pair())
        opts.merge_delimiter = ' '
      end,
      ['>'] = function(steps, opts)
        opts.split_pattern = '=>'
        table.insert(steps.pre_justify, MiniAlign.gen_step.trim())
        table.insert(steps.pre_justify, MiniAlign.gen_step.pair())
        opts.merge_delimiter = ' '
      end,
    }
  })
  require('mini.bufremove').setup()
  require('mini.ai').setup({
    search_method = 'cover'
  })

  require('lspsaga').setup({
    lightbulb = {
      enable = false
    }, 
    symbol_in_winbar = {
      enable = false
    }, 
    beacon = {
      enable = false
    }, 
  })

  local lspconfig = require'lspconfig'
  local configs = require'lspconfig.configs'
  local util = require'lspconfig/util'

  function make_lsp_config(t)
    if false then
      coq = require 'coq'
    else
      coq = {
        lsp_ensure_capabilities = function(t2)
          return t2
        end
      }
    end
    tmp = coq.lsp_ensure_capabilities(vim.deepcopy(t))
    tmp.on_attach = function(client, bufnr)
      require'lsp_compl'.attach(client, bufnr, {
        --server_side_fuzzy_completion = true
      })
    end
    return tmp
  end

  -- lspconfig.pasls.setup(make_lsp_config({}))
  -- lspconfig.prosemd_lsp.setup(make_lsp_config({}))
  -- lspconfig.racket_langserver.setup(make_lsp_config({}))
  lspconfig.zls.setup(make_lsp_config({
    cmd = { vim.env.HOME .. '/bin/darwin/zls-0.11.0' }, 
    flags = {
      debounce_text_changes = 250, 
    },
  }))

  require'go'.setup(make_lsp_config({
    lsp_codelens = true,
    lsp_inlay_hints = {
      enable = true, 
      only_current_line = true, 
    }, 
  }))

  lspconfig.gopls.setup(make_lsp_config({
    cmd = { vim.env.HOME .. '/.gocode/bin/gopls' },
    root_dir = util.root_pattern("go.mod"), 
  }))

  -- lspconfig.denols.setup(make_lsp_config({
  --   root_dir = util.root_pattern("deno.json"),
  -- }))
  -- lspconfig.haxe_language_server.setup(make_lsp_config({}))
  -- lspconfig.leanls.setup(make_lsp_config({})).
  -- lspconfig.solang.setup(make_lsp_config({}))
  -- lspconfig.svls.setup(make_lsp_config({}))

  lspconfig.rust_analyzer.setup(make_lsp_config({
  }))
  -- require('rust-tools').setup({})
  -- lspconfig.ccls.setup(make_lsp_config({
  --   cmd = {
  --     "ccls", 
  --     "--log-file=/tmp/ccls.out", 
  --     "-v=1", 
  --   },
  --   init_options = {
  --     index = {
  --       initialBlackList = { '.*omtr_tmp.*' }
  --     }
  --   },
  --   settings = {
  --     ccls = {
  --       clang = {
  --         extraArgs = {
  --             "-isystem/usr/local/include", 
  --             "-isystem/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/../include/c++/v1", 
  --             "-isystem/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/lib/clang/11.0.3/include", 
  --             "-isystem/Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX.sdk/usr/include", 
  --             "-isystem/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/include", 
  --             "-isystem/Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX.sdk/System/Library/Frameworks}", 
  --         }, 
  --         resourceDir = "/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/lib/clang/11.0.3"
  --       }
  --     }
  --   },
  -- }))
  lspconfig.clangd.setup(make_lsp_config({
    cmd = {
      "/usr/local/opt/llvm/bin/clangd", 
      "--background-index",
      "--pch-storage=memory",
      "--all-scopes-completion",
      "--pretty",
      "--header-insertion=never",
      "-j=4",
      "--inlay-hints",
      "--header-insertion-decorators",
      "--function-arg-placeholders",
      "--completion-style=detailed", 
      "--enable-config", 
    },
    root_dir = util.root_pattern(".clangd", ".clang-tidy", ".clang-format", "compile_commands.json", "compile_flags.txt", ".git"), 
    init_option = {
      fallbackFlags = {
        "-std=c++2a"
      }, 
    }, 
  }))
  lspconfig.clojure_lsp.setup(make_lsp_config({}))
  lspconfig.intelephense.setup(make_lsp_config({
    settings = {
      intelephense = {
        files = {
          maxSize = 10000000,
        },
        format = {
          enable = true,
          braces = "psr12",
        }, 
        environment = {
          shortOpenTag = true,
          phpVersion = "8.1.8",
          includePaths = {
          },
        }
      }
    }
  }))
  -- lspconfig.svls.setup(make_lsp_config({}))
  lspconfig.pylsp.setup(make_lsp_config({
    on_init = function(client)
      client.config.settings = {
        pylsp = {
          plugins = {
            pycodestyle = {
              enabled = false, 
              select = {"E112", "E113", "E117", "E223", "E224", }
            }, 
            flake8 = {
              enabled = false, 
              ignore = {"E261"}
            }, 
            mccabe = {
              enabled= false, 
            }, 
            preload = {
              enabled= false, 
            }, 
            pyflakes = {
              enabled= false, 
            }, 
            yapf = {
              enabled= false, 
            }, 
          }
        }
      }
      client.notify('workspace/didChangeConfiguration')
    end, 
  }))

  -- lspconfig.jdtls.setup(make_lsp_config({
  --   root_dir = util.root_pattern("pom.xml", "build.xml"),
  -- }))
  lspconfig.tsserver.setup(make_lsp_config({
  }))

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
  lspconfig.lua_ls.setup(make_lsp_config({
    cmd = {sumneko_binary, "-E", sumneko_root_path .. "/main.lua"},
    settings = {
      Lua = {
        runtime = {
          version = 'LuaJIT',
          path = vim.split(package.path, ';'),
        },
        diagnostics = {
          globals = {'vim'},
        },
        workspace = {
          library = {
            [vim.fn.expand('$VIMRUNTIME/lua')] = true,
            [vim.fn.expand('$VIMRUNTIME/lua/vim/lsp')] = true,
          },
        },
      },
    },
  }))

  -- lspconfig.sourcekit.setup(make_lsp_config({}))
  -- lspconfig.solargraph.setup(make_lsp_config({
  --   settings = {
  --     solargraph = {
  --       diagnostics = false,
  --       formatting = true,
  --       autoformat = false,
  --     }
  --   },
  -- }))

  lspconfig.terraformls.setup(make_lsp_config({
  }))

  local metals_config = require("metals").bare_config()
  metals_config.settings = {
    showImplicitArguments = true,
    excludedPackages = {
      "akka.actor.typed.javadsl",
      "com.github.swagger.akka.javadsl"
    },
  }
  metals_config.on_attach = function(client, bufnr)
    require("metals").setup_dap()
  end
  local nvim_metals_group = vim.api.nvim_create_augroup("nvim-metals", { clear = true })
  vim.api.nvim_create_autocmd("FileType", {
    -- NOTE: You may or may not want java included here. You will need it if you
    -- want basic Java support but it may also conflict if you are using
    -- something like nvim-jdtls which also works on a java filetype autocmd.
    pattern = { "scala", "sbt", "java" },
    callback = function()
      require("metals").initialize_or_attach(metals_config)
    end,
    group = nvim_metals_group,
  })
  -- lspconfig.elmls.setup(make_lsp_config({
  -- }))
  -- lspconfig.html.setup(make_lsp_config({
  -- }))
  -- lspconfig.yamlls.setup(make_lsp_config({
  -- }))
  lspconfig.hoon_ls.setup(make_lsp_config({
  }))

  lspconfig.jails.setup(make_lsp_config({
  }))

  lspconfig.csharp_ls.setup{
    cmd = {
      "/Users/adragomi/.dotnet/tools/csharp-ls"
    }, 
    handlers = {
      ["textDocument/definition"] = require('csharpls_extended').handler,
    },
  }
  -- lspconfig.omnisharp.setup {
  --   cmd = {
  --     "/Users/adragomi/work/tools/omnisharp/OmniSharp",
  --     "--languageserver",
  --     "--hostPID",
  --     tostring(vim.fn.getpid())
  --   },
  --   handlers = {
  --     ["textDocument/definition"] = require('omnisharp_extended').handler,
  --   },
  --   enable_editorconfig_support = true,
  --   enable_ms_build_load_projects_on_demand = false,
  --   enable_roslyn_analyzers = false,
  --   organize_imports_on_format = false,
  --   enable_import_completion = false,
  --   sdk_include_prereleases = false,
  --   analyze_open_documents_only = true,
  -- }

  -- require "lsp_signature".setup({
  --   bind = false,
  --   doc_lines = 0,
  --   floating_window = true,
  --   floating_window_above_cur_line = true,
  --   fix_pos = false,
  --   hint_enable = false,
  --   always_trigger = true,
  --   toggle_key = nil,
  --   handler_opts = {
  --     border = "rounded"
  --   }
  -- })
  vim.api.nvim_create_autocmd('LspAttach', {
    group = vim.api.nvim_create_augroup('UserLspConfig', {}),
    callback = function(ev)
      -- Enable completion triggered by <c-x><c-o>
      vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'
      vim.bo[ev.buf].completefunc = 'v:lua.vim.lsp.omnifunc'
    end,
  })

  require('telescope').setup{
    extensions = {
      fzy_native = {
        override_generic_sorter = true,
        override_file_sorter = true,
      }, 
      fzf = {
        fuzzy = true,
        override_generic_sorter = true,
        override_file_sorter = true,
        case_mode = "smart_case",
      }
    }, 
    highlight = {
      enable = false
    }, 
    defaults = {
      mappings = {
        n = {
    	    ['<C-d>'] = require('telescope.actions').delete_buffer
        },
        i = {
          ["<C-h>"] = "which_key", 
          ['<C-d>'] = require('telescope.actions').delete_buffer
        }
      }, 
      vimgrep_arguments = {
        'rg',
        '--color=never',
        '--no-heading',
        '--with-filename',
        '--line-number',
        '--column',
        '--smart-case'
      },
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
      preview = false, 
      grep_previewer = require'telescope.previewers'.vim_buffer_vimgrep.new,
      qflist_previewer = require'telescope.previewers'.vim_buffer_qflist.new,
    }
  }
  require('telescope').load_extension('fzf')
EOF

" call ddc#custom#patch_global('ui', 'native')
" call ddc#custom#patch_global('sources', ['around', 'nvim-lsp', 'buffer'])
" call ddc#custom#patch_global('sourceOptions', #{
"       \ _: #{
"       \   matchers: ['matcher_head'],
"       \   sorters: ['sorter_rank']},
"       \ })
" " <TAB>: completion.
" inoremap <silent><expr> <TAB>
" \ pumvisible() ? '<C-n>' :
" \ (col('.') <= 1 <Bar><Bar> getline('.')[col('.') - 2] =~# '\s') ?
" \ '<TAB>' : ddc#map#manual_complete()
" " <S-TAB>: completion back.
" inoremap <expr><S-TAB>  pumvisible() ? '<C-p>' : '<C-h>'
" call ddc#enable()

" function! s:check_back_space() abort
"   let col = col('.') - 1
"   return !col || getline('.')[col - 1] =~ '\s'
" endfunction
"
" " make tab open coq
" inoremap <silent><expr> <Tab>
"   \ pumvisible() ? "\<C-n>" :
"   \ <SID>check_back_space() ? "\<Tab>" :
"   \ "\<C-x>\<C-u>"

lua <<EOF
local chainy_tab = function()
  -- if vim.fn.pumvisible() ~= 0 then
  --   if vim.fn.complete_info({ "selected" }).selected ~= -1 then
  --     return "<c-y>"
  --   else
  --     return "<c-n><c-y><c-e>"
  --   end
  -- else
  --   return "<tab>"
  -- end

  if vim.fn.pumvisible() ~= 0 then
    vim.api.nvim_eval([[feedkeys("\<c-n>", "n")]])
    return
  else
    local col = vim.fn.col('.') - 1
    if col == 0 or vim.fn.getline('.'):sub(col, col):match('%s') then
      vim.api.nvim_eval([[feedkeys("\<tab>", "n")]])
      return
    else
      vim.api.nvim_eval([[feedkeys("\<c-x>\<c-o>", "n")]])
      return
    end
  end
end
local chainy_esc = function()
  if vim.fn.pumvisible() ~= 0 then
    vim.api.nvim_eval([[feedkeys("\<c-e>\<Esc>", "n")]])
    return
  else
    vim.api.nvim_eval([[feedkeys("\<Esc>", "n")]])
    return
  end
end
local chainy_cc = function()
  if vim.fn.pumvisible() ~= 0 then
    vim.api.nvim_eval([[feedkeys("\<c-e>\<c-c>", "n")]])
    return
  else
    vim.api.nvim_eval([[feedkeys("\<c-c>", "n")]])
    return
  end
end
local chainy_bs = function()
  if vim.fn.pumvisible() ~= 0 then
    vim.api.nvim_eval([[feedkeys("\<c-e>\<BS>", "n")]])
    return
  else
    vim.api.nvim_eval([[feedkeys("\<BS>", "n")]])
    return
  end
end
local chainy_cr = function()
  if vim.fn.pumvisible() ~= 0 then
    if vim.fn.complete_info() == -1 then
      vim.api.nvim_eval([[feedkeys("\<c-e>\<CR>", "n")]])
      return
    else
      vim.api.nvim_eval([[feedkeys("\<c-y>", "n")]])
      return
    end
  else
    vim.api.nvim_eval([[feedkeys("\<CR>", "n")]])
    return
  end
end
local chainy_stab = function()
  if vim.fn.pumvisible() ~= 0 then
    vim.api.nvim_eval([[feedkeys("\<c-p>", "n")]])
    return
  else
    vim.api.nvim_eval([[feedkeys("\<BS>", "n")]])
    return
  end
end
vim.keymap.set("i", "<Esc>", chainy_esc, { silent=true, expr = true, noremap = true })
vim.keymap.set("i", "<C-c>", chainy_cc, { silent=true, expr = true, noremap = true })
vim.keymap.set("i", "<BS>", chainy_bs, { silent=true, expr = true, noremap = true })
vim.keymap.set("i", "<CR>", chainy_cr, { silent=true, expr = true, noremap = true })
vim.keymap.set("i", "<Tab>", chainy_tab, { silent=true, expr = true, noremap = true })
vim.keymap.set("i", "<S-Tab>", chainy_stab, { silent=true, expr = true, noremap = true })
EOF

lua <<EOF
local move_left = function()
  require("move").move(1)
end
local move_right = function()
  require("move").move(2)
end
vim.keymap.set("n", "<M-h>", move_left, { silent=true, expr = true, noremap = true })
vim.keymap.set("n", "<M-l>", move_right, { silent=true, expr = true, noremap = true })
EOF

nmap <C-p> <cmd>lua require('telescope.builtin').find_files()<cr> 
nmap <leader>1 :NvimTreeFindFileToggle<cr> 
"nmap <leader>g <cmd>lua require('telescope.builtin').grep_string({ search = vim.fn.input('Grep >' ) })<cr>
nmap <leader>g <cmd>lua require('telescope.builtin').live_grep()<cr>
nmap <leader>s <cmd>lua require('telescope.builtin').lsp_workspace_symbols({file_encoding='utf-8'})<cr>
nmap <leader>5 <cmd>lua require('telescope.builtin').buffers()<cr> 
nmap <leader>6 <cmd>lua require('telescope.builtin').find_files({cwd= $HOME . '/Dropbox/personal/notes/'})<cr> 

lua <<EOF
vim.keymap.set('n', '<F7>', function() require('dap').continue() end)
vim.keymap.set('n', '<S-F7>', function() require('dap').terminate() end)
vim.keymap.set('n', '<C-F7>', function() require('dap').restart() end)
vim.keymap.set('n', '<C-F10>', function() require('dap').run_to_cursor() end)
vim.keymap.set('n', '<F10>', function() require('dap').step_over() end)
vim.keymap.set('n', '<F11>', function() require('dap').step_into() end)
vim.keymap.set('n', '<S-F11>', function() require('dap').step_out() end)
vim.keymap.set('n', '<F9>', function() require('dap').toggle_breakpoint() end)
vim.keymap.set('n', '<Leader>B', function() require('dap').set_breakpoint() end)
vim.keymap.set('n', '<Leader>lp', function() require('dap').set_breakpoint(nil, nil, vim.fn.input('Log point message: ')) end)
vim.keymap.set('n', '<Leader>dr', function() require('dap').repl.open() end)
vim.keymap.set('n', '<Leader>dl', function() require('dap').run_last() end)
vim.keymap.set({'n', 'v'}, '<Leader>dh', function()
  require('dap.ui.widgets').hover()
end)
vim.keymap.set({'n', 'v'}, '<Leader>dp', function()
  require('dap.ui.widgets').preview()
end)
vim.keymap.set('n', '<Leader>df', function()
  local widgets = require('dap.ui.widgets')
  widgets.centered_float(widgets.frames)
end)
vim.keymap.set('n', '<Leader>ds', function()
  local widgets = require('dap.ui.widgets')
  widgets.centered_float(widgets.scopes)
end)
EOF

lua <<EOF
--   require("cutlass").setup({
--     cut_key = 'x', 
--     override_del = true, 
--     exclude = {}
--   })
  require'nvim-treesitter.install'.compilers = { "clang" }
  require'nvim-treesitter.configs'.setup {
    highlight = {
      enable = true,
      disable = {},
      additional_vim_regex_highlighting = true,
    },
    force_unix_shell = true, 
    incremental_selection = {
      enable = true, 
      keymaps = {
        init_selection = "<C-s>",
        node_incremental = "<C-s>",
        scope_incremental = "grc",
        node_decremental = "grm"
      }
    }
  }
  local parser_config = require "nvim-treesitter.parsers".get_parser_configs()
  parser_config.jai = {
    install_info = {
      -- url = "https://github.com/adragomir/tree-sitter-jai", -- local path or git repo
      url = "/Users/adragomi/temp/tree-sitter-jai-new", -- local path or git repo
      files = {"src/parser.c", "src/scanner.cc"},
      -- optional entries:
      branch = "adragomi",
      generate_requires_npm = true,
      requires_generate_from_grammar = false, -- if folder contains pre-generated src/parser.c
    },
    filetype = "jai", -- if filetype does not match the parser name
  }
EOF
endif

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
let g:clang_format#command = "/usr/local/bin/clang-format"
let g:clang_format#detect_style_file = 1
let javaScript_fold=0
let g:vim_json_syntax_conceal = 0
let g:terraform_align = 1
let g:terraform_fmt_on_save = 1

" does not work, see https://github.com/neovim/neovim/issues/1716
" for now, replaced with SudaWrite
com! -bar -nargs=0 W  silent! exec "write !sudo tee % >/dev/null"  | silent! edit!
com! -bar -nargs=0 WX silent! exec "write !chmod a+x % >/dev/null" | silent! edit!
" typos
com! -bang E e<bang>
com! -bang Q q<bang>
com! -bang QA qa<bang>
com! -bang Qa qa<bang>
com! -bang Wa wa<bang>
com! -bang WA wa<bang>
com! -bang Wq wq<bang>
com! -bang WQ wq<bang>

hi default hi_MarkInsertStop ctermbg=128 ctermfg=white cterm=bold
hi default hi_MarkChange ctermbg=160 ctermfg=154 cterm=underdashed
hi default hi_MarkBeforeJump ctermbg=23 ctermfg=white cterm=undercurl,bold

lua <<EOF
local jump_ns = vim.api.nvim_create_namespace("jump_ns")
local change_ns = vim.api.nvim_create_namespace("change_ns")
local insert_ns = vim.api.nvim_create_namespace("insert_ns")

function mark_on(ns, mark, highlight)
  local bufnr = vim.api.nvim_get_current_buf()
  vim.api.nvim_buf_clear_namespace(bufnr, ns, 0, -1)
  local pos = vim.api.nvim_buf_get_mark(bufnr, mark)
  if pos ~= nil and (pos[1] ~= 0 and pos[2] ~= 0) then
    local pos1 = {pos[1] - 1, pos[2]}
    local pos2 = {pos[1] - 1, pos[2]}
    local lines = vim.api.nvim_buf_get_lines(bufnr, pos1[1], pos2[1]+1, false)
    if lines ~= nil and #lines > 0 then
      local length = lines[1]:len()
      if pos1[2] == length then
        pos1[2] = pos1[2] - 1
      end
      vim.highlight.range(bufnr, ns, highlight, pos1, pos2, {inclusive = true, priority=10000})
    end
  end
end
function mark_on_move()
  mark_on(jump_ns, '`', 'hi_MarkBeforeJump')
end
function mark_on_changed()
  mark_on(change_ns, '.', 'hi_MarkChange')
end
function mark_on_insert_stop()
  mark_on(insert_ns, '^', 'hi_MarkInsertStop')
end
EOF

" aug marks
"   au!
"   au CursorMoved * silent! lua mark_on_move()
"   au BufModifiedSet,TextChangedP,TextChangedI,TextChanged * lua mark_on_changed()
"   au InsertLeave * silent! lua mark_on_insert_stop()
" aug END

lua << EOF
function dump(o)
   if type(o) == 'table' then
      local s = '{ '
      for k,v in pairs(o) do
         if type(k) ~= 'number' then k = '"'..k..'"' end
         s = s .. '['..k..'] = ' .. dump(v) .. ','
      end
      return s .. '} '
   else
      return tostring(o)
   end
end

local make_diagnostics_ns = vim.api.nvim_create_namespace("make_diagnostics_ns")

function append_make_diagnostics()
  local bufnr = vim.api.nvim_get_current_buf()
  local ql = vim.fn.getqflist()
  qlb = {}
  for i, qli in pairs(ql) do
    if qli['bufnr'] == bufnr and qli['lnum'] > 0 and qli['col'] > 0 then
      qlb[#qlb+1] = qli
    end
  end
  local dqlb = vim.diagnostic.fromqflist(qlb)
  vim.diagnostic.reset(make_diagnostics_ns, bufnr)
  vim.diagnostic.set(make_diagnostics_ns, bufnr, dqlb)
end

EOF

let g:save_cr_map = {}
aug all_buffers
  au! 
  au!
  au VimLeavePre * execute 'silent! 1,' . bufnr('$') . 'bwipeout!'
  au! CmdwinEnter * 
    \ let g:save_cr_map = SaveMap('<cr>') |
    \ execute ':silent! :unmap <cr>'
  au! CmdwinLeave *
    \ execute ':call RestoreMap(g:save_cr_map)'
  au! WinEnter,BufWinEnter *
    \ if &ft == "qf" |
    \     let g:save_cr_map = SaveMap('<cr>') |
    \     execute ':silent! unmap <cr>' |
    \ else |
    \     execute ':silent! call RestoreMap(g:save_cr_map)' |
    \ endif
  au! WinLeave * 
    \ if &ft == "qf" |
    \     execute ':call RestoreMap(g:save_cr_map)' |
    \ endif
aug END

aug settings
  au! ModeChanged *:[iiI]* hi ModeMsg guifg=#ff0000
  au BufNewFile,BufRead *.Jenkinsfile set filetype=groovy
  autocmd BufRead ~/work/DPO/*.class set filetype=php
  au BufNewFile,BufRead *.jai set filetype=jai
  au BufNewFile,BufRead *.ino set filetype=cpp
  au BufNewFile,BufRead *.pde set filetype=cpp
  au FileType qf wincmd J
  au FileType jai setlocal et ts=4 sw=4 sts=4 isk=a-z,A-Z,48-57,_ commentstring=//\ %s | compiler jai
  au QuickFixCmdPost jaimake lua append_make_diagnostics()
  au FileType python setlocal et ts=4 sw=4
  au FileType java setlocal et ts=2 sw=2
  au FileType ruby,haml,eruby,yaml,html,sass setlocal ai sw=2 sts=2 et
  au FileType javascript setlocal ai sw=4 ts=4 sts=4 et
  au FileType c setlocal ts=4 sw=4 sts=4 isk=a-z,A-Z,48-57,_ commentstring=//\ %s
  au FileType cpp setlocal ts=4 sw=4 sts=4 isk=a-z,A-Z,48-57,_ commentstring=//\ %s
  au FileType openscad setlocal ts=4 sw=4 sts=4 commentstring=//\ %s
  au FileType qf setlocal colorcolumn=0 nolist nocursorline nowrap
  au FileType go setlocal noexpandtab ts=4 sw=4 sts=4
  au FileType sh setlocal iskeyword=35,36,45,46,48-57,64,65-90,97-122,_
  au FileType php setlocal ts=4 sw=4 sts=4 isk=a-z,A-Z,48-57,_ commentstring=//\ %s
aug END

" completions
if !exists('g:vscode')
aug completions
  au!
  au FileType c setlocal omnifunc=v:lua.vim.lsp.omnifunc
  au FileType cpp setlocal omnifunc=v:lua.vim.lsp.omnifunc
  au FileType python setlocal omnifunc=v:lua.vim.lsp.omnifunc
  au FileType ruby setlocal omnifunc=v:lua.vim.lsp.omnifunc
  au FileType haskell setlocal omnifunc=v:lua.vim.lsp.omnifunc
  au FileType php setlocal omnifunc=v:lua.vim.lsp.omnifunc
  au FileType java setlocal omnifunc=v:lua.vim.lsp.omnifunc
  au FileType rust setlocal omnifunc=v:lua.vim.lsp.omnifunc
  au FileType javascript setlocal omnifunc=v:lua.vim.lsp.omnifunc
  au FileType typescript setlocal omnifunc=v:lua.vim.lsp.omnifunc
  au FileType go setlocal omnifunc=v:lua.vim.lsp.omnifunc
  au FileType markdown setlocal nospell
  au FileType checkhealth setlocal nospell
aug END
endif

map <Leader>j :let g:jai_entrypoint = expand('%')<Enter> :call UpdateJaiMakeprg()<Enter>
map <Leader>u :call UpdateJaiMakeprg()<Enter>

aug hoon_mappings
  au!
  au FileType hoon nn <silent><leader>d   <cmd>lua hoon_def_search()<CR>
aug END

let hostfile=$HOME . '/.vim/hosts/' . hostname() . ".vim"
if filereadable(hostfile)
  exe 'source ' . hostfile
endif

