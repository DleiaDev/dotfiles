vim.keymap.set("n", "<leader>gl", require("utils.tools").lazygit, { desc = "Lazygit" })

return {
  {
    "michaelrommel/nvim-silicon",
    cmd = "Silicon",
    config = function()
      require("silicon").setup {
        gobble = false,
        font = "JetBrainsMono Nerd Font",
        theme = "TwoDark",
      }
    end,
  },
  {
    "ruifm/gitlinker.nvim",
    keys = {
      {
        "<leader>gy",
        function()
          require("gitlinker").get_buf_range_url "n"
        end,
        mode = "n",
      },
      {
        "<leader>gy",
        function()
          require("gitlinker").get_buf_range_url "v"
        end,
        mode = "v",
      },
      {
        "<leader>gb",
        function()
          require("gitlinker").get_buf_range_url("n", {
            action_callback = require("gitlinker.actions").open_in_browser,
          })
        end,
        mode = "n",
      },
      {
        "<leader>gb",
        function()
          require("gitlinker").get_buf_range_url("v", {
            action_callback = require("gitlinker.actions").open_in_browser,
          })
        end,
        mode = "v",
      },
    },
    config = true,
  },
  {
    "sindrets/diffview.nvim",
    cmd = { "DiffviewOpen", "DiffviewClose", "DiffviewToggleFiles", "DiffviewFocusFiles" },
    config = true,
  },
  -- {
  --   "NeogitOrg/neogit",
  --   cmd = "Neogit",
  --   opts = {
  --     integrations = {
  --       diffview = true,
  --     },
  --   },
  --   dependencies = {
  --     "nvim-lua/plenary.nvim",
  --     "nvim-telescope/telescope.nvim",
  --     "sindrets/diffview.nvim",
  --     "ibhagwan/fzf-lua",
  --   },
  --   config = true,
  -- },
  {
    "lewis6991/gitsigns.nvim",
    event = "BufReadPre",
    config = true,
    opts = {
      signs = {
        add = { hl = "GitSignsAdd", text = "▍", numhl = "GitSignsAddNr", linehl = "GitSignsAddLn" },
        change = {
          hl = "GitSignsChange",
          text = "▍",
          numhl = "GitSignsChangeNr",
          linehl = "GitSignsChangeLn",
        },
        delete = {
          hl = "GitSignsDelete",
          text = "▸",
          numhl = "GitSignsDeleteNr",
          linehl = "GitSignsDeleteLn",
        },
        topdelete = {
          hl = "GitSignsDelete",
          text = "▾",
          numhl = "GitSignsDeleteNr",
          linehl = "GitSignsDeleteLn",
        },
        changedelete = {
          hl = "GitSignsChange",
          text = "▍",
          numhl = "GitSignsChangeNr",
          linehl = "GitSignsChangeLn",
        },
      },
      on_attach = function(bufnr)
        local gs = package.loaded.gitsigns

        local function map(mode, l, r, opts)
          opts = opts or {}
          opts.buffer = bufnr
          vim.keymap.set(mode, l, r, opts)
        end

        -- Navigation
        map("n", "]c", function()
          if vim.wo.diff then
            return "]c"
          end
          vim.schedule(function()
            gs.next_hunk()
          end)
          return "<Ignore>"
        end, { expr = true })

        map("n", "[c", function()
          if vim.wo.diff then
            return "[c"
          end
          vim.schedule(function()
            gs.prev_hunk()
          end)
          return "<Ignore>"
        end, { expr = true })

        -- Actions
        map("n", "<leader>hs", gs.stage_hunk)
        map("n", "<leader>hr", gs.reset_hunk)
        map("v", "<leader>hs", function()
          gs.stage_hunk { vim.fn.line ".", vim.fn.line "v" }
        end)
        map("v", "<leader>hr", function()
          gs.reset_hunk { vim.fn.line ".", vim.fn.line "v" }
        end)
        map("n", "<leader>hS", gs.stage_buffer)
        map("n", "<leader>hu", gs.undo_stage_hunk)
        map("n", "<leader>hR", gs.reset_buffer)
        map("n", "<leader>hp", gs.preview_hunk)
        map("n", "<leader>hb", function()
          gs.blame_line { full = true }
        end)
        map("n", "<leader>tb", gs.toggle_current_line_blame)
        map("n", "<leader>hd", gs.diffthis)
        map("n", "<leader>hD", function()
          gs.diffthis "~"
        end)
        map("n", "<leader>td", gs.toggle_deleted)

        -- Text object
        map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>")
      end,
    },
  },
}
