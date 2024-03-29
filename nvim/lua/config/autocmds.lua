-- Highlight on yank
local yankGroup = vim.api.nvim_create_augroup("HighlightOnYank", { clear = true })
vim.api.nvim_create_autocmd("TextYankPost", {
  pattern = "*",
  group = yankGroup,
  callback = function()
    vim.highlight.on_yank()
  end,
})

-- Check if we need to reload a file when it changed
vim.api.nvim_create_autocmd("FocusGained", { command = "checktime" })

-- Go to last loc when opening a buffer
vim.api.nvim_create_autocmd("BufReadPost", {
  callback = function()
    local mark = vim.api.nvim_buf_get_mark(0, '"')
    local lcount = vim.api.nvim_buf_line_count(0)
    if mark[1] > 0 and mark[1] <= lcount then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
})

-- Show cursor line only in active window
--vim.api.nvim_create_autocmd({ 'InsertLeave', 'WinEnter' }, {
--  callback = function()
--    local ok, cl = pcall(vim.api.nvim_win_get_var, 0, 'auto-cursorline')
--    if ok and cl then
--      vim.wo.cursorline = true
--      vim.api.nvim_win_del_var(0, 'auto-cursorline')
--    end
--  end,
--})
--vim.api.nvim_create_autocmd({ 'InsertEnter', 'WinLeave' }, {
--  callback = function()
--    local cl = vim.wo.cursorline
--    if cl then
--      vim.api.nvim_win_set_var(0, 'auto-cursorline', cl)
--      vim.wo.cursorline = false
--    end
--  end,
--})
