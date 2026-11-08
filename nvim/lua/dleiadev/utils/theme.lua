local M = {}

-- WezTerm writes "light" or "dark" here on every macOS appearance change.
local appearance_file = vim.fn.expand("~/.cache/wezterm/appearance")

---@return "light"|"dark"|nil
local function read_mode()
	local file = io.open(appearance_file, "r")
	if not file then
		return nil
	end
	local mode = file:read("*l")
	file:close()
	if mode == "light" or mode == "dark" then
		return mode
	end
end

local function apply(colorscheme)
	local mode = read_mode()
	if mode then
		vim.o.background = mode
	end
	vim.cmd.colorscheme(colorscheme)
end

--- Applies the colorscheme with WezTerm's light/dark mode and keeps following it.
function M.follow_wezterm(colorscheme)
	apply(colorscheme)

	local watcher = vim.uv.new_fs_event()
	if not watcher then
		return
	end
	local function watch()
		watcher:stop()
		pcall(watcher.start, watcher, appearance_file, {}, vim.schedule_wrap(function()
			local mode = read_mode()
			if mode and mode ~= vim.o.background then
				apply(colorscheme)
			end
			watch() -- re-arm, the file may be replaced rather than rewritten
		end))
	end
	watch()
end

return M
