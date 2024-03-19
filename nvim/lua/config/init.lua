require "config.options"
require "config.lazy"
require("util").setup()

vim.api.nvim_create_autocmd("User", {
  pattern = "VeryLazy",
  callback = function()
    require "config.cmds"
    require "config.autocmds"
    require "config.keymaps"
  end,
})
