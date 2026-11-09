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
	{ src = "https://github.com/nvim-neo-tree/neo-tree.nvim", version = vim.version.range("^3") },
	"https://github.com/nvim-lua/plenary.nvim",
	"https://github.com/MunifTanjim/nui.nvim",
	{ src = "https://github.com/nvim-treesitter/nvim-treesitter", version = "main" },
	"https://github.com/folke/todo-comments.nvim",
	"https://github.com/brenoprata10/nvim-highlight-colors",
	"https://github.com/mason-org/mason.nvim",
	"https://github.com/WhoIsSethDaniel/mason-tool-installer.nvim",
	"https://github.com/neovim/nvim-lspconfig",
	{ src = "https://github.com/saghen/blink.cmp", version = vim.version.range("^1") },
	"https://github.com/nvim-mini/mini.pairs",
	"https://github.com/stevearc/conform.nvim",
	"https://github.com/lewis6991/gitsigns.nvim",
	"https://github.com/craftzdog/mini.diff",
	"https://github.com/esmuellert/codediff.nvim",
})

require("dleiadev.plugins.colorscheme")
require("dleiadev.plugins.ui")
require("dleiadev.plugins.navigation")
require("dleiadev.plugins.syntax")
require("dleiadev.plugins.completion")
require("dleiadev.plugins.lsp")
require("dleiadev.plugins.formatting")
require("dleiadev.plugins.git")

require("dleiadev.keymaps")
