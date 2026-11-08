require("mini.icons").setup({})
MiniIcons.mock_nvim_web_devicons()

require("tiny-cmdline").setup({
	position = { x = "50%", y = "20%" },
})

local root_markers = { ".git", "lua", "package.json", "Makefile", "Cargo.toml", "go.mod", "pyproject.toml" }

local function root_name()
	local root = vim.fs.root(0, root_markers)
	if not root or root == vim.fn.getcwd() then
		return ""
	end
	return vim.fs.basename(root)
end

local function pretty_path()
	if vim.bo.buftype ~= "" then
		return ""
	end
	return vim.fn.expand("%:~:.")
end

local function recording()
	local reg = vim.fn.reg_recording()
	return reg == "" and "" or "recording @" .. reg
end

require("lualine").setup({
	options = {
		theme = "auto",
		globalstatus = true,
	},
	sections = {
		lualine_a = { "mode" },
		lualine_b = { "branch" },
		lualine_c = {
			root_name,
			{ "filetype", icon_only = true, separator = "", padding = { left = 1, right = 0 } },
			pretty_path,
		},
		lualine_x = {
			recording,
			{
				"diagnostics",
				symbols = {
					error = DleiaDev.icons.diagnostics.Error,
					warn = DleiaDev.icons.diagnostics.Warn,
					info = DleiaDev.icons.diagnostics.Info,
					hint = DleiaDev.icons.diagnostics.Hint,
				},
			},
			{
				"diff",
				symbols = {
					added = DleiaDev.icons.git.added,
					modified = DleiaDev.icons.git.modified,
					removed = DleiaDev.icons.git.removed,
				},
			},
		},
		lualine_y = { "progress" },
		lualine_z = { "location" },
	},
})

vim.api.nvim_create_autocmd({ "CursorMoved", "RecordingEnter", "RecordingLeave" }, {
	group = vim.api.nvim_create_augroup("dleiadev_lualine", { clear = true }),
	callback = function()
		-- reg_recording() still returns the register during RecordingLeave
		vim.schedule(function()
			require("lualine").refresh()
		end)
	end,
})

require("incline").setup({
	window = {
		placement = { vertical = "top", horizontal = "right" },
		-- Same colors as the tabline: the focused window's tag stands out
		winhighlight = {
			active = { Normal = "DleiaDevTabActive" },
			inactive = { Normal = "DleiaDevTabInactive" },
		},
	},
	hide = {
		cursorline = "focused_win",
	},
	render = function(props)
		local name = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(props.buf), ":t")
		if name == "" then
			name = "[No Name]"
		end
		local icon = MiniIcons.get("file", name)
		return {
			icon,
			" ",
			name,
			vim.bo[props.buf].modified and " [+]" or "",
		}
	end,
})

require("snacks").setup({
	notifier = { enabled = true },
	indent = { enabled = true },
	statuscolumn = { enabled = true },
	words = { enabled = true },
	scroll = { enabled = false },
	picker = {
		enabled = true,
		sources = {
			files = { hidden = true },
			grep = { hidden = true },
			buffers = { jump = { reuse_win = true } },
		},
	},
})
