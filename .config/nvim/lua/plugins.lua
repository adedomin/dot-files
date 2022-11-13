local M = {}

vim.g.global_runtime_path = vim.env.XDG_DATA_HOME .. '/nvim/site'

function M.setup()
    packer = require 'packer'
    packer.startup(function(use)
        use 'norcalli/nvim_utils'
        use 'drmingdrmer/vim-tabbar'
        use {
            'preservim/nerdtree',
            setup = function()
                vim.g.NERDTreeShowHidden = 1
                vim.g.NERDTreeBookmarksFile = vim.g.global_runtime_path .. '/../NERDTreeBookmarks'
            end,
            config = function()
                require 'nvim_utils'
                nvim_create_augroups {
                    NERDTree_start = {
                        { "StdinReadPre", "*", "let g:nerdtree_aucmd_std_in=1" },
                        { "VimEnter",     "*", "if argc() == 0 && !exists('g:nerdtree_aucmd_std_in') | NERDTree | endif" },
                    },
                }
            end,
            requires = 'norcalli/nvim_utils',
        }
        use {
            'dense-analysis/ale',
            config = function()
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
        }
        use {
            'ishan9299/nvim-solarized-lua',
            config = function()
                require 'nvim_utils'
                nvim_create_augroups {
                    solarized_colorscheme = {
                        { "ColorScheme", "solarized", "highlight Whitespace gui=bold guibg=#eee8d5" },
                        { "ColorScheme", "solarized", "highlight Conceal gui=bold guibg=#eee8d5" },
                        { "BufWinEnter,BufReadPre", "*", "setlocal conceallevel=2 concealcursor=nv" },
                        { "BufWinEnter,BufReadPre", "*", "syntax match LeadingSpace /\\(^ *\\)\\@<= / containedin=ALL conceal cchar= " },
                    },
                }
                vim.cmd [[ colorscheme solarized ]]
            end,
            requires = 'norcalli/nvim_utils',
        }
        use {
            'lifepillar/vim-solarized8',
            disable = true,
            config = function()
                require 'nvim_utils'
                nvim_create_augroups {
                    solarized8_colorscheme = {
                        { "ColorScheme", "solarized8", "highlight Whitespace gui=bold guibg=#eee8d5" },
                        { "ColorScheme", "solarized8", "highlight Conceal gui=bold guibg=#eee8d5" },
                        { "BufWinEnter,BufReadPre", "*", "setlocal conceallevel=2 concealcursor=nv" },
                        { "BufWinEnter,BufReadPre", "*", "syntax match LeadingSpace /\\(^ *\\)\\@<= / containedin=ALL conceal cchar= " },
                    },
                }
                vim.cmd 'colorscheme solarized8'
            end,
            requires = 'norcalli/nvim_utils',
        }
        use {
            'antoyo/vim-licenses',
            cmd = {'Gpl','Apache','Mit','Isc','PrattAndWhitney'},
            setup = function()
                vim.g.licenses_copyright_holders_name = "Anthony DeDominic <adedomin@gmail.com>"
                vim.g.licenses_default_commands = { "gpl", "apache", "mit", "isc" }

                vim.g.licenses_corporate_copyright_name = "Anthony DeDominic <Anthony.DeDominic@prattwhitney.com>"
                local corp = 'PrattAndWhitney'
                vim.g.corp_license_file = vim.g.global_runtime_path .. '/pack/packer/opt/vim-licenses/licenses/' ..  corp .. '.txt'

                if vim.fn.filereadable(vim.g.corp_license_file) == 0 then
                     vim.cmd [[
exe '!printf ' . shellescape('%s\n', 1) . ' ' .
    \ shellescape('Copyright (c) <year> Pratt & Whitney') . ' ' .
    \ shellescape('') . ' ' .
    \ shellescape('All rights reserved') . ' ' .
    \ shellescape('This document contains confidential and proprietary information of') . ' ' .
    \ shellescape('Pratt & Whitney, any reproduction, disclosure, or use in whole or in part is') . ' ' .
    \ shellescape('expressly prohibited, except as may be specifically authorized by prior') . ' ' .
    \ shellescape('written agreement or permission of Pratt & Whitney.') . ' ' .
    \ shellescape('') . ' ' .
    \ shellescape('Author: <name of copyright holder>') . ' > ' . shellescape(g:corp_license_file)
                 ]]
                end
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
        }
        use { 'vim-scripts/loremipsum' }
        use 'tpope/vim-unimpaired'
        use 'sheerun/vim-polyglot'
        use {
            'Shougo/deoplete.nvim',
            run = ':UpdateRemotePlugins',
            config = function()
                vim.cmd [[ call deoplete#enable() ]]
            end,
        }
        use {
            ft = {'zsh'},
            'deoplete-plugins/deoplete-zsh',
            requires = 'Shougo/deoplete.nvim',
        }
        use {
            'neovim/nvim-lspconfig',
            ft = {'rust','vim','python','typescript','cpp','go','zig','nix'},
            requires = {
                'ray-x/lsp_signature.nvim',
                'simrat39/rust-tools.nvim',
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
        }
        use { 'deoplete-plugins/deoplete-lsp', requires = {
            {'neovim/nvim-lspconfig'}, {'Shougo/deoplete.nvim'}
        } }
        use {
            'folke/lsp-colors.nvim',
            disable = true,
        }
        use 'ray-x/lsp_signature.nvim'
        use {
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
        }

        if vim.fn.has('nvim-0.6.0') then
            use { 'nvim-treesitter/nvim-treesitter', run = ':TSUpdate' }
        end
    end)
end

return M
