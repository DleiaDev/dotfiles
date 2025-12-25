---@type Wezterm
local wezterm = require("wezterm")

---@type Config
local config = wezterm.config_builder()

require("theme").setup(config)

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

-- Cursor
config.default_cursor_style = "SteadyBlock"
config.cursor_blink_rate = 0

return config
