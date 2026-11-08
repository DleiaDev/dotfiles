require("mason").setup({})

require("mason-tool-installer").setup({
	ensure_installed = {
		-- Servers
		"lua-language-server",
		"vtsls",
		"eslint-lsp",
		"oxlint",
		"tailwindcss-language-server",
		"css-lsp",
		"rust-analyzer",
		"copilot-language-server",
		-- Formatters
		"prettier",
		"prettierd",
		"oxfmt",
		"stylua",
		"shfmt",
	},
	run_on_start = true,
	auto_update = false,
})

vim.lsp.config("*", {
	capabilities = require("blink.cmp").get_lsp_capabilities({
		workspace = {
			fileOperations = {
				didRename = true,
				willRename = true,
			},
		},
	}),
})

vim.lsp.enable({ "eslint", "oxlint", "lua_ls", "cssls", "vtsls", "tailwindcss", "rust_analyzer" })

local icons = DleiaDev.icons.diagnostics
local severity = vim.diagnostic.severity
local severity_icons = {
	[severity.ERROR] = icons.Error,
	[severity.WARN] = icons.Warn,
	[severity.INFO] = icons.Info,
	[severity.HINT] = icons.Hint,
}
local severity_hls = {
	[severity.ERROR] = "DiagnosticError",
	[severity.WARN] = "DiagnosticWarn",
	[severity.INFO] = "DiagnosticInfo",
	[severity.HINT] = "DiagnosticHint",
}

vim.diagnostic.config({
	underline = true,
	update_in_insert = false,
	severity_sort = true,
	virtual_text = {
		prefix = function(diagnostic)
			return vim.trim(severity_icons[diagnostic.severity])
		end,
		source = "if_many",
	},
	float = {
		prefix = function(diagnostic)
			return severity_icons[diagnostic.severity], severity_hls[diagnostic.severity]
		end,
	},
	signs = {
		text = severity_icons,
	},
})
