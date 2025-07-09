-- ~/.config/nvim/lua/plugins/react.lua
-- React/TypeScript specific plugins

return {
  -- React snippets and utilities
  {
    'mlaursen/vim-react-snippets',
    dependencies = { 'L3MON4D3/LuaSnip' },
    ft = { 'javascript', 'javascriptreact', 'typescript', 'typescriptreact' },
    config = function()
      require('luasnip.loaders.from_vscode').lazy_load({ 
        paths = { vim.fn.stdpath('data') .. '/lazy/vim-react-snippets' } 
      })
    end,
  },

  -- Package.json management
  {
    'vuki656/package-info.nvim',
    dependencies = { 'MunifTanjim/nui.nvim' },
    ft = 'json',
    config = function()
      require('package-info').setup({
        colors = {
          up_to_date = "#3C4048",
          outdated = "#d19a66",
        },
        icons = {
          enable = true,
          style = {
            up_to_date = "|  ",
            outdated = "|  ",
          },
        },
        autostart = true,
        hide_up_to_date = false,
        hide_unstable_versions = false,
        package_manager = 'npm'
      })

      -- Package.json keymaps
      vim.keymap.set('n', '<leader>ns', require('package-info').show, { desc = 'Show package versions', silent = true })
      vim.keymap.set('n', '<leader>nc', require('package-info').hide, { desc = 'Hide package versions', silent = true })
      vim.keymap.set('n', '<leader>nu', require('package-info').update, { desc = 'Update package', silent = true })
      vim.keymap.set('n', '<leader>nd', require('package-info').delete, { desc = 'Delete package', silent = true })
      vim.keymap.set('n', '<leader>ni', require('package-info').install, { desc = 'Install package', silent = true })
      vim.keymap.set('n', '<leader>np', require('package-info').change_version, { desc = 'Change package version', silent = true })
    end,
  },

  -- TypeScript import cost display
  {
    'yardnsm/vim-import-cost',
    build = 'npm install --production',
    ft = { 'javascript', 'javascriptreact', 'typescript', 'typescriptreact' },
    config = function()
      vim.g.import_cost_show_gzipped = true
      -- Auto-refresh import cost on file changes
      vim.api.nvim_create_autocmd({ 'BufWritePost', 'InsertLeave' }, {
        pattern = { '*.ts', '*.tsx', '*.js', '*.jsx' },
        callback = function()
          vim.cmd('ImportCostRefresh')
        end,
      })
    end,
  },

  -- React component hierarchy and utilities
  {
    'David-Kunz/cmp-npm',
    dependencies = { 'nvim-lua/plenary.nvim' },
    ft = 'json',
    config = function()
      require('cmp-npm').setup({})
      
      -- Add to cmp sources for package.json files
      local cmp = require('cmp')
      cmp.setup.filetype('json', {
        sources = cmp.config.sources({
          { name = 'npm', keyword_length = 4 },
          { name = 'nvim_lsp' },
          { name = 'buffer' },
        })
      })
    end,
  },

  -- Better JSX/TSX support with auto-closing tags
  {
    'windwp/nvim-ts-autotag',
    dependencies = { 'nvim-treesitter/nvim-treesitter' },
    ft = { 'html', 'javascript', 'typescript', 'javascriptreact', 'typescriptreact', 'vue', 'xml' },
    config = function()
      require('nvim-ts-autotag').setup({
        opts = {
          enable_close = true,
          enable_rename = true,
          enable_close_on_slash = false
        },
        per_filetype = {
          ["html"] = {
            enable_close = false
          }
        }
      })
    end,
  },

  -- Enhanced React development tools
  {
    'nvim-treesitter/nvim-treesitter-textobjects',
    dependencies = { 'nvim-treesitter/nvim-treesitter' },
  },

  -- React/Next.js specific snippets and tools
  {
    'dsznajder/vscode-es7-javascript-react-snippets',
    build = 'yarn install --frozen-lockfile && yarn compile',
    ft = { 'javascript', 'javascriptreact', 'typescript', 'typescriptreact' },
  },

  -- React prop/state management helpers
  {
    'maxmellon/vim-jsx-pretty',
    ft = { 'javascript', 'javascriptreact', 'typescript', 'typescriptreact' },
    config = function()
      vim.g.vim_jsx_pretty_colorful_config = 1
    end,
  },

  -- Tailwind CSS utilities
  {
    'roobert/tailwindcss-colorizer-cmp.nvim',
    dependencies = { 'nvim-cmp' },
    config = function()
      require('tailwindcss-colorizer-cmp').setup({
        color_square_width = 2,
      })
      
      -- Add to cmp formatting
      local cmp = require('cmp')
      local format_kinds = cmp.config.formatting.format or function(entry, vim_item) return vim_item end
      
      cmp.setup({
        formatting = {
          format = function(entry, vim_item)
            vim_item = format_kinds(entry, vim_item)
            return require('tailwindcss-colorizer-cmp').formatter(entry, vim_item)
          end
        }
      })
    end,
  },

  -- React testing utilities
  {
    'haydenmeade/neotest-jest',
    dependencies = {
      'nvim-neotest/neotest',
      'nvim-lua/plenary.nvim',
      'antoinemadec/FixCursorHold.nvim',
      'nvim-treesitter/nvim-treesitter'
    },
  },

  -- React Native specific support
  {
    'microsoft/vscode-react-native',
    build = 'npm install && npm run compile',
    ft = { 'javascript', 'javascriptreact', 'typescript', 'typescriptreact' },
    config = function()
      -- React Native specific keymaps
      vim.keymap.set('n', '<leader>rns', ':ReactNativeStart<CR>', { desc = 'Start React Native' })
      vim.keymap.set('n', '<leader>rnr', ':ReactNativeReload<CR>', { desc = 'Reload React Native' })
      vim.keymap.set('n', '<leader>rnd', ':ReactNativeDebug<CR>', { desc = 'Debug React Native' })
    end,
  },
} 