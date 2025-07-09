-- ~/.config/nvim/init.lua
-- Main entry point for Neovim configuration

-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    'git',
    'clone',
    '--filter=blob:none',
    'https://github.com/folke/lazy.nvim.git',
    '--branch=stable',
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- Load configuration modules
require('config.options')
require('config.keymaps')
require('config.autocmds')

-- Setup plugins
require('plugins')

-- Final setup
print("🚀 Neovim configuration loaded successfully!")
print("📋 TypeScript/React/NextJS/React Native development ready!")
print("💡 Use Space as leader key • Cmd+P for files • Cmd+F for search")
