---@type Wezterm
local wezterm = require("wezterm")

---@type Config
local config = wezterm.config_builder()

---@return "Light" | "Dark"
local function get_appearance()
	-- wezterm.gui is not available to the mux server
	if wezterm.gui then
		return wezterm.gui.get_appearance()
	end
	return "Dark"
end

---@param appearance "Light" | "Dark"
---@return string
local function get_color_scheme(appearance)
	return "Tokyo Night Day"
	-- if appearance == "Light" then
	-- 	return "Tokyo Night"
	-- else
	-- 	return "Tokyo Night Day"
	-- end
end

-- Colors
config.color_scheme = get_color_scheme(get_appearance())
local scheme = wezterm.get_builtin_color_schemes()[config.color_scheme] ---@type Palette
scheme.tab_bar.background = "none"
scheme.tab_bar.new_tab.bg_color = "none"
config.color_schemes = {
	["Tokyo Night Day"] = scheme,
}

-- Font
config.font = wezterm.font("JetBrains Mono", { weight = "Medium" })
config.font_size = 15

-- Tab
config.use_fancy_tab_bar = false
config.hide_tab_bar_if_only_one_tab = true
config.tab_bar_at_bottom = true

-- Window
config.window_decorations = "RESIZE"
config.window_padding = {
	left = 0,
	right = 0,
	top = 0,
	bottom = 0,
}

return config
