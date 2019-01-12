set nocompatible
scriptencoding utf8
filetype off

" Set Config Path
set runtimepath^=~/.vim runtimepath+=~/.local/share/vim
let &packpath = &runtimepath

" Plugins
call plug#begin('~/.local/share/vim/bundle')
Plug 'scrooloose/nerdtree'
Plug 'w0rp/ale'
Plug 'rstacruz/sparkup', {'rtp': 'vim/'}
Plug 'altercation/vim-colors-solarized'
Plug 'colepeters/spacemacs-theme.vim'
Plug 'grod/grod-vim-colors'
Plug 'aquach/vim-http-client'
Plug 'vim-pandoc/vim-pandoc-syntax'
Plug 'antoyo/vim-licenses'
Plug 'vim-scripts/loremipsum'
Plug 'vim-scripts/VOoM'
Plug 'tpope/vim-unimpaired'
Plug 'sheerun/vim-polyglot'
Plug 'reasonml-editor/vim-reason-plus'
Plug 'autozimu/LanguageClient-neovim', { 'branch': 'next', 'do': 'bash install.sh' }
Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
Plug 'zchee/deoplete-jedi'
if !has('nvim')
    Plug 'roxma/nvim-yarp'
    Plug 'roxma/vim-hug-neovim-rpc'
endif
call plug#end()

filetype plugin indent on

"" maralla Completor.vim, DEPRECATED
" completor.vim config
"let g:completor_python_binary = '/usr/bin/python3'
"let g:completor_node_binary = '/usr/bin/node'
"let g:completor_clang_binary = '/usr/bin/clang'
"set splitbelow
"" omnifunc triggers
"let g:completor_css_omni_trigger = '([\w-]+|@[\w-]*|[\w-]+:\s*[\w-]*)$'
"let g:completor_html_omni_trigger = '(<[^>]*(?!>)|[\w]+)'

"" Language Servers
let g:LanguageClient_serverCommands = {
    \ 'rust': ['~/.cargo/bin/rustup', 'run', 'stable', 'rls'],
    \ 'reason': ['~/.local/bin/ocaml-language-server', '--stdio'],
    \ 'javascript.jsx': ['~/.local/bin/js-langserver', '--stdio'],
    \ 'c' : ['/usr/bin/clangd'],
    \ 'cpp' : ['/usr/bin/clangd'],
    \}
    " 'python': ['/usr/local/bin/pyls'],
    " \ }

" ALE config
let g:ale_open_list = 1
let g:ale_completion_enabled = 0
let g:ale_lint_on_text_changed = 'never'
let g:ale_lint_on_enter = 0
let g:ale_linters = {
\   'javascript': ['eslint'],
\   'python':     ['flake8'],
\   'cpp':        [],
\   'c':          [],
\   'sh':         ['shellcheck'],
\   'zsh':        [],
\}

" GUI config
set guioptions=
set guifont=DeJaVu\ Sans\ Mono\ 11

" deoplete
let g:deoplete#enable_at_startup = 1

" Syntastic
"set statusline+=%#warningmsg#
"set statusline+=%{SyntasticStatuslineFlag()}
"set statusline+=%*
"
"let g:syntastic_always_populate_loc_list = 1
"let g:syntastic_auto_loc_list = 0
"let g:syntastic_check_on_open = 1
"let g:syntastic_check_on_wq = 0
""let g:syntastic_disabled_filetypes=['tex']
"let g:syntastic_javascript_checkers = ['eslint']

" vim-licenses
let g:licenses_copyright_holders_name = 'Anthony DeDominic <adedomin@gmail.com>'
let g:licenses_default_commands = ['gpl', 'affero', 'apache', 'mit', 'isc']

" NERDTree
let g:NERDTreeShowHidden=1
augroup nerdtree_vimrc
    autocmd!
    autocmd StdinReadPre * let s:std_in=1
    autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif
augroup END

" Eclim
"let g:EclimCompletionMethod = 'omnifunc'

" github markdown
augroup pandoc_syntax
    autocmd! BufNewFile,BufRead *.md,*.markdown setlocal filetype=markdown.pandoc spell
augroup END

augroup filetype_config_vimrc
    autocmd!
    " TeX
    au BufNewFile,BufRead *.tex setlocal spell

    " deerkin highlight
    au BufNewFile,BufRead *.deer setlocal filetype=deer

    " pug/jade template
    au BufNewFile,BufRead *.pug setl sts=2 ts=2 sw=2

    " html/xml indenting
    au FileType html setl sts=2 ts=2 sw=2
    au FileType xhtml setl sts=2 ts=2 sw=2
    au FileType xml setl sts=2 ts=2 sw=2
    au FileType ant setl sts=2 ts=2 sw=2
    au FileType yaml setl sts=2 ts=2 sw=2
augroup END

" General
set softtabstop=4
set tabstop=4
set shiftwidth=4
set autoindent
set expandtab
set smartindent
set number
set mouse=a
set modifiable
set clipboard=unnamed
syntax on

" Color
"let base16colorspace=256
set t_Co=256
"let g:solarized_termcolors=256
set background=light
colorscheme solarized

" show tabs and trailing as special
set list
set listchars=trail:\ ,tab:>\ 
" show leading spaces as special
" highlight Conceal gui=bold cterm=bold guibg=LightGray ctermbg=LightGray guifg=NONE ctermfg=NONE
augroup leading_spaces
    autocmd!
    autocmd BufWinEnter,BufReadPre * setlocal conceallevel=2 concealcursor=nv
    autocmd BufWinEnter,BufReadPre * syntax match LeadingSpace /\(^ *\)\@<= / containedin=ALL conceal cchar=·
augroup END
" cursor column
set cursorcolumn
set cursorline

" Mapping
noremap \ $
noremap ; l
noremap l k
noremap k j
noremap j h
noremap K <C-d>
noremap L <C-u>
noremap q <C-r>
noremap / /\v
vnoremap / /\v
inoremap <S-Tab> <C-V><Tab>

" source per-machine customizations
for g:vfile in glob('~/.config/vimrc.d/*.vim', 0, 1)
    exe 'source' g:vfile
endfor
