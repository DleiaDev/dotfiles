local M = {}

M.servers = {
  servers = {
    volar = {
      filetypes = { "typescript", "vue" }, -- Activates "Take Over Mode"
    },
    bashls = {},
    eslint = {},
    intelephense = {},
    tsserver = {
      disabled = true, -- Volar "Take Over Mode"
      disable_formatting = false,
    },
    lua_ls = {
      settings = {
        Lua = {
          workspace = {
            checkThirdParty = false,
          },
          completion = { callSnippet = "Replace" },
          telemetry = { enable = false },
          hint = {
            enable = false,
          },
        },
      },
    },
    dockerls = {},
  },
  setup = {
    lua_ls = function()
      local lsp_utils = require "plugins.lsp.utils"
      lsp_utils.on_attach(function(client, buffer)
            -- stylua: ignore
            if client.name == "lua_ls" then
              vim.keymap.set("n", "<leader>dX", function() require("osv").run_this() end, { buffer = buffer, desc = "OSV run" })
              vim.keymap.set("n", "<leader>dL", function() require("osv").launch({ port = 8086 }) end, { buffer = buffer, desc = "OSV Launch" })
            end
      end)
    end,
  },
}

function M.setup()
  local servers = M.servers.servers
  local lsp_utils = require "plugins.lsp.utils"

  require("mason-lspconfig").setup { ensure_installed = vim.tbl_keys(servers) }
  require("mason-lspconfig").setup_handlers {
    function(server)
      local server_opts = servers[server] or {}
      if server_opts.disabled then
        return
      end
      server_opts.capabilities = lsp_utils.lsp_capabilities()
      if M.servers.setup[server] then
        if M.servers.setup[server](server, server_opts) then
          return
        end
      elseif M.servers.setup["*"] then
        if M.servers.setup["*"](server, server_opts) then
          return
        end
      end
      require("lspconfig")[server].setup(server_opts)
    end,
  }
end

return M
