
local Onedark = require('onedark')

Onedark.setup({
  style = 'darker',
  highlights = {
    ['@property'] = { fg = '$red' },
    ['@tag.delimiter'] = { fg = '$fg' },
    ['@tag.attribute'] = { fg = '$orange' },
    ['@punctuation.special'] = { fg = '$green' },
  },
})

Onedark.load()

