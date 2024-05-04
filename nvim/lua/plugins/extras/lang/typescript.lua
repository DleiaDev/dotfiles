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
      servers = {
        tsserver = {
          init_options = {
            plugins = {
              -- npm i -g @vue/typescript-plugin
              {
                name = "@vue/typescript-plugin",
                location = "/usr/local/lib/node_modules/@vue/typescript-plugin",
                languages = { "javascript", "typescript", "vue" },
              },
            },
          },
          filetypes = {
            "javascript",
            "typescript",
            "vue",
          },
        },
      },
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
