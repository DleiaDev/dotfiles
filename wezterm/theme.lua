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
---this in `M.setup` keeps every visible window in sync. Hidden workspaces
---are handled by the `update-status` handler below.
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

-- A config reload only pushes the new palette to panes of the mux window a GUI
-- window is currently showing; panes in hidden workspaces keep the old colors,
-- and switching to them does not re-apply the config. Record which scheme each
-- mux window last received and force a reload when a stale one comes on screen.
local function applied_key(window)
	return "theme_applied_" .. window:window_id()
end

wezterm.on("window-config-reloaded", function(window)
	wezterm.GLOBAL[applied_key(window)] = window:effective_config().color_scheme

	-- The tab bar is rendered once and cached; a reload does not rebuild it,
	-- only a title or status change does. Flip the (otherwise unused) left
	-- status and back so it is redrawn with the new palette.
	window:set_left_status(" ")
	window:set_left_status("")
end)

wezterm.on("update-status", function(window)
	local key = applied_key(window)
	local scheme = window:effective_config().color_scheme
	if wezterm.GLOBAL[key] == scheme then
		return
	end
	wezterm.GLOBAL[key] = scheme

	-- WezTerm ignores set_config_overrides when the value is unchanged, so flip
	-- `color_scheme` to an equivalent-but-different value, then restore it.
	local overrides = window:get_config_overrides() or {}
	local bumped = {}
	for k, v in pairs(overrides) do
		bumped[k] = v
	end
	bumped.color_scheme = overrides.color_scheme == nil and scheme or nil
	window:set_config_overrides(bumped)
	window:set_config_overrides(overrides)
end)

---@param config Config
M.setup = function(config)
	local builtin = wezterm.get_builtin_color_schemes()
	config.color_schemes = {}
	for _, name in pairs(schemes) do
		config.color_schemes[name] = apply_tab_bar(builtin[name])
	end

	local mode = system_mode()
	config.color_scheme = schemes[mode]
	write_appearance(mode)
end

return M
