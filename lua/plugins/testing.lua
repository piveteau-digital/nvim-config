-- ~/.config/nvim/lua/plugins/testing.lua
-- Testing and debugging configuration

return {
  -- Testing framework
  {
    'nvim-neotest/neotest',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'antoinemadec/FixCursorHold.nvim',
      'nvim-treesitter/nvim-treesitter',
      'marilari88/neotest-vitest',
      'haydenmeade/neotest-jest',
    },
    config = function()
      require('neotest').setup({
        adapters = {
          require('neotest-jest')({
            jestCommand = 'npm test --',
            jestConfigFile = function(file)
              if string.find(file, "/packages/") then
                return string.match(file, "(.-/[^/]+/)src") .. "jest.config.js"
              end
              return vim.fn.getcwd() .. "/jest.config.js"
            end,
            env = { CI = true },
            cwd = function(path)
              if string.find(path, "/packages/") then
                return string.match(path, "(.-/[^/]+/)src")
              end
              return vim.fn.getcwd()
            end,
          }),
          require('neotest-vitest')({
            filter_dir = function(name, rel_path, root)
              return name ~= 'node_modules'
            end,
          }),
        },
        discovery = {
          enabled = false,
        },
        running = {
          concurrent = true,
        },
        summary = {
          animated = true,
        },
        output = {
          open_on_run = true,
        },
        quickfix = {
          open = function()
            vim.cmd('Trouble quickfix')
          end,
        },
      })

      -- Testing keymaps
      vim.keymap.set('n', '<leader>tt', require('neotest').run.run, { desc = 'Run nearest test' })
      vim.keymap.set('n', '<leader>tf', function()
        require('neotest').run.run(vim.fn.expand('%'))
      end, { desc = 'Run current file tests' })
      vim.keymap.set('n', '<leader>ts', require('neotest').summary.toggle, { desc = 'Toggle test summary' })
      vim.keymap.set('n', '<leader>to', require('neotest').output.open, { desc = 'Show test output' })
      vim.keymap.set('n', '<leader>tO', function()
        require('neotest').output.open({ enter = true })
      end, { desc = 'Show test output and enter' })
      vim.keymap.set('n', '<leader>tw', require('neotest').watch.toggle, { desc = 'Toggle test watch' })
      vim.keymap.set('n', '<leader>td', function()
        require('neotest').run.run({ strategy = 'dap' })
      end, { desc = 'Debug nearest test' })
    end,
  },

  -- Debug Adapter Protocol
  {
    'mfussenegger/nvim-dap',
    dependencies = {
      'rcarriga/nvim-dap-ui',
      'theHamsta/nvim-dap-virtual-text',
      'nvim-telescope/telescope-dap.nvim',
      'mxsdev/nvim-dap-vscode-js',
    },
    config = function()
      local dap = require('dap')
      local dapui = require('dapui')

      -- DAP UI setup
      dapui.setup({
        icons = { expanded = "", collapsed = "", current_frame = "" },
        mappings = {
          expand = { "<CR>", "<2-LeftMouse>" },
          open = "o",
          remove = "d",
          edit = "e",
          repl = "r",
          toggle = "t",
        },
        layouts = {
          {
            elements = {
              { id = "scopes", size = 0.25 },
              "breakpoints",
              "stacks",
              "watches",
            },
            size = 40,
            position = "left",
          },
          {
            elements = {
              "repl",
              "console",
            },
            size = 0.25,
            position = "bottom",
          },
        },
        controls = {
          enabled = true,
          element = "repl",
          icons = {
            pause = "",
            play = "",
            step_into = "",
            step_over = "",
            step_out = "",
            step_back = "",
            run_last = "",
            terminate = "",
          },
        },
        floating = {
          max_height = nil,
          max_width = nil,
          border = "single",
          mappings = {
            close = { "q", "<Esc>" },
          },
        },
      })

      -- Virtual text
      require('nvim-dap-virtual-text').setup({
        enabled = true,
        enabled_commands = true,
        highlight_changed_variables = true,
        highlight_new_as_changed = false,
        show_stop_reason = true,
        commented = false,
        only_first_definition = true,
        all_references = false,
        filter_references_pattern = '<module',
        virt_text_pos = 'eol',
        all_frames = false,
        virt_lines = false,
        virt_text_win_col = nil
      })

      -- JavaScript/TypeScript debugging
      require('dap-vscode-js').setup({
        debugger_path = vim.fn.stdpath('data') .. '/mason/packages/js-debug-adapter',
        debugger_cmd = { 'js-debug-adapter' },
        adapters = { 'pwa-node', 'pwa-chrome', 'pwa-msedge', 'node-terminal', 'pwa-extensionHost' },
      })

      -- DAP configurations for TypeScript/JavaScript
      for _, language in ipairs({ 'typescript', 'javascript', 'typescriptreact', 'javascriptreact' }) do
        dap.configurations[language] = {
          -- Node.js debugging
          {
            type = 'pwa-node',
            request = 'launch',
            name = 'Launch file',
            program = '${file}',
            cwd = '${workspaceFolder}',
          },
          {
            type = 'pwa-node',
            request = 'attach',
            name = 'Attach',
            processId = require('dap.utils').pick_process,
            cwd = '${workspaceFolder}',
          },
          -- Browser debugging
          {
            type = 'pwa-chrome',
            request = 'launch',
            name = 'Start Chrome with "localhost"',
            url = 'http://localhost:3000',
            webRoot = '${workspaceFolder}',
            userDataDir = '${workspaceFolder}/.vscode/vscode-chrome-debug-userdatadir'
          },
          -- Jest debugging
          {
            type = 'pwa-node',
            request = 'launch',
            name = 'Debug Jest Tests',
            runtimeExecutable = 'node',
            runtimeArgs = {
              './node_modules/jest/bin/jest.js',
              '--runInBand',
            },
            rootPath = '${workspaceFolder}',
            cwd = '${workspaceFolder}',
            console = 'integratedTerminal',
            internalConsoleOptions = 'neverOpen',
          },
          -- Vitest debugging
          {
            type = 'pwa-node',
            request = 'launch',
            name = 'Debug Vitest Tests',
            runtimeExecutable = 'node',
            runtimeArgs = {
              './node_modules/vitest/vitest.mjs',
              '--run',
            },
            rootPath = '${workspaceFolder}',
            cwd = '${workspaceFolder}',
            console = 'integratedTerminal',
            internalConsoleOptions = 'neverOpen',
          },
          -- Next.js debugging
          {
            type = 'pwa-node',
            request = 'launch',
            name = 'Next.js: debug server-side',
            program = '${workspaceFolder}/node_modules/next/dist/bin/next-dev',
            cwd = '${workspaceFolder}',
          },
          -- React Native debugging
          {
            type = 'pwa-node',
            request = 'launch',
            name = 'React Native: debug iOS',
            cwd = '${workspaceFolder}',
            runtimeExecutable = 'node',
            runtimeArgs = {
              './node_modules/react-native/local-cli/cli.js',
              'start',
            },
          },
        }
      end

      -- Auto-open UI when debugging starts
      dap.listeners.after.event_initialized['dapui_config'] = function()
        dapui.open()
      end
      dap.listeners.before.event_terminated['dapui_config'] = function()
        dapui.close()
      end
      dap.listeners.before.event_exited['dapui_config'] = function()
        dapui.close()
      end

      -- Telescope DAP integration
      require('telescope').load_extension('dap')

      -- Debugging keymaps
      vim.keymap.set('n', '<F5>', dap.continue, { desc = 'Debug: Start/Continue' })
      vim.keymap.set('n', '<F1>', dap.step_into, { desc = 'Debug: Step Into' })
      vim.keymap.set('n', '<F2>', dap.step_over, { desc = 'Debug: Step Over' })
      vim.keymap.set('n', '<F3>', dap.step_out, { desc = 'Debug: Step Out' })
      vim.keymap.set('n', '<leader>b', dap.toggle_breakpoint, { desc = 'Debug: Toggle Breakpoint' })
      vim.keymap.set('n', '<leader>B', function()
        dap.set_breakpoint(vim.fn.input('Breakpoint condition: '))
      end, { desc = 'Debug: Set Breakpoint' })

      -- DAP UI keymaps
      vim.keymap.set('n', '<F7>', dapui.toggle, { desc = 'Debug: See last session result.' })
      vim.keymap.set('n', '<leader>du', dapui.toggle, { desc = 'Debug: Toggle UI' })
      vim.keymap.set('n', '<leader>dr', dap.repl.open, { desc = 'Debug: Open REPL' })
      vim.keymap.set('n', '<leader>dl', dap.run_last, { desc = 'Debug: Run Last' })
      vim.keymap.set({ 'n', 'v' }, '<leader>dh', require('dap.ui.widgets').hover, { desc = 'Debug: Hover' })
      vim.keymap.set({ 'n', 'v' }, '<leader>dp', require('dap.ui.widgets').preview, { desc = 'Debug: Preview' })
      vim.keymap.set('n', '<leader>df', function()
        local widgets = require('dap.ui.widgets')
        widgets.centered_float(widgets.frames)
      end, { desc = 'Debug: Frames' })
      vim.keymap.set('n', '<leader>ds', function()
        local widgets = require('dap.ui.widgets')
        widgets.centered_float(widgets.scopes)
      end, { desc = 'Debug: Scopes' })
    end,
  },
} 