local M = {}

-- local g = vim.g
local o = vim.o
local wo = vim.wo
-- local bo = vim.bo
local indent = 4
-- local opt = vim.opt

function M.setup()
  vim.cmd [[
syntax enable
filetype plugin indent on

augroup filetype_config_vimrc
  autocmd!
  " Documents
  au BufNewFile,BufRead *.tex,*.txt,*.md,*.rst setlocal spell

  " pug/jade template
  au BufNewFile,BufRead *.pug setl sts=2 ts=2 sw=2

  " html/xml indenting
  au FileType html setl sts=2 ts=2 sw=2
  au FileType xhtml setl sts=2 ts=2 sw=2
  au FileType xml setl sts=2 ts=2 sw=2
  au FileType ant setl sts=2 ts=2 sw=2
  au FileType yaml setl sts=2 ts=2 sw=2
  au FileType vimwiki setl sts=2 ts=2 sw=2 spell
  au FileType nix setl sts=2 ts=2 sw=2

  " go indenting
  au FileType go setl noexpandtab ts=4 sw=0

  " javascript indent fixes
  " au FileType javascript setl noautoindent nosmartindent

  au FileType lua setl sw=2 ts=2 sts=2

  " disable legacy regexp engine
  au FileType typescript setl re=0
augroup END
  ]]

  o.shiftwidth = indent
  o.tabstop = indent
  o.softtabstop = indent
  o.expandtab = true
  o.autoindent = true
  o.smartindent = true

  o.list = true
  o.listchars = "nbsp:␣,trail: ,tab:> "

  o.termguicolors = true
  o.background = "light"

  o.mouse = "a"
  o.clipboard = "unnamedplus"
  o.incsearch = true
  o.inccommand = "nosplit"
  o.hlsearch = true
  o.wildmode = "longest:full,full"
  o.number = true
  o.relativenumber = true

  wo.cursorline = true
  wo.cursorcolumn = true
end

return M
