set nocompatible
filetype off

" rtp
set runtimepath+=~/.vim/bundle/Vundle.vim
call vundle#begin()
Plugin 'scrooloose/nerdtree'
"Plugin 'scrooloose/syntastic'
Plugin 'w0rp/ale'
Plugin 'VundleVim/Vundle.vim'
Plugin 'rstacruz/sparkup', {'rtp': 'vim/'}
"Plugin 'shougo/neocomplete'
Plugin 'maralla/completor.vim'
Plugin 'altercation/vim-colors-solarized'
Plugin 'colepeters/spacemacs-theme.vim'
Plugin 'grod/grod-vim-colors'
Plugin 'aquach/vim-http-client'
Plugin 'vim-pandoc/vim-pandoc-syntax'
Plugin 'antoyo/vim-licenses'
Plugin 'vim-scripts/loremipsum'
Plugin 'vim-scripts/VOoM'
Plugin 'tpope/vim-unimpaired'
Plugin 'sheerun/vim-polyglot'
call vundle#end()

filetype plugin indent on

" completor.vim config
let g:completor_python_binary = '/usr/bin/python3'
let g:completor_node_binary = '/usr/bin/node'
let g:completor_clang_binary = '/usr/bin/clang'
set splitbelow

" ALE config
let g:ale_open_list = 1
let g:ale_lint_on_text_changed = 'never'
let g:ale_lint_on_enter = 0

" GUI config
set guioptions=
set guifont=DeJaVu\ Sans\ Mono\ 11

" Syntastic
"set statusline+=%#warningmsg#
"set statusline+=%{SyntasticStatuslineFlag()}
"set statusline+=%*
"
"let g:neocomplete#enable_at_startup = 1
"let g:syntastic_always_populate_loc_list = 1
"let g:syntastic_auto_loc_list = 0
"let g:syntastic_check_on_open = 1
"let g:syntastic_check_on_wq = 0
""let g:syntastic_disabled_filetypes=['tex']
"let g:syntastic_javascript_checkers = ['eslint']

" vim-licenses
let g:licenses_copyright_holders_name = 'Anthony DeDominic <adedomin@gmail.com>'
"let g:licenses_authors_name = 'prussian <genunrest@gmail.com>'
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

" source customizations
for g:f in split(glob('~/.vimrc.d/*.vim'), '\n')
    exe 'source' g:f
endfor
