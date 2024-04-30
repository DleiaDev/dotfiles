return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      if type(opts.ensure_installed) == "table" then
        vim.list_extend(opts.ensure_installed, { "javascript", "typescript", "vue", "tsx" })
      end
    end,
  },
  {
    "neovim/nvim-lspconfig",
    opts = {
      -- To be continued
    },
  },
  {
    "OlegGulevskyy/better-ts-errors.nvim",
    dependencies = {
      "MunifTanjim/nui.nvim",
    },
    keys = {
      "<leader>as",
      "<leader>ax",
    },
    opts = {
      keymaps = {
        toggle = "<leader>as",
        go_to_definition = "<leader>ax",
      },
    },
  },
}
