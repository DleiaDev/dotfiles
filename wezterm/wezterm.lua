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
if string.find(wezterm.target_triple, "linux") then
	config.window_decorations = "NONE"
else
	config.window_decorations = "RESIZE"
end
config.window_background_opacity = 0.9
config.macos_window_background_blur = 20
config.window_padding = {
	left = 0,
	right = 0,
	top = 0,
	bottom = 0,
}

-- Cursor
config.default_cursor_style = "SteadyBlock"
config.cursor_blink_rate = 0

-- Workspaces
local act = wezterm.action

config.keys = {
	-- Fuzzy-pick an existing workspace
	{ key = "s", mods = "CMD|SHIFT", action = act.ShowLauncherArgs({ flags = "FUZZY|WORKSPACES" }) },

	-- Create/switch to a workspace by name
	{
		key = "n",
		mods = "CMD|SHIFT",
		action = act.PromptInputLine({
			description = "Workspace name:",
			action = wezterm.action_callback(function(window, pane, line)
				if line and line ~= "" then
					window:perform_action(act.SwitchToWorkspace({ name = line }), pane)
				end
			end),
		}),
	},

	-- Rename the current workspace
	{
		key = "e",
		mods = "CMD|SHIFT",
		action = act.PromptInputLine({
			description = "Rename workspace:",
			action = wezterm.action_callback(function(window, _, line)
				if line and line ~= "" then
					wezterm.mux.rename_workspace(window:active_workspace(), line)
				end
			end),
		}),
	},

	-- Rename the current tab (empty input resets to the default title)
	{
		key = "r",
		mods = "CMD|SHIFT",
		action = act.PromptInputLine({
			description = "Tab name:",
			action = wezterm.action_callback(function(window, _, line)
				if line then
					window:active_tab():set_title(line)
				end
			end),
		}),
	},
}

-- Show the current workspace name in the tab bar
wezterm.on("update-right-status", function(window)
	window:set_right_status(" " .. window:active_workspace() .. " ")
end)

return config
