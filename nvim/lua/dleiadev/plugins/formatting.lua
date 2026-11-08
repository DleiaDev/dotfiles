-- oxfmt only runs in projects configured for it, so prettier projects keep prettier
local function has_oxfmt_config(_, ctx)
	if vim.fs.root(ctx.dirname, { ".oxfmtrc.json", ".oxfmtrc.jsonc", "oxfmt.config.ts" }) then
		return true
	end
	-- A plain Vite config doesn't count, only a Vite+ one
	local vite_config = vim.fs.find({ "vite.config.ts", "vite.config.js" }, { path = ctx.dirname, upward = true })[1]
	if not vite_config then
		return false
	end
	local file = io.open(vite_config, "r")
	if not file then
		return false
	end
	local content = file:read("*a")
	file:close()
	return content:find("vite-plus", 1, true) ~= nil
end

local web = { "oxfmt", "prettierd", "prettier", stop_after_first = true }

require("conform").setup({
	formatters_by_ft = {
		javascript = web,
		typescript = web,
		javascriptreact = web,
		typescriptreact = web,
		json = web,
		css = web,
		scss = web,
		less = web,
		html = web,
		markdown = web,
		mdx = web,
		yaml = web,
		lua = { "stylua" },
		sh = { "shfmt" },
		fish = { "fish_indent" },
	},
	formatters = {
		oxfmt = { condition = has_oxfmt_config },
	},
	format_on_save = function(buf)
		if vim.b[buf].disable_autoformat then
			return
		end
		return { timeout_ms = 1000, lsp_format = "fallback" }
	end,
})
