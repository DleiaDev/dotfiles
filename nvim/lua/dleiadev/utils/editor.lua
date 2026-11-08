local M = {}

function M.close_hidden_buffers()
	for _, buf in ipairs(vim.fn.getbufinfo({ buflisted = 1 })) do
		if #buf.windows == 0 and buf.changed == 0 then
			vim.api.nvim_buf_delete(buf.bufnr, {})
		end
	end
end

return M
