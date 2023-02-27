
vim.g.mapleader = ' '
vim.g.maplocalleader = ","

local fn = vim.fn
local execute = vim.api.nvim_command

local function packer_strap()
  local install_path = fn.stdpath('data') .. '/site/pack/packer-strap/opt/packer.nvim'
  if fn.empty(fn.glob(install_path)) > 0 then
    execute([[!git clone https://github.com/wbthomason/packer.nvim ]] .. install_path)
  end
  vim.cmd [[packadd! packer.nvim]]
  -- vim.cmd [[autocmd BufWritePost plugins.lua PackerCompile]]
end

-- local function sys_init()
--   -- Performance
--   require "impatient"
-- end

packer_strap()

-- modules

require('plugins').setup()
require('defaults').setup()
require('keybinds').setup()
