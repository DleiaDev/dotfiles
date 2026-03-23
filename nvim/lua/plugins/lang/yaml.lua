local nls = require("null-ls")

return {
  "nvimtools/none-ls.nvim",
  opts = {
    sources = {
      nls.builtins.diagnostics.cfn_lint,
    },
  },
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = {
        "yaml",
      },
    },
  },
}
