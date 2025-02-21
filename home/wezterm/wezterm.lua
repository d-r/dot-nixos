local wezterm = require 'wezterm'

local config = wezterm.config_builder()

config.hide_tab_bar_if_only_one_tab = true

config.font = wezterm.font('JetBrains Mono')
config.font_size = 10 -- In points

-- config.font = wezterm.font("Iosevka")
-- config.font_size = 12 -- In points

config.harfbuzz_features = {'calt=0'} -- Disable ligatures

-- config.color_scheme = 'Modus Vivendi (Gogh)'
-- config.color_scheme = 'Vs Code Dark+ (Gogh)'

return config
