return {
  "navarasu/onedark.nvim",
  lazy = false,
  config = function()
    local Onedark = require "onedark"

    Onedark.setup {
      style = "darker",
      -- transparent = true,
      highlights = {
        ["@tag"] = { fg = "$red" },
        ["@property"] = { fg = "$red" },
        ["@tag.delimiter"] = { fg = "$fg" },
        ["@tag.attribute"] = { fg = "$orange" },
        ["@constructor.lua"] = { fg = "$light_grey" },
        ["@punctuation.special"] = { fg = "$green" },
      },
    }

    Onedark.load()
  end,
}
