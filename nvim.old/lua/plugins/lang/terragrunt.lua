return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        -- Not shipped by nvim-lspconfig, so the config is defined here
        terragrunt_ls = {
          cmd = { "terragrunt-ls" },
          filetypes = { "hcl" },
          root_markers = { "root.hcl", ".git" },
        },
      },
    },
  },
}
