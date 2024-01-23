return {
  {
    "nvim-telescope/telescope.nvim",
    dependencies = {
      "nvim-telescope/telescope-fzy-native.nvim",
    },
    cmd = "Telescope",
    keys = {
      { "<leader>f", "<cmd>Telescope find_files<cr>", desc = "Telescope find files" },
      { "<leader>F", "<cmd>Telescope live_grep<cr>", desc = "Telescope live grep" },
      { "<leader>s", "<cmd>Telescope grep_string<cr>", desc = "Telescope Grep string" },
      { "<leader>g", "<cmd>Telescope git_files<cr>", desc = "Telescope git files" },
      { "<leader>h", "<cmd>Telescope help_tags<cr>", desc = "Telescope help tags" },
      { "<leader>b", "<cmd>Telescope buffers<cr>", desc = "Telescope buffers" },
      { "<leader>r", "<cmd>Telescope resume<cr>", desc = "Telescope resume" },
      -- stylua: ignore
      { "<leader>zc", function() require("telescope.builtin").colorscheme({ enable_preview = true }) end, desc = "Colorscheme" },
    },
    config = function()
      local telescope = require "telescope"
      local actions = require "telescope.actions"
      local actions_layout = require "telescope.actions.layout"
      telescope.setup {
        defaults = {
          dynamic_preview_title = true,
          results_title = false,
          sorting_strategy = "ascending",
          layout_config = {
            horizontal = {
              prompt_position = "top",
            },
          },
          mappings = {
            i = {
              ["<C-j>"] = actions.move_selection_next,
              ["<C-k>"] = actions.move_selection_previous,
              ["<C-n>"] = actions.cycle_history_next,
              ["<C-p>"] = actions.cycle_history_prev,
              ["?"] = actions_layout.toggle_preview,
            },
          },
          --preview = {
          --  mime_hook = function(filepath, bufnr, opts)
          --    local is_image = function(filepath)
          --      local image_extensions = {'png','jpg'}   -- Supported image formats
          --      local split_path = vim.split(filepath:lower(), '.', {plain=true})
          --      local extension = split_path[#split_path]
          --      return vim.tbl_contains(image_extensions, extension)
          --    end
          --    if is_image(filepath) then
          --      local term = vim.api.nvim_open_term(bufnr, {})
          --      --vim.api.nvim_chan_send(term, 'aaaaaaa')
          --      local function send_output(_, data, _ )
          --        for _, d in ipairs(data) do
          --          vim.api.nvim_chan_send(term, d..'\r\n')
          --        end
          --      end
          --      vim.fn.jobstart({
          --        "viu",
          --        "-w",
          --        "40",
          --        "-b",
          --        filepath,
          --      }, {
          --        on_stdout = send_output,
          --        stdout_buffered = true,
          --      })
          --    else
          --      require("telescope.previewers.utils").set_preview_message(bufnr, opts.winid, "Binary cannot be previewed")
          --    end
          --  end
          --},
        },
        pickers = {
          find_files = {
            hidden = true,
          },
        },
      }

      telescope.load_extension "fzy_native"
    end,
  },
}
