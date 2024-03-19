local M = {}

function M.setup()
  M.setup_lazy_file_event()
end

-- Setup "LazyFile" event that allows us to load plugins without blocking the UI
function M.setup_lazy_file_event()
  local Event = require "lazy.core.handler.event"

  vim.print(Event)
end
