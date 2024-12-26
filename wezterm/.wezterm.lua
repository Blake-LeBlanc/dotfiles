local wezterm = require("wezterm")
local mux = wezterm.mux
local config = wezterm.config_builder()

-- color schemes {{{
-- light
-- config.color_scheme = "aikofog (terminal.sexy)"
-- config.color_scheme = "Ashes (light) (terminal.sexy)"
-- config.color_scheme = "AtomOneLight"
-- config.color_scheme = "ayu_light"
-- config.color_scheme = "Belafonte Day"
-- config.color_scheme = "BlulocoLight"
-- config.color_scheme = "Catppuccin Latte"
-- config.color_scheme = 'Catppuccin Latte (Gogh)'
-- NO config.color_scheme = "Clrs (Gogh)"
-- config.color_scheme = "dawnfox"
-- NO config.color_scheme = "dayfox"
-- config.color_scheme = "Default (light) (terminal.sexy)"
-- config.color_scheme = "Ef-Cyprus"
-- config.color_scheme = "Ef-Duo-Light"
-- config.color_scheme = "Ef-Frost"
-- config.color_scheme = "Ef-Kassio"
-- config.color_scheme = "Ef-Light"
-- config.color_scheme = "Ef-Reverie"
-- NO config.color_scheme = "Eighties (light) (terminal.sexy)"
-- config.color_scheme = "Embers (light) (terminal.sexy)"
-- NO config.color_scheme = "Github Light (Gogh)"
-- config.color_scheme = "Google (light) (terminal.sexy)"
-- config.color_scheme = "Grayscale (light) (terminal.sexy)"
config.color_scheme = "Ivory Light (terminal.sexy)"
-- NO config.color_scheme = "Londontube (light) (terminal.sexy)"
-- NO config.color_scheme = "Night Owlish Light"

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
config.line_height = 1.5

-- }}}
-- startup{{{
wezterm.on("gui-startup", function(cmd)
	local tab, pane, window = mux.spawn_window(cmd or {})
	window:gui_window():maximize()

	-- Attempting to center vertically and horizontally, but not working properly...
	-- local screen = wezterm.gui.screens().active
	-- local ratio = 0.7
	-- local width, height = screen.width * ratio, screen.height * ratio
	-- local tab, pane, window = wezterm.mux.spawn_window({
	-- 	positon = {
	-- 		x = (screen.width - width) / 2,
	-- 		y = (screen.height - height) / 2,
	-- 		origin = "ActiveScreen",
	-- 	},
	-- })
	-- window:gui_window():set_inner_size(width, height)
end)

-- }}}
-- window decorations {{{
-- config.window_decorations = "TITLE | RESIZE"
config.window_decorations = "RESIZE"

-- }}}
-- window padding{{{
config.window_padding = {
	left = 5,
	right = 5,
	top = 5,
	bottom = 5,
}

-- }}}

config.enable_tab_bar = false
-- config.window_background_opacity = 0.9
config.default_prog = { "pwsh" }
config.max_fps = 120

return config
