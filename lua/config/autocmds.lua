-- ~/.config/nvim/lua/config/autocmds.lua
-- Autocommands configuration

local autocmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup

-- Highlight on yank
autocmd('TextYankPost', {
  group = augroup('highlight_yank', { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

-- Remove trailing whitespace on save
autocmd('BufWritePre', {
  group = augroup('trim_whitespace', { clear = true }),
  pattern = '*',
  callback = function()
    local save_cursor = vim.fn.getpos('.')
    vim.cmd([[%s/\s\+$//e]])
    vim.fn.setpos('.', save_cursor)
  end,
})

-- Auto-close NvimTree if it's the last window
autocmd('QuitPre', {
  group = augroup('auto_close_nvimtree', { clear = true }),
  callback = function()
    local invalid_win = {}
    local wins = vim.api.nvim_list_wins()
    for _, w in ipairs(wins) do
      local bufname = vim.api.nvim_buf_get_name(vim.api.nvim_win_get_buf(w))
      if bufname:match('NvimTree_') ~= nil then
        table.insert(invalid_win, w)
      end
    end
    if #invalid_win == #wins - 1 then
      for _, w in ipairs(invalid_win) do
        vim.api.nvim_win_close(w, true)
      end
    end
  end,
})

-- Auto-detect project type and apply settings
autocmd('VimEnter', {
  group = augroup('project_detection', { clear = true }),
  callback = function()
    -- Check for package.json (Node.js project)
    if vim.fn.filereadable('package.json') == 1 then
      vim.opt.tabstop = 2
      vim.opt.shiftwidth = 2
      print('📦 Detected Node.js project - using 2-space indentation')
    end
    
    -- Check for Cargo.toml (Rust project)
    if vim.fn.filereadable('Cargo.toml') == 1 then
      vim.opt.tabstop = 4
      vim.opt.shiftwidth = 4
      print('🦀 Detected Rust project - using 4-space indentation')
    end
    
    -- Check for pyproject.toml or setup.py (Python project)
    if vim.fn.filereadable('pyproject.toml') == 1 or vim.fn.filereadable('setup.py') == 1 then
      vim.opt.tabstop = 4
      vim.opt.shiftwidth = 4
      print('🐍 Detected Python project - using 4-space indentation')
    end

    -- Check for turbo.json (Turbo monorepo)
    if vim.fn.filereadable('turbo.json') == 1 then
      print('🚀 Detected Turbo monorepo')
    end

    -- Check for nx.json (Nx monorepo)
    if vim.fn.filereadable('nx.json') == 1 then
      print('🔥 Detected Nx monorepo')
    end
  end,
})

-- Set filetype for specific files
autocmd({ 'BufRead', 'BufNewFile' }, {
  group = augroup('custom_filetypes', { clear = true }),
  pattern = {
    '*.tsx',
    '*.jsx',
  },
  callback = function()
    vim.bo.filetype = 'typescriptreact'
  end,
})

-- Auto-format on save for specific filetypes
autocmd('BufWritePre', {
  group = augroup('auto_format', { clear = true }),
  pattern = {
    '*.tsx',
    '*.ts',
    '*.jsx',
    '*.js',
    '*.json',
    '*.css',
    '*.scss',
    '*.html',
    '*.yaml',
    '*.yml',
    '*.md',
    '*.lua',
  },
  callback = function()
    local conform = package.loaded['conform']
    if conform then
      conform.format({ timeout_ms = 500, lsp_fallback = true })
    end
  end,
})

-- Close certain filetypes with q
autocmd('FileType', {
  group = augroup('close_with_q', { clear = true }),
  pattern = {
    'qf',
    'help',
    'man',
    'notify',
    'lspinfo',
    'spectre_panel',
    'startuptime',
    'tsplayground',
    'PlenaryTestPopup',
  },
  callback = function(event)
    vim.bo[event.buf].buflisted = false
    vim.keymap.set('n', 'q', '<cmd>close<cr>', { buffer = event.buf, silent = true })
  end,
})

-- Check if we need to reload the file when it changed
autocmd({ 'FocusGained', 'TermClose', 'TermLeave' }, {
  group = augroup('checktime', { clear = true }),
  command = 'checktime',
})

-- Resize splits if window got resized
autocmd('VimResized', {
  group = augroup('resize_splits', { clear = true }),
  callback = function()
    local current_tab = vim.fn.tabpagenr()
    vim.cmd('tabdo wincmd =')
    vim.cmd('tabnext ' .. current_tab)
  end,
})

-- Go to last loc when opening a buffer
autocmd('BufReadPost', {
  group = augroup('last_loc', { clear = true }),
  callback = function(event)
    local exclude = { 'gitcommit' }
    local buf = event.buf
    if vim.tbl_contains(exclude, vim.bo[buf].filetype) or vim.b[buf].lazyvim_last_loc then
      return
    end
    vim.b[buf].lazyvim_last_loc = true
    local mark = vim.api.nvim_buf_get_mark(buf, '"')
    local lcount = vim.api.nvim_buf_line_count(buf)
    if mark[1] > 0 and mark[1] <= lcount then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
})

-- Auto create dir when saving a file, in case some intermediate directory does not exist
autocmd('BufWritePre', {
  group = augroup('auto_create_dir', { clear = true }),
  callback = function(event)
    if event.match:match('^%w%w+://') then
      return
    end
    local file = vim.loop.fs_realpath(event.match) or event.match
    vim.fn.mkdir(vim.fn.fnamemodify(file, ':p:h'), 'p')
  end,
}) 