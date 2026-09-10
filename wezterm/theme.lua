---@type Wezterm
local wezterm = require("wezterm")

local M = {}

---@alias Mode "light" | "dark"

local schemes = {
	dark = "Tokyo Night",
	light = "Tokyo Night Day",
}

-- Current appearance is mirrored here so terminal programs (Neovim) can follow
-- along. WezTerm re-runs the config on every OS light/dark switch, so this file
-- is rewritten in place each time.
local APPEARANCE_FILE = (os.getenv("HOME") or wezterm.home_dir) .. "/.cache/wezterm/appearance"

---Resolve the current macOS appearance. WezTerm reloads the config
---automatically whenever the OS light/dark setting changes, so reading
---this in `M.setup` is enough to keep every window in sync.
---@return Mode
local function system_mode()
	local appearance = wezterm.gui and wezterm.gui.get_appearance() or "Dark"
	return appearance:find("Dark") and "dark" or "light"
end

---@param mode Mode
local function write_appearance(mode)
	os.execute('mkdir -p "' .. APPEARANCE_FILE:match("(.*)/") .. '"')
	local file = io.open(APPEARANCE_FILE, "w")
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

	local mode = system_mode()
	config.color_scheme = schemes[mode]
	write_appearance(mode)

	-- Per-window manual override, e.g. to temporarily flip a single window.
	-- Cleared on the next config reload (OS appearance change).
	table.insert(config.keys, {
		key = "F1",
		mods = "CMD",
		action = wezterm.action_callback(function(window)
			local overrides = window:get_config_overrides() or {}
			local current = overrides.color_scheme or config.color_scheme
			local next_mode = current == schemes.dark and "light" or "dark"
			overrides.color_scheme = schemes[next_mode]
			window:set_config_overrides(overrides)
		end),
	})
end

return M
