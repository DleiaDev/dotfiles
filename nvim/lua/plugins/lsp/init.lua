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
      "stevearc/conform.nvim",
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
    config = function()
      require("plugins.lsp.diagnostics").setup()
      require("plugins.lsp.handlers").setup()
      require("plugins.lsp.servers").setup()
      vim.api.nvim_create_autocmd("LspAttach", {
        callback = function(args)
          local bufnr = args.buf
          local client = vim.lsp.get_client_by_id(args.data.client_id)
          require("plugins.lsp.keymaps").setup(client, bufnr)
        end,
      })
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
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        lua = { "stylua" },
        php = { { "pint", "php_cs_fixer" } },
        vue = { "prettierd" },
        javascript = { "prettierd" },
        typescript = { "prettierd" },
      },
      format_on_save = {
        timeout_ms = 3000,
        lsp_fallback = true,
      },
    },
  },
}
