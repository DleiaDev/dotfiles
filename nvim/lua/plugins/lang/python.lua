local nls = require("null-ls")

return {
  "nvimtools/none-ls.nvim",
  opts = {
    sources = {
      nls.builtins.diagnostics.mypy,
    },
  },
}
