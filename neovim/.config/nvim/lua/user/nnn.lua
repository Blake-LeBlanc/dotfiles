local status_ok, nnn = pcall(require, "nnn")
if not status_ok then
  return
end

local builtin = require("nnn").builtin

nnn.setup({
	explorer = {
		cmd = "nnn",       -- command overrride (-F1 flag is implied, -a flag is invalid!)
		width = 24,        -- width of the vertical split
		side = "topleft",  -- or "botright", location of the explorer window
		session = "",      -- or "global" / "local" / "shared"
		tabs = true,       -- seperate nnn instance per tab
	},
	picker = {
		cmd = "nnn -d -e -H -r -C",       -- command override (-p flag is implied)
		style = {
			width = 0.9,     -- percentage relative to terminal size when < 1, absolute otherwise
			height = 0.8,    -- ^
			xoffset = 0.5,   -- ^
			yoffset = 0.5,   -- ^
			border = "single"-- border decoration for example "rounded"(:h nvim_open_win)
		},
		session = "",      -- or "global" / "local" / "shared"
	},
	auto_open = {
		setup = nil,       -- or "explorer" / "picker", auto open on setup function
		tabpage = nil,     -- or "explorer" / "picker", auto open when opening new tabpage
		empty = false,     -- only auto open on empty buffer
		ft_ignore = {      -- dont auto open for these filetypes
			"gitcommit",
		}
	},
	auto_close = false,  -- close tabpage/nvim when nnn is last window
	replace_netrw = nil, -- or "explorer" / "picker"
	mappings = {
		{ "<C-t>", builtin.open_in_tab },       -- open file(s) in tab
		{ "<C-x>", builtin.open_in_split },     -- open file(s) in split
		{ "<C-v>", builtin.open_in_vsplit },    -- open file(s) in vertical split
		{ "<C-p>", builtin.open_in_preview },   -- open file in preview split keeping nnn focused
		{ "<C-y>", builtin.copy_to_clipboard }, -- copy file(s) to clipboard
		{ "<C-w>", builtin.cd_to_path },        -- cd to file directory
		{ "<C-e>", builtin.populate_cmdline },  -- populate cmdline (:) with file(s)
  },
	windownav = {        -- window movement mappings to navigate out of nnn
		left = "<C-w>h",
		right = "<C-w>l",
		next = "<C-w>w",
		prev = "<C-w>W",
	},
	buflisted = false,   -- whether or not nnn buffers show up in the bufferlist
	quitcd = "tcd",      -- or "cd" / "lcd", command to run if quitcd file is found
	offset = false,      -- whether or not to write position offset to tmpfile(for use in preview-tui)
})

