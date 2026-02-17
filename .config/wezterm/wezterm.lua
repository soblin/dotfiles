local wezterm = require 'wezterm'
local config = wezterm.config_builder()

config.automatically_reload_config = true
config.scrollback_lines = 10000
-- config.window_background_opacity = 0.5

-- theme
config.color_scheme = 'Dracula (Official)'

config.background = {
   {
      source = {
         File = wezterm.home_dir .. '/.dotfiles/wallpaper/ink_drop1.jpg',
      },
      hsb = { brightness = 0.075 },
   }
}

-- font
config.font = wezterm.font {
   family = 'HackGen Console NF',
}
config.font_size = 12

return config
