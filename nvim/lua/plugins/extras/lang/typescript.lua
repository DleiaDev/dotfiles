return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, { "javascript", "typescript", "vue", "tsx" })
    end,
  },
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "jose-elias-alvarez/typescript.nvim",
    },
    opts = {
      setup = {
        tsserver = function(_, opts)
          local lsp_utils = require "plugins.lsp.utils"
          lsp_utils.on_attach(function(client, bufnr)
            if client.name == "tsserver" then
              vim.keymap.set("n", "<leader>co", "TypescriptOrganizeImports", { buffer = bufnr, desc = "Organize imports" })
              vim.keymap.set("n", "<leader>cR", "TypescriptRenameFile", { buffer = bufnr, desc = "Rename file" })
            end
          end)
          require("typescript").setup { server = opts }
          return true
        end,
      },
    },
  },
}
