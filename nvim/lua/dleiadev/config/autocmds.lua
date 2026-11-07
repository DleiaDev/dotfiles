local group = vim.api.nvim_create_augroup("dleiadev", { clear = true })

vim.api.nvim_create_autocmd("TextYankPost", {
	group = group,
	callback = function()
		vim.hl.on_yank()
	end,
})

vim.api.nvim_create_autocmd({ "WinEnter", "BufEnter" }, {
	group = group,
	callback = function()
		vim.opt_local.cursorline = true
	end,
})

vim.api.nvim_create_autocmd("WinLeave", {
	group = group,
	callback = function()
		vim.opt_local.cursorline = false
	end,
})
