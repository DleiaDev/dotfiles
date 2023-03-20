
-- Colors
vim.opt.termguicolors = true

-- Statusline
vim.opt.laststatus = 3
--vim.opt.cmdheight = 0
vim.opt.showmode = false

-- Columns
vim.opt.number = true
vim.opt.signcolumn = 'yes'

-- Cursor
vim.opt.guicursor = 'a:block'
vim.opt.cursorline = true

-- Undofile
vim.opt.undofile = true

-- Clipboard
vim.opt.clipboard = 'unnamed,unnamedplus'

-- Scrolling
vim.opt.wrap = true
vim.opt.list = false
vim.opt.linebreak = true
vim.opt.scrolloff = 12
vim.opt.sidescrolloff = 12

-- Formatting
vim.opt.shiftwidth = 2
vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.textwidth = 120
vim.opt.expandtab = true

-- Window splitting
vim.opt.splitbelow = true
vim.opt.splitright = true

-- Netrw
vim.g.netrw_banner = false
vim.g.netrw_liststyle = 3
vim.g.netrw_winsize = 30

-- Highlight on yank
local yankGroup = vim.api.nvim_create_augroup('HighlightOnYank', { clear = true })
vim.api.nvim_create_autocmd('TextYankPost', {
  group = yankGroup,
  callback = function()
    vim.highlight.on_yank()
  end
})

-- Go to last position
local lastPositionGroup = vim.api.nvim_create_augroup('LastPosition', { clear = true })
vim.api.nvim_create_autocmd('BufReadPost', {
  group = lastPositionGroup,
  command = 'normal g\'"',
})

