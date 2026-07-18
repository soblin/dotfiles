local wezterm = require 'wezterm'
local config = wezterm.config_builder()

config.window_close_confirmation = 'AlwaysPrompt'
config.skip_close_confirmation_for_processes_named = {
  'bash',
  'sh',
  'zsh',
  'fish',
--  'tmux',
  'nu',
  'cmd.exe',
  'pwsh.exe',
  'powershell.exe',
}

config.automatically_reload_config = true
config.scrollback_lines = 10000

config.window_background_opacity = 0.85
-- config.kde_window_background_blur = true // デフォルトのubuntuでは使えない

-- theme
config.color_scheme = 'Dracula (Official)'

--[[
config.background = {
   {
      source = {
         File = wezterm.home_dir .. '/.dotfiles/wallpaper/ink_drop1.jpg',
      },
      hsb = { brightness = 0.075 },
   }
}
--]]

-- font
config.font = wezterm.font {
   family = 'HackGen Console NF',
}
config.font_size = 12

-- title bar
config.window_frame = {
   inactive_titlebar_bg = "none",
   active_titlebar_bg = "none",
}

-- for WSL
--[[
config.default_domain = 'WSL:Ubuntu-22.04'
config.audible_bell = "Disabled"
--]]

return config
