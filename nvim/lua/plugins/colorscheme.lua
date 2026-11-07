-- Let WezTerm's translucent, blurred background show through Neovim
-- (see `wezterm/wezterm.lua`: window_background_opacity / macos_window_background_blur).
return {
  {
    "folke/tokyonight.nvim",
    opts = {
      transparent = true,
      styles = {
        sidebars = "transparent",
        floats = "transparent",
      },
    },
  },
}
