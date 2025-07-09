-- ~/.config/nvim/lua/plugins/utils.lua
-- Utility plugins and quality of life improvements

return {
  -- Session management
  {
    'folke/persistence.nvim',
    event = 'BufReadPre',
    config = function()
      require('persistence').setup({
        dir = vim.fn.expand(vim.fn.stdpath('state') .. '/sessions/'),
        options = { 'buffers', 'curdir', 'tabpages', 'winsize', 'help', 'globals', 'skiprtp' },
        pre_save = nil,
      })

      -- Session keymaps
      vim.keymap.set('n', '<leader>qs', function() require('persistence').load() end, { desc = 'Restore session' })
      vim.keymap.set('n', '<leader>ql', function() require('persistence').load({ last = true }) end, { desc = 'Restore last session' })
      vim.keymap.set('n', '<leader>qd', function() require('persistence').stop() end, { desc = 'Stop session recording' })
    end,
  },

  -- Better escape
  {
    'max397574/better-escape.nvim',
    config = function()
      require('better_escape').setup({
        mapping = { 'jk', 'jj' },
        timeout = vim.o.timeoutlen,
        clear_empty_lines = false,
        keys = '<Esc>',
      })
    end,
  },

  -- Indentation guides
  {
    'lukas-reineke/indent-blankline.nvim',
    main = 'ibl',
    config = function()
      require('ibl').setup({
        indent = {
          char = '│',
          tab_char = '│',
        },
        scope = {
          enabled = true,
          show_start = true,
          show_end = false,
          injected_languages = false,
          highlight = { 'Function', 'Label' },
          priority = 500,
        },
        exclude = {
          filetypes = {
            'help',
            'alpha',
            'dashboard',
            'neo-tree',
            'Trouble',
            'lazy',
            'mason',
            'notify',
            'toggleterm',
            'lazyterm',
          },
        },
      })
    end,
  },

  -- Highlight colors
  {
    'NvChad/nvim-colorizer.lua',
    config = function()
      require('colorizer').setup({
        filetypes = { '*' },
        user_default_options = {
          RGB = true,
          RRGGBB = true,
          names = true,
          RRGGBBAA = false,
          AARRGGBB = false,
          rgb_fn = false,
          hsl_fn = false,
          css = false,
          css_fn = false,
          mode = 'background',
          tailwind = true,
          sass = { enable = false, parsers = { 'css' } },
          virtualtext = '■',
        },
        buftypes = {},
      })
    end,
  },

  -- Surround text objects
  {
    'kylechui/nvim-surround',
    version = '*',
    event = 'VeryLazy',
    config = function()
      require('nvim-surround').setup({
        keymaps = {
          insert = '<C-g>s',
          insert_line = '<C-g>S',
          normal = 'ys',
          normal_cur = 'yss',
          normal_line = 'yS',
          normal_cur_line = 'ySS',
          visual = 'S',
          visual_line = 'gS',
          delete = 'ds',
          change = 'cs',
          change_line = 'cS',
        },
        aliases = {
          ['a'] = '>',
          ['b'] = ')',
          ['B'] = '}',
          ['r'] = ']',
          ['q'] = { '"', "'", '`' },
          ['s'] = { '}', ']', ')', '>', '"', "'", '`' },
        },
        highlight = {
          duration = 0,
        },
        move_cursor = 'begin',
        indent_lines = function(start, stop)
          local b = vim.bo
          if b.filetype == 'yaml' then
            return false
          end
          return true
        end,
      })
    end,
  },

  -- Multiple cursors
  {
    'mg979/vim-visual-multi',
    branch = 'master',
    config = function()
      vim.g.VM_maps = {
        ['Find Under'] = '<C-d>',
        ['Find Subword Under'] = '<C-d>',
      }
      vim.g.VM_mouse_mappings = 1
    end,
  },

  -- Quick word motions
  {
    'phaazon/hop.nvim',
    branch = 'v2',
    config = function()
      require('hop').setup({
        keys = 'etovxqpdygfblzhckisuran',
        jump_on_sole_occurrence = true,
        case_insensitive = true,
        create_hl_autocmd = true,
      })

      -- Hop keymaps
      vim.keymap.set('n', '<leader>hw', ':HopWord<CR>', { desc = 'Hop to word' })
      vim.keymap.set('n', '<leader>hl', ':HopLine<CR>', { desc = 'Hop to line' })
      vim.keymap.set('n', '<leader>hc', ':HopChar1<CR>', { desc = 'Hop to character' })
      vim.keymap.set('n', '<leader>hp', ':HopPattern<CR>', { desc = 'Hop to pattern' })
      vim.keymap.set('n', 's', ':HopChar2<CR>', { desc = 'Hop to 2 characters' })
      vim.keymap.set('n', 'S', ':HopWord<CR>', { desc = 'Hop to word' })
    end,
  },

  -- Enhanced increment/decrement
  {
    'monaqa/dial.nvim',
    config = function()
      local augend = require('dial.augend')
      require('dial.config').augends:register_group({
        default = {
          augend.integer.alias.decimal,
          augend.integer.alias.hex,
          augend.date.alias['%Y/%m/%d'],
          augend.constant.alias.bool,
          augend.semver.alias.semver,
          augend.constant.new({
            elements = { 'and', 'or' },
            word = true,
            cyclic = true,
          }),
          augend.constant.new({
            elements = { '&&', '||' },
            word = false,
            cyclic = true,
          }),
          augend.constant.new({
            elements = { 'true', 'false' },
            word = true,
            cyclic = true,
          }),
          augend.constant.new({
            elements = { 'True', 'False' },
            word = true,
            cyclic = true,
          }),
          augend.constant.new({
            elements = { 'yes', 'no' },
            word = true,
            cyclic = true,
          }),
          augend.constant.new({
            elements = { 'on', 'off' },
            word = true,
            cyclic = true,
          }),
          augend.constant.new({
            elements = { 'enable', 'disable' },
            word = true,
            cyclic = true,
          }),
          augend.constant.new({
            elements = { 'enabled', 'disabled' },
            word = true,
            cyclic = true,
          }),
        },
      })

      vim.keymap.set('n', '<C-a>', require('dial.map').inc_normal(), { noremap = true })
      vim.keymap.set('n', '<C-x>', require('dial.map').dec_normal(), { noremap = true })
      vim.keymap.set('v', '<C-a>', require('dial.map').inc_visual(), { noremap = true })
      vim.keymap.set('v', '<C-x>', require('dial.map').dec_visual(), { noremap = true })
      vim.keymap.set('v', 'g<C-a>', require('dial.map').inc_gvisual(), { noremap = true })
      vim.keymap.set('v', 'g<C-x>', require('dial.map').dec_gvisual(), { noremap = true })
    end,
  },

  -- Better quickfix
  {
    'kevinhwang91/nvim-bqf',
    ft = 'qf',
    config = function()
      require('bqf').setup({
        auto_enable = true,
        auto_resize_height = true,
        preview = {
          win_height = 12,
          win_vheight = 12,
          delay_syntax = 80,
          border_chars = { '┃', '┃', '━', '━', '┏', '┓', '┗', '┛', '█' },
          show_title = false,
          should_preview_cb = function(bufnr, qwinid)
            local ret = true
            local bufname = vim.api.nvim_buf_get_name(bufnr)
            local fsize = vim.fn.getfsize(bufname)
            if fsize > 100 * 1024 then
              ret = false
            end
            return ret
          end,
        },
        func_map = {
          drop = 'o',
          openc = 'O',
          split = '<C-s>',
          vsplit = '<C-v>',
          tab = 't',
          tabb = 'T',
          tabc = '<C-t>',
          tabdrop = '',
          ptogglemode = 'z,',
          pscrollup = '<C-b>',
          pscrolldown = '<C-f>',
          pscrollorig = 'zo',
          prevfile = '<C-p>',
          nextfile = '<C-n>',
          prevhist = '<',
          nexthist = '>',
          lastleave = [['"]],
          stoggleup = '<S-Tab>',
          stoggledown = '<Tab>',
          stogglevm = '<Tab>',
          stogglebuf = [['<Tab>]],
          sclear = 'z<Tab>',
          filter = 'zn',
          filterr = 'zN',
          fzffilter = 'zf',
        },
        filter = {
          fzf = {
            action_for = { ['ctrl-s'] = 'split', ['ctrl-t'] = 'tab drop' },
            extra_opts = { '--bind', 'ctrl-o:toggle-all', '--prompt', '> ' },
          },
        },
      })
    end,
  },

  -- Zen mode for focused writing
  {
    'folke/zen-mode.nvim',
    config = function()
      require('zen-mode').setup({
        window = {
          backdrop = 0.95,
          width = 120,
          height = 1,
          options = {
            signcolumn = 'no',
            number = false,
            relativenumber = false,
            cursorline = false,
            cursorcolumn = false,
            foldcolumn = '0',
            list = false,
          },
        },
        plugins = {
          options = {
            enabled = true,
            ruler = false,
            showcmd = false,
          },
          twilight = { enabled = true },
          gitsigns = { enabled = false },
          tmux = { enabled = false },
        },
      })

      vim.keymap.set('n', '<leader>zz', require('zen-mode').toggle, { desc = 'Toggle Zen Mode' })
    end,
  },

  -- Focus on current window
  {
    'folke/twilight.nvim',
    config = function()
      require('twilight').setup({
        dimming = {
          alpha = 0.25,
          color = { 'Normal', '#ffffff' },
          term_bg = '#000000',
          inactive = false,
        },
        context = 10,
        treesitter = true,
        expand = {
          'function',
          'method',
          'table',
          'if_statement',
        },
        exclude = {},
      })

      vim.keymap.set('n', '<leader>zt', require('twilight').toggle, { desc = 'Toggle Twilight' })
    end,
  },

  -- Smooth scrolling
  {
    'karb94/neoscroll.nvim',
    config = function()
      require('neoscroll').setup({
        mappings = { '<C-u>', '<C-d>', '<C-b>', '<C-f>', '<C-y>', '<C-e>', 'zt', 'zz', 'zb' },
        hide_cursor = true,
        stop_eof = true,
        respect_scrolloff = false,
        cursor_scrolls_alone = true,
        easing_function = nil,
        pre_hook = nil,
        post_hook = nil,
        performance_mode = false,
      })
    end,
  },

  -- Split/join code blocks
  {
    'Wansmer/treesj',
    dependencies = { 'nvim-treesitter/nvim-treesitter' },
    config = function()
      require('treesj').setup({
        use_default_keymaps = false,
        check_syntax_error = true,
        max_join_length = 120,
        cursor_behavior = 'hold',
        notify = true,
        dot_repeat = true,
      })

      vim.keymap.set('n', '<leader>j', require('treesj').toggle, { desc = 'Toggle split/join' })
      vim.keymap.set('n', '<leader>J', function()
        require('treesj').toggle({ split = { recursive = true } })
      end, { desc = 'Toggle split/join recursively' })
    end,
  },
} 