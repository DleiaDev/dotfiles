local M = {}

local Terminal = require("toggleterm.terminal").Terminal

function M.cht()
  vim.ui.input({ prompt = "cht.sh/" }, function(input)
    if input == nil then
      return
    end
    local cmd = "curl cht.sh/" .. input
    Terminal:new({
      cmd = cmd,
      direction = "vertical",
      close_on_exit = false,
      on_open = function(term)
        vim.cmd "stopinsert"
        vim.api.nvim_buf_set_keymap(term.bufnr, "n", "q", "<cmd>close<CR>", { noremap = true, silent = true })
        vim.api.nvim_buf_set_name(term.bufnr, "cheatsheet-" .. term.bufnr)
        vim.api.nvim_buf_set_option(term.bufnr, "filetype", "cheat")
        --vim.api.nvim_buf_set_option(term.bufnr, "syntax", lang)
      end,
      on_exit = function()
        vim.cmd [[normal gg]]
      end,
    }):open(vim.o.columns * 0.5)
  end)
end

function M.stack_overflow()
  vim.ui.input({ prompt = "so input: " }, function(input)
    if input == nil then
      return
    end
    local cmd = "so " .. input
    Terminal:new({
      cmd = cmd,
      direction = "vertical",
      close_on_exit = false,
      on_open = function(term)
        vim.cmd "stopinsert"
        vim.api.nvim_buf_set_keymap(term.bufnr, "n", "q", "<cmd>close<CR>", { noremap = true, silent = true })
      end,
    }):open(vim.o.columns * 0.5)
  end)
end

function M.tokei()
  Terminal:new({
    cmd = "tokei",
    dir = "git_dir",
    hidden = true,
    direction = "float",
    close_on_exit = false,
  }):toggle()
end

function M.bottom()
  Terminal:new({
    cmd = "btm",
    hidden = true,
    direction = "float",
  }):open()
end

function M.lazydocker()
  Terminal:new({
    cmd = "lazydocker",
    dir = "git_dir",
    hidden = true,
    direction = "float",
  }):open()
end

function M.lazygit()
  Terminal:new({
    cmd = "lazygit",
    dir = "git_dir",
    hidden = true,
    direction = "float",
  }):open()
end

return M
