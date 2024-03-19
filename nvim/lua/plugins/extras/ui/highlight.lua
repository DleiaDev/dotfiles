return {
  {
    "RRethy/vim-illuminate",
    event = "BufReadPost",
    opts = {
      --delay = 200,
      filetypes_denylist = {
        "help",
      },
    },
    config = function(_, opts)
      require("illuminate").configure(opts)
      vim.cmd "hi IlluminatedWordText gui=NONE guibg=#4d4d4d"
      vim.cmd "hi IlluminatedWordRead gui=NONE guibg=#4d4d4d"
      vim.cmd "hi IlluminatedWordWrite gui=NONE guibg=#4d4d4d"
    end,
  },
  {
    "m-demare/hlargs.nvim",
    event = "VeryLazy",
    opts = {
      disable = function(_, bufnr)
        if vim.b.semantic_tokens then
          return true
        end
        local clients = vim.lsp.get_active_clients { bufnr = bufnr }
        for _, client in pairs(clients) do
          local capabilities = client.capabilities
          if capabilities and capabilities.semanticTokensProvider and capabilities.semanticTokensProvider.full then
            vim.b.semantic_tokens = true
            return vim.b.semantic_tokens
          end
        end
      end,
    },
  },
}
