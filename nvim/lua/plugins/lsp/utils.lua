local M = {}

function M.list_formatters(ft)
  return {}
end

function M.list_linters(ft)
  return {}
end

function M.list_completions(ft)
  return {}
end

function M.list_code_actions(ft)
  return {}
end

function M.list_hovers(ft)
  return {}
end

function M.lsp_capabilities()
  local capabilities = vim.lsp.protocol.make_client_capabilities()
  return require("cmp_nvim_lsp").default_capabilities(capabilities)
end

function M.on_attach(on_attach)
  vim.api.nvim_create_autocmd("LspAttach", {
    callback = function(args)
      local bufnr = args.buf
      local client = vim.lsp.get_client_by_id(args.data.client_id)
      on_attach(client, bufnr)
    end,
  })
end

return M
