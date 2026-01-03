local wezterm = require('wezterm')
local config = wezterm.config_builder()
config = {
  font_size = 13,
  default_cursor_style = 'SteadyBar',
}
return config
