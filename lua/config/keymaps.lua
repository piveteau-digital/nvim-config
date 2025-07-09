-- ~/.config/nvim/lua/config/keymaps.lua
-- Keymaps configuration (IntelliJ-style shortcuts)

local keymap = vim.keymap.set

-- Essential keymaps
keymap('n', '<leader>w', ':w<CR>', { desc = 'Save file' })
keymap('n', '<leader>q', ':q<CR>', { desc = 'Quit' })
keymap('i', 'jk', '<Esc>', { desc = 'Exit insert mode' })
keymap('n', '<Esc>', ':nohlsearch<CR>', { desc = 'Clear search highlight' })

-- macOS shortcuts
keymap('n', '<D-s>', ':w<CR>', { desc = 'Save file' })
keymap('i', '<D-s>', '<Esc>:w<CR>a', { desc = 'Save file in insert mode' })
keymap('n', '<D-a>', 'ggVG', { desc = 'Select all' })
keymap('n', '<D-c>', '"+y', { desc = 'Copy to clipboard' })
keymap('n', '<D-v>', '"+p', { desc = 'Paste from clipboard' })
keymap('v', '<D-c>', '"+y', { desc = 'Copy selection to clipboard' })
keymap('i', '<D-v>', '<C-r>+', { desc = 'Paste from clipboard in insert mode' })

-- Buffer navigation
keymap('n', '<leader>bn', ':bnext<CR>', { desc = 'Next buffer' })
keymap('n', '<leader>bp', ':bprevious<CR>', { desc = 'Previous buffer' })
keymap('n', '<leader>bd', ':bdelete<CR>', { desc = 'Delete buffer' })
keymap('n', '<D-w>', ':bdelete<CR>', { desc = 'Close buffer' })

-- Tab navigation (IntelliJ-style)
keymap('n', '<D-S-]>', ':bnext<CR>', { desc = 'Next tab' })
keymap('n', '<D-S-[>', ':bprevious<CR>', { desc = 'Previous tab' })

-- Split navigation
keymap('n', '<C-h>', '<C-w>h', { desc = 'Move to left split' })
keymap('n', '<C-j>', '<C-w>j', { desc = 'Move to bottom split' })
keymap('n', '<C-k>', '<C-w>k', { desc = 'Move to top split' })
keymap('n', '<C-l>', '<C-w>l', { desc = 'Move to right split' })

-- Resize splits
keymap('n', '<C-Up>', ':resize -2<CR>', { desc = 'Resize split up' })
keymap('n', '<C-Down>', ':resize +2<CR>', { desc = 'Resize split down' })
keymap('n', '<C-Left>', ':vertical resize -2<CR>', { desc = 'Resize split left' })
keymap('n', '<C-Right>', ':vertical resize +2<CR>', { desc = 'Resize split right' })

-- Movement (IntelliJ-style)
keymap('n', '<D-Up>', 'gg', { desc = 'Go to top' })
keymap('n', '<D-Down>', 'G', { desc = 'Go to bottom' })
keymap('n', '<D-Left>', '^', { desc = 'Go to line start' })
keymap('n', '<D-Right>', '$', { desc = 'Go to line end' })

-- Selection (IntelliJ-style)
keymap('n', '<D-S-Up>', 'vgg', { desc = 'Select to top' })
keymap('n', '<D-S-Down>', 'vG', { desc = 'Select to bottom' })
keymap('n', '<D-S-Left>', 'v^', { desc = 'Select to line start' })
keymap('n', '<D-S-Right>', 'v$', { desc = 'Select to line end' })

-- Duplicate line (IntelliJ-style)
keymap('n', '<D-d>', 'yyp', { desc = 'Duplicate line' })

-- Diagnostics navigation
keymap('n', '[d', vim.diagnostic.goto_prev, { desc = 'Previous diagnostic' })
keymap('n', ']d', vim.diagnostic.goto_next, { desc = 'Next diagnostic' })

-- Git hunks navigation
keymap('n', ']h', ':Gitsigns next_hunk<CR>', { desc = 'Next git hunk' })
keymap('n', '[h', ':Gitsigns prev_hunk<CR>', { desc = 'Previous git hunk' })

-- Terminal
keymap('n', '<C-\\>', ':ToggleTerm<CR>', { desc = 'Toggle terminal' })
keymap('t', '<C-\\>', '<C-\\><C-n>:ToggleTerm<CR>', { desc = 'Toggle terminal' })

-- Custom utility functions
local function toggle_line_numbers()
  if vim.wo.relativenumber then
    vim.wo.relativenumber = false
    vim.wo.number = true
  else
    vim.wo.relativenumber = true
    vim.wo.number = true
  end
end

local function create_new_file()
  local current_dir = vim.fn.expand('%:p:h')
  local filename = vim.fn.input('New file name: ', current_dir .. '/')
  if filename ~= '' then
    vim.cmd('edit ' .. filename)
  end
end

local function copy_file_path()
  local filepath = vim.fn.expand('%:p')
  vim.fn.setreg('+', filepath)
  print('Copied to clipboard: ' .. filepath)
end

local function toggle_wrap()
  vim.wo.wrap = not vim.wo.wrap
  print('Wrap: ' .. (vim.wo.wrap and 'ON' or 'OFF'))
end

-- Utility keymaps
keymap('n', '<leader>tn', toggle_line_numbers, { desc = 'Toggle line numbers' })
keymap('n', '<leader>nf', create_new_file, { desc = 'Create new file' })
keymap('n', '<leader>cp', copy_file_path, { desc = 'Copy file path' })
keymap('n', '<leader>tw', toggle_wrap, { desc = 'Toggle wrap' }) 