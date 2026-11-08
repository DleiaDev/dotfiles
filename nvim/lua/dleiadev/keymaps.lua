vim.keymap.set("n", "]]", function()
	Snacks.words.jump(vim.v.count1)
end, { desc = "Next reference" })
vim.keymap.set("n", "[[", function()
	Snacks.words.jump(-vim.v.count1)
end, { desc = "Previous reference" })

vim.keymap.set("n", ";f", function()
	Snacks.picker.files()
end, { desc = "Find files" })
vim.keymap.set("n", ";r", function()
	Snacks.picker.grep()
end, { desc = "Live grep" })
vim.keymap.set("n", ";;", function()
	Snacks.picker.resume()
end, { desc = "Resume last picker" })
vim.keymap.set("n", "\\\\", function()
	Snacks.picker.buffers()
end, { desc = "Buffers" })
vim.keymap.set("n", ";e", function()
	Snacks.picker.diagnostics()
end, { desc = "Diagnostics" })
vim.keymap.set("n", ";n", function()
	Snacks.picker.notifications()
end, { desc = "Notification history" })
vim.keymap.set("n", ";h", function()
	Snacks.picker.git_diff()
end, { desc = "Git hunks" })

vim.keymap.set("n", "sf", function()
	require("oil").open_float(nil, { preview = {} })
end, { desc = "File explorer" })

vim.api.nvim_create_autocmd("FileType", {
	group = vim.api.nvim_create_augroup("dleiadev.oil_keymaps", { clear = true }),
	pattern = "oil",
	callback = function(args)
		local actions = require("oil.actions")
		vim.keymap.set("n", "h", actions.parent.callback, { buffer = args.buf, desc = "Parent directory" })
		vim.keymap.set("n", "q", actions.close.callback, { buffer = args.buf, desc = "Close oil" })
	end,
})

-- TypeScript: jump past `.d.ts` files to the real code. Other languages: the implementation.
local function source_definition()
	local client = vim.lsp.get_clients({ bufnr = 0, name = "vtsls" })[1]
	if not client then
		Snacks.picker.lsp_implementations()
		return
	end
	local params = vim.lsp.util.make_position_params(0, client.offset_encoding)
	client:exec_cmd({
		title = "Go to source definition",
		command = "typescript.goToSourceDefinition",
		arguments = { params.textDocument.uri, params.position },
	}, { bufnr = 0 }, function(err, result)
		if err then
			vim.notify(err.message, vim.log.levels.ERROR)
		elseif not result or vim.tbl_isempty(result) then
			vim.notify("No source definition found", vim.log.levels.WARN)
		else
			vim.lsp.util.show_document(result[1], client.offset_encoding, { focus = true })
		end
	end)
end

vim.api.nvim_create_autocmd("LspAttach", {
	group = vim.api.nvim_create_augroup("dleiadev.lsp_keymaps", { clear = true }),
	callback = function(args)
		local function map(mode, lhs, rhs, desc)
			vim.keymap.set(mode, lhs, rhs, { buffer = args.buf, desc = desc })
		end

		map("n", "gd", function()
			Snacks.picker.lsp_definitions()
		end, "Go to definition")
		map("n", "gD", function()
			Snacks.picker.lsp_declarations()
		end, "Go to declaration")
		map("n", "gY", function()
			Snacks.picker.lsp_type_definitions()
		end, "Go to type definition")
		map("n", "gr", function()
			Snacks.picker.lsp_references()
		end, "References")
		map("n", "gI", source_definition, "Go to source definition / implementation")
		map("n", ";c", function()
			Snacks.picker.lsp_incoming_calls()
		end, "Incoming calls")
		map("n", "K", vim.lsp.buf.hover, "Hover")
		map("n", "gK", vim.lsp.buf.signature_help, "Signature help")
		map("i", "<C-k>", vim.lsp.buf.signature_help, "Signature help")
		map("n", "<C-j>", function()
			vim.diagnostic.jump({ count = 1, float = true })
		end, "Next diagnostic")
		map({ "n", "x" }, "<leader>ca", vim.lsp.buf.code_action, "Code action")
		map("n", "<leader>cr", vim.lsp.buf.rename, "Rename symbol")
		map("n", "<leader>cR", function()
			Snacks.rename.rename_file()
		end, "Rename file")
		map("n", "<leader>cl", "<cmd>checkhealth vim.lsp<cr>", "LSP info")
	end,
})

vim.keymap.set({ "n", "x" }, "<leader>f", function()
	require("conform").format({ async = true, lsp_format = "fallback" })
end, { desc = "Format" })

-- Opens the file as of the commit that last touched the line, at that line, in a new tab
local function open_line_commit()
	local file = vim.api.nvim_buf_get_name(0)
	local lnum = vim.api.nvim_win_get_cursor(0)[1]
	local root = vim.fs.root(file, ".git")
	if not root then
		vim.notify("Not in a git repository", vim.log.levels.WARN)
		return
	end
	local out = vim.system(
		{ "git", "blame", "--porcelain", "-L", lnum .. "," .. lnum, "--", file },
		{ cwd = root, text = true }
	)
		:wait()
	if out.code ~= 0 then
		vim.notify(vim.trim(out.stderr), vim.log.levels.ERROR)
		return
	end
	local sha, orig_lnum = out.stdout:match("^(%x+) (%d+)")
	if not sha or sha:match("^0+$") then
		vim.notify("Line is not committed yet", vim.log.levels.WARN)
		return
	end
	-- The file may have had another name in that commit
	local path = out.stdout:match("\nfilename ([^\n]+)")
	require("gitsigns").show(sha .. ":" .. path, { open = "tabnew" }, function(err)
		if err then
			vim.notify(err, vim.log.levels.ERROR)
			return
		end
		vim.schedule(function()
			pcall(vim.api.nvim_win_set_cursor, 0, { tonumber(orig_lnum), 0 })
		end)
	end)
end

-- Stages the whole buffer, or unstages it when nothing is left to stage
local function toggle_stage_buffer()
	local gitsigns = require("gitsigns")
	if vim.tbl_isempty(gitsigns.get_hunks() or {}) then
		gitsigns.reset_buffer_index()
	else
		gitsigns.stage_buffer()
	end
end

vim.keymap.set("n", "<leader>gb", function()
	require("gitsigns").blame_line({ full = true })
end, { desc = "Blame line" })
vim.keymap.set("n", "<leader>gB", function()
	require("gitsigns").blame()
end, { desc = "Blame buffer" })
vim.keymap.set("n", "<leader>go", open_line_commit, { desc = "Open file at line's commit" })
vim.keymap.set("n", "<leader>gs", toggle_stage_buffer, { desc = "Stage / unstage buffer" })
vim.keymap.set("n", "<leader>gh", function()
	require("gitsigns").stage_hunk()
end, { desc = "Stage / unstage hunk" })

vim.keymap.set("n", "<leader>gd", function()
	MiniDiff.toggle_overlay(0)
end, { desc = "Toggle diff overlay" })
-- In diff mode, keep the built-in change jumps
vim.keymap.set("n", "]c", function()
	if vim.wo.diff then
		vim.cmd.normal({ "]c", bang = true })
	else
		MiniDiff.goto_hunk("next")
	end
end, { desc = "Next hunk" })
vim.keymap.set("n", "[c", function()
	if vim.wo.diff then
		vim.cmd.normal({ "[c", bang = true })
	else
		MiniDiff.goto_hunk("prev")
	end
end, { desc = "Previous hunk" })
