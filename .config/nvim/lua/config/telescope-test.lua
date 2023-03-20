local pickers = require('telescope.pickers')
local finders = require('telescope.finders')
local conf = require('telescope.config').values
local themes = require('telescope.themes')
local actions = require('telescope.actions')
local actionsState = require('telescope.actions.state')

local colorsPicker = function(opts)
  opts = opts or {}
  pickers.new(opts, {
    prompt_title = 'colors',
    finder = finders.new_table({
      results = {
        { 'red', '#ff0000' },
        { 'green', '#00ff00' },
        { 'blue', '#0000ff' },
      },
      entry_maker = function(entry)
        return {
          value = entry,
          display = entry[1],
          ordinal = entry[1],
        }
      end
    }),
    sorter = conf.generic_sorter(opts),
    attach_mappings = function(promptBufnr, map)
      actions.select_default:replace(function()
        actions.close(promptBufnr)
        local selection = actionsState.get_selected_entry()
        vim.api.nvim_put({ selection[1] }, '', false, true)
      end)
      return true
    end
  }):find()
end

colorsPicker(themes.get_dropdown({}))
