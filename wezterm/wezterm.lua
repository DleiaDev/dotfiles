local wezterm = require("wezterm") --[[@as Wezterm]]

local config = {}

if wezterm.config_builder then
	config = wezterm.config_builder()
end

-- wezterm.gui is not available to the mux server, so take care to
-- do something reasonable when this config is evaluated by the mux
local function get_appearance()
	if wezterm.gui then
		return wezterm.gui.get_appearance()
	end
	return "Dark"
end

local function scheme_for_appearance(appearance)
	if appearance:find("Dark") then
		return "Tokyo Night"
	else
		return "Tokyo Night Day"
	end
end

-- Colors
config.color_scheme = scheme_for_appearance(get_appearance())
config.colors = {
	tab_bar = {
		background = "none",
	},
}

config.font = wezterm.font_with_fallback({
	{ family = "JetBrainsMono NF", scale = 1.27, weight = "Medium" },
	-- { family = ... }
})

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
