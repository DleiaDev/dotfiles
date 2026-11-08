require("blink.cmp").setup({
	keymap = { preset = "enter" },
	appearance = {
		-- blink adds its own gap after the icon
		kind_icons = vim.tbl_map(vim.trim, DleiaDev.icons.kinds),
	},
	completion = {
		accept = { auto_brackets = { enabled = true } },
		documentation = { auto_show = true, auto_show_delay_ms = 200 },
		-- Copilot already shows inline suggestions
		ghost_text = { enabled = false },
		menu = {
			draw = { treesitter = { "lsp" } },
		},
	},
	cmdline = {
		completion = {
			menu = {
				auto_show = function()
					return vim.fn.getcmdtype() == ":"
				end,
			},
			list = { selection = { preselect = false } },
		},
	},
})
