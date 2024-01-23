local M = {}

function M.setup()
  local float_config = {
    focusable = true,
    style = "minimal",
    border = "rounded",
  }

  -- Hover configuration
  vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, float_config)

  -- Signature help configuration
  vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, float_config)
end

return M
