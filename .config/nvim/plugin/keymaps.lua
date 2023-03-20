
-- Leader
vim.g.mapleader = ' '

local defaultOpts = { noremap = true, silent = true }

-- Center search results
vim.keymap.set('n', 'n', 'nzz', defaultOpts)
vim.keymap.set('n', 'N', 'Nzz', defaultOpts)

-- Better indent with < and >
vim.keymap.set('v', '<', '<gv', defaultOpts)
vim.keymap.set('v', '>', '>gv', defaultOpts)

-- Paste over currenly selected text without yanking it
vim.keymap.set('v', 'p', '"_dP', defaultOpts)

-- Clear search highlighting with <esc>
vim.keymap.set('n', '<esc>', ':noh<cr>', defaultOpts)

-- Save current buffer
vim.keymap.set('n', '<leader>w', ':w<cr>', defaultOpts)

-- Quit current buffer
vim.keymap.set('n', '<leader>q', ':q<cr>', defaultOpts)

-- Print synstack
--vim.keymap.set('n', '<c-P>', function()
--  local currentPosition = vim.api.nvim_win_get_cursor(0)
--  local synstack = vim.fn.synstack(currentPosition[1], currentPosition[2])
--  local result = vim.tbl_map(function(synID)
--    return vim.fn.synIDattr(synID, 'name')
--  end, synstack)
--  print(vim.inspect(result))
--end, defaultOpts)

