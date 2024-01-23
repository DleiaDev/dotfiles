local indent = 2

vim.o.shortmess = "filnxtToOFWIcC"
vim.o.formatoptions = "jcroqlnt"

-- Cursor
vim.opt.cursorline = true
vim.opt.guicursor = "a:block"

-- Indenting
vim.opt.breakindent = true
vim.opt.expandtab = true
vim.opt.shiftround = true
vim.opt.shiftwidth = indent
vim.opt.smartindent = true
vim.opt.tabstop = indent

-- Searching
vim.opt.hlsearch = true

-- Undoing
vim.opt.undofile = true

-- Line numbers
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.signcolumn = "yes"

-- Scrolling
vim.opt.scrolloff = 12
vim.opt.sidescrolloff = 12
vim.opt.splitkeep = "screen"

-- Clipboard
vim.opt.clipboard = "unnamedplus"

-- Status line
vim.opt.cmdheight = 1
vim.opt.showmode = false
vim.opt.laststatus = 3

-- Windows
vim.opt.splitbelow = true
vim.opt.splitright = true

-- Colors
vim.opt.termguicolors = true

-- Performance
vim.opt.scrollback = 100000

-- Mapping
vim.opt.timeoutlen = 300
vim.g.mapleader = " "
vim.g.maplocalleader = ","
vim.keymap.set({ "n", "v" }, "<Space>", "<Nop>", { silent = true })
