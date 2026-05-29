---@type Wezterm
local wezterm = require("wezterm")

local M = {}

---@alias Mode "light" | "dark"

local schemes = {
	dark = "Tokyo Night",
	light = "Tokyo Night Day",
}

local MODE_FILE = "/tmp/wezterm_mode"

---@return Mode
local function read_mode()
	local file = io.open(MODE_FILE, "r")
	if not file then
		return "dark"
	end
	local mode = file:read("*l")
	file:close()
	return (mode == "light" or mode == "dark") and mode or "dark"
end

---@param mode Mode
local function write_mode(mode)
	local file = io.open(MODE_FILE, "w")
	if file then
		file:write(mode)
		file:close()
	end
end

local function apply_tab_bar(scheme)
	scheme.tab_bar = scheme.tab_bar or {}
	scheme.tab_bar.background = "none"
	scheme.tab_bar.new_tab = scheme.tab_bar.new_tab or {}
	scheme.tab_bar.new_tab.bg_color = "none"
	return scheme
end

---@param config Config
M.setup = function(config)
	config.keys = config.keys or {}

	local builtin = wezterm.get_builtin_color_schemes()
	config.color_schemes = {}
	for _, name in pairs(schemes) do
		config.color_schemes[name] = apply_tab_bar(builtin[name])
	end

	local initial_mode = read_mode()
	config.color_scheme = schemes[initial_mode]

	table.insert(config.keys, {
		key = "F1",
		mods = "CMD",
		action = wezterm.action_callback(function(window)
			local overrides = window:get_config_overrides() or {}
			local current = overrides.color_scheme or config.color_scheme
			local next_mode = current == schemes.dark and "light" or "dark"
			overrides.color_scheme = schemes[next_mode]
			window:set_config_overrides(overrides)
			write_mode(next_mode)
		end),
	})
end

return M

