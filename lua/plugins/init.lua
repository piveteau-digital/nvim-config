-- ~/.config/nvim/lua/plugins/init.lua
-- Main plugins configuration

-- Load all plugin configurations and setup lazy.nvim
require('lazy').setup({
  -- Load plugin configurations
  require('plugins.ui'),
  require('plugins.treesitter'),
  require('plugins.telescope'),
  require('plugins.lsp'),
  require('plugins.completion'),
  require('plugins.formatting'),
  require('plugins.react'),
  require('plugins.testing'),
  require('plugins.git'),
  require('plugins.utils'),
}, {
  -- Lazy.nvim configuration
  defaults = {
    lazy = false,
    version = false,
  },
  install = {
    missing = true,
    colorscheme = { 'tokyonight' },
  },
  checker = {
    enabled = true,
    notify = false,
  },
  change_detection = {
    enabled = true,
    notify = false,
  },
  ui = {
    border = 'rounded',
    size = {
      width = 0.8,
      height = 0.8,
    },
    icons = {
      cmd = ' ',
      config = '',
      event = '',
      ft = ' ',
      init = ' ',
      import = ' ',
      keys = ' ',
      lazy = '󰒲 ',
      loaded = '●',
      not_loaded = '○',
      plugin = ' ',
      runtime = ' ',
      require = '󰢱 ',
      source = ' ',
      start = '',
      task = '✔ ',
      list = {
        '●',
        '➜',
        '★',
        '‒',
      },
    },
  },
  performance = {
    cache = {
      enabled = true,
    },
    reset_packpath = true,
    rtp = {
      disabled_plugins = {
        'gzip',
        'matchit',
        'matchparen',
        'netrwPlugin',
        'tarPlugin',
        'tohtml',
        'tutor',
        'zipPlugin',
      },
    },
  },
}) 