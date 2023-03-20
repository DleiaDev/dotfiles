
local telescope = require('telescope')
local builtin = require('telescope.builtin')
local actions = require('telescope.actions')

telescope.setup({
  defaults = {
    file_ignore_patterns = {
      'node_modules',
      'vendor',
    },
    dynamic_preview_title = true,
    results_title = false,
    sorting_strategy = 'ascending',
    layout_config = {
      horizontal = {
        prompt_position = 'top',
      },
    },
    mappings = {
      i = {
        ['<C-Down>'] = actions.cycle_history_next,
        ['<C-Up>'] = actions.cycle_history_prev,
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
    --      vim.api.nvim_chan_send(term, 'aaaaaaa')
    --      local function send_output(_, data, _ )
    --        for _, d in ipairs(data) do
    --          vim.api.nvim_chan_send(term, d..'\r\n')
    --        end
    --      end
    --      vim.fn.jobstart(
    --        {
    --          'kitty +kitten icat', filepath  -- Terminal image viewer command
    --        }, 
    --        {on_stdout=send_output, stdout_buffered=true, pty=true}
    --      )
    --    else
    --      require("telescope.previewers.utils").set_preview_message(bufnr, opts.winid, "Binary cannot be previewed")
    --    end
    --  end
    --},
  },
  extensions = {
    media_files = {
      find_cmd = 'rg',
    },
  },
})

-- Extensions
telescope.load_extension('fzy_native')
telescope.load_extension('media_files')

-- Keymaps
local defaultOpts = { noremap = true, silent = true }
vim.keymap.set('n', '<leader>f', builtin.find_files, defaultOpts)
vim.keymap.set('n', '<leader>F', builtin.live_grep, defaultOpts)
vim.keymap.set('n', '<leader>s', builtin.grep_string, defaultOpts)
vim.keymap.set('n', '<leader>g', builtin.git_files, defaultOpts)
vim.keymap.set('n', '<leader>h', builtin.help_tags, defaultOpts)
vim.keymap.set('n', '<leader>b', builtin.buffers, defaultOpts)

