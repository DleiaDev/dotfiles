local M = {}

function M.setup(opts)
  vim.print(opts)
  local servers = opts.servers
  local lsp_utils = require "plugins.lsp.utils"

  require("mason-lspconfig").setup { ensure_installed = vim.tbl_keys(servers) }
  require("mason-lspconfig").setup_handlers {
    function(server)
      local server_opts = servers[server] or {}
      if server_opts.disabled then
        return
      end
      server_opts.capabilities = lsp_utils.lsp_capabilities()
      if opts.setup[server] then
        if opts.setup[server](server, server_opts) then
          return
        end
      elseif opts.setup["*"] then
        if opts.setup["*"](server, server_opts) then
          return
        end
      end
      require("lspconfig")[server].setup(server_opts)
    end,
  }
end

return M
