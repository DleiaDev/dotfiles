return {
  "neovim/nvim-lspconfig",
  opts = {
    servers = {
      eslint = {
        settings = {
          options = {
            -- flags = { "unstable_ts_config" },
          },
        },
      },
    },
  },
}
