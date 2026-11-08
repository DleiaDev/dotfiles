local map = vim.keymap.set

map("n", "x", '"_x', { desc = "Delete char without copying" })
map({ "n", "x" }, "<leader>d", '"_d', { desc = "Delete without copying" })
map({ "n", "x" }, "<leader>c", '"_c', { desc = "Change without copying" })
map("n", "<leader>p", '"0p', { desc = "Paste last yank" })
map("x", "<leader>p", '"_dP', { desc = "Paste over selection without copying" })
map("n", "dw", 'vb"_d', { desc = "Delete word backwards without copying" })

map("n", "+", "<C-a>", { desc = "Increment number" })
map("n", "-", "<C-x>", { desc = "Decrement number" })
map("n", "<C-a>", "gg<S-v>G", { desc = "Select all" })

map("n", "te", "<Cmd>tabedit<CR>", { desc = "New tab" })
map("n", "<Tab>", "<Cmd>tabnext<CR>", { desc = "Next tab" })
map("n", "<S-Tab>", "<Cmd>tabprevious<CR>", { desc = "Previous tab" })

map("n", "ss", "<Cmd>split<CR>", { desc = "Split below" })
map("n", "sv", "<Cmd>vsplit<CR>", { desc = "Split right" })
map("n", "sh", "<C-w>h", { desc = "Window left" })
map("n", "sj", "<C-w>j", { desc = "Window down" })
map("n", "sk", "<C-w>k", { desc = "Window up" })
map("n", "sl", "<C-w>l", { desc = "Window right" })

map("n", "<C-m>", "<C-i>", { desc = "Jump forward" })

map("n", "<leader>o", "o<Esc>^Da", { desc = "Open line below without comment" })
map("n", "<leader>O", "O<Esc>^Da", { desc = "Open line above without comment" })

map("n", "<leader>bd", DleiaDev.editor.close_hidden_buffers, { desc = "Close hidden buffers" })

-- Copies `<path>#L<line>` to the clipboard, for pointing an agent at the exact line
local function copy_path(modifier)
	local path = vim.fn.expand("%" .. modifier)
	if path == "" then
		vim.notify("Buffer has no file", vim.log.levels.WARN)
		return
	end
	local text = ("%s#L%d"):format(path, vim.fn.line("."))
	vim.fn.setreg("+", text)
	vim.notify("Copied " .. text)
end

map("n", "<leader>yf", function()
	copy_path(":.")
end, { desc = "Copy relative path with line" })
map("n", "<leader>yp", function()
	copy_path(":p")
end, { desc = "Copy absolute path with line" })
