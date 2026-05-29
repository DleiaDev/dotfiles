---@type Wezterm
local wezterm = require("wezterm")

local M = {}

---@alias Mode "light" | "dark"

---@type Mode|nil
local force = nil

local schemes = {
	dark = "Tokyo Night",
	light = "Tokyo Night Day",
}

-- Stores mode
local MODE_FILE = "/tmp/wezterm_mode"

---@return Mode
local function read_mode()
	local file = io.open(MODE_FILE, "r")
	if not file then
		return "dark"
	end

	local mode = file:read("*l")
	file:close()

	if mode ~= "light" and mode ~= "dark" then
		return "dark"
	end

	return mode
end

---@param mode Mode
local function write_mode(mode)
	local file = io.open(MODE_FILE, "w")
	if file then
		file:write(mode)
		file:close()
	end
end

---@return Mode
local detect_mode = function()
	if force ~= nil then
		return force
	end

	return read_mode()
end

---@param config Config
M.setup = function(config)
	config.keys = config.keys or {}

	table.insert(config.keys, {
		key = "F1",
		action = wezterm.action_callback(function(window)
			local current_mode = read_mode()
			local next_mode = current_mode == "light" and "dark" or "light"

			write_mode(next_mode)

			-- reload config so the color scheme updates
			window:perform_action(wezterm.action.ReloadConfiguration, window:active_pane())
		end),
	})

	local mode = detect_mode()
	local scheme_name = schemes[mode]

	config.color_scheme = scheme_name

	local scheme_object = wezterm.get_builtin_color_schemes()[scheme_name]
	scheme_object.tab_bar.background = "none"
	scheme_object.tab_bar.new_tab.bg_color = "none"
	config.color_schemes = {
		[scheme_name] = scheme_object,
	}
end

return M
