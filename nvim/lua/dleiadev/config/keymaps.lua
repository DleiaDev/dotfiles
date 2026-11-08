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

map("x", "<leader>cc", function()
	local lines = vim.fn.getregion(vim.fn.getpos("v"), vim.fn.getpos("."), { type = vim.fn.mode() })
	local text = ("```%s\n%s\n```"):format(vim.bo.filetype, table.concat(lines, "\n"))
	vim.fn.setreg("+", text)
	vim.api.nvim_feedkeys(vim.keycode("<Esc>"), "n", false)
end, { desc = "Copy selection as Markdown code block" })

-- Opens the nearest package.json above the current file (or cwd) in a centered float
map("n", "<leader>j", function()
	local start = vim.api.nvim_buf_get_name(0) ~= "" and vim.fn.expand("%:p:h") or vim.fn.getcwd()
	local file = vim.fs.find("package.json", { upward = true, path = start })[1]
	if not file then
		vim.notify("No package.json found", vim.log.levels.WARN)
		return
	end
	local width = math.floor(vim.o.columns * 0.8)
	local height = math.floor(vim.o.lines * 0.8)
	local buf = vim.fn.bufadd(file)
	local win = vim.api.nvim_open_win(buf, true, {
		relative = "editor",
		width = width,
		height = height,
		col = math.floor((vim.o.columns - width) / 2),
		row = math.floor((vim.o.lines - height) / 2),
	})
	local function close()
		if vim.api.nvim_win_is_valid(win) then
			vim.api.nvim_win_close(win, false)
		end
	end
	for _, key in ipairs({ "q", "<Esc>" }) do
		vim.keymap.set("n", key, close, { buffer = buf, desc = "Close package.json" })
	end
	-- The buffer may be opened normally later, so don't leave the close keys on it
	vim.api.nvim_create_autocmd("WinClosed", {
		pattern = tostring(win),
		once = true,
		callback = function()
			for _, key in ipairs({ "q", "<Esc>" }) do
				pcall(vim.keymap.del, "n", key, { buffer = buf })
			end
		end,
	})
end, { desc = "Open package.json" })
