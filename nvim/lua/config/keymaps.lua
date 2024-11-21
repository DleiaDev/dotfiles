-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

vim.keymap.del("n", "<leader>l")
vim.keymap.set("n", "<leader>lz", "<cmd>Lazy<cr>", { desc = "Lazy" })

-- Lazydocker
if vim.fn.executable("lazydocker") == 1 then
  vim.keymap.set("n", "<leader>ld", function()
    LazyVim.terminal("lazydocker", { esc_esc = false, ctrl_hjkl = false })
  end, { desc = "Lazydocker" })
end

-- Lazysql
if vim.fn.executable("lazysql") == 1 then
  vim.keymap.set("n", "<leader>ls", function()
    LazyVim.terminal("lazysql", { esc_esc = false, ctrl_hjkl = false })
  end, { desc = "Lazysql" })
end
