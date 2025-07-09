-- ~/.config/nvim/lua/plugins/lsp.lua
-- LSP configuration with enhanced TypeScript/React support

return {
  {
    'neovim/nvim-lspconfig',
    dependencies = {
      'williamboman/mason.nvim',
      'williamboman/mason-lspconfig.nvim',
      'j-hui/fidget.nvim',
      'pmizio/typescript-tools.nvim',
      'b0o/schemastore.nvim',
    },
    config = function()
      -- Mason setup
      require('mason').setup({
        ui = {
          border = 'rounded',
          icons = {
            package_installed = '✓',
            package_pending = '➜',
            package_uninstalled = '✗'
          }
        }
      })
      
      require('mason-lspconfig').setup({
        ensure_installed = {
          'lua_ls',
          'tsserver',
          'eslint',
          'tailwindcss',
          'cssls',
          'html',
          'jsonls',
          'emmet_ls',
          'pyright',
          'rust_analyzer',
          'gopls',
        },
        automatic_installation = true,
      })

      -- LSP progress indicator
      require('fidget').setup({
        notification = {
          window = {
            winblend = 100,
          },
        },
      })

      -- Enhanced TypeScript Tools setup
      require('typescript-tools').setup({
        on_attach = function(client, bufnr)
          -- Disable tsserver's formatting in favor of prettier
          client.server_capabilities.documentFormattingProvider = false
          client.server_capabilities.documentRangeFormattingProvider = false
          
          -- TypeScript specific keymaps
          local opts = { buffer = bufnr, silent = true }
          vim.keymap.set('n', '<leader>rf', ':TSToolsFileReferences<CR>', opts)
          vim.keymap.set('n', '<leader>rF', ':TSToolsRenameFile<CR>', opts)
          vim.keymap.set('n', '<leader>oi', ':TSToolsOrganizeImports<CR>', opts)
          vim.keymap.set('n', '<leader>si', ':TSToolsSortImports<CR>', opts)
          vim.keymap.set('n', '<leader>ru', ':TSToolsRemoveUnused<CR>', opts)
          vim.keymap.set('n', '<leader>ai', ':TSToolsAddMissingImports<CR>', opts)
          vim.keymap.set('n', '<leader>fa', ':TSToolsFixAll<CR>', opts)
          vim.keymap.set('n', 'gS', ':TSToolsGoToSourceDefinition<CR>', opts)
        end,
        settings = {
          separate_diagnostic_server = true,
          publish_diagnostic_on = "insert_leave",
          expose_as_code_action = {
            "fix_all",
            "add_missing_imports",
            "remove_unused",
            "remove_unused_imports",
            "organize_imports",
          },
          tsserver_path = nil,
          tsserver_plugins = {
            "@styled/typescript-styled-plugin",
          },
          tsserver_max_memory = "auto",
          tsserver_format_options = {
            allowIncompleteCompletions = false,
            allowRenameOfImportPath = false,
          },
          tsserver_file_preferences = {
            includeInlayParameterNameHints = "all",
            includeInlayParameterNameHintsWhenArgumentMatchesName = false,
            includeInlayFunctionParameterTypeHints = true,
            includeInlayVariableTypeHints = true,
            includeInlayPropertyDeclarationTypeHints = true,
            includeInlayFunctionLikeReturnTypeHints = true,
            includeInlayEnumMemberValueHints = true,
            importModuleSpecifier = "shortest",
            includePackageJsonAutoImports = "auto",
          },
          jsx_close_tag = {
            enable = true,
            filetypes = { "javascriptreact", "typescriptreact" },
          }
        },
      })

      -- LSP capabilities
      local capabilities = vim.lsp.protocol.make_client_capabilities()
      capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)
      
      -- Enhanced capabilities for React/TypeScript
      capabilities.textDocument.completion.completionItem.snippetSupport = true
      capabilities.textDocument.completion.completionItem.resolveSupport = {
        properties = { "documentation", "detail", "additionalTextEdits" }
      }

      -- LSP servers setup
      local lspconfig = require('lspconfig')
      local servers = {
        lua_ls = {
          settings = {
            Lua = {
              workspace = { checkThirdParty = false },
              telemetry = { enable = false },
              diagnostics = { globals = { 'vim' } },
            },
          },
        },
        eslint = {
          settings = {
            codeAction = {
              disableRuleComment = {
                enable = true,
                location = "separateLine"
              },
              showDocumentation = {
                enable = true
              }
            },
            codeActionOnSave = {
              enable = false,
              mode = "all"
            },
            experimental = {
              useFlatConfig = false
            },
            format = true,
            nodePath = "",
            onIgnoredFiles = "off",
            packageManager = "npm",
            problems = {
              shortenToSingleLine = false
            },
            quiet = false,
            rulesCustomizations = {},
            run = "onType",
            useESLintClass = false,
            validate = "on",
            workingDirectory = {
              mode = "location"
            }
          },
          on_attach = function(client, bufnr)
            -- Auto-fix on save
            vim.api.nvim_create_autocmd("BufWritePre", {
              buffer = bufnr,
              command = "EslintFixAll",
            })
          end,
        },
        tailwindcss = {
          settings = {
            tailwindCSS = {
              experimental = {
                classRegex = {
                  "tw`([^`]*)",
                  "tw=\"([^\"]*)",
                  "tw={\"([^\"}]*)",
                  "tw\\.\\w+`([^`]*)",
                  "tw\\(.*?\\)`([^`]*)",
                  { "clsx\\(([^)]*)\\)", "(?:'|\"|`)([^']*)(?:'|\"|`)" },
                  { "classnames\\(([^)]*)\\)", "'([^']*)'" },
                  { "cva\\(([^)]*)\\)", "[\"'`]([^\"'`]*).*?[\"'`]" },
                  { "cn\\(([^)]*)\\)", "(?:'|\"|`)([^']*)(?:'|\"|`)" },
                },
              },
              validate = true,
              lint = {
                cssConflict = "warning",
                invalidApply = "error",
                invalidConfigPath = "error",
                invalidScreen = "error",
                invalidTailwindDirective = "error",
                invalidVariant = "error",
                recommendedVariantOrder = "warning"
              },
              classAttributes = {
                "class", "className", "class:list", "classList", "ngClass", "style"
              }
            }
          },
          filetypes = {
            "aspnetcorerazor", "astro", "astro-markdown", "blade", "clojure", "django-html", 
            "htmldjango", "edge", "eelixir", "elixir", "ejs", "erb", "eruby", "gohtml", 
            "gohtmltmpl", "haml", "handlebars", "hbs", "html", "html-eex", "heex", "jade", 
            "leaf", "liquid", "markdown", "mdx", "mustache", "njk", "nunjucks", "php", 
            "razor", "slim", "twig", "css", "less", "postcss", "sass", "scss", "stylus", 
            "sugarss", "javascript", "javascriptreact", "reason", "rescript", "typescript", 
            "typescriptreact", "vue", "svelte", "templ"
          }
        },
        emmet_ls = {
          filetypes = {
            "html", "typescriptreact", "javascriptreact", "css", "sass", "scss", "less", "vue",
          },
          init_options = {
            html = {
              options = {
                ["bem.enabled"] = true,
              },
            },
          },
        },
        cssls = {
          settings = {
            css = {
              validate = true,
              lint = { unknownAtRules = "ignore" }
            },
            scss = {
              validate = true,
              lint = { unknownAtRules = "ignore" }
            },
            less = {
              validate = true,
              lint = { unknownAtRules = "ignore" }
            }
          }
        },
        html = {
          filetypes = { "html", "templ" }
        },
        jsonls = {
          settings = {
            json = {
              schemas = require('schemastore').json.schemas(),
              validate = { enable = true },
            },
          },
        },
        pyright = {},
        rust_analyzer = {},
        gopls = {},
      }

      for server, config in pairs(servers) do
        if server ~= 'tsserver' then -- Skip tsserver as we use typescript-tools
          config.capabilities = capabilities
          lspconfig[server].setup(config)
        end
      end

      -- Enhanced LSP keymaps
      vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('UserLspConfig', {}),
        callback = function(ev)
          local opts = { buffer = ev.buf, silent = true }
          
          -- Navigation
          vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
          vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
          vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
          vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
          vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opts)
          vim.keymap.set('n', '<leader>D', vim.lsp.buf.type_definition, opts)
          vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
          
          -- Code actions
          vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, opts)
          vim.keymap.set({ 'n', 'v' }, '<leader>ca', vim.lsp.buf.code_action, opts)
          
          -- IntelliJ-style shortcuts
          vim.keymap.set('n', '<D-Enter>', vim.lsp.buf.code_action, opts)
          vim.keymap.set('n', '<D-S-Enter>', vim.lsp.buf.code_action, opts)
          vim.keymap.set('n', '<D-S-r>', vim.lsp.buf.rename, opts)
          vim.keymap.set('n', '<F2>', vim.lsp.buf.rename, opts)
          
          -- Formatting
          vim.keymap.set('n', '<leader>f', function()
            vim.lsp.buf.format { async = true }
          end, opts)
          vim.keymap.set('n', '<D-S-f>', function()
            vim.lsp.buf.format { async = true }
          end, opts)
        end,
      })

      -- Configure diagnostics
      vim.diagnostic.config({
        virtual_text = {
          spacing = 4,
          source = 'if_many',
          prefix = '●',
        },
        signs = true,
        underline = true,
        update_in_insert = false,
        severity_sort = true,
        float = {
          focusable = false,
          style = 'minimal',
          border = 'rounded',
          source = 'always',
          header = '',
          prefix = '',
        },
      })

      -- Set up diagnostic signs
      local signs = { Error = '󰅚 ', Warn = '󰀪 ', Hint = '󰌶 ', Info = ' ' }
      for type, icon in pairs(signs) do
        local hl = 'DiagnosticSign' .. type
        vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
      end
    end,
  },

  -- Trouble.nvim for diagnostics
  {
    'folke/trouble.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function()
      require('trouble').setup({
        position = "bottom",
        height = 10,
        width = 50,
        icons = true,
        mode = "workspace_diagnostics",
        fold_open = "",
        fold_closed = "",
        group = true,
        padding = true,
        action_keys = {
          close = "q",
          cancel = "<esc>",
          refresh = "r",
          jump = { "<cr>", "<tab>" },
          open_split = { "<c-x>" },
          open_vsplit = { "<c-v>" },
          open_tab = { "<c-t>" },
          jump_close = { "o" },
          toggle_mode = "m",
          toggle_preview = "P",
          hover = "K",
          preview = "p",
          close_folds = { "zM", "zm" },
          open_folds = { "zR", "zr" },
          toggle_fold = { "zA", "za" },
          previous = "k",
          next = "j"
        },
        indent_lines = true,
        auto_open = false,
        auto_close = false,
        auto_preview = true,
        auto_fold = false,
        auto_jump = { "lsp_definitions" },
        signs = {
          error = "",
          warning = "",
          hint = "",
          information = "",
          other = "﫠"
        },
        use_diagnostic_signs = false
      })

      -- Trouble keymaps
      vim.keymap.set('n', '<leader>xx', ':TroubleToggle<CR>', { desc = 'Toggle diagnostics' })
      vim.keymap.set('n', '<leader>xw', ':TroubleToggle workspace_diagnostics<CR>', { desc = 'Workspace diagnostics' })
      vim.keymap.set('n', '<leader>xd', ':TroubleToggle document_diagnostics<CR>', { desc = 'Document diagnostics' })
      vim.keymap.set('n', '<leader>xl', ':TroubleToggle loclist<CR>', { desc = 'Location list' })
      vim.keymap.set('n', '<leader>xq', ':TroubleToggle quickfix<CR>', { desc = 'Quickfix list' })
      vim.keymap.set('n', 'gR', ':TroubleToggle lsp_references<CR>', { desc = 'LSP references' })
    end,
  },
} 