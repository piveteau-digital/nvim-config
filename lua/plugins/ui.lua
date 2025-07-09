-- ~/.config/nvim/lua/plugins/ui.lua
-- UI plugins configuration

return {
  -- Color scheme
  {
    'folke/tokyonight.nvim',
    lazy = false,
    priority = 1000,
    config = function()
      require('tokyonight').setup({
        style = 'night',
        transparent = false,
        terminal_colors = true,
        styles = {
          comments = { italic = true },
          keywords = { italic = true },
          functions = {},
          variables = {},
        },
        on_colors = function(colors)
          colors.border = colors.blue7
        end,
        on_highlights = function(highlights, colors)
          highlights.DiagnosticVirtualTextError = {
            bg = colors.none,
            fg = colors.red1,
          }
          highlights.DiagnosticVirtualTextWarn = {
            bg = colors.none,
            fg = colors.yellow,
          }
          highlights.DiagnosticVirtualTextInfo = {
            bg = colors.none,
            fg = colors.blue2,
          }
          highlights.DiagnosticVirtualTextHint = {
            bg = colors.none,
            fg = colors.teal,
          }
        end,
      })
      vim.cmd.colorscheme('tokyonight')
    end,
  },

  -- Status line
  {
    'nvim-lualine/lualine.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function()
      require('lualine').setup({
        options = {
          theme = 'tokyonight',
          component_separators = { left = '', right = '' },
          section_separators = { left = '', right = '' },
          globalstatus = true,
        },
        sections = {
          lualine_a = { 'mode' },
          lualine_b = { 'branch', 'diff', 'diagnostics' },
          lualine_c = { 
            {
              'filename',
              path = 1, -- Show relative path
            }
          },
          lualine_x = { 
            {
              function()
                local clients = vim.lsp.get_active_clients({ bufnr = 0 })
                if #clients == 0 then
                  return 'No LSP'
                end
                
                local names = {}
                for _, client in pairs(clients) do
                  table.insert(names, client.name)
                end
                return table.concat(names, ', ')
              end,
              icon = ' LSP:',
            },
            'encoding', 
            'fileformat', 
            'filetype' 
          },
          lualine_y = { 'progress' },
          lualine_z = { 'location' }
        },
      })
    end,
  },

  -- Buffer line
  {
    'akinsho/bufferline.nvim',
    version = '*',
    dependencies = 'nvim-tree/nvim-web-devicons',
    config = function()
      require('bufferline').setup({
        options = {
          mode = 'buffers',
          separator_style = 'slant',
          always_show_bufferline = false,
          show_buffer_close_icons = false,
          show_close_icon = false,
          color_icons = true,
          diagnostics = 'nvim_lsp',
          diagnostics_indicator = function(count, level, diagnostics_dict, context)
            local s = " "
            for e, n in pairs(diagnostics_dict) do
              local sym = e == "error" and " " or (e == "warning" and " " or "")
              s = s .. n .. sym
            end
            return s
          end,
          offsets = {
            {
              filetype = 'NvimTree',
              text = 'File Explorer',
              text_align = 'center',
              separator = true,
            }
          },
        },
      })
    end,
  },

  -- File explorer
  {
    'nvim-tree/nvim-tree.lua',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function()
      require('nvim-tree').setup({
        disable_netrw = true,
        hijack_netrw = true,
        view = {
          width = 35,
          side = 'left',
        },
        renderer = {
          group_empty = true,
          highlight_git = true,
          icons = {
            glyphs = {
              default = '',
              symlink = '',
              bookmark = '',
              git = {
                unstaged = '✗',
                staged = '✓',
                unmerged = '',
                renamed = '➜',
                deleted = '',
                untracked = '★',
                ignored = '◌',
              },
            },
          },
        },
        filters = {
          dotfiles = false,
          custom = { '.git', 'node_modules', '.cache', '.DS_Store' },
        },
        git = {
          enable = true,
          ignore = true,
        },
        actions = {
          open_file = {
            quit_on_open = false,
            resize_window = true,
          },
        },
        update_focused_file = {
          enable = true,
          update_cwd = true,
        },
      })

      -- Keymaps for nvim-tree
      vim.keymap.set('n', '<leader>e', ':NvimTreeToggle<CR>', { desc = 'Toggle file explorer' })
      vim.keymap.set('n', '<D-1>', ':NvimTreeToggle<CR>', { desc = 'Toggle file explorer' })
      vim.keymap.set('n', '<leader>ef', ':NvimTreeFindFileToggle<CR>', { desc = 'Find file in explorer' })
    end,
  },

  -- Which-key (key hints)
  {
    'folke/which-key.nvim',
    event = 'VeryLazy',
    config = function()
      vim.o.timeout = true
      vim.o.timeoutlen = 300
      require('which-key').setup({
        plugins = {
          marks = true,
          registers = true,
          spelling = {
            enabled = true,
            suggestions = 20,
          },
          presets = {
            operators = true,
            motions = true,
            text_objects = true,
            windows = true,
            nav = true,
            z = true,
            g = true,
          },
        },
        window = {
          border = 'rounded',
          position = 'bottom',
          margin = { 1, 0, 1, 0 },
          padding = { 2, 2, 2, 2 },
          winblend = 0,
        },
        layout = {
          height = { min = 4, max = 25 },
          width = { min = 20, max = 50 },
          spacing = 3,
          align = 'left',
        },
      })
    end,
  },

  -- Terminal
  {
    'akinsho/toggleterm.nvim',
    version = '*',
    config = function()
      require('toggleterm').setup({
        size = 20,
        open_mapping = [[<C-\>]],
        hide_numbers = true,
        shade_filetypes = {},
        shade_terminals = true,
        shading_factor = 2,
        start_in_insert = true,
        insert_mappings = true,
        persist_size = true,
        direction = 'float',
        close_on_exit = true,
        shell = vim.o.shell,
        float_opts = {
          border = 'curved',
          winblend = 0,
          highlights = {
            border = 'Normal',
            background = 'Normal',
          },
        },
      })

      -- Terminal keymaps
      function _G.set_terminal_keymaps()
        local opts = {buffer = 0}
        vim.keymap.set('t', '<esc>', [[<C-\><C-n>]], opts)
        vim.keymap.set('t', 'jk', [[<C-\><C-n>]], opts)
        vim.keymap.set('t', '<C-h>', [[<Cmd>wincmd h<CR>]], opts)
        vim.keymap.set('t', '<C-j>', [[<Cmd>wincmd j<CR>]], opts)
        vim.keymap.set('t', '<C-k>', [[<Cmd>wincmd k<CR>]], opts)
        vim.keymap.set('t', '<C-l>', [[<Cmd>wincmd l<CR>]], opts)
      end

      vim.cmd('autocmd! TermOpen term://* lua set_terminal_keymaps()')
    end,
  },

  -- Notification system
  {
    'rcarriga/nvim-notify',
    config = function()
      require('notify').setup({
        background_colour = '#000000',
        fps = 30,
        icons = {
          DEBUG = '',
          ERROR = '',
          INFO = '',
          TRACE = '✎',
          WARN = ''
        },
        level = 2,
        minimum_width = 50,
        render = 'default',
        stages = 'fade_in_slide_out',
        timeout = 5000,
        top_down = true
      })
      vim.notify = require('notify')
    end,
  },

  -- Markdown preview
  {
    'MeanderingProgrammer/render-markdown.nvim',
    dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-tree/nvim-web-devicons' },
    ft = { 'markdown', 'mdx' },
    config = function()
      require('render-markdown').setup({
        heading = {
          enabled = true,
          sign = true,
          icons = { '󰲡 ', '󰲣 ', '󰲥 ', '󰲧 ', '󰲩 ', '󰲫 ' },
        },
        code = {
          enabled = true,
          sign = false,
          style = 'full',
          position = 'left',
          language_pad = 0,
          disable_background = { 'diff' },
        },
      })
    end,
  },
} 