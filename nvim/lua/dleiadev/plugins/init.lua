vim.pack.add({
	"https://github.com/folke/tokyonight.nvim",
	"https://github.com/nvim-mini/mini.icons",
	"https://github.com/rachartier/tiny-cmdline.nvim",
	"https://github.com/nvim-lualine/lualine.nvim",
	"https://github.com/b0o/incline.nvim",
})

require("dleiadev.plugins.colorscheme")
require("dleiadev.plugins.ui")

require("dleiadev.keymaps")
