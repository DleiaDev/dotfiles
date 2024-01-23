return {
  "danymat/neogen",
  dependencies = "nvim-treesitter/nvim-treesitter",
  config = true,
  opts = {
    snippet_engine = "luasnip",
    languages = {
      lua = {
        template = {
          annotation_convention = "ldoc",
        },
      },
      python = {
        template = {
          annotation_convention = "google_docstrings",
        },
      },
      typescript = {
        template = {
          annotation_convention = "tsdoc",
        },
      },
      vue = {
        template = {
          annotation_convention = "tsdoc",
        },
      },
    },
  },
  --stylua: ignore
  keys = {
    { "<leader>aa", function() require("neogen").generate() end, desc = "Annotation", },
    { "<leader>ac", function() require("neogen").generate { type = "class" } end, desc = "Class", },
    { "<leader>af", function() require("neogen").generate { type = "func" } end, desc = "Function", },
    { "<leader>at", function() require("neogen").generate { type = "type" } end, desc = "Type", },
  },
}
