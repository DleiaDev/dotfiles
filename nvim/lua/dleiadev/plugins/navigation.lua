local events = require("neo-tree.events")

-- Highlight the tree node whose buffer is focused in the tab
local focused = {} -- tabid -> name of the focused buffer

local function record_focused_buffer()
	local buf = vim.api.nvim_get_current_buf()
	if vim.bo[buf].filetype == "neo-tree" then
		return
	end
	local tabid = vim.api.nvim_get_current_tabpage()
	local name = vim.api.nvim_buf_get_name(buf)
	if focused[tabid] == name then
		return
	end
	focused[tabid] = name
	require("neo-tree.sources.manager").redraw("filesystem")
end

vim.api.nvim_create_autocmd({ "BufEnter", "WinEnter" }, {
	group = vim.api.nvim_create_augroup("dleiadev.neotree_focus", { clear = true }),
	callback = record_focused_buffer,
})

-- Wrap the name component so the focused file stands out, as LazyVim's opened-file highlight does
local components = require("neo-tree.sources.common.components")
local name_component = components.name
components.name = function(config, node, state)
	local ret = name_component(config, node, state)
	if node.type == "file" and focused[state.tabid] == node.path then
		ret.highlight = "NeoTreeFileNameOpened"
	end
	return ret
end

-- Renames go through Snacks so LSP import updates land in the right buffers
local function on_move(data)
	Snacks.rename.on_rename_file(data.source, data.destination)
end

require("neo-tree").setup({
	sources = { "filesystem", "buffers", "git_status" },
	open_files_do_not_replace_types = { "terminal", "Trouble", "trouble", "qf", "Outline" },
	filesystem = {
		bind_to_cwd = false,
		follow_current_file = { enabled = true },
		use_libuv_file_watcher = true,
		hijack_netrw_behavior = "disabled",
	},
	window = {
		mappings = {
			["l"] = "open",
			["h"] = "close_node",
			["<space>"] = "none",
			["Y"] = {
				function(state)
					local node = state.tree:get_node()
					local path = node:get_id()
					vim.fn.setreg("+", path, "c")
				end,
				desc = "Copy Path to Clipboard",
			},
			["O"] = {
				function(state)
					vim.ui.open(state.tree:get_node().path)
				end,
				desc = "Open with System Application",
			},
			["P"] = { "toggle_preview", config = { use_float = false } },
		},
	},
	default_component_configs = {
		indent = {
			with_expanders = true,
			expander_collapsed = "",
			expander_expanded = "",
			expander_highlight = "NeoTreeExpander",
		},
		git_status = {
			symbols = {
				unstaged = "󰄱",
				staged = "󰱒",
			},
		},
	},
	event_handlers = {
		{ event = events.FILE_MOVED, handler = on_move },
		{ event = events.FILE_RENAMED, handler = on_move },
	},
})

vim.api.nvim_create_autocmd("TermClose", {
	group = vim.api.nvim_create_augroup("dleiadev.neotree", { clear = true }),
	pattern = "*lazygit",
	callback = function()
		if package.loaded["neo-tree.sources.git_status"] then
			require("neo-tree.sources.git_status").refresh()
		end
	end,
})

require("oil").setup({
	default_file_explorer = true,
	columns = { "icon", "permissions", "size", "mtime" },
	view_options = {
		show_hidden = true,
	},
	lsp_file_methods = {
		enabled = true,
		autosave_changes = true,
	},
	float = {
		max_width = 200,
		border = "rounded",
	},
})
