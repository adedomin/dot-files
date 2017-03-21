set nocompatible
filetype off

set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
Plugin 'scrooloose/nerdtree'
Plugin 'scrooloose/syntastic'
Plugin 'gmarik/Vundle.vim'
Plugin 'rstacruz/sparkup', {'rtp': 'vim/'}
Plugin 'shougo/neocomplete'
Plugin 'altercation/vim-colors-solarized'
Plugin 'colepeters/spacemacs-theme.vim'
Plugin 'grod/grod-vim-colors'
Plugin 'aquach/vim-http-client'
Plugin 'vim-pandoc/vim-pandoc-syntax'
Plugin 'antoyo/vim-licenses'
Plugin 'vim-scripts/loremipsum'
Plugin 'vim-scripts/VOoM'
call vundle#end()

filetype plugin indent on

" GUI config
"set guioptions-=T
"set guioptions-=m
"set guioptions-=r
set guioptions=
set guifont=DeJaVu\ Sans\ Mono\ 11

" Syntastic
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

let g:neocomplete#enable_at_startup = 1
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 0
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0
"let g:syntastic_disabled_filetypes=['tex']

let g:syntastic_javascript_checkers = ['eslint']

" vim-licenses
let g:licenses_copyright_holders_name = 'prussian <genunrest@gmail.com>'
"let g:licenses_authors_name = 'prussian <genunrest@gmail.com>'
let g:licenses_default_commands = ['gpl', 'apache', 'mit', 'isc']

" NERDTree
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif
let NERDTreeShowHidden=1

" Eclim
let g:EclimCompletionMethod = 'omnifunc'

" github markdown
augroup pandoc_syntax
    au! BufNewFile,BufRead *.md,*.markdown setlocal filetype=markdown.pandoc
augroup END

" deerkin highlight
au BufNewFile,BufRead *.deer setlocal filetype=deer

" html indenting
au FileType html setl sts=2 ts=2 sw=2
au FileType xhtml setl sts=2 ts=2 sw=2
au FileType xml setl sts=2 ts=2 sw=2

" General
set sts=4 ts=4 sw=4 ai
set expandtab
set smartindent
set nu
set mouse=a
set modifiable
set clipboard=unnamed
syntax on

" Color
"let base16colorspace=256
set t_Co=256 
"let g:solarized_termcolors=256
set background=light
"colorscheme spacemacs-theme
colorscheme solarized
"colorscheme twilight
"colorscheme base16-eighties

" Mapping
noremap \ $
noremap ; l
noremap l k
noremap k j
noremap j h
noremap K <C-d>
noremap L <C-u>  
noremap q <C-r>
