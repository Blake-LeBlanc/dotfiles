local wezterm = require("wezterm")
local config = wezterm.config_builder()

-- color schemes {{{
-- light
-- config.color_scheme = "aikofog (terminal.sexy)"
-- config.color_scheme = "Ashes (light) (terminal.sexy)"
-- config.color_scheme = "AtomOneLight"
-- config.color_scheme = "ayu_light"
-- config.color_scheme = "Belafonte Day"
-- config.color_scheme = "BlulocoLight"
config.color_scheme = "Catppuccin Latte"
-- config.color_scheme = 'Catppuccin Latte (Gogh)'

-- dark
-- config.color_scheme = 'Arthur (Gogh)'
-- config.color_scheme = "Breadog (Gogh)"

-- }}}
-- cursor {{{
config.animation_fps = 60
-- config.cursor_blink_ease_in = "EaseOut"
-- config.cursor_blink_ease_out = "EaseOut"
config.cursor_blink_ease_in = "Constant"
config.cursor_blink_ease_out = "Constant"
-- config.default_cursor_style = "SteadyBlock"
-- config.default_cursor_style = "SteadyUnderline"
config.default_cursor_style = "BlinkingBlock"
-- config.default_cursor_style = "BlinkingUnderline"
config.cursor_blink_rate = 600

-- }}}
-- font {{{
-- config.font = wezterm.font("JetBrainsMonoNL Nerd Font")
config.font = wezterm.font("JetBrains Mono")
config.font_size = 11
config.line_height = 1.75

-- }}}
-- window decorations {{{
-- config.window_decorations = "TITLE | RESIZE"
config.window_decorations = "RESIZE"

-- }}}

config.enable_tab_bar = false
-- config.window_background_opacity = 0.9
config.default_prog = { "pwsh" }
config.max_fps = 120

return config
