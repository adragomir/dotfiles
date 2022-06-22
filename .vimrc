if has("mac")
  let g:os_bin_path = "darwin"
  let g:python2_host_prog = '/usr/local/bin/python'
  let g:python3_host_prog = '/usr/local/opt/python@3.10/bin/python3'
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
    let g:ruby_host_prog = 'c:\tools\ruby30\bin\neovim-ruby-host.bat'
  endif
endif

set guifont=Jetbrains\ Mono:h12

if &term =~ '^screen'
  execute "set <xUp>=\e[1;*A"
  execute "set <xDown>=\e[1;*B"
  execute "set <xRight>=\e[1;*C"
  execute "set <xLeft>=\e[1;*D"
endif
let g:do_filetype_lua=1
let g:did_load_filetypes=0

if exists('g:neovide') == 1
  let g:neovide_cursor_animation_length=0.0
  let g:neovide_cursor_trail_length=0.0
  colorscheme monochrome2
else
  colorscheme monochrome
endif

filetype on
syntax on
set shm+=I
set mouse=a
set sr
set noswf
set nu
set ww=<,>,h,l,b,s,~,[,]
set ic scs gd
set lbr bri briopt=sbr sbr=…
set stl=%<%f\ (%{&ft},%{&ff})\ (%{&ts},%{&sts},%{&sw},%{&et?'et':'noet'})\ %-4(%m%)%=%-19(%3l,%02c%03V,%o\|%B%)
set ve+=block
set novb noeb
set wa
set isk=@,-,>,48-57,128-167,224-235,_
set isk-=.
set showtabline=0
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
set guicursor=a:blinkon0
set t_Co=256
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
let g:loaded_remote_plugins = 1
let g:loaded_gzip=1
let g:loaded_spellfile_plugin=1
let g:loaded_shada_plugin = 1
let g:loaded_vimballPlugin=1
"let g:loaded_netrwPlugin = 1
let g:netrw_banner=0
let g:netrw_altv=1
let g:netrw_browse_split=4
"let g:loaded_netrwFileHandlers = 1
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
" languages
if !exists('g:vscode')
" lang
Plug 'mfussenegger/nvim-jdtls'
Plug 'ray-x/go.nvim'
Plug 'pangloss/vim-javascript', { 'dir': stdpath('data') . '/bundle/javascript', 'for': 'javascript' }
Plug 'gabrielelana/vim-markdown', { 'dir': stdpath('data') . '/bundle/markdown', 'for': ['md', 'markdown']}
Plug 'rust-lang/rust.vim', { 'dir': stdpath('data') . '/bundle/rust', 'for': 'rust' }
Plug 'sirtaj/vim-openscad', { 'dir': stdpath('data') . '/bundle/openscad' }
Plug 'pearofducks/ansible-vim'
Plug 'stephpy/vim-yaml', { 'for': 'yaml' }
Plug 'rhysd/vim-clang-format'
Plug 'hashivim/vim-terraform'
Plug 'leafgarland/typescript-vim'
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
" lsp
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
" debug
Plug 'mfussenegger/nvim-dap'
Plug 'theHamsta/nvim-dap-virtual-text'
Plug 'leoluz/nvim-dap-go'
Plug 'rcarriga/nvim-dap-ui'
" syntax
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'nvim-treesitter/nvim-treesitter-textobjects'
Plug 'RRethy/nvim-treesitter-textsubjects'
Plug 'ms-jpq/coq_nvim', {'branch': 'coq'}
" tools
Plug 'tpope/vim-fugitive', { 'dir': stdpath('data') . '/bundle/fugitive' }
Plug 'duane9/nvim-rg'
Plug 'vim-scripts/a.vim', { 'dir': stdpath('data') . '/bundle/a', 'do': 'patch -p1 < ~/.vim/patches/a.patch' }
Plug 'antoinemadec/FixCursorHold.nvim'
let g:cursorhold_updatetime = 100
" Plug 'lukas-reineke/indent-blankline.nvim', { 'dir': stdpath('data') . '/bundle/indent-blankline.nvim' }
Plug 'vim-scripts/DetectIndent', { 'dir': stdpath('data') . '/bundle/detectindent' }
Plug 't9md/vim-choosewin'
Plug 'tpope/vim-endwise', { 'dir': stdpath('data') . '/bundle/endwise' }
Plug 'echasnovski/mini.nvim'
Plug 'isa/vim-matchit', { 'dir': stdpath('data') . '/bundle/matchit' }

endif
call plug#end()

function! SyntaxAttr()
  let synid = ""
  let guifg = ""
  let guibg = ""
  let gui   = ""

  let id1  = synID(line("."), col("."), 1)
  let tid1 = synIDtrans(id1)

  if synIDattr(id1, "name") != ""
    let synid = "group: " . synIDattr(id1, "name")
    if (tid1 != id1)
      let synid = synid . '->' . synIDattr(tid1, "name")
    endif
    let id0 = synID(line("."), col("."), 0)
    if (synIDattr(id1, "name") != synIDattr(id0, "name"))
      let synid = synid .  " (" . synIDattr(id0, "name")
      let tid0 = synIDtrans(id0)
      if (tid0 != id0)
        let synid = synid . '->' . synIDattr(tid0, "name")
      endif
      let synid = synid . ")"
    endif
  endif

  " Use the translated id for all the color & attribute lookups; the linked id yields blank values.
  if (synIDattr(tid1, "fg") != "" )
    let guifg = " guifg=" . synIDattr(tid1, "fg") . "(" . synIDattr(tid1, "fg#") . ")"
  endif
  if (synIDattr(tid1, "bg") != "" )
    let guibg = " guibg=" . synIDattr(tid1, "bg") . "(" . synIDattr(tid1, "bg#") . ")"
  endif
  if (synIDattr(tid1, "bold"     ))
    let gui   = gui . ",bold"
  endif
  if (synIDattr(tid1, "italic"   ))
    let gui   = gui . ",italic"
  endif
  if (synIDattr(tid1, "reverse"  ))
    let gui   = gui . ",reverse"
  endif
  if (synIDattr(tid1, "inverse"  ))
    let gui   = gui . ",inverse"
  endif
  if (synIDattr(tid1, "underline"))
    let gui   = gui . ",underline"
  endif
  if (gui != ""                  )
    let gui   = substitute(gui, "^,", " gui=", "")
  endif

  echohl MoreMsg
  let message = synid . guifg . guibg . gui
  if message == ""
    echohl WarningMsg
    let message = "<no syntax group here>"
  endif
  echo message
  echohl None
endfunction
map gm :call SyntaxAttr()<CR>

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
fu! s:VSetSearch()
  let temp = @@
  norm! gvy
  let @/ = '\V' . substitute(escape(@@, '\'), '\n', '\\n', 'g')
  let @@ = temp
endf

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

fu! ToggleSideEffects()
  if mapcheck("dd", "n") == ""
    no dd "_dd
    no D "_D
    no d "_d
    no X "_X
    no x "_x
    vn p "_dP
    echo 'side effects off'
  else
    unm dd
    unm D
    unm d
    unm X
    unm x
    vu p
    echo 'side effects on'
  endif
endf

nn ,, :call ToggleSideEffects()<CR>

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
nn r <nop>
nn R <nop>
nn L <nop>
nn M <nop>
nn \| <nop>
nn ( <nop>
nn ) <nop>
nn [ <nop>
nn ] <nop>
nn { <nop>
nn } <nop>
nn ]] <nop>
nn [[ <nop>
nn [] <nop>
nn ][ <nop>
nn <silent> Q <nop>
map  <MiddleMouse>  <nop>
map  <2-MiddleMouse>  <nop>
map  <3-MiddleMouse>  <nop>
map  <4-MiddleMouse>  <nop>
im  <MiddleMouse>  <nop>
im  <2-MiddleMouse>  <nop>
im  <3-MiddleMouse>  <nop>
im  <4-MiddleMouse>  <nop>
lua <<EOF
vim.api.nvim_set_keymap("", "<F1>", "<nop>", {noremap = true})
for i=1,24 do
  for j, t in ipairs({"i", "c"}) do
    vim.api.nvim_set_keymap(t, "<F" .. i .. ">", "<nop>", {noremap = true})
    vim.api.nvim_set_keymap(t, "<S-F" .. i .. ">", "<nop>", {noremap = true})
  end
end
EOF


map <leader>y "*y
no <C-a> <Home>
no <C-e> <End>

silent! nunmap Y
vn y myy`y
vn Y myY`y

no gV `<v'>
no g> `<v'>
no g< `<v'>
no g] `[v']
no g[ `[v']

no j gj
no k gk
no <up> gk
no <down> gj
nn D d$
nn * *<c-o>

vn J j
vn K k
nn <Del> "_x

ino <c-a> <esc>I
cno <c-a> <home>
ino <c-e> <esc>A
cno <c-e> <end>
ino <c-c> <Esc>


nn <silent> <leader>/ :Rg <cword><cr>

nn <cr> :nohlsearch<cr>
nn <m-Down> :cnext<cr>zz
nn <m-Up> :cprevious<cr>zz

nn ' `
xn ' `
map <leader>' ``
map <leader>. `.
map <leader>] `]
map <leader>> `>
map <leader>` `^

vn p "_dP
vn r "_dP
ino <C-u> <esc>mzgUiw`za
vn * :<C-u>call <SID>VSetSearch()<CR>//<CR><c-o>
vn # :<C-u>call <SID>VSetSearch()<CR>??<CR><c-o>

nn <C-h> <c-w>h
nn <C-j> <c-w>j
nn <C-k> <c-w>k
nn <C-l> <c-w>l

ino <S-Space> <Space>
ino <C-Space> <C-o>m`
ino <silent> <Home> <C-o>:call HomeKey()<CR>
nn <silent> <Home> :call HomeKey()<CR>
no <Space> m`

nm <MapLocalLeader>h :AT<CR>

nm - <Plug>(choosewin)


if !exists('g:vscode')
nn <silent> gd          <cmd>lua vim.lsp.buf.definition()<CR>
nn <Leader>T            :lua require'lsp_extensions'.inlay_hints()<cr>
nn <silent> K           <cmd>lua vim.lsp.buf.signature_help()<CR>
" nn <silent> gi          <cmd>lua vim.lsp.buf.implementation()<CR>
" nn <silent> gr          <cmd>lua vim.lsp.buf.references()<CR>
nn <silent> gr          <cmd>lua require'telescope.builtin'.lsp_references{}<CR> 
" <cmd>lua require'telescope.builtin'.lsp_workspace_symbols{}<CR> 
" <cmd>lua require'telescope.builtin'.lsp_document_symbols{}<CR> 
" nn <silent> gsd         <cmd>lua vim.lsp.buf.document_symbol()<CR>
nn <silent> gsd         <cmd>lua require'telescope.builtin'.lsp_document_symbols{}<CR>  
nn <silent> gsw         <cmd>lua vim.lsp.buf.workspace_symbol()<CR>
nn <silent> <leader>rn  <cmd>lua vim.lsp.buf.rename()<CR>
nn <silent> <leader>f   <cmd>lua vim.lsp.buf.formatting()<CR>
nn <silent> <leader>ca  <cmd>lua vim.lsp.buf.code_action()<CR>
nn <silent> [c          :NextDiagnostic<CR>
nn <silent> ]c          :PrevDiagnostic<CR>
nn <silent> <space>d    :OpenDiagnostic<CR>

lua <<EOF
function hoon_def_search()
  require 'telescope.builtin'.grep_string({search='\\+(\\+|\\$|\\*)  '.. vim.fn.expand('<cword>') .. '( |$)', use_regex=true})
end
EOF
nn <silent><leader>d   <cmd>lua hoon_def_search()<CR>

nn <silent>gh :Lspsaga lsp_finder<CR>
nn <silent><leader>ca :Lspsaga code_action<CR>
nn <silent>K :Lspsaga signature_help<CR>
nn <silent>gs :Lspsaga hover_doc<CR>
nn <silent>g<space> :Lspsaga preview_definition<CR>
nn <silent><leader>cd :Lspsaga show_line_diagnostics<CR>
nn <silent>[e :Lspsaga diagnostic_jump_next<CR>
nn <silent>]e :Lspsaga diagnostic_jump_prev<CR>

let g:coq_settings = {
        \ 'auto_start': 'shut-up', 
        \ 'display.pum.fast_close': v:false,
        \ 'display.icons.mode': 'none', 
        \ 'clients.tags.enabled': v:false,  
        \ 'clients.snippets.enabled': v:false,
        \ 'clients.snippets.warn': {},
        \ 'clients.paths.enabled': v:false, 
        \ 'clients.tmux.enabled': v:false, 
        \ 'keymap.bigger_preview': '', 
        \ 'keymap.jump_to_mark': ''
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
  require('mini.bufremove').setup()

  local saga = require 'lspsaga'
  saga.init_lsp_saga()

  local lspconfig = require'lspconfig'
  local configs = require'lspconfig.configs'
  local util = require'lspconfig/util'

  local coq = require 'coq'
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

  require'go'.setup()
  lspconfig.gopls.setup{
    on_attach = M.on_attach;
    root_dir = util.root_pattern("go.mod");
  }

  lspconfig.denols.setup{
    on_attach = M.on_attach;
    root_dir = util.root_pattern("deno.json");
  }
  lspconfig.haxe_language_server.setup{ }
  lspconfig.leanls.setup{ }
  lspconfig.solang.setup{ }
  lspconfig.svls.setup{ }

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
  lspconfig.clojure_lsp.setup{ }
  lspconfig.intelephense.setup{
    on_attach = M.on_attach;
  }
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
      enable = true,
      disable = {},
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

  require'lsp_extensions'.inlay_hints{
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

aug marks
  au!
  au CursorMoved * silent! lua mark_on_move()
  au BufModifiedSet,TextChangedP,TextChangedI,TextChanged * silent! lua mark_on_changed()
  au InsertLeave * silent! lua mark_on_insert_stop()
aug END

let g:save_cr_map = {}
aug all_buffers
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
  au!
  au BufNewFile,BufRead *.Jenkinsfile set filetype=groovy
  au BufNewFile,BufRead *.ino set filetype=cpp
  au BufNewFile,BufRead *.pde set filetype=cpp
  au FileType python setlocal et ts=4 sw=4
  au FileType java setlocal et ts=2 sw=2
  au FileType ruby,haml,eruby,yaml,html,sass setlocal ai sw=2 sts=2 et
  au FileType javascript setlocal ai sw=4 ts=4 sts=4 et
  au FileType c setlocal ts=4 sw=4 sts=4 commentstring=//\ %s
  au FileType cpp setlocal ts=4 sw=4 sts=4 commentstring=//\ %s
  au FileType openscad setlocal ts=4 sw=4 sts=4 commentstring=//\ %s
  au FileType qf setlocal colorcolumn=0 nolist nocursorline nowrap
  au FileType go setlocal noexpandtab ts=4 sw=4 sts=4
  au FileType sh setlocal iskeyword=35,36,45,46,48-57,64,65-90,97-122,_
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
  au FileType scala,sbt lua require('metals').initialize_or_attach({})
  au FileType rust setlocal omnifunc=v:lua.vim.lsp.omnifunc
  au FileType javascript setlocal omnifunc=v:lua.vim.lsp.omnifunc
  au FileType typescript setlocal omnifunc=v:lua.vim.lsp.omnifunc
  au FileType go setlocal omnifunc=v:lua.vim.lsp.omnifunc
  au FileType markdown setlocal nospell
  au FileType checkhealth setlocal nospell
  au BufEnter,BufWinEnter,TabEnter *.rs :lua require'lsp_extensions'.inlay_hints{}
  au CursorHold,CursorHoldI *.rs :lua require'lsp_extensions'.inlay_hints{ only_current_line = true }
aug END
endif

aug mappings
  au!
aug END

let hostfile=$HOME . '.vim/hosts/' . hostname() . ".vim"
if filereadable(hostfile)
  exe 'source ' . hostfile
endif

