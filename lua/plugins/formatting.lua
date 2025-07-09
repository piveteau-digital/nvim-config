-- ~/.config/nvim/lua/plugins/formatting.lua
-- Code formatting configuration

return {
  {
    'stevearc/conform.nvim',
    config = function()
      require('conform').setup({
        formatters_by_ft = {
          -- Web technologies
          lua = { 'stylua' },
          typescript = { 'prettier' },
          javascript = { 'prettier' },
          typescriptreact = { 'prettier' },
          javascriptreact = { 'prettier' },
          json = { 'prettier' },
          jsonc = { 'prettier' },
          json5 = { 'prettier' },
          css = { 'prettier' },
          scss = { 'prettier' },
          sass = { 'prettier' },
          html = { 'prettier' },
          markdown = { 'prettier' },
          mdx = { 'prettier' },
          yaml = { 'prettier' },
          yml = { 'prettier' },
          graphql = { 'prettier' },
          
          -- Other languages
          python = { 'black' },
          rust = { 'rustfmt' },
          go = { 'gofmt' },
          sh = { 'shfmt' },
          bash = { 'shfmt' },
          zsh = { 'shfmt' },
        },
        
        format_on_save = {
          timeout_ms = 500,
          lsp_fallback = true,
        },
        
        format_after_save = {
          lsp_fallback = true,
        },
        
        formatters = {
          prettier = {
            options = {
              ft_parsers = {
                javascript = "babel",
                javascriptreact = "babel",
                typescript = "typescript",
                typescriptreact = "typescript",
                vue = "vue",
                css = "css",
                scss = "scss",
                less = "less",
                html = "html",
                json = "json",
                jsonc = "json",
                yaml = "yaml",
                markdown = "markdown",
                mdx = "mdx",
                graphql = "graphql",
                handlebars = "glimmer",
              },
            },
          },
        },
      })

      -- Format keymaps
      vim.keymap.set({ 'n', 'v' }, '<leader>f', function()
        require('conform').format({
          lsp_fallback = true,
          async = false,
          timeout_ms = 1000,
        })
      end, { desc = 'Format file or range (in visual mode)' })

      vim.keymap.set('n', '<D-S-f>', function()
        require('conform').format({
          lsp_fallback = true,
          async = false,
          timeout_ms = 1000,
        })
      end, { desc = 'Format code (IntelliJ style)' })
    end,
  },
} 