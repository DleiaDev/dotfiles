local M = {}

function M.on_attach(client, buffer)
  -- References (Lspsaga)
  vim.keymap.set("n", "<leader>lf", "<cmd>Lspsaga finder<cr>", { buffer = buffer, desc = "Lspsaga finder" })

  -- References (Telescope)
  vim.keymap.set("n", "<leader>lr", "<cmd>Telescope lsp_references<cr>", { buffer = buffer, desc = "Telescope lsp_references" })

  -- Hover
  vim.keymap.set("n", "K", "<cmd>Lspsaga hover_doc<cr>", { buffer = buffer, desc = "Lspsaga hover_doc" })

  -- Signature help
  if client.server_capabilities.signatureHelpProvider then
    vim.keymap.set("n", "gK", vim.lsp.buf.signature_help, { buffer = buffer, desc = "LSP signature help" })
  end

  -- Code action
  if client.server_capabilities.codeActionProvider then
    vim.keymap.set({ "n", "v" }, "<leader>ca", "<cmd>Lspsaga code_action<cr>", { buffer = buffer, desc = "Lspsaga code_action" })
  end

  -- Peek definition
  vim.keymap.set("n", "<leader>lp", "<cmd>Lspsaga peek_definition<cr>", { buffer = buffer, desc = "Lspsaga peek_definition" })

  -- Diagnostics
  vim.keymap.set("n", "]d", "<cmd>Lspsaga diagnostic_jump_next<cr>", { buffer = buffer, desc = "Next diagnostic" })
  vim.keymap.set("n", "]d", "<cmd>Lspsaga diagnostic_jump_prev<cr>", { buffer = buffer, desc = "Prev diagnostic" })
  vim.keymap.set("n", "<leader>dl", "<cmd>Lspsaga show_line_diagnostics<cr>", { buffer = buffer, desc = "Show line diagnostics" })
  -- self:map("<leader>dd", "Lspsaga show_buf_diagnostics ++normal", { desc = "Show buffer diagnostics" })
  vim.keymap.set("n", "<leader>dw", "Lspsaga show_workspace_diagnostics ++normal", { desc = "Show workspace diagnostics" })

  -- Formatting
  local format = require("plugins.lsp.format").format
  if client.server_capabilities.documentFormattingProvider then
    vim.keymap.set("n", "<leader>cf", format, { buffer = buffer, desc = "LSP format document" })
  end
  if client.server_capabilities.documentRangeFormattingProvider then
    vim.keymap.set("v", "<leader>cf", format, { buffer = buffer, desc = "LSP format range" })
  end

  -- Rename
  vim.keymap.set("n", "<leader>R", ":IncRename ", { buffer = buffer, desc = "IncRename" })

  -- Symbols
  vim.keymap.set("n", "<leader>cs", require("telescope.builtin").lsp_document_symbols, { desc = "Telescope document symbols" })
  vim.keymap.set("n", "<leader>cS", require("telescope.builtin").lsp_dynamic_workspace_symbols, { desc = "Telescope document symbols" })
end

return M
