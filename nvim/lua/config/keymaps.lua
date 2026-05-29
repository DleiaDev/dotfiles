-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

vim.keymap.del("n", "<leader>l")
vim.keymap.set("n", "<leader>lz", "<cmd>Lazy<cr>", { desc = "Lazy" })

-- Lazydocker
if vim.fn.executable("lazydocker") == 1 then
  vim.keymap.set("n", "<leader>ld", function()
    Snacks.terminal.toggle("lazydocker")
  end, { desc = "Lazydocker" })
end

-- Lazysql
if vim.fn.executable("lazysql") == 1 then
  vim.keymap.set("n", "<leader>ls", function()
    Snacks.terminal.toggle("lazysql")
  end, { desc = "Lazysql" })
end

-- Posting
if vim.fn.executable("posting") == 1 then
  vim.keymap.set("n", "<leader>lp", function()
    Snacks.terminal.toggle("posting")
  end, { desc = "Posting" })
end
