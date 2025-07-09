-- ~/.config/nvim/lua/plugins/telescope.lua
-- Fuzzy finder and search configuration

return {
  {
    'nvim-telescope/telescope.nvim',
    tag = '0.1.4',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'BurntSushi/ripgrep',
      'nvim-tree/nvim-web-devicons',
      { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
      'nvim-telescope/telescope-live-grep-args.nvim',
      'ahmedkhalf/project.nvim',
    },
    config = function()
      local telescope = require('telescope')
      local actions = require('telescope.actions')
      
      telescope.setup({
        defaults = {
          file_ignore_patterns = { 
            'node_modules', '.git', 'dist', '.next', '.nuxt', 'build', 
            '%.lock', 'package-lock.json', 'yarn.lock', 'pnpm-lock.yaml',
            '%.jpg', '%.jpeg', '%.png', '%.svg', '%.gif', '%.ico', '%.pdf'
          },
          mappings = {
            i = {
              ['<C-u>'] = false,
              ['<C-d>'] = false,
              ['<C-j>'] = actions.move_selection_next,
              ['<C-k>'] = actions.move_selection_previous,
              ['<Esc>'] = actions.close,
              ['<C-q>'] = actions.send_to_qflist + actions.open_qflist,
              ['<C-x>'] = actions.select_horizontal,
              ['<C-v>'] = actions.select_vertical,
              ['<C-t>'] = actions.select_tab,
            },
            n = {
              ['q'] = actions.close,
              ['<C-q>'] = actions.send_to_qflist + actions.open_qflist,
            },
          },
          vimgrep_arguments = {
            'rg',
            '--color=never',
            '--no-heading',
            '--with-filename',
            '--line-number',
            '--column',
            '--smart-case',
            '--hidden',
            '--glob=!.git/',
          },
          prompt_prefix = ' 🔍 ',
          selection_caret = ' ▶ ',
          entry_prefix = '  ',
          initial_mode = 'insert',
          selection_strategy = 'reset',
          sorting_strategy = 'ascending',
          layout_strategy = 'horizontal',
          layout_config = {
            horizontal = {
              mirror = false,
              prompt_position = 'top',
              preview_width = 0.55,
              results_width = 0.8,
            },
            vertical = {
              mirror = false,
              preview_height = 0.35,
            },
            center = {
              preview_cutoff = 40,
            },
            width = 0.87,
            height = 0.80,
            preview_cutoff = 120,
          },
          winblend = 0,
          border = {},
          borderchars = { '─', '│', '─', '│', '╭', '╮', '╯', '╰' },
          color_devicons = true,
          use_less = true,
          path_display = { 'truncate' },
          set_env = { ['COLORTERM'] = 'truecolor' },
        },
        
        pickers = {
          find_files = {
            hidden = true,
            find_command = { 'rg', '--files', '--hidden', '--glob', '!.git/*' },
          },
          live_grep = {
            additional_args = function(opts)
              return { '--hidden' }
            end,
          },
          buffers = {
            show_all_buffers = true,
            sort_lastused = true,
            theme = 'dropdown',
            previewer = false,
            mappings = {
              i = {
                ['<c-d>'] = actions.delete_buffer,
              }
            }
          },
          git_files = {
            theme = 'dropdown',
            previewer = false,
          },
          lsp_references = {
            theme = 'dropdown',
            initial_mode = 'normal',
          },
          lsp_definitions = {
            theme = 'dropdown',
            initial_mode = 'normal',
          },
          lsp_implementations = {
            theme = 'dropdown',
            initial_mode = 'normal',
          },
        },
        
        extensions = {
          fzf = {
            fuzzy = true,
            override_generic_sorter = true,
            override_file_sorter = true,
            case_mode = 'smart_case',
          },
          live_grep_args = {
            auto_quoting = true,
            mappings = {
              i = {
                ['<C-k>'] = require('telescope-live-grep-args.actions').quote_prompt(),
                ['<C-i>'] = require('telescope-live-grep-args.actions').quote_prompt({ postfix = ' --iglob ' }),
              },
            },
          },
        },
      })

      -- Load extensions
      telescope.load_extension('fzf')
      telescope.load_extension('live_grep_args')
      telescope.load_extension('projects')

      -- Keymaps
      local builtin = require('telescope.builtin')
      local keymap = vim.keymap.set
      
      -- File finding
      keymap('n', '<leader>ff', builtin.find_files, { desc = 'Find files' })
      keymap('n', '<leader>fg', builtin.live_grep, { desc = 'Search in files' })
      keymap('n', '<leader>fb', builtin.buffers, { desc = 'Find buffers' })
      keymap('n', '<leader>fh', builtin.help_tags, { desc = 'Find help' })
      keymap('n', '<leader>fr', builtin.oldfiles, { desc = 'Recent files' })
      keymap('n', '<leader>fs', builtin.grep_string, { desc = 'Search current word' })
      keymap('n', '<leader>fc', builtin.commands, { desc = 'Find commands' })
      keymap('n', '<leader>fk', builtin.keymaps, { desc = 'Find keymaps' })
      keymap('n', '<leader>ft', builtin.filetypes, { desc = 'Find filetypes' })
      
      -- IntelliJ shortcuts
      keymap('n', '<D-p>', builtin.find_files, { desc = 'Find files' })
      keymap('n', '<D-f>', function()
        require('telescope').extensions.live_grep_args.live_grep_args()
      end, { desc = 'Search in files' })
      keymap('n', '<D-e>', builtin.oldfiles, { desc = 'Recent files' })
      keymap('n', '<D-r>', builtin.lsp_references, { desc = 'Find references' })
      keymap('n', '<D-b>', builtin.lsp_definitions, { desc = 'Go to definition' })
      keymap('n', '<C-D-Up>', builtin.lsp_implementations, { desc = 'Go to implementation' })
      
      -- Git integration
      keymap('n', '<leader>gf', builtin.git_files, { desc = 'Git files' })
      keymap('n', '<leader>gc', builtin.git_commits, { desc = 'Git commits' })
      keymap('n', '<leader>gb', builtin.git_branches, { desc = 'Git branches' })
      keymap('n', '<leader>gs', builtin.git_status, { desc = 'Git status' })
      
      -- LSP integration
      keymap('n', '<leader>ld', builtin.lsp_definitions, { desc = 'LSP definitions' })
      keymap('n', '<leader>lr', builtin.lsp_references, { desc = 'LSP references' })
      keymap('n', '<leader>li', builtin.lsp_implementations, { desc = 'LSP implementations' })
      keymap('n', '<leader>lt', builtin.lsp_type_definitions, { desc = 'LSP type definitions' })
      keymap('n', '<leader>ls', builtin.lsp_document_symbols, { desc = 'LSP document symbols' })
      keymap('n', '<leader>lw', builtin.lsp_workspace_symbols, { desc = 'LSP workspace symbols' })
      
      -- Project management
      keymap('n', '<leader>pp', '<cmd>Telescope projects<cr>', { desc = 'Find projects' })
      
      -- Diagnostics
      keymap('n', '<leader>xx', builtin.diagnostics, { desc = 'Diagnostics' })
    end,
  },

  -- Project management for monorepos
  {
    'ahmedkhalf/project.nvim',
    config = function()
      require('project_nvim').setup({
        detection_methods = { 'lsp', 'pattern' },
        patterns = { 
          '.git', 
          '_darcs', 
          '.hg', 
          '.bzr', 
          '.svn', 
          'Makefile', 
          'package.json',
          'turbo.json',
          'nx.json',
          'lerna.json',
          'rush.json',
          'pnpm-workspace.yaml',
          'yarn.lock',
          'cargo.toml',
        },
        exclude_dirs = { '*/node_modules/*', '*/dist/*', '*/build/*' },
        show_hidden = false,
        silent_chdir = true,
        scope_chdir = 'global',
      })
    end,
  },
} 