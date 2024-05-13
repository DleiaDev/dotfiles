-- Install lazy.nvim
local installPath = vim.fn.stdpath "data" .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(installPath) then
  vim.fn.system {
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    installPath,
  }
end
vim.opt.rtp:prepend(installPath)

vim.cmd "colorscheme darkblue"

-- Configure lazy.nvim
require("lazy").setup {
  spec = {
    { import = "plugins" },
    { import = "plugins.extras.ui" },
    { import = "plugins.extras.lang" },
    { import = "plugins.extras.editor" },
  },
  defaults = {
    lazy = true,
  },
  install = {
    colorscheme = {
      "onedark",
    },
  },
  checker = {
    enabled = true,
  },
  performance = {
    rtp = {
      disabled_plugins = {
        "gzip",
        "matchit",
        "matchparen",
        "netrwPlugin",
        "tarPlugin",
        "tohtml",
        "tutor",
        "zipPlugin",
      },
    },
  },
}

vim.keymap.set("n", "<leader>zz", "<cmd>:Lazy<cr>", { desc = "Plugin manager" })
