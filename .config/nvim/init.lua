if vim.fn.has("mac") == 1 then
  vim.g.os_bin_path = "darwin"
  vim.g.python3_host_prog = '/opt/homebrew/opt/python@3.12/bin/python3.12'
  vim.g.ruby_host_prog = '/opt/homebrew/lib/ruby/gems/3.3.0/bin/neovim-ruby-host'
  vim.g.node_host_prog = '/opt/homebrew/lib/node_modules/neovim/bin/cli.js'
elseif vim.fn.has("wsl") then
  vim.g.os_bin_path = "linux"
  vim.g.python2_host_prog = '/usr/local/bin/python'
  vim.g.python3_host_prog = '/home/linuxbrew/.linuxbrew/Cellar/python@3.9/3.9.2_1/bin/python3'
elseif vim.fn.has("win64") then
  if vim.env.MSYSTEM == "MSYS" then
    vim.g.os_bin_path = "windows"
    vim.o.shell = "/usr/bin/zsh"
  else
    vim.g.os_bin_path = "windows"
    if vim.fn.has("win64") then
      vim.o.shell = "powershell"
    else
      vim.o.shell = "pwsh"
    end
    vim.o.shellquote = ""
    vim.o.shellpipe = "\\|"
    vim.o.shellxquote = ""
    vim.o.shellcmdflag = "-NoLogo -NoProfile -ExecutionPolicy RemoteSigned -Command"
    vim.o.shellredir = "| Out-File -Encoding UTF8"
  end
end

if vim.regex("^screen"):match_str(vim.env.TERM) then
  vim.fn.execute("set <xUp>=\\e[1;*A")
  vim.fn.execute("set <xDown>=\\e[1;*B")
  vim.fn.execute("set <xRight>=\\e[1;*C")
  vim.fn.execute("set <xLeft>=\\e[1;*D")
end

function GuiTabLabel(n)
  local tab_num = n
  local win_num = vim.fn.tabpagewinnr(n)
  return tab_num .. ' ' .. vim.fn.fnamemodify(vim.fn.getcwd(win_num, tab_num), ':t')
end

function MyTabLine()
  local s = ""
  for i = 0,(vim.fn.tabpagenr("$") - 1) do
    if i + 1 == vim.fn.tabpagenr() then
      s = s .. '%#TabLineSel#'
    else
      s = s .. '%#TabLine#'
    end
    s = s .. '%' .. (i + 1) .. 'T'
    s = s .. ' %{v:lua.GuiTabLabel(' .. (i + 1) .. ')}'

    if i + 1 == vim.fn.tabpagenr() then
      s = s .. ' *'
    else
      s = s .. ' '
    end
  end
  s = s .. '%#TabLineFill#%T'
  if vim.fn.tabpagenr('$') > 1 then
    s = s .. '%=%#TabLine#%999Xclose'
  end
  return s
end

if vim.fn.exists("g:neovide") == 1 then
  vim.o.tabline= "%!v:lua.MyTabLine()"
  vim.o.guifont="Consolas:h12"
  -- vim.o.guifont="Iosevka Custom:h11"
  vim.o.linespace=-2
  vim.g.neovide_cursor_animation_length=0.0
  vim.g.neovide_cursor_trail_length=0.0
  vim.g.neovide_input_use_logo=1
  vim.cmd [[colorscheme jb]]
  vim.keymap.set("c", "<D-v>", "<C-r>+", {silent = true, noremap = true})
  vim.keymap.set("i", "<D-v>", "<C-r>+", {silent = true, noremap = true})
  vim.keymap.set("i", "<D-v>", "<C-r>+", {silent = true, noremap = true})
  vim.keymap.set("v", "<D-c>", "y", {silent = true})
  vim.o.guicursor="a:block-blinkon0-Cursor"
  vim.g.neovide_scroll_animation_far_lines = 9999
  vim.g.neovide_scroll_animation_length = 0.0
  vim.g.neovide_hide_mouse_when_typing = false
  vim.g.neovide_cursor_animation_length = 0.0
  vim.g.neovide_cursor_trail_size = 0.0
  vim.g.neovide_cursor_animate_in_insert_mode = false
  vim.g.neovide_cursor_animate_command_line = false
else
  vim.cmd [[colorscheme jb]]
  vim.o.guicursor="a:block-blinkon0-Cursor"
end
vim.o.termguicolors = true
vim.o.shortmess= vim.o.shortmess .. "I"
vim.o.mouse="a"
vim.o.swapfile = false
vim.o.number = true
vim.o.whichwrap="<,>,h,l,b,s,~,[,]"
vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.gdefault = true
vim.o.linebreak = true
vim.o.breakindent = true
vim.o.breakindentopt="sbr"
vim.o.showbreak="…"
vim.o.statusline=[[%<%f (%{&ft},%{&ff}) (%{&ts},%{&sts},%{&sw},%{&et?'et':'noet'}) %-4(%m%)%=%-19(%3l,%02c%03V,%o|%B%)]]
vim.o.virtualedit = "block"
vim.o.signcolumn = "yes"
vim.o.visualbell = false
vim.o.errorbells = false
vim.o.writeany = true
vim.o.iskeyword="@,-,>,48-57,128-167,224-235,_"
--vim.o.iskeyword = vim.o.iskeyword .. ',.'
vim.o.showtabline = 1
vim.o.matchtime=3
vim.o.complete=".,w,b,u,t,i,d"
vim.o.completeopt="menu,menuone,noselect,fuzzy" --set completeopt=longest,menu,noinsert,noselect,menuone "sjl: set completeopt=longest,menuone,preview
vim.o.timeout = true
vim.o.timeoutlen = 200
vim.o.ttimeoutlen = 0
if vim.fn.has("mac") then
  vim.o.clipboard = "unnamed" -- unnamed,unnamedplus,autoselect
else
  vim.o.clipboard = "unnamedplus"
end
if vim.fn.has("wsl") or vim.fn.has("mac") then
  vim.o.shell="bash"
  vim.o.shellcmdflag="-lc"
end
vim.o.splitbelow = true
vim.o.splitright = true
vim.o.switchbuf = "useopen"
vim.o.grepprg = [[rg --no-ignore -H --no-heading --color never]]
vim.o.grepformat="%f:%l:%m"
vim.o.foldenable = false
vim.g.vimsyn_folding = 0
vim.o.smartindent = true
vim.o.copyindent = true
vim.o.preserveindent = true
vim.o.autoindent = true
vim.o.shiftround = true
vim.o.expandtab = true
vim.o.tabstop=2
vim.o.shiftwidth=2
vim.o.softtabstop=2
vim.o.scrolloff=10
vim.o.startofline = false
vim.o.splitkeep="topline"
vim.o.wildmode = "longest,list"
vim.o.suffixes=vim.o.suffixes .. ".lo,.moc,.la,.closure,.loT"
vim.g.is_bash = 1

vim.g.mapleader = ","
vim.g.maplocalleader = ","
-- vim.o.t_Co=256
vim.o.background = "dark"

vim.cmd [[syntax enable]]
vim.cmd [[syntax on]]
vim.cmd [[filetype on]]
vim.cmd [[filetype indent on]]
vim.cmd [[filetype plugin on]]
vim.g.spell = false

vim.g.loaded_ruby_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.loaded_tutor_mode_plugin = 1
vim.g.loaded_man = 1
vim.g.loaded_manpageview = 1
vim.g.loaded_manpageviewPlugin = 1
vim.g.loaded_sql_completion=1
vim.g.omni_sql_no_default_maps = 1
vim.g.loaded_gzip=1
vim.g.loaded_spellfile_plugin=1
vim.g.loaded_shada_plugin = 1
vim.g.loaded_vimballPlugin=1
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
vim.g.netrw_banner=0
vim.g.netrw_altv=1
vim.g.netrw_browse_split=4
vim.g.loaded_netrwFileHandlers = 1
vim.g.loaded_zipPlugin=1
vim.g.loaded_zip=1
vim.g.loaded_tarPlugin=1
vim.g.loaded_2html_plugin=1
vim.g.loaded_xmlformat = 1

local function bootstrap_pckr()
  local pckr_path = vim.fs.joinpath(vim.fn.stdpath('config'), 'autoload/pckr')

  if not vim.uv.fs_stat(pckr_path) then
    vim.fn.system({
      'git',
      'clone',
      "--filter=blob:none",
      'https://github.com/lewis6991/pckr.nvim',
      pckr_path
    })
  end

  vim.opt.rtp:prepend(pckr_path)
end

bootstrap_pckr()

vim.opt.runtimepath:append(',~/.config/nvim/lua')
vim.lsp.set_log_level('error')

require('pckr').setup {
  pack_dir = vim.fs.joinpath(vim.fn.stdpath('data'), 'bundle-pckr'),
}

require('pckr').add {
  --------------------------------
  -- lang
  'terrastruct/d2-vim',
  'https://git.sr.ht/~sircmpwn/hare.vim',
  {
    'mrcjkb/rustaceanvim',
    config = function()
      vim.g.rustaceanvim = {
        tools = {
          reload_workspace_from_cargo_toml = true,
          hover_actions = {
            replace_builtin_hover = true
          },
          code_actions = {
            ui_select_fallback = false
          },
          float_win_config = {
            auto_focus = true
          }
        },
        server = {
          on_attach = function(client, bufnr)
            if client.server_capabilities.inlayHintProvider then
                vim.g.inlay_hints_visible = true
                vim.lsp.inlay_hint.enable(true, {bufnr = bufnr})
            end
          end,
          default_settings = {
            ['rust-analyzer'] = {
              server = {
                -- path = ''
                ['extraEnv'] = {
                  ['RA_LOG'] = 'error'
                },
              },
              -- trace = {
              --   server = 'verbose'
              -- },
              cargo = {
                allFeatures = true,
                buildScripts = {
                  enable = true
                },
              },
              check = {
                ignore = {
                  "dead_code",
                  "unused_imports",
                  "unused_mut",
                }
              },
              procMacro = {
                enable = true,
                attributes = { enable = true }
              },
              completion = {
                autoself = { enable = true },
                callable = { snippets = 'none' },
                fullFunctionSignatures = { enable = true },
                privateEditable = { enable = true },
                postfix = { enable = false },
                termSearch = { enable = true }
              },
              imports = {
                group = { enable = false }
              },
              hover = {
                actions = {
                  enable = true,
                  references = { enable = true },
                  run = { enable = true },
                  gotoTypeDef = { enable = true },
                  implementations = { enable = true },
                },
              },
              inlayHints = {
                bindingModeHints = { enable = true },
                chainingHints = {enable = true },
                closingBraceHints = { enable = false },
                closureCaptureHints = { enable = true },
                closureReturnTypeHints = { enable = true },
                closureStyle = 'impl_fn',  --'rust_analyzer',
                discriminantHints = { enable = 'fieldless' },
                expressionAdjustmentHints = { enable = 'always', mode = 'postfix' },
                genericParameterHints = {
                  const = { enable = true },
                  lifetime = { enable = true },
                  type = { enable = true }
                },
                implicitDrops = { enable = false },
                implicitSizedBoundHints = {enable = false},
                lifetimeElisionHints = {
                  enable = 'always',
                  useParameterNames = true
                },
                parameterHints = { enable = false },
                typeHints = { enable = true },
                maxLength = nil
              },
              interpret = {
                tests = true
              },
              diagnostics = {
                disabled = {
                  'incorrect-ident-case',
                  'replace-filter-map-next-with-find-map'
                },
                experimental = {
                  enable = true
                }
              },
              lens = {
                enable = true,
                references = {
                  adt = { enable = true },
                  method = { enable = true },
                  trait = { enable = true },
                },
                implementations = { enable = true }
              },
              checkOnSave = true,
            },
          },
        },
        dap = {
        },
      }

    end
  },
  {
    'ray-x/go.nvim',
    requires = {
      "ray-x/guihua.lua",
      -- "neovim/nvim-lspconfig",
      "nvim-treesitter/nvim-treesitter",
    },
    config = function()
      require('go').setup()
    end
  },
  {
    'rust-lang/rust.vim',
  },
  {
    'HealsCodes/vim-gas'
  },
  {
    "https://git.sr.ht/~swaits/scratch.nvim",
    config = function()
      require("scratch").setup()
    end
  },
  'compnerd/arm64asm-vim',
  'sirtaj/vim-openscad',
  'stephpy/vim-yaml',
  'rhysd/vim-clang-format',
  'hashivim/vim-terraform',
  'ziglang/zig.vim',
  'fedorenchik/fasm.vim',
  'urbit/hoon.vim',
  'karolbelina/uxntal.vim',
  'rluba/jai.vim',
  --  'pangloss/vim-javascript', { 'dir': stdpath('data') . '/bundle/javascript', 'for': 'javascript' },
  --  'leafgarland/typescript-vim',
  --  'neovimhaskell/haskell-vim', { 'dir': stdpath('data') . '/bundle/haskell-vim', 'for': 'haskell' },
  --  'jdonaldson/vaxe', { 'dir': stdpath('data') . '/bundle/vaxe' },
  --  'jansedivy/jai.vim', {'dir': stdpath('data') . '/bundle/jai' },
  --  'elmcast/elm-vim', { 'dir': stdpath('data') . '/bundle/elm-vim', 'for': 'elm' }.
  --  'google/vim-jsonnet', {'dir': stdpath('data') . '/bundle/jsonnet', 'for': 'jsonnet' },
  ---------------------------------------
  -- lsp
  {
    'onsails/diaglist.nvim',
    config = function()
      -- require("diaglist").init({
      --     debug = false,
      --     debounce_ms = 150,
      -- })
    end
  },
  {
    'williamboman/mason-lspconfig.nvim',
    requires = {
      'williamboman/mason.nvim',
    },
    config = function()
      require("mason").setup()
      require("mason-lspconfig").setup()
    end
  },
  -- {'scalameta/nvim-metals', {'branch': 'main'}},
  {
    'nvimdev/lspsaga.nvim',
    branch='main',
    requires = {
      'nvim-treesitter/nvim-treesitter',
    },
    config = function()
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
    end
  },
  'nvim-lua/popup.nvim',
  {
    'nvim-telescope/telescope.nvim',
    requires = {
      'nvim-lua/plenary.nvim',
      {
        'nvim-telescope/telescope-fzf-native.nvim',
        run ='make',
      },
      'nvim-telescope/telescope-ui-select.nvim',
    },
    config = function()
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
          preview = true,
          -- grep_previewer = require'telescope.previewers'.vim_buffer_vimgrep.new,
          grep_previewer = require'telescope.previewers'.vimgrep.new,
          qflist_previewer = require'telescope.previewers'.vim_buffer_qflist.new,
        }
      }
      require('telescope').load_extension('fzf')
      require("telescope").load_extension("ui-select")
    end
  },
  {
    'nvim-telescope/telescope-dap.nvim',
    requires = {
      'nvim-treesitter/nvim-treesitter',
      'mfussenegger/nvim-dap',
      'nvim-telescope/telescope.nvim',
    },
    config = function()
      require('telescope').load_extension('dap')
    end
  },
  {
    'ray-x/lsp_signature.nvim',
    config = function()
      require "lsp_signature".setup({
        bind = true,
        floating_window = false,
        hint_prefix = "",
      })
    end
  },
  ----------------------------------
  -- debug
  {
    'mfussenegger/nvim-dap',
    config = function()
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
        command = '/opt/homebrew/opt/llvm@16/bin/lldb-vscode',
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
      -- dap.configurations.scala = {
      --   {
      --     type = "scala",
      --     request = "launch",
      --     name = "RunOrTest",
      --     metals = {
      --       runType = "runOrTestFile",
      --       --args = { "firstArg", "secondArg", "thirdArg" }, -- here just as an example
      --     },
      --   },
      --   {
      --     type = "scala",
      --     request = "launch",
      --     name = "Test Target",
      --     metals = {
      --       runType = "testTarget",
      --     },
      --   },
      -- }

    end
  },
  {
    'theHamsta/nvim-dap-virtual-text',
    requires = {
      'nvim-treesitter/nvim-treesitter',
      'mfussenegger/nvim-dap',
    },
    config = function()
      require("nvim-dap-virtual-text").setup()
    end
  },
  {
    'rcarriga/nvim-dap-ui',
    requires = {
      "mfussenegger/nvim-dap",
      "nvim-neotest/nvim-nio"
    },
    config = function()
      require("dapui").setup()
      local dapui = require('dapui')
      local dap = require('dap')
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
    end
  },
  {
    'leoluz/nvim-dap-go',
    requires = {
      'mfussenegger/nvim-dap',
    },
    config = function()
      require('dap-go').setup()
    end
  },
  -- 'mfussenegger/nvim-jdtls'
  ---------------------------------
  -- syntax
  {
    'nvim-treesitter/nvim-treesitter',
    run = ':TSUpdate',
    config = function()
      require'nvim-treesitter.configs'.setup {
        textsubjects = {
          enable = true,
          prev_selection = ',',
          keymaps = {
            ['.'] = 'textsubjects-smart',
          }
        },
      }
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
      -- parser_config.jai = {
      --   install_info = {
      --     -- url = "https://github.com/adragomir/tree-sitter-jai", -- local path or git repo
      --     url = "/Users/adragomi/temp/tree-sitter-jai-new", -- local path or git repo
      --     files = {"src/parser.c", "src/scanner.cc"},
      --     cxx_standard = "c++14",
      --     -- optional entries:
      --     branch = "adragomi",
      --     generate_requires_npm = true,
      --     requires_generate_from_grammar = false, -- if folder contains pre-generated src/parser.c
      --   },
      --   filetype = "jai", -- if filetype does not match the parser name
      -- }
      parser_config.jai = {
        install_info = {
          url = "https://github.com/constantitus/tree-sitter-jai",
          files = {"src/parser.c", "src/scanner.c"},
          cxx_standard = "c++14",
          -- optional entries:
          branch = "master",
          generate_requires_npm = true,
          requires_generate_from_grammar = false, 
        },
        filetype = "jai",
      }
      parser_config.mojo = {
        install_info = {
          url = "https://github.com/HerringtonDarkholme/tree-sitter-mojo", -- local path or git repo
          files = {"src/parser.c", "src/scanner.cc"},
          -- optional entries:
          generate_requires_npm = true,
          requires_generate_from_grammar = false, -- if folder contains pre-generated src/parser.c
        },
        filetype = "mojo", -- if filetype does not match the parser name
      }
    end
  },
  --'nvim-treesitter/nvim-treesitter-context',
  {
    'RRethy/nvim-treesitter-textsubjects',
    requires = {
      'nvim-treesitter/nvim-treesitter',
    }
  },
  --------------------------------
  -- tools
  {
    'ej-shafran/compile-mode.nvim',
    requires = {
      "nvim-lua/plenary.nvim",
    }
  },
  'rbgrouleff/bclose.vim',
  {
    'nvim-pack/nvim-spectre',
    requires = {
      "nvim-lua/plenary.nvim",
    },
    config = function()
      require('spectre').setup()
    end
  },
  {
    '0x00-ketsu/maximizer.nvim',
    config = function()
      require('maximizer').setup()
    end
  },
  {
    'tiagovla/scope.nvim',
    requires = {
      'nvim-telescope/telescope.nvim',
    },
    config = function()
      require("telescope").load_extension("scope")
    end
  },
  'folke/lazydev.nvim',
  {
    'tversteeg/registers.nvim',
    config = function()
      require('registers').setup()
    end
  },
  {
    'gbprod/yanky.nvim',
    requires = {
      'kkharji/sqlite.lua',
    },
    config = function()
      require('yanky').setup({
        ring = {
          history_length = 100,
          storage = "sqlite",
          sync_with_numbered_registers = true,
          cancel_event = "update",
          ignore_registers = { "_" },
          update_register_on_cycle = false,
        },
        system_clipboard = {
          sync_with_ring = true,
        },
        highlight = {
          on_put = false,
          on_yank = false,
          timer = 50,
        },
        preserve_cursor_position = {
          enabled = true,
        },
        textobj = {
          enabled = true,
        },
      })
    end
  },
  {
    'nvim-tree/nvim-tree.lua',
    config = function()
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
    end
  },
  'tpope/vim-fugitive',
  'jremmen/vim-ripgrep',
  'vim-scripts/a.vim',
  'NMAC427/guess-indent.nvim',
  {
    'tkmpypy/chowcho.nvim',
    config = function()
      require('chowcho').setup {
        icon_enabled = false,
        text_color = '#FFFFFF',
        bg_color = '#555555',
        active_border_color = '#0A8BFF',
        border_style = 'default',
        use_exclude_default = false,
      }
    end
  },
  {
    'echasnovski/mini.nvim',
    config = function()
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
      })
      require('mini.bufremove').setup()
      require('mini.ai').setup({
        search_method = 'cover'
      })
      -- local map_multistep = require('mini.keymap').map_multistep
      -- map_multistep('i', '<Tab>',   { 'pmenu_next' })
      -- map_multistep('i', '<S-Tab>', { 'pmenu_prev' })
      -- map_multistep('i', '<CR>',    { 'pmenu_accept', 'minipairs_cr' })
      -- map_multistep('i', '<BS>',    { 'minipairs_bs' })
      -- require('mini.completion').setup({
      --   lsp_completion = {
      --     source_func = 'completefunc',
      --     auto_setup = true, 
      --     process_items = function(items)
      --       return items
      --     end, 
      --     snippet_insert = nil
      --   }, 
      --   fallback_action = '<C-n>', 
      --   mappings = {
      --     force_twostep = '<C-Space>',
      --     force_fallback = '<A-Space>',
      --     scroll_down = '<C-f>',
      --     scroll_up = '<C-b>',
      --   }
      -- })
    end
  },
  'chrisbra/matchit',
  {
    'utilyre/sentiment.nvim',
    config = function()
      require('sentiment').setup()
    end
  },
  --map <leader>m :AsyncRun -mode=term -pos=right -focus=0 -listed=0 ./build && jairun ./main<cr>
  'skywind3000/asyncrun.vim',
  -- 'github/copilot.vim'
  {
    'natecraddock/sessions.nvim',
    config = function()
      require('sessions').setup({
          session_filepath = vim.fn.stdpath("data") .. '/sessions',
          absolute = true,
      })
    end
  },
  {
    'natecraddock/workspaces.nvim',
    requires = {
      'natecraddock/sessions.nvim',
      'nvim-telescope/telescope.nvim',
    },
    config = function()
      require("workspaces").setup({
          path = vim.fn.stdpath("data") .. '/workspaces',
          cd_type = "global",
          sort = true,
          mru_sort = true,
          hooks = {
              open_pre = {
                  "SessionsSave",
                  "silent %bdelete!",
              },
              open = {
                  "SessionsLoad",
                  "NvimTreeOpen",
              },
          }
      })
      require('telescope').load_extension("workspaces")
    end
  },
  {
    'benlubas/molten-nvim',
    config = function()
    end
  },
  {
    "GCBallesteros/NotebookNavigator.nvim",
    keys = {
      { "<leader>X", "<cmd>lua require('notebook-navigator').run_cell()<cr>" },
    },
    dependencies = {
      "benlubas/molten-nvim"
    },
    config = function()
      local nn = require "notebook-navigator"
      nn.setup({
        cell_markers = {
          python = "# %%",
        },
        repl_provider = "auto",
      })
    end,
  }
}

vim.lsp.config.lua_ls = {
  cmd = { 'lua-language-server' },
  filetypes = { 'lua' },
  root_markers = {
    '.luarc.json',
    '.luarc.jsonc',
    '.luacheckrc',
    '.stylua.toml',
    'stylua.toml',
    'selene.toml',
    'selene.yml',
    '.git',
  },
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
}

vim.lsp.config.jails = {
  cmd = { '/Users/adragomi/temp/source/jai/Jails2/bin/jails' },
  filetypes = { 'jai' },
  root_markers = {'jails.json'},
}

vim.lsp.config.zls = {
  cmd = { vim.env.HOME .. '/.local/share/zvm/bin/zls' },
  on_new_config = function(new_config, new_root_dir)
    if vim.fn.filereadable(vim.fs.joinpath(new_root_dir, 'zls.json')) ~= 0 then
      new_config.cmd = { 'zls', '--config-path', 'zls.json' }
    end
  end,
  flags = {
    debounce_text_changes = 250
  },
  filetypes = { 'zig', 'zir' },
  root_markers = {'zls.json', 'build.zig', '.git'},
}

vim.lsp.config.buf_ls = {
  cmd = { 'buf', 'beta', 'lsp', '--timeout=0', '--log-format=text' },
  filetypes = { 'proto' },
  root_markers = {'buf.yaml', '.git'},
}

vim.lsp.config.gopls = {
  cmd = { 'gopls' },
  filetypes = { 'go', 'gomod', 'gowork', 'gotmpl' },
  root_markers = {'go.work', 'go.mod', '.git'}
}

vim.lsp.config.mojo = {
  cmd = { vim.env.HOME .. '/.local/share/modular/pkg/packages.modular.com_mojo/bin/mojo-lsp-server' },
  filetypes = { 'mojo' },
  root_markers = {'.git'},
}

vim.lsp.config.ols = {
  cmd = { 'ols' },
  filetypes = { 'odin' },
  root_markers = {'ols.json', '.git', '*.odin'},
}

function lsp_server(opts)
  opts = opts or {}
  local capabilities = opts.capabilities or {}
  local on_request = opts.on_request or function(_, _) end
  local on_notify = opts.on_notify or function(_, _) end
  local handlers = opts.handlers or {}

  return function(dispatchers)
    local closing = false
    local srv = {}
    local request_id = 0

    function srv.request(method, params, callback)
      pcall(on_request, method, params)
      local handler = handlers[method]
      if handler then
        local response, err = handler(method, params)
        callback(err, response)
      elseif method == 'initialize' then
        callback(nil, {
          capabilities = capabilities
        })
      elseif method == 'shutdown' then
        callback(nil, nil)
      end
      request_id = request_id + 1
      return true, request_id
    end

    function srv.notify(method, params)
      pcall(on_notify, method, params)
      if method == 'exit' then
        dispatchers.on_exit(0, 15)
      end
    end

    function srv.is_closing()
      return closing
    end

    function srv.terminate()
      closing = true
    end

    return srv
  end
end

local function get_word_before_cursor(position)
  local cursor_row = position.line
  local cursor_col = vim.lsp.util._get_line_byte_from_position(bufnr, position, 'utf-8')

  local current_row = vim.api.nvim_buf_get_lines(0, cursor_row, cursor_row + 1, false)[1]
  if not current_row or cursor_col == 0 then
    return ""
  end
  local end_pos = cursor_col
  local start_pos = end_pos
  while start_pos > 0 do
    local char = current_row:sub(start_pos, start_pos)
    if char:match("%w") then
      start_pos = start_pos - 1
    else
      break
    end
  end
  start_pos = start_pos + 1
  if start_pos > end_pos then
    return ""
  end
  return current_row:sub(start_pos, end_pos)
end

local function get_words_from_current_buffer(base_string)
  if not base_string or #base_string == 0 then
    return {}
  end

  local words = {}
  local seen = {}
  local word_pattern = "%w+" -- word boundary followed by word characters
  local line_count = vim.api.nvim_buf_line_count(0)
  for i = 0, line_count - 1 do
    local line = vim.api.nvim_buf_get_lines(0, i, i + 1, false)[1]
    if line then
      for word in line:gmatch(word_pattern) do
        if #word >= #base_string and word:sub(1, #base_string) == base_string and word ~= base_string then
          if not seen[word] then
            table.insert(words, word)
            seen[word] = true
          end
        end
      end
    end
  end
  table.sort(words)
  return words
end

vim.lsp.config.all_keyword_lsp = {
  cmd = lsp_server({
    capabilities = {
      completionProvider = {
        triggerCharacters = {'.'}
      }
    }, 
    handlers = {
      ["textDocument/completion"] = function(method, params)
        local bufnr = vim.api.nvim_get_current_buf()
        local cursor_row = params.position.line
        local cursor_col = vim.lsp.util._get_line_byte_from_position(bufnr, params.position, 'utf-8')
        local word = get_word_before_cursor(params.position)
        local similar_words = get_words_from_current_buffer(word)

        local completion_result = {
          isIncomplete = true,
          items = { }
        }

        for _, word in ipairs(similar_words) do
          table.insert(
            completion_result.items, 
            {
              data = {
                position = params.position, 
                symbolLabel = word, 
                uri = params.textDocument.uri
              }, 
              label = word,
              kind = 1
            }
          )

        end
        return completion_result
      end
    }
  }),
  filetypes = {'python'}, 
  root_markers = { '*' }
}

vim.lsp.config.rust_analyzer = {
  cmd = { 'rust-analyzer' },
  filetypes = { 'rust' },
  root_dir = function(fname)
    local function is_library(fname)
      local user_home = vim.fs.normalize(vim.env.HOME)
      local cargo_home = os.getenv 'CARGO_HOME' or user_home .. '/.cargo'
      local registry = cargo_home .. '/registry/src'
      local git_registry = cargo_home .. '/git/checkouts'

      local rustup_home = os.getenv 'RUSTUP_HOME' or user_home .. '/.rustup'
      local toolchains = rustup_home .. '/toolchains'

      for _, item in ipairs { toolchains, registry, git_registry } do
        if vim.fs.relpath(item, fname) ~= nil then
          local clients = vim.lsp.get_clients({ name = 'rust_analyzer' })
          return #clients > 0 and clients[#clients].config.root_dir or nil
        end
      end
    end
    local reuse_active = is_library(fname)
    if reuse_active then
      return reuse_active
    end

    local cargo_crate_dir = util.root_pattern 'Cargo.toml'(fname)
    local cargo_workspace_root

    if cargo_crate_dir ~= nil then
      local cmd = {
        'cargo',
        'metadata',
        '--no-deps',
        '--format-version',
        '1',
        '--manifest-path',
        cargo_crate_dir .. '/Cargo.toml',
      }

      local result = async.run_command(cmd)

      if result and result[1] then
        result = vim.json.decode(table.concat(result, ''))
        if result['workspace_root'] then
          cargo_workspace_root = vim.fs.normalize(result['workspace_root'])
        end
      end
    end

    return cargo_workspace_root
      or cargo_crate_dir
      or vim.fs.dirname(vim.fs.find('.git', { path = fname, upward = true })[1])
  end,
  capabilities = {
    experimental = {
      serverStatusNotification = true,
    },
  },
}

vim.lsp.config.clangd = {
  cmd = {
    "/opt/homebrew/opt/llvm/bin/clangd",
    -- "--background-index",
    "--pch-storage=disk",
    -- "--all-scopes-completion",
    -- "--pretty",
    "--header-insertion=never",
    "-j=4",
    "--function-arg-placeholders",
    "--completion-style=detailed",
    "--enable-config",
    "--query-driver=**",
  },
  filetypes = {'c', 'cpp', 'objc', 'objcpp', 'cuda' },
  root_markers = {".clangd", ".clang-tidy", ".clang-format", "compile_commands.json", "compile_flags.txt", ".git"},
  capabilities = {
    textDocument = {
      completion = {
        editsNearCursor = true,
      },
    },
    offsetEncoding = { 'utf-8', 'utf-16' },
  },
}

vim.lsp.config.basedpyright = {
  cmd = { 'basedpyright-langserver', '--stdio' },
  filetypes = { 'python' },
  root_markers = {
    'pyproject.toml',
    'setup.py',
    'setup.cfg',
    'requirements.txt',
    'Pipfile',
    'pyrightconfig.json',
    '.git',
  },
  settings = {
    basedpyright = {
      analysis = {
        autoSearchPaths = true,
        useLibraryCodeForTypes = true,
        diagnosticMode = 'openFilesOnly',
        diagnosticSeverityOverrides = {
          reportUnusedImport = false,
          reportMissingTypeStubs = false,
          reportUnknownMemberType = false,
          reportUnknownVariableType = false,
          reportUnknownParameterType = false,
          reportUnknownArgumentType = false,
          reportMissingParameterType = false,
          reportUnannotatedClassAttribute = false,
          reportUnusedCallResult = false,
          reportAttributeAccessIssue = false,
          reportImplicitOverride = false,
          reportAny = false,
          reportArgumentType = false,
        }
      }
    }
  },
}

vim.lsp.config.nim_langserver = {
  cmd = { vim.fn.stdpath('data') .. '/mason/bin/nimlangserver' },
  root_markers = { '.nimble', '.git' },
  filetypes = { 'nim' },
  settings = {
    nim = {
      nimSuggestPath = "/opt/homebrew/bin/nimsuggest",
      logNimsuggest = true,
      inlayHints = {
        typeHints = {
          enable = true
        },
        parameterHints = {
          enable = true
        },
        exceptionHints = {
          enable = true
        }
      },
      notificationVerbosity = "warning",
      useNimCheck = false,
    }
  }
}

vim.lsp.config.c3lsp = {
  cmd = { vim.fn.stdpath('data') .. '/mason/bin/c3lsp' },
  root_markers = { 'project.json', 'manifest.json', '.git' },
  filetypes = { 'c3', 'c3i' },
}

vim.lsp.enable({
  'lua_ls', 'jails', 'zls', 'buf_ls', 'gopls', 'mojo',
  -- 'denols', 'haxe_language_server', 'leanls', 'solang', 'svls'
  'ols', "clangd", "basedpyright", "c3lsp", "nim_langserver", 'all_keyword_lsp'
})

vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('UserLspConfig', {}),
  callback = function(ev)
    -- Enable completion triggered by <c-x><c-o>
    vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'
    vim.bo[ev.buf].completefunc = 'v:lua.vim.lsp.omnifunc'
    local client = vim.lsp.get_client_by_id(ev.data.client_id)
    if client.name == "basedpyright" then
      vim.api.nvim_create_user_command("PyrightOrganizeImports", function()
        local params = {
          command = 'pyright.organizeimports',
          arguments = { vim.uri_from_bufnr(0) },
        }
        client.request('workspace/executeCommand', params, nil, 0)
      end,{
        desc = 'Organize Imports'
      })
      vim.api.nvim_create_user_command("PyrightSetPythonPath", function(path)
        if client.settings then
          client.settings.python = vim.tbl_deep_extend('force', client.settings.python or {}, { pythonPath = path })
        else
          client.config.settings = vim.tbl_deep_extend('force', client.config.settings, { python = { pythonPath = path } })
        end
        client.notify('workspace/didChangeConfiguration', { settings = nil })
      end,{
        desc = 'Reconfigure basedpyright with the provided python path',
        nargs = 1,
        complete = 'file',
      })
    end
    if client.name == "clangd" then
      vim.api.nvim_create_user_command("ClangdSwitchSourceHeader", function()
        local params = vim.lsp.util.make_text_document_params(bufnr)
        client.request('textDocument/switchSourceHeader', params, function(err, result)
          if err then
            error(tostring(err))
          end
          if not result then
            vim.notify('corresponding file cannot be determined')
            return
          end
          vim.cmd.edit(vim.uri_to_fname(result))
        end, bufnr)
      end,{
        desc = 'Organize Imports'
      })
      vim.api.nvim_create_user_command("ClangdShowSymbolInfo", function()
        local win = vim.api.nvim_get_current_win()
        local params = vim.lsp.util.make_position_params(win, clangd_client.offset_encoding)
        clangd_client.request('textDocument/symbolInfo', params, function(err, res)
          if err or #res == 0 then
            -- Clangd always returns an error, there is not reason to parse it
            return
          end
          local container = string.format('container: %s', res[1].containerName) ---@type string
          local name = string.format('name: %s', res[1].name) ---@type string
          vim.lsp.util.open_floating_preview({ name, container }, '', {
            height = 2,
            width = math.max(string.len(name), string.len(container)),
            focusable = false,
            focus = false,
            border = 'single',
            title = 'Symbol Info',
          })
        end, 0)
      end,{
        desc = 'Organize Imports'
      })

    end
    if client.name == "rust_analyzer" then
      vim.api.nvim_create_user_command("CargoReload", function()
          vim.notify 'Reloading Cargo Workspace'
          client.request('rust-analyzer/reloadWorkspace', nil, function(err)
            if err then
              error(tostring(err))
            end
            vim.notify 'Cargo workspace reloaded'
          end, 0)
      end,{
        desc = 'Reload current cargo workspace'
      })
    end

    if client:supports_method('textDocument/completion') then
      vim.lsp.completion.enable(true, client.id, ev.buf, {
        autotrigger = false
      })
    end
  end,
})

vim.diagnostic.config({
  virtual_text = {
    current_line = true,
    virt_text_pos = "eol_right_align" -- eol_right_align, inline, overlay, right_align
  },
  virtual_lines = false,
  -- virtual_lines = {
  --   current_line = true,
  -- },
  severity = vim.diagnostic.severity.WARNING
})
-- vim.api.nvim_create_autocmd({ "CursorHold" }, {
--   pattern = "*",
--   callback = function()
--       for _, winid in pairs(vim.api.nvim_tabpage_list_wins(0)) do
--         if vim.api.nvim_win_get_config(winid).zindex then
--           return
--         end
--       end
--       vim.diagnostic.open_float({
--         scope = "cursor",
--         focusable = false,
--         close_events = {
--           "CursorMoved",
--           "CursorMovedI",
--           "BufHidden",
--           "InsertCharPre",
--           "WinLeave",
--         },
--       })
--   end
-- })
-- vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
--   vim.lsp.diagnostic.on_publish_diagnostics, {
--     signs = {
--       severity_limit = "Warning",
--     },
--     virtual_text = {
--       severity_limit = "Warning",
--     },
--     -- virtual_text = false,
--     virtual_lines = false,
--     update_in_insert = false,
--   }
-- )

vim.g.compile_mode = {}

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
      if vim.o.omnifunc == "" then
        vim.api.nvim_eval([[feedkeys("\<c-n>", "n")]])
      else
        vim.api.nvim_eval([[feedkeys("\<c-x>\<c-o>", "n")]])
      end
      return
    end
  end
end
local chainy_esc = function()
  if vim.fn.pumvisible() ~= 0 then
    vim.api.nvim_eval([[feedkeys("\<c-e>", "n")]])
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
    if vim.o.omnifunc == "" then
      vim.api.nvim_eval([[feedkeys("\<c-p>", "n")]])
    else
      vim.api.nvim_eval([[feedkeys("\<c-x>\<c-o>", "n")]])
      --vim.api.nvim_eval([[feedkeys("\<BS>", "n")]])
    end
    return
  end
end
vim.keymap.set("i", "<Esc>", chainy_esc, { silent=true, expr = true, noremap = true })
vim.keymap.set("i", "<C-c>", chainy_cc, { silent=true, expr = true, noremap = true })
vim.keymap.set("i", "<BS>", chainy_bs, { silent=true, expr = true, noremap = true })
vim.keymap.set("i", "<CR>", chainy_cr, { silent=true, expr = true, noremap = true })
vim.keymap.set("i", "<Tab>", chainy_tab, { silent=true, expr = true, noremap = true })
vim.keymap.set("i", "<S-Tab>", chainy_stab, { silent=true, expr = true, noremap = true })

local move_left = function()
  require("move").move(1)
end
local move_right = function()
  require("move").move(2)
end
vim.keymap.set("n", "<M-h>", move_left, { silent=true, expr = true, noremap = true })
vim.keymap.set("n", "<M-l>", move_right, { silent=true, expr = true, noremap = true })

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

-- COLORING
local jump_ns = vim.api.nvim_create_namespace("jump_ns")
local change_ns = vim.api.nvim_create_namespace("change_ns")
local insert_ns = vim.api.nvim_create_namespace("insert_ns")

local function mark_on(ns, mark, highlight)
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
local function mark_on_move()
  mark_on(jump_ns, '`', 'hi_MarkBeforeJump')
end
local function mark_on_changed()
  mark_on(change_ns, '.', 'hi_MarkChange')
end
local function mark_on_insert_stop()
  mark_on(insert_ns, '^', 'hi_MarkInsertStop')
end

function MoveCursor(move, mode)
  if move == 'h' then
    if mode == '0' then
      vim.cmd [[normal 0]]
    elseif vim.regex('^\\^'):match_str(mode) then
      if mode == '^g' then
        vim.cmd [[normal g^]]
      elseif mode == '^n' then
        vim.cmd [[normal ^]]
      end
    end
  elseif move == 'e' then
    if vim.regex('^\\$'):match_str(mode) then
      if mode == '$g' then
        vim.cmd [[normal g$]]
      elseif mode == '$n' then
        vim.cmd [[normal $]]
      end
    end
  end
end

function HomeKey()
  local oldcol = vim.fn.col('.')
  MoveCursor('h', '^n')
  local newcol = vim.fn.col('.')
  if oldcol == newcol then
    if vim.o.wrap ~= 1 or  newcol <= (vim.fn.winwidth(0) - 20) then
      MoveCursor('h', '0')
      if newcol == vim.fn.col('.') then
        if newcol == oldcol then
          vim.cmd [[normal i]]
        else
          MoveCursor('h', '^n')
        end
      else
        MoveCursor('h', '0')
      end
    end
  end
end

function EndKey()
  MoveCursor('e', '$g')
end

function SaveMap(key)
  local output = {}
  local buf = vim.api.nvim_get_current_buf()
  local keymaps = vim.api.nvim_buf_get_keymap(buf, 'n')
  for _, keymap in pairs(keymaps) do
    if keymap.lhs == key  then
      table.insert(output, keymap)
      vim.api.nvim_buf_del_keymap(buf, 'n', 'K')
    end
  end
  return output
end

function RestoreMap(map)
  if not vim.fn.empty(map) then
    local tmp = ""
    if map.nnoremap then
      tmp = tmp .. "nn"
    else
      tmp = tmp .. "nmap"
    end
    for _, v in pairs({'buffer', 'expr', 'nowait', 'silent'}) do
      if v then
        tmp = tmp .. "<" .. v .. ">"
      end
    end
    tmp = tmp .. map.lhs
    vim.cmd([[execute ]] .. tmp)
  end
end



vim.keymap.set("n", "K", "<nop>", {noremap = true})
vim.keymap.set("v", "u", "<nop>", {noremap = true})
vim.keymap.set("n", "+", "<nop>", {noremap = true})
--vim.keymap.set("n", "r", "<nop>", {noremap = true})
--vim.keymap.set("n", "R", "<nop>", {noremap = true})
vim.keymap.set("n", "L", "<nop>", {noremap = true})
vim.keymap.set("n", "M", "<nop>", {noremap = true})
vim.keymap.set("n", "|", "<nop>", {noremap = true})
vim.keymap.set("n", "(", "<nop>", {noremap = true})
vim.keymap.set("n", ")", "<nop>", {noremap = true})
vim.keymap.set("n", "[", "<nop>", {noremap = true})
vim.keymap.set("n", "]", "<nop>", {noremap = true})
-- vim.keymap.set("n", "{", "<nop>", {noremap = true})
-- vim.keymap.set("n", "}", "<nop>", {noremap = true})
vim.keymap.set("n", "[[", "<nop>", {noremap = true})
vim.keymap.set("n", "]]", "<nop>", {noremap = true})
vim.keymap.set("n", "[]", "<nop>", {noremap = true})
vim.keymap.set("n", "][", "<nop>", {noremap = true})
vim.keymap.set("n", "Q", "<nop>", {silent = true, noremap = true})
vim.keymap.set("", "<MiddleMouse", "<nop>", {})
vim.keymap.set("", "<2-MiddleMouse", "<nop>", {})
vim.keymap.set("", "<3-MiddleMouse", "<nop>", {})
vim.keymap.set("", "<4-MiddleMouse", "<nop>", {})
vim.keymap.set("i", "<MiddleMouse", "<nop>", {})
vim.keymap.set("i", "<2-MiddleMouse", "<nop>", {})
vim.keymap.set("i", "<3-MiddleMouse", "<nop>", {})
vim.keymap.set("i", "<4-MiddleMouse", "<nop>", {})
vim.keymap.set("", "<F1>", "<nop>", {noremap = true})
for i=1,24 do
  for _, t in ipairs({"i", "c"}) do
    vim.keymap.set(t, "<F" .. i .. ">", "<nop>", {noremap = true})
    vim.keymap.set(t, "<S-F" .. i .. ">", "<nop>", {noremap = true})
  end
end

-- kill / yank
vim.keymap.set({"n","x"}, "p", "<Plug>(YankyPutAfter)")
vim.keymap.set({"n","x"}, "P", "<Plug>(YankyPutBefore)")
vim.keymap.set({"n","x"}, "gp", "<Plug>(YankyGPutAfter)")
vim.keymap.set({"n","x"}, "gP", "<Plug>(YankyGPutBefore)")
vim.keymap.set("n", "<c-q>", "<Plug>(YankyPreviousEntry)")
vim.keymap.set("n", "<c-s-q>", "<Plug>(YankyNextEntry)")

vim.keymap.set(
  'n', "<f2>",
  function()
    vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({bufnr=0}), {bufnr=0})
  end,
  {silent = true}
)
vim.keymap.del("n", "Y")
vim.keymap.set("v", "y", "myy`y")
vim.keymap.set("v", "Y", "myY`y")
-- vim.keymap.set("n", "D", "d$", {noremap = true})
-- vim.keymap.set("v", "p", "\"_dP", {noremap = true})
-- vim.keymap.set("v", "r", "\"_dP", {noremap = true})

-- mapping movement
vim.keymap.set("", "j", "gj", {noremap = true})
vim.keymap.set("", "k", "gk", {noremap = true})
vim.keymap.set("", "<up>", "gk", {noremap = true})
vim.keymap.set("", "<down>", "gj", {noremap = true})
vim.keymap.set("v", "J", "j", {noremap = true})
vim.keymap.set("v", "K", "k", {noremap = true})

-- mapping cr
vim.keymap.set("n", "<cr>", ":nohlsearch<cr>", {noremap = true})
SAVE_CR_MAP = {}
local all_buffers_augroup_id = vim.api.nvim_create_augroup('all_buffers', { clear = true })
vim.api.nvim_create_autocmd({ 'VimLeavePre' }, {
  pattern = '*',
  group = all_buffers_augroup_id,
  callback = function()
    local bwstr = 'silent! 1,' .. vim.fn.bufnr('$') .. 'bwipeout!'
    vim.cmd(bwstr)
  end
})
vim.api.nvim_create_autocmd({ 'CmdwinEnter' }, {
  pattern = '*',
  group = all_buffers_augroup_id,
  callback = function()
    SAVE_CR_MAP = SaveMap('<cr>')
    vim.cmd [[silent! :unmap <cr>]]
  end
})
vim.api.nvim_create_autocmd({ 'CmdwinLeave' }, {
  pattern = '*',
  group = all_buffers_augroup_id,
  callback = function() RestoreMap(SAVE_CR_MAP) end
})
vim.api.nvim_create_autocmd({ 'WinEnter', 'BufWinEnter' }, {
  pattern = '*',
  group = all_buffers_augroup_id,
  callback = function()
    if vim.bo.filetype == "qf" then
      SAVE_CR_MAP = SaveMap('<cr>')
      vim.cmd [[silent! :unmap <cr>]]
    else
      RestoreMap(SAVE_CR_MAP)
    end
  end
})

vim.api.nvim_create_autocmd({ 'WinLeave' }, {
  pattern = '*',
  group = all_buffers_augroup_id,
  callback = function()
    if vim.bo.filetype == "qf" then
      RestoreMap(SAVE_CR_MAP)
    end
  end
})

-- mapping resize
vim.keymap.set("n", "<M-Right>", ":vertical resize +5<CR>", {noremap = true})
vim.keymap.set("n", "<M-Left>", ":vertical resize -5<CR>", {noremap = true})
vim.keymap.set("n", "<M-Down>", ":resize +3<CR>", {noremap = true})
vim.keymap.set("n", "<M-Up>", ":resize -3<CR>", {noremap = true})
vim.keymap.set("n", "<C-h>", "<c-w>h", {noremap = true})
vim.keymap.set("n", "<C-j>", "<c-w>j", {noremap = true})
vim.keymap.set("n", "<C-k>", "<c-w>k", {noremap = true})
vim.keymap.set("n", "<C-l>", "<c-w>l", {noremap = true})

-- mapping jumps
vim.keymap.set("n", "<S-D-Left>", "<C-o>", {})
vim.keymap.set({"n", "x"}, "'", "`", {})
vim.keymap.set("", "<leader>'", "``", {})
vim.keymap.set("", "<leader>.", "`.", {})
vim.keymap.set("n", "gl", "`.", {})
vim.keymap.set("", "<leader>]", "`]", {})
vim.keymap.set("", "<leader>>", "`>", {})
vim.keymap.set("", "<leader>`", "`^", {})

vim.keymap.set("n", "bd", ":Bclose", {silent = true, noremap = true})
vim.keymap.set("", "<Space>", "m`", {noremap = true})

-- mappings home/end
vim.keymap.set("i", "<Home>", "<C-o>:lua HomeKey()<cr>", {silent = true, noremap = true})
vim.keymap.set("n", "<Home>", ":lua HomeKey()<cr>", {silent = true, noremap = true})
vim.keymap.set("n", "<leader>/", ":Rg <cword><cr>", {silent = true, noremap = true})
vim.keymap.set("n", "-", ":Chowcho<cr>", {})

vim.keymap.set("n", "<D-F12>", function() require('maximizer').toggle() end, {noremap = true, silent = true})
vim.keymap.set("n", "gD", vim.lsp.buf.declaration, {noremap = true, silent = true})
vim.keymap.set("n", "<D-S-b>", vim.lsp.buf.declaration, {noremap = true, silent = true})
vim.keymap.set("n", "gd", vim.lsp.buf.definition, {noremap = true, silent = true})
vim.keymap.set("n", "<D-b>", vim.lsp.buf.definition, {noremap = true, silent = true})
vim.keymap.set("n", "pd", "<cmd>Lspsaga peek_definition<cr>", {noremap = true, silent = true})
vim.keymap.set("n", "K", vim.lsp.buf.signature_help, {noremap = true, silent = true})
vim.keymap.set("n", "gi", vim.lsp.buf.implementation, {noremap = true, silent = true})
vim.keymap.set("n", "gr", vim.lsp.buf.references, {noremap = true, silent = true})
vim.keymap.set("n", "gsd", vim.lsp.buf.document_symbol, {noremap = true, silent = true})
vim.keymap.set("n", "gsw", vim.lsp.buf.workspace_symbol, {noremap = true, silent = true})
vim.keymap.set("n", "<F12>", require('telescope.builtin').lsp_document_symbols, {noremap = true, silent = true})
vim.keymap.set("n", "<C-F12>", require('telescope.builtin').lsp_workspace_symbols, {noremap = true, silent = true})
vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, {noremap = true, silent = true})
vim.keymap.set("n", "<leader>f", vim.lsp.buf.format, {noremap = true, silent = true})
vim.keymap.set("n", "<leader>d", "<cmd>lua vim.diagnostic.enable(not vim.diagnostic.is_enabled())<CR>", {noremap = true, silent = true})
vim.keymap.set("n", "gh", ":Lspsaga finder<cr>", {noremap = true, silent = true})
vim.keymap.set("n", "<leader>ca", ":Lspsaga code_action<cr>", {noremap = true, silent = true})
vim.keymap.set("n", "gs", ":Lspsaga hover_doc<cr>", {noremap = true, silent = true})
vim.keymap.set("n", "gt<space>", ":Lspsaga peek_type_definition<cr>", {noremap = true, silent = true})
vim.keymap.set("n", "<leader>da", "<cmd>lua require('diaglist').open_all_diagnostics()<cr>", {noremap = true, silent = true})
vim.keymap.set("n", "<leader>dw", "<cmd>lua require('diaglist').open_all_diagnostics()<cr>", {noremap = true, silent = true})

if vim.fn.exists("g:neovide") == 1 then
  vim.keymap.set("n", "<D-t>", ":tabnew<cr>", {noremap = true, silent = true})
  vim.keymap.set("n", "<D-w>", ":tabclose<cr>", {noremap = true, silent = true})
  vim.keymap.set("n", "<D-]>", ":tabnext<cr>", {noremap = true, silent = true})
  vim.keymap.set("n", "<D-[>", ":tabprevious<cr>", {noremap = true, silent = true})
  vim.keymap.set("n", "<D-}>", ":tabnext<cr>", {noremap = true, silent = true})
  vim.keymap.set("n", "<D-{>", ":tabprevious<cr>", {noremap = true, silent = true})
  vim.keymap.set("", "<D-1>", "1gt", {noremap = true, silent = true})
  vim.keymap.set("", "<D-2>", "2gt", {noremap = true, silent = true})
  vim.keymap.set("", "<D-3>", "3gt", {noremap = true, silent = true})
  vim.keymap.set("", "<D-4>", "4gt", {noremap = true, silent = true})
  vim.keymap.set("", "<D-5>", "5gt", {noremap = true, silent = true})
  vim.keymap.set("", "<D-6>", "6gt", {noremap = true, silent = true})
  vim.keymap.set("", "<D-7>", "7gt", {noremap = true, silent = true})
  vim.keymap.set("", "<D-8>", "8gt", {noremap = true, silent = true})
  vim.keymap.set("", "<D-9>", "9gt", {noremap = true, silent = true})
  vim.keymap.set("i", "<D-1>", "1gt", {noremap = true, silent = true})
  vim.keymap.set("i", "<D-2>", "2gt", {noremap = true, silent = true})
  vim.keymap.set("i", "<D-3>", "3gt", {noremap = true, silent = true})
  vim.keymap.set("i", "<D-4>", "4gt", {noremap = true, silent = true})
  vim.keymap.set("i", "<D-5>", "5gt", {noremap = true, silent = true})
  vim.keymap.set("i", "<D-6>", "6gt", {noremap = true, silent = true})
  vim.keymap.set("i", "<D-7>", "7gt", {noremap = true, silent = true})
  vim.keymap.set("i", "<D-8>", "8gt", {noremap = true, silent = true})
  vim.keymap.set("i", "<D-9>", "9gt", {noremap = true, silent = true})
  vim.keymap.set("i", "<D-t>", "<C-o>:tabnew<cr>", {noremap = true, silent = true})
  vim.keymap.set("i", "<D-w>", "<C-o>:tabclose<cr>", {noremap = true, silent = true})
  vim.keymap.set("i", "<D-]>", "<C-o>:tabnext<cr>", {noremap = true, silent = true})
  vim.keymap.set("i", "<D-[>", "<C-o>:tabprevious<cr>", {noremap = true, silent = true})
  vim.keymap.set("i", "<D-}>", "<C-o>:tabnext<cr>", {noremap = true, silent = true})
  vim.keymap.set("i", "<D-{>", "<C-o>:tabprevious<cr>", {noremap = true, silent = true})
end

-- telescope
vim.keymap.set("n", "<C-p>", "<cmd>lua require('telescope.builtin').find_files()<cr>", {})
vim.keymap.set("n", "<C-f>", "<cmd>lua require('telescope.builtin').diagnostics()<cr>", {})
vim.keymap.set("n", "<C-S-f>", "<cmd>lua require('telescope.builtin').live_grep()<cr>", {})
vim.keymap.set("n", "<leader>1", ":NvimTreeToggle<cr>", {})
vim.keymap.set("n", "<leader>s", "<cmd>lua require('telescope.builtin').lsp_workspace_symbols({file_encoding='utf-8'})<cr>", {})
vim.keymap.set("n", "<leader>4", "<cmd>Telescope scope buffers<cr>", {})
vim.keymap.set("n", "<leader>5", "<cmd>Telescope scope buffers cwd_only=true<cr>", {})

vim.g.godef_split = 0
vim.g.go_play_open_browser = 0
vim.g.go_fmt_fail_silently = 0
vim.g.go_fmt_autosave = 1
vim.g.go_disable_autoinstall = 1
vim.g.go_doc_keywordprg_enabled = 0
vim.g.go_def_mode = 'gopls'
vim.g.go_def_mapping_enabled = 0
vim.g.go_bin_path = vim.fn.expand("~/.gocode/bin")
vim.g.go_diagnostics_enabled = 0
vim.g.javaScript_fold=0
vim.g.vim_json_syntax_conceal = 0
vim.g.terraform_align = 1
vim.g.terraform_fmt_on_save = 1

vim.api.nvim_create_user_command('W', 'silent! exec "write !sudo tee % >/dev/null"  | silent! edit!', {bar = true})

vim.cmd [[hi default hi_MarkInsertStop ctermbg=128 ctermfg=white cterm=bold]]
vim.cmd [[hi default hi_MarkChange ctermbg=160 ctermfg=154 cterm=underdashed]]
vim.cmd [[hi default hi_MarkBeforeJump ctermbg=23 ctermfg=white cterm=undercurl,bold]]
local make_diagnostics_ns = vim.api.nvim_create_namespace("make_diagnostics_ns")

function append_make_diagnostics()
  local bufnr = vim.api.nvim_get_current_buf()
  local ql = vim.fn.getqflist()
  local qlb = {}
  for _, qli in pairs(ql) do
    if qli['bufnr'] == bufnr and qli['lnum'] > 0 and qli['col'] > 0 then
      qlb[#qlb+1] = qli
    end
  end
  local dqlb = vim.diagnostic.fromqflist(qlb)
  vim.diagnostic.reset(make_diagnostics_ns, bufnr)
  vim.diagnostic.set(make_diagnostics_ns, bufnr, dqlb)
end

vim.api.nvim_create_autocmd({ "VimEnter" }, {
  group = vim.api.nvim_create_augroup("KittySetVarVimEnter", { clear = true }),
  callback = function()
    io.stdout:write("\x1b]1337;SetUserVar=in_editor=MQo\007")
  end,
})

vim.api.nvim_create_autocmd({ "VimLeave" }, {
  group = vim.api.nvim_create_augroup("KittyUnsetVarVimLeave", { clear = true }),
  callback = function()
    io.stdout:write("\x1b]1337;SetUserVar=in_editor\007")
  end,
})


local settings_augroup_id = vim.api.nvim_create_augroup('settings', { clear = true })
vim.api.nvim_create_autocmd({ 'ModeChanged' }, {
  pattern = '*:[iiI]*',
  group = settings_augroup_id,
  command = "hi ModeMsg guifg=#ff0000"
})
vim.api.nvim_create_autocmd({ 'BufNewFile', 'BufRead' }, {
  pattern = '*.Jenkinsfile',
  group = settings_augroup_id,
  command = "set filetype=groovy"
})
vim.api.nvim_create_autocmd({ 'BufNewFile', 'BufRead' }, {
  pattern = '*.jai',
  group = settings_augroup_id,
  command = "set filetype=jai"
})
vim.api.nvim_create_autocmd({ 'BufNewFile', 'BufRead' }, {
  pattern = '*.ino',
  group = settings_augroup_id,
  command = "set filetype=cpp"
})
vim.api.nvim_create_autocmd({ 'BufNewFile', 'BufRead' }, {
  pattern = '*.pde',
  group = settings_augroup_id,
  command = "set filetype=cpp"
})
vim.api.nvim_create_autocmd({ 'Filetype' }, {
  pattern = 'qf',
  group = settings_augroup_id,
  command = "wincmd J"
})
vim.api.nvim_create_autocmd({ 'Filetype' }, {
  pattern = 'jai',
  group = settings_augroup_id,
  command = "setlocal et ts=4 sw=4 sts=4 isk=a-z,A-Z,48-57,_ commentstring=//\\ %s | compiler jai"
})
vim.api.nvim_create_autocmd({ 'Filetype' }, {
  pattern = {'python', 'java', 'ruby', 'javascript'},
  group = settings_augroup_id,
  command = "setlocal et ts=4 sw=4 sts=4"
})
vim.api.nvim_create_autocmd({ 'Filetype' }, {
  pattern = {'c', 'cpp'},
  group = settings_augroup_id,
  command = "setlocal ts=4 sw=4 sts=4 isk=a-z,A-Z,48-57,_ commentstring=//\\ %s"
})
vim.api.nvim_create_autocmd({ 'Filetype' }, {
  pattern = {'go'},
  group = settings_augroup_id,
  command = "setlocal noexpandtab ts=4 sw=4 sts=4"
})
vim.api.nvim_create_autocmd({ 'Filetype' }, {
  pattern = {'sh'},
  group = settings_augroup_id,
  command = "setlocal iskeyword=35,36,45,46,48-57,64,65-90,97-122,_"
})

local lsp_augroup_id = vim.api.nvim_create_augroup('lsp', { clear = true })
vim.api.nvim_create_autocmd({ 'Filetype' }, {
  pattern = {'c', 'cpp', 'python', 'ruby', 'haskell', 'php', 'java', 'rust', 'javascript', 'typescript', 'go'},
  group = lsp_augroup_id,
  command = "setlocal omnifunc=v:lua.vim.lsp.omnifunc"
})

