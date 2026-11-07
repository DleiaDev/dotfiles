-- Follow WezTerm's light/dark appearance.
--
-- WezTerm mirrors the current macOS appearance to `~/.cache/wezterm/appearance`
-- (see `wezterm/theme.lua`) and rewrites it on every OS light/dark switch.
-- Neovim reads it on startup and watches it for live changes, since WezTerm
-- does not push palette changes to already-running panes.

local uv = vim.uv or vim.loop
local appearance_file = vim.fn.expand("~/.cache/wezterm/appearance")

---@return "light"|"dark"|nil
local function read_mode()
  local fd = io.open(appearance_file, "r")
  if not fd then
    return nil
  end
  local mode = fd:read("*l")
  fd:close()
  if mode == "light" or mode == "dark" then
    return mode
  end
end

-- Is the colorscheme *currently rendered* already the right one for `mode`?
-- Checked against `colors_name`, not `&background`: LazyVim can leave those two
-- disagreeing mid-startup, and we set `&background` ourselves.
local function is_correct(mode)
  local cs = vim.g.colors_name
  if cs == nil then
    return false -- not loaded yet; we still have work to do
  end
  if not cs:match("^tokyonight") then
    return true -- some other colorscheme is in charge; don't fight it
  end
  if mode == "light" then
    return cs == "tokyonight-day"
  end
  return cs ~= "tokyonight-day"
end

local pending = false -- a fix is already queued for the next tick
local applying = false -- we are inside our own :colorscheme call

local function sync()
  if applying then
    return
  end
  local mode = read_mode()
  if not mode or pending or is_correct(mode) then
    return
  end
  pending = true
  -- Defer: applying a colorscheme while another :colorscheme is still
  -- unwinding (e.g. LazyVim's startup one) gets silently clobbered.
  vim.schedule(function()
    pending = false
    local m = read_mode()
    if not m or is_correct(m) then
      return
    end
    vim.o.background = m
    local scheme = vim.g.colors_name or "tokyonight"
    if scheme:match("^tokyonight") then
      scheme = "tokyonight" -- base name -> picks day/night from &background
    end
    applying = true
    pcall(vim.cmd.colorscheme, scheme)
    applying = false
  end)
end

local group = vim.api.nvim_create_augroup("wezterm_appearance", { clear = true })

sync()

-- Re-check after LazyVim (or a theme switcher) applies any colorscheme, and at
-- the usual startup / resume milestones.
vim.api.nvim_create_autocmd({ "ColorScheme", "VimEnter", "UIEnter", "FocusGained", "VimResume" }, {
  group = group,
  callback = sync,
})
vim.schedule(sync)

-- Live updates: watch the file WezTerm rewrites on every appearance change.
local watcher

local function watch()
  if not watcher then
    watcher = uv.new_fs_event()
  end
  if not watcher then
    return
  end
  watcher:stop()
  pcall(function()
    watcher:start(
      appearance_file,
      {},
      vim.schedule_wrap(function()
        sync()
        watch() -- re-arm; some writers replace the file instead of truncating
      end)
    )
  end)
end

watch()

vim.api.nvim_create_autocmd("VimLeavePre", {
  group = group,
  callback = function()
    if watcher then
      pcall(function()
        watcher:stop()
      end)
      pcall(function()
        watcher:close()
      end)
      watcher = nil
    end
  end,
})
