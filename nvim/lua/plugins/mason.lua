return {
  "williamboman/mason.nvim",
  dependencies = {
    {
      "WhoIsSethDaniel/mason-tool-installer.nvim",
      opts = {
        auto_update = true,
        ensure_installed = {

          -- LSP
          "volar",
          "bashls",
          "intelephense",
          "tsserver",
          "lua_ls",
          "dockerls",
          "json-lsp",

          -- Formatting
          --"pint",
          "php-cs-fixer",
          "stylua",
          "prettierd",

          -- Linting
          "selene",
          "eslint_d",
        },
      },
    },
  },
  cmd = "Mason",
  keys = {
    { "<leader>cm", "<cmd>Mason<cr>", desc = "Mason" },
  },
  config = true,
}
