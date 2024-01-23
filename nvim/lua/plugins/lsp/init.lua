return {
  {
    "neovim/nvim-lspconfig",
    event = "BufReadPre",
    dependencies = {
      { "j-hui/fidget.nvim", config = true },
      { "smjonas/inc-rename.nvim", config = true },
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-nvim-lsp-signature-help",
      {
        "folke/neodev.nvim",
        opts = {
          library = {
            plugins = {
              "neotest",
              "nvim-dap-ui",
            },
            types = true,
          },
        },
      },
    },
    opts = {
      servers = {
        volar = {
          filetypes = { "typescript", "vue" }, -- Actives "Take Over Mode"
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
    },
    config = function(_, opts)
      require("plugins.lsp.diagnostics").setup()
      require("plugins.lsp.handlers").setup()
      require("plugins.lsp.servers").setup(opts)
    end,
  },
  {
    "williamboman/mason.nvim",
    cmd = "Mason",
    keys = {
      { "<leader>cm", "<cmd>Mason<cr>", desc = "Mason" },
    },
    opts = {
      ensure_installed = {
        "stylua",
        "ruff",
        "debugpy",
      },
    },
    config = function(_, opts)
      require("mason").setup()
      local mr = require "mason-registry"
      for _, tool in ipairs(opts.ensure_installed) do
        local p = mr.get_package(tool)
        if not p:is_installed() then
          p:install()
        end
      end
    end,
  },
  {
    "jose-elias-alvarez/null-ls.nvim",
    event = "BufReadPre",
    dependencies = {
      "mason.nvim",
    },
    config = function()
      local nls = require "null-ls"
      nls.setup {
        sources = {
          nls.builtins.formatting.stylua,
          nls.builtins.formatting.prettierd,
        },
      }
    end,
  },
  {
    "utilyre/barbecue.nvim",
    event = "VeryLazy",
    dependencies = {
      "neovim/nvim-lspconfig",
      "SmiteshP/nvim-navic",
      "nvim-tree/nvim-web-devicons",
    },
    config = true,
  },
  {
    "glepnir/lspsaga.nvim",
    event = "VeryLazy",
    config = true,
    opts = {
      symbol_in_winbar = {
        enable = false, -- barbece.nvim is much better
      },
    },
  },
}
