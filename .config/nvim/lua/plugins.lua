local M = {}

vim.g.global_runtime_path = vim.env.XDG_DATA_HOME .. '/nvim/site/'

M.plugins = {}

function M.setup()
  require('lazy').setup({
      'drmingdrmer/vim-tabbar',
      {
        'nvim-telescope/telescope.nvim',
        cmd = {'Telescope'},
        init = function()
          require('which-key').register({
              f = { '<cmd>Telescope find_files<cr>', 'Find file' },
              g = { '<cmd>Telescope live_grep<cr>', 'Grep live' },
              b = { '<cmd>Telescope buffers<cr>', 'Find buffer' },
              h = { '<cmd>Telescope help_tags<cr>', 'help_tags' },
            }, { prefix = '<leader>t' })
        end,
        dependencies = { 'nvim-lua/plenary.nvim' },
      },
      {
        'preservim/nerdtree',
        init = function()
          vim.g.NERDTreeShowHidden = 1
          vim.g.NERDTreeBookmarksFile = vim.g.global_runtime_path .. '/../NERDTreeBookmarks'
          vim.cmd [[
          augroup NERDTree_group
          autocmd!
          autocmd StdinReadPre * let s:std_in=1
          autocmd VimEnter * if argc() == 0 && !exists('s:std_in') | exe "NERDTree" | endif
          autocmd BufEnter * if tabpagenr('$') == 1 && winnr('$') == 1 && exists('b:NERDTree') && b:NERDTree.isTabTree() | quit | endif
          augroup END
          ]]
        end,
        cmd = {"NERDTree", "NERDTreeToggle"},
      },
      {
        'folke/which-key.nvim',
        config = function()
          vim.o.timeout = true
          vim.o.timeoutlen = 350
          require('which-key').setup {}
        end
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
      {
        'ishan9299/nvim-solarized-lua',
        lazy = false,
        config = function()
          vim.cmd [[
          augroup Solarized_colorscheme
          autocmd!
          autocmd ColorScheme * highlight Whitespace gui=bold guibg=#eee8d5
          autocmd ColorScheme * highlight Conceal gui=bold guibg=#eee8d5
          autocmd BufWinEnter,BufReadPre * setlocal conceallevel=2 concealcursor=nv
          autocmd BufWinEnter,BufReadPre * syntax match LeadingSpace /\(^ *\)\@<= / containedin=ALL conceal cchar= 
          augroup END
          colorscheme solarized
          ]]
        end,
      },
      {
        'antoyo/vim-licenses',
        cmd = {'Gpl','Apache','Mit','Isc','PrattAndWhitney'},
        init = function()
          vim.g.licenses_copyright_holders_name = "Anthony DeDominic <adedomin@gmail.com>"
          vim.g.licenses_default_commands = { "gpl", "apache", "mit", "isc" }

          vim.g.licenses_corporate_copyright_name = "Anthony DeDominic <Anthony.DeDominic@prattwhitney.com>"
          local corp = 'PrattAndWhitney'
          vim.g.corp_license_file = vim.g.global_runtime_path .. '/../lazy/vim-licenses/licenses/' ..  corp .. '.txt'

          vim.loop.fs_stat(vim.g.corp_license_file, function(err)
            if err == nil then
              return
            end
            vim.loop.fs_open(vim.g.corp_license_file, "w", tonumber("0644", 8), function(err, fd)
              assert(not err, err)
              vim.loop.fs_write(fd, [===[Copyright (c) <year> Pratt & Whitney

All rights reserved
This document contains confidential and proprietary information of
Pratt & Whitney, any reproduction, disclosure, or use in whole or in part is
expressly prohibited, except as may be specifically authorized by prior
written agreement or permission of Pratt & Whitney

Author: <name of copyright holder>
]===], function(err)
                  assert(not err, err)
                  vim.loop.fs_close(fd, function() end)
                end)
              end)
            end)
          end,
          config = function()
            function PrattAndWhitneyLicense()
              local copy_l = vim.g.licenses_copyright_holders_name
              vim.g.licenses_copyright_holders_name = vim.g.licenses_corporate_copyright_name
              vim.cmd [[ call InsertLicense('PrattAndWhitney') ]]
              vim.g.licenses_copyright_holders_name = copy_l
            end

            vim.cmd [[ command! PrattAndWhitney exe "lua PrattAndWhitneyLicense()" ]]
          end,
        },
        'vim-scripts/loremipsum',
        'tpope/vim-unimpaired',
        'sheerun/vim-polyglot',
        {
          'Shougo/deoplete.nvim',
          build = ':UpdateRemotePlugins',
          lazy = false,
          config = function()
            vim.cmd [[ call deoplete#enable() ]]
          end,
        },
        {
          ft = {'zsh'},
          'deoplete-plugins/deoplete-zsh',
          dependencies = { 'Shougo/deoplete.nvim' },
        },
        {
          'deoplete-plugins/deoplete-lsp',
          ft = {'rust','vim','python','typescript','cpp','go','zig','nix'},
          dependencies = { 'neovim/nvim-lspconfig', 'Shougo/deoplete.nvim' }
        },
        {
          'neovim/nvim-lspconfig',
          ft = {'rust','vim','python','typescript','cpp','go','zig','nix'},
          dependencies = {
            'ray-x/lsp_signature.nvim',
            'simrat39/rust-tools.nvim',
            'lvimuser/lsp-inlayhints.nvim',
          },
          config = function()
            local init_fn = require('lsp.init')
            local servers = {
              'vimls',
              'pyright',
              'tsserver',
              'clangd',
              'gopls',
              'zls',
              'rnix',
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
        { 'nvim-treesitter/nvim-treesitter', build = ':TSUpdate' },
        {
          'koka-lang/koka',
          config = function(plugin)
            vim.opt.rtp:append(plugin.dir .. "/support/vim")
          end,
        },
      })
  end

  return M
