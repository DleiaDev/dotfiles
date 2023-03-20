
local Lualine = require('lualine')

Lualine.setup({
  sections = {
    lualine_c = {
      {
        'filename',
        path = 1,
      },
    },
    lualine_x = {
      'encoding',
      'fileformat',
      {
        'filetype',
        icon_only = true,
      },
    },
  },
})

