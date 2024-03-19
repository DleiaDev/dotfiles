local keymap = vim.keymap.set

-- Remap for dealing with word wrap
keymap("n", "k", "v:count == 0 ? 'gk' : 'k'", { expr = true })
keymap("n", "j", "v:count == 0 ? 'gj' : 'j'", { expr = true })

-- Better viewing
keymap("n", "n", "nzzzv")
keymap("n", "N", "Nzzzv")
keymap("n", "g,", "g,zvzz")
keymap("n", "g;", "g;zvzz")

-- Better escape using jk in insert and terminal mode
--keymap("i", "jk", "<ESC>")
keymap("t", "<C-j><C-k>", "<C-\\><C-n>")
keymap("t", "<C-h>", "<C-\\><C-n><C-w>h")
keymap("t", "<C-j>", "<C-\\><C-n><C-w>j")
keymap("t", "<C-k>", "<C-\\><C-n><C-w>k")
keymap("t", "<C-l>", "<C-\\><C-n><C-w>l")

-- Add undo break-points
keymap("i", ",", ",<c-g>u")
keymap("i", ".", ".<c-g>u")
keymap("i", ";", ";<c-g>u")

-- Better indent
keymap("v", "<", "<gv")
keymap("v", ">", ">gv")

-- Paste over currently selected text without yanking it
keymap("v", "p", '"_dP')

-- Move Lines
keymap("n", "<A-j>", "<cmd>m .+1<CR>==")
keymap("v", "<A-j>", "<cmd>m '>+1<CR>gv=gv")
keymap("i", "<A-j>", "<Esc>:m .+1<CR>==gi")
keymap("n", "<A-k>", "<cmd>m .-2<CR>==")
keymap("v", "<A-k>", "<cmd>m '<-2<CR>gv=gv")
keymap("i", "<A-k>", "<Esc>:m .-2<CR>==gi")

-- Resize window using <shift> arrow keys
keymap("n", "<S-Up>", "<cmd>resize +2<CR>")
keymap("n", "<S-Down>", "<cmd>resize -2<CR>")
keymap("n", "<S-Left>", "<cmd>vertical resize -2<CR>")
keymap("n", "<S-Right>", "<cmd>vertical resize +2<CR>")

-- Clear search highlighting with escape
keymap("n", "<Esc>", "<cmd>noh<cr>")

-- Save current buffer
keymap("n", "<leader>w", "<cmd>w<cr>")

-- Quit current buffer
keymap("n", "<leader>q", "<cmd>q<cr>")

keymap("n", "<leader>sc", require("util.tools").cht, { desc = "cht.sh" })
keymap("n", "<leader>st", require("util.tools").tokei, { desc = "Tokei" })
keymap("n", "<leader>sb", require("util.tools").bottom, { desc = "Bottom" })
keymap("n", "<leader>sd", require("util.tools").lazydocker, { desc = "Lazydocker" })
keymap("n", "<leader>ss", require("util.tools").stack_overflow, { desc = "Stack Overflow" })
