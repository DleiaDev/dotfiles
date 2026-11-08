-- Defined before vim.pack.add so it also catches changes made during startup
vim.api.nvim_create_autocmd("PackChanged", {
	group = vim.api.nvim_create_augroup("dleiadev.pack_changed", { clear = true }),
	callback = function(ev)
		if ev.data.spec.name == "nvim-treesitter" and ev.data.kind == "update" then
			if not ev.data.active then
				vim.cmd.packadd("nvim-treesitter")
			end
			vim.cmd("TSUpdate")
		end
	end,
})

vim.pack.add({
	"https://github.com/folke/tokyonight.nvim",
	"https://github.com/nvim-mini/mini.icons",
	"https://github.com/rachartier/tiny-cmdline.nvim",
	"https://github.com/nvim-lualine/lualine.nvim",
	"https://github.com/b0o/incline.nvim",
	"https://github.com/folke/snacks.nvim",
	"https://github.com/stevearc/oil.nvim",
	{ src = "https://github.com/nvim-treesitter/nvim-treesitter", version = "main" },
	"https://github.com/folke/todo-comments.nvim",
	"https://github.com/brenoprata10/nvim-highlight-colors",
	"https://github.com/mason-org/mason.nvim",
	"https://github.com/WhoIsSethDaniel/mason-tool-installer.nvim",
	"https://github.com/neovim/nvim-lspconfig",
	{ src = "https://github.com/saghen/blink.cmp", version = vim.version.range("^1") },
	"https://github.com/nvim-mini/mini.pairs",
})

require("dleiadev.plugins.colorscheme")
require("dleiadev.plugins.ui")
require("dleiadev.plugins.navigation")
require("dleiadev.plugins.syntax")
require("dleiadev.plugins.completion")
require("dleiadev.plugins.lsp")

require("dleiadev.keymaps")
