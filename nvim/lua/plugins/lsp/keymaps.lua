local M = {}

function M.on_attach(client, buffer)
  local self = M.new(client, buffer)

  self:map("gd", "Lspsaga goto_definition", { desc = "Goto Definition" })
  self:map("<leader>lf", "Lspsaga finder", { desc = "Lspsaga finder" })
  self:map("<leader>lr", "Telescope lsp_references", { desc = "Telescope lsp_references" })
  self:map("K", "Lspsaga hover_doc", { desc = "Lsp hover" })
  self:map("gK", vim.lsp.buf.signature_help, { desc = "Signature Help", has = "signatureHelp" })
  self:map("<leader>ca", "Lspsaga code_action", { desc = "Code Action", mode = { "n", "v" }, has = "codeAction" })
  self:map("<leader>lp", "Lspsaga peek_definition", { desc = "Peak defintion" })

  self:map("]d", "Lspsaga diagnostic_jump_next", { desc = "Next Diagnostic" })
  self:map("[d", "Lspsaga diagnostic_jump_prev", { desc = "Prev Diagnostic" })
  self:map("<leader>dl", "Lspsaga show_line_diagnostics", { desc = "Show line diagnostics" })
  self:map("<leader>dd", "Lspsaga show_buf_diagnostics ++normal", { desc = "Show buffer diagnostics" })
  self:map("<leader>dw", "Lspsaga show_workspace_diagnostics ++normal", { desc = "Show workspace diagnostics" })

  local format = require("plugins.lsp.format").format
  self:map("<leader>cf", format, { desc = "Format Document", has = "documentFormatting" })
  self:map("<leader>cf", format, { desc = "Format Range", mode = "v", has = "documentRangeFormatting" })
  self:map("<leader>R", M.rename, { expr = true, desc = "Rename", has = "rename" })

  self:map("<leader>cs", require("telescope.builtin").lsp_document_symbols, { desc = "Document Symbols" })
  self:map("<leader>cS", require("telescope.builtin").lsp_dynamic_workspace_symbols, { desc = "Workspace Symbols" })
end

function M.new(client, buffer)
  return setmetatable({ client = client, buffer = buffer }, { __index = M })
end

function M:has(cap)
  return self.client.server_capabilities[cap .. "Provider"]
end

function M:map(lhs, rhs, opts)
  opts = opts or {}
  if opts.has and not self:has(opts.has) then
    return
  end
  vim.keymap.set(
    opts.mode or "n",
    lhs,
    type(rhs) == "string" and ("<cmd>%s<cr>"):format(rhs) or rhs,
    ---@diagnostic disable-next-line: no-unknown
    { silent = true, buffer = self.buffer, expr = opts.expr, desc = opts.desc }
  )
end

function M.rename()
  if pcall(require, "inc_rename") then
    return ":IncRename " .. vim.fn.expand "<cword>"
  else
    vim.lsp.buf.rename()
  end
end

return M
