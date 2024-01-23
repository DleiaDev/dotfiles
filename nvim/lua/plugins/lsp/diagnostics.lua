local M = {}

function M.setup()
  local icons = require "config.icons"

  local signs = {
    { name = "DiagnosticSignError", text = icons.diagnostics.BoldError },
    { name = "DiagnosticSignWarn", text = icons.diagnostics.BoldWarning },
    { name = "DiagnosticSignHint", text = icons.diagnostics.BoldHint },
    { name = "DiagnosticSignInfo", text = icons.diagnostics.BoldInfo },
  }
  for _, sign in ipairs(signs) do
    vim.fn.sign_define(sign.name, { texthl = sign.name, text = sign.text, numhl = sign.name })
  end

  vim.diagnostic.config {
    virtual_text = {
      spacing = 4,
      prefix = "",
    },
    signs = {
      active = signs,
    },
    underline = false,
    update_in_insert = false,
    severity_sort = true,
    float = {
      focusable = true,
      style = "minimal",
      border = "rounded",
      source = "always",
      header = "",
      prefix = "",
    },
  }
end

return M
