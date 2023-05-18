local M = {}

vim.g.global_runtime_path = vim.env.XDG_DATA_HOME .. '/nvim/site/'

M.plugins = {}

function M.setup()
  require('lazy').setup({
    'drmingdrmer/vim-tabbar',
    {
      'folke/which-key.nvim',
      config = function()
        vim.o.timeout = true
        vim.o.timeoutlen = 350
        require('which-key').setup {}
      end
    },
    {
      'nvim-telescope/telescope.nvim',
      cmd = {'Telescope'},
      init = function()
        require('keybinds').setup_telescope_mappings()
        vim.cmd [[
        augroup Autoscope_group
        autocmd!
        autocmd StdinReadPre * let s:std_in=1
        autocmd VimEnter * if argc() == 0 && !exists('s:std_in') | exe "Telescope find_files" | endif
        augroup END
        ]]
      end,
      dependencies = { 'nvim-lua/plenary.nvim' },
    },
    {
      'preservim/nerdtree',
      init = function()
        vim.g.NERDTreeShowHidden = 1
        vim.g.NERDTreeBookmarksFile = vim.g.global_runtime_path .. '/../NERDTreeBookmarks'
      end,
      cmd = {"NERDTree", "NERDTreeToggle"},
    },
    {
      'dense-analysis/ale',
      lazy = false,
      init = function()
        vim.g.ale_lint_on_text_changed = "never"
        vim.g.ale_lint_on_enter = 0
        vim.g.ale_linters = {
          javascript  =  {"eslint"},
          vim         =  {"vimls"},
          python      =  {"flake8"},
          c           =  {"clangd"},
          cpp         =  {"clangd"},
          rust        =  {"analyzer"},
          sh          =  {"shellcheck"},
          zsh         =  {},
          go          =  {"gopls"},
          java        =  {"eclipselsp"},
        }
        vim.g.ale_disable_lsp = 1
      end,
    },
    'tpope/vim-surround',
    {
      'ishan9299/nvim-solarized-lua',
      lazy = false,
      config = function()
        local guibg = vim.o.background == 'light' and '#eee8d5' or '#073642'
        vim.cmd([[
        augroup Solarized_colorscheme
        autocmd!
        autocmd ColorScheme * highlight Whitespace gui=bold guibg=]] .. guibg .. [[

        autocmd ColorScheme * highlight Conceal gui=bold guibg=]] .. guibg .. [[

        autocmd BufWinEnter,BufReadPre * setlocal conceallevel=2 concealcursor=nv
        autocmd BufWinEnter,BufReadPre * syntax match LeadingSpace /\(^ *\)\@<= / containedin=ALL conceal cchar= 
        augroup END
        colorscheme solarized
        ]])
      end,
    },
    {
      'antoyo/vim-licenses',
      cmd = {'Gpl','Apache','Mit','Isc'},
      init = function()
        vim.g.licenses_copyright_holders_name = "Anthony DeDominic <adedomin@gmail.com>"
        vim.g.licenses_default_commands = { "gpl", "apache", "mit", "isc" }
      end,
    },
    'vim-scripts/loremipsum',
    'tpope/vim-unimpaired',
    'sheerun/vim-polyglot',
    {
      'hrsh7th/nvim-cmp',
      dependencies = {
        'hrsh7th/cmp-nvim-lsp',
        'hrsh7th/cmp-nvim-lua',
        'hrsh7th/cmp-vsnip',
        'hrsh7th/vim-vsnip',
      },
      config = function()
        local cmp = require('cmp')
        cmp.setup({
          snippet = {
            -- REQUIRED - you must specify a snippet engine
            expand = function(args)
              vim.fn["vsnip#anonymous"](args.body)
            end,
          },
          mapping = cmp.mapping.preset.insert({
            ['<Tab>'] = cmp.mapping(function(fallback)
              cmp.complete()
              if cmp.visible() then
                cmp.select_next_item()
              elseif vim.fn["vsnip#available"](1) == 1 then
                feedkey("<Plug>(vsnip-expand-or-jump)", "")
              else
                fallback()
              end
            end, { "i", "s"}),
            ['<CR>'] = cmp.mapping.confirm({ select = false }),
          }),
          sources = cmp.config.sources({
            { name = 'nvim_lsp' },
            { name = 'vsnip' },
            { name = 'path' },
            { name = 'buffer', keyword_length = 3 },
            { name = 'nvim_lua' },
          }),
        })
      end
    },
    {
      'Shougo/deoplete.nvim',
      enabled = false,
      build = ':UpdateRemotePlugins',
      lazy = false,
      config = function()
        vim.cmd [[ call deoplete#enable() ]]
      end,
    },
    {
      ft = {'zsh'},
      enabled = false,
      'deoplete-plugins/deoplete-zsh',
      dependencies = { 'Shougo/deoplete.nvim' },
    },
    {
      'deoplete-plugins/deoplete-lsp',
      enabled = false,
      ft = {'rust','python','typescript','c','cpp','go','zig','nix'},
      dependencies = { 'neovim/nvim-lspconfig', 'Shougo/deoplete.nvim' }
    },
    {
      'neovim/nvim-lspconfig',
      ft = {'rust','python','javascript','typescript','c','cpp','go','zig','nix'},
      dependencies = {
        'ray-x/lsp_signature.nvim',
        'simrat39/rust-tools.nvim',
        'lvimuser/lsp-inlayhints.nvim',
      },
      config = function()
        local init_fn = require('lsp.init')
        local servers = {
          'pyright',
          'tsserver',
          'clangd',
          'gopls',
          'zls',
          'nil_ls',
          'rust_analyzer'
        }
        init_fn.setup_servers(servers)
      end,
    },
    {
      'jbyuki/venn.nvim',
      cmd = {'VBox'},
      config = function()
        local vedit_enable = false
        function ToggleVEdit()
          if vedit_enable then
            vim.bo.virtualedit = ''
            vedit_enable = true
          else
            vim.bo.virtualedit = 'all'
            vedit_enable = false
          end
        end

        vim.cmd [[
        command! ToggleVEdit exe 'lua ToggleVEdit()'
        noremap <Leader>V :ToggleVEdit<Return>
        noremap <Leader>v :VBox<Return>
        ]]
      end,
    },
    {
      'lvimuser/lsp-inlayhints.nvim',
      config = function()
        require("lsp-inlayhints").setup()
      end,
    },
    {
      'nvim-treesitter/nvim-treesitter',
      build = ':TSUpdate',
    },
    {
      'koka-lang/koka',
      config = function(plugin)
        vim.opt.rtp:append(plugin.dir .. "/support/vim")
      end,
    },
    {
      'ojroques/nvim-osc52',
      config = function()
        local osc52 = require('osc52');
        osc52.setup {
          max_length = 0,      -- Maximum length of selection (0 for no limit)
          silent     = false,  -- Disable message on successful copy
          trim       = false,  -- Trim surrounding whitespaces before copy
        }

        local function copy(lines, _)
          osc52.copy(table.concat(lines, '\n'))
        end

        local function paste()
          return {
            vim.fn.split(vim.fn.getreg(''), '\n'),
            vim.fn.getregtype(''),
          }
        end

        vim.g.clipboard = {
          name = 'osc52',
          copy = {['+'] = copy, ['*'] = copy},
          paste = {['+'] = paste, ['*'] = paste},
        }
      end,
    },
  })
end

return M
