
local TreesitterConfigs = require('nvim-treesitter.configs')

TreesitterConfigs.setup({
  ensure_installed = 'all',
  highlight = {
    enable = true,
  },
  incremental_selection = {
    enable = true,
    keymaps = {
      init_selection = '<M-w>',
      node_incremental = '<M-w>',
      node_decremental = '<M-C-w>',
      scope_incremental = '<M-e>',
    },
  },
  playground = {
    enable = true,
  },
  autotag = {
    enable = true,
  },
  endwise = {
    enable = true,
  },
})

require('nvim-autopairs').setup()
