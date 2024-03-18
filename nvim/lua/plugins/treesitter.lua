return {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  event = "BufReadPost",
  dependencies = {
    "windwp/nvim-ts-autotag",
    "windwp/nvim-autopairs",
    "RRethy/nvim-treesitter-endwise",
    "nvim-treesitter/nvim-treesitter-textobjects",
  },
  opts = {
    ensure_installed = {
      "bash",
      "dockerfile",
      "html",
      "lua",
      "vimdoc",
      "markdown", -- Needed by Lspsaga hover_doc
      "markdown_inline", -- Needed by Lspsaga hover_doc
      "query",
      "regex",
      "vim",
      "yaml",
      "php",
      "phpdoc",
      "vue",
      "scss",
      "css",
    },
    highlight = {
      enable = true,
    },
    indent = {
      enable = true,
    },
    incremental_selection = {
      enable = true,
      keymaps = {
        init_selection = "<M-w>",
        node_incremental = "<M-w>",
        node_decremental = "<M-C-w>",
        scope_incremental = "<M-e>",
      },
    },
    textobjects = {
      select = {
        enable = true,
        lookahead = true,
        keymaps = {
          ["aa"] = "@parameter.outer",
          ["ia"] = "@parameter.inner",
          ["af"] = "@function.outer",
          ["if"] = "@function.inner",
          ["ac"] = "@class.outer",
          ["ic"] = "@class.inner",
        },
      },
      move = {
        enable = true,
        set_jumps = true,
        goto_next_start = {
          ["]m"] = "@function.outer",
          ["]]"] = "@class.outer",
        },
        goto_next_end = {
          ["]M"] = "@function.outer",
          ["]["] = "@class.outer",
        },
        goto_previous_start = {
          ["[m"] = "@function.outer",
          ["[["] = "@class.outer",
        },
        goto_previous_end = {
          ["[M"] = "@function.outer",
          ["[]"] = "@class.outer",
        },
      },
      swap = {
        enable = true,
        swap_next = {
          ["<leader>cxc"] = "@class.outer",
          ["<leader>cxf"] = "@function.outer",
          ["<leader>cxp"] = "@parameter.inner",
        },
        swap_previous = {
          ["<leader>cXc"] = "@class.outer",
          ["<leader>cXf"] = "@function.outer",
          ["<leader>cXp"] = "@parameter.inner",
        },
      },
    },
    -- Plugins
    --playground = {
    --  enable = true,
    --},
    autotag = {
      enable = true,
    },
    endwise = {
      enable = true,
    },
  },
  config = function(_, opts)
    require("nvim-treesitter.configs").setup(opts)
    require("nvim-autopairs").setup()
  end,
}
