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
		lualine_x = { recording, "diagnostics", "diff" },
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
