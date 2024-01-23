return {
  {
    "echasnovski/mini.ai",
    version = false,
    main = "mini.ai",
    config = true,
    dependencies = {
      {
        "nvim-treesitter/nvim-treesitter-textobjects",
        init = function()
          require("lazy.core.loader").disable_rtp_plugin "nvim-treesitter-textobjects"
        end,
      },
    },
    keys = {
      { "a", mode = { "x", "o" } },
      { "i", mode = { "x", "o" } },
    },
    opts = function()
      local ai = require "mini.ai"
      return {
        n_lines = 500,
        custom_textobjects = {
          o = ai.gen_spec.treesitter {
            a = { "@block.outer", "@conditional.outer", "@loop.outer" },
            i = { "@block.inner", "@conditional.inner", "@loop.inner" },
          },
          f = ai.gen_spec.treesitter({
            a = "@function.outer",
            i = "@function.inner",
          }, {}),
          c = ai.gen_spec.treesitter({
            a = "@class.outer",
            i = "@class.inner",
          }, {}),
        },
      }
    end,
  },
  {
    "echasnovski/mini.jump",
    version = false,
    main = "mini.jump",
    config = true,
    keys = { "f", "F", "t", "T" },
  },
  {
    "echasnovski/mini.jump2d",
    version = false,
    main = "mini.jump2d",
    config = true,
    keys = { "<cr>" },
  },
  {
    "echasnovski/mini.map",
    version = false,
    main = "mini.map",
    config = true,
    keys = {
      -- stylua: ignore start
      { "<leader>mc", function() require("mini.map").close() end, desc = "Minimap close" },
      { "<leader>mf", function() require("mini.map").toggle_focus() end, desc = "Minimap toggle focus" },
      { "<leader>mo", function() require("mini.map").open() end, desc = "Minimap open" },
      { "<leader>mr", function() require("mini.map").refresh() end, desc = "Minimap refresh" },
      { "<leader>ms", function() require("mini.map").toggle_side() end, desc = "Minimap toggle side" },
      { "<leader>mt", function() require("mini.map").toggle() end, desc = "Minimap toggle" },
      -- stylua: ignore end
    },
  },
  {
    "echasnovski/mini.move",
    version = false,
    main = "mini.move",
    config = true,
    keys = { "<M-k>", "<M-j>", "<M-h>", "<M-l>" },
  },
}
