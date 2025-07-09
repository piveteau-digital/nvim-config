-- ~/.config/nvim/lua/plugins/treesitter.lua
-- Treesitter configuration for enhanced syntax highlighting

return {
  {
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
    dependencies = {
      'nvim-treesitter/nvim-treesitter-textobjects',
      'windwp/nvim-ts-autotag',
    },
    config = function()
      require('nvim-treesitter.configs').setup({
        ensure_installed = {
          -- Web technologies
          'typescript',
          'tsx',
          'javascript',
          'jsx',
          'html',
          'css',
          'scss',
          'json',
          'json5',
          'jsonc',
          'yaml',
          'toml',
          'graphql',
          'markdown',
          'markdown_inline',
          'mdx',
          
          -- Configuration files
          'lua',
          'vim',
          'vimdoc',
          'dockerfile',
          'bash',
          'fish',
          
          -- Other languages
          'python',
          'rust',
          'go',
          'prisma',
          'sql',
          'regex',
          'comment',
          
          -- Mobile development
          'kotlin',
          'swift',
          'java',
        },
        
        highlight = {
          enable = true,
          additional_vim_regex_highlighting = false,
        },
        
        indent = { 
          enable = true,
          disable = { 'yaml', 'python' } -- These can be problematic
        },
        
        autotag = { 
          enable = true,
          enable_rename = true,
          enable_close = true,
          enable_close_on_slash = false,
          filetypes = {
            'html', 'javascript', 'typescript', 'javascriptreact', 'typescriptreact', 
            'svelte', 'vue', 'tsx', 'jsx', 'rescript', 'xml', 'php', 'markdown', 
            'astro', 'glimmer', 'handlebars', 'hbs'
          }
        },
        
        textobjects = {
          select = {
            enable = true,
            lookahead = true,
            keymaps = {
              -- Function selections
              ['af'] = '@function.outer',
              ['if'] = '@function.inner',
              ['ac'] = '@class.outer',
              ['ic'] = '@class.inner',
              
              -- Loop selections
              ['al'] = '@loop.outer',
              ['il'] = '@loop.inner',
              
              -- Conditional selections
              ['ai'] = '@conditional.outer',
              ['ii'] = '@conditional.inner',
              
              -- Parameter/argument selections
              ['aa'] = '@parameter.outer',
              ['ia'] = '@parameter.inner',
              
              -- Comment selections
              ['aC'] = '@comment.outer',
              ['iC'] = '@comment.inner',
              
              -- Block selections
              ['ab'] = '@block.outer',
              ['ib'] = '@block.inner',
              
              -- Call selections
              ['ak'] = '@call.outer',
              ['ik'] = '@call.inner',
            },
          },
          
          move = {
            enable = true,
            set_jumps = true,
            goto_next_start = {
              [']f'] = '@function.outer',
              [']c'] = '@class.outer',
              [']a'] = '@parameter.inner',
              [']k'] = '@call.outer',
            },
            goto_next_end = {
              [']F'] = '@function.outer',
              [']C'] = '@class.outer',
              [']A'] = '@parameter.inner',
              [']K'] = '@call.outer',
            },
            goto_previous_start = {
              ['[f'] = '@function.outer',
              ['[c'] = '@class.outer',
              ['[a'] = '@parameter.inner',
              ['[k'] = '@call.outer',
            },
            goto_previous_end = {
              ['[F'] = '@function.outer',
              ['[C'] = '@class.outer',
              ['[A'] = '@parameter.inner',
              ['[K'] = '@call.outer',
            },
          },
          
          swap = {
            enable = true,
            swap_next = {
              ['<leader>na'] = '@parameter.inner',
            },
            swap_previous = {
              ['<leader>pa'] = '@parameter.inner',
            },
          },
        },
        
        incremental_selection = {
          enable = true,
          keymaps = {
            init_selection = '<C-space>',
            node_incremental = '<C-space>',
            scope_incremental = '<C-s>',
            node_decremental = '<M-space>',
          },
        },
        
        rainbow = {
          enable = true,
          extended_mode = true,
          max_file_lines = nil,
          colors = {
            '#68a0b0',
            '#946EaD',
            '#c7aA6D',
          },
        },
      })
      
      -- Set up folding with treesitter
      vim.opt.foldmethod = 'expr'
      vim.opt.foldexpr = 'nvim_treesitter#foldexpr()'
      vim.opt.foldenable = false -- Don't fold by default
    end,
  },
} 