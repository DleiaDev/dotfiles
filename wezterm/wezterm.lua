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

config.color_scheme = scheme_for_appearance(get_appearance())
config.font = wezterm.font_with_fallback({
	{ family = "JetBrainsMono NF", scale = 1.2 },
})
config.window_background_opacity = 0.9

return config
