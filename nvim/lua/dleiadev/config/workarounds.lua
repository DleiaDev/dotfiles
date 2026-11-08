-- Treesitter folds keep per-buffer state that can outlive its buffer. When a plugin
-- then sets 'foldminlines' or 'foldnestmax' globally (codediff's compact mode does),
-- Neovim refreshes every buffer in that state and errors on the dead one:
-- "Invalid buffer id". Replace Neovim's refresh autocmd with one that drops dead
-- buffers first, then runs the original.
do
	local foldexpr = require("vim.treesitter._fold").foldexpr
	local foldinfos
	for i = 1, math.huge do
		local name, value = debug.getupvalue(foldexpr, i)
		if not name or name == "foldinfos" then
			foldinfos = value
			break
		end
	end

	local refresh = vim.tbl_filter(function(au)
		return au.desc == "Refresh treesitter folds" and type(au.callback) == "function"
	end, vim.api.nvim_get_autocmds({ event = "OptionSet" }))

	if foldinfos and #refresh > 0 then
		local callback = refresh[1].callback
		-- One autocmd with two patterns is listed twice
		for _, au in ipairs(refresh) do
			pcall(vim.api.nvim_del_autocmd, au.id)
		end
		vim.api.nvim_create_autocmd("OptionSet", {
			group = vim.api.nvim_create_augroup("dleiadev.ts_fold_refresh", { clear = true }),
			pattern = { "foldminlines", "foldnestmax" },
			desc = "Refresh treesitter folds, skipping deleted buffers",
			callback = function(ev)
				for bufnr in pairs(foldinfos) do
					if not vim.api.nvim_buf_is_valid(bufnr) then
						foldinfos[bufnr] = nil
					end
				end
				return callback(ev)
			end,
		})
	end
end
