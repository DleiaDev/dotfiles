local M = {}

local PAD = "   "
local MAX_NAME = 20
local CUT_NAME = 17

local function set_highlights()
	local style = (vim.g.colors_name or ""):match("^tokyonight%-(.+)$")
	local ok, colors = pcall(function()
		return require("tokyonight.colors").setup({ style = style })
	end)
	if not ok or not style then
		vim.api.nvim_set_hl(0, "DleiaDevTabActive", { link = "TabLineSel" })
		vim.api.nvim_set_hl(0, "DleiaDevTabInactive", { link = "TabLine" })
		vim.api.nvim_set_hl(0, "DleiaDevTabFill", { bg = "NONE" })
		return
	end
	vim.api.nvim_set_hl(0, "DleiaDevTabActive", { fg = colors.bg, bg = colors.blue })
	vim.api.nvim_set_hl(0, "DleiaDevTabInactive", { fg = colors.fg_dark, bg = colors.bg_highlight })
	vim.api.nvim_set_hl(0, "DleiaDevTabFill", { bg = "NONE" })
end

vim.api.nvim_create_autocmd("ColorScheme", {
	group = vim.api.nvim_create_augroup("dleiadev.tabline", { clear = true }),
	callback = set_highlights,
})

local function truncate(name)
	if vim.fn.strchars(name) > MAX_NAME then
		return vim.fn.strcharpart(name, 0, CUT_NAME) .. "..."
	end
	return name
end

local function truncate_left(path)
	local len = vim.fn.strchars(path)
	if len > MAX_NAME then
		return "..." .. vim.fn.strcharpart(path, len - CUT_NAME)
	end
	return path
end

---@param tab integer
---@return string
local function label(tab)
	local buf = vim.api.nvim_win_get_buf(vim.api.nvim_tabpage_get_win(tab))
	local path = vim.api.nvim_buf_get_name(buf)
	local text
	if vim.bo[buf].buftype == "terminal" then
		text = "[Terminal]"
	elseif vim.bo[buf].filetype == "oil" then
		text = truncate_left(vim.fn.fnamemodify(require("oil").get_current_dir(buf) or "", ":~:s?/$??"))
	elseif path == "" then
		text = "[No Name]"
	else
		local name = vim.fn.fnamemodify(path, ":t")
		local icon = MiniIcons and MiniIcons.get("file", name)
		text = (icon and icon .. " " or "") .. truncate(name)
	end
	if vim.bo[buf].modified then
		text = "[+] " .. text
	end
	return (text:gsub("%%", "%%%%"))
end

function M.render()
	local current = vim.api.nvim_get_current_tabpage()
	local parts = {}
	for _, tab in ipairs(vim.api.nvim_list_tabpages()) do
		local hl = tab == current and "DleiaDevTabActive" or "DleiaDevTabInactive"
		table.insert(parts, ("%%#%s#%s%s%s"):format(hl, PAD, label(tab), PAD))
	end
	return table.concat(parts) .. "%#DleiaDevTabFill#"
end

return M
