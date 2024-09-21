local opts = { noremap = true, silent = true }
-- local term_opts = { silent = true }
local keymap = vim.api.nvim_set_keymap

-- Modes
--   normal_mode = "n",
--   insert_mode = "i",
--   visual_mode = "v",
--   visual_block_mode = "x",
--   term_mode = "t",
--   command_mode = "c",

-- Vim {{{
-- buffers {{{
keymap("n", "[b", ":bprevious<CR>", opts)
keymap("n", "]b", ":bnext<CR>", opts)
keymap("n", "[B", ":bfirst<CR>", opts)
keymap("n", "]B", ":blast<CR>", opts)

--}}}

-- folds --{{{
-- keymap("n", "<Space>", "@=(foldlevel('.')?'za':"\<Space>")<CR>")

--}}}

-- indent mode {{{
keymap("v", "<", "<gv", opts)
keymap("v", ">", ">gv", opts)

--}}}

-- center cursor {{{
keymap("n", "n", "nzzzv", opts)
keymap("n", "N", "Nzzzv", opts)
keymap("n", "J", "mzJ`z", opts)
keymap("n", "<C-o>", "<C-o>zz", opts)
keymap("n", "<C-i>", "<C-i>zz", opts)
keymap("n", "}", "}zz", opts)
keymap("n", "{", "{zz", opts)
keymap("n", "[", "[zz", opts)
keymap("n", "]", "]zz", opts)
-- keymap("n", "CTRL-T", "<cmd>po zz", opts) --FIXME: delays <S-c>, change to EOL 
-- keymap("n", "CTRL-]", "CTRL-] zz", opts) --FIXME: delays <S-c>, change to EOL

-- undo break points
  -- NOTE: This screwed up a bunch of stuff. Couldn't type a comma, for example
-- keymap("i", ",", "<c-g>u", opts)
-- keymap("i", ".", ".<c-g>u", opts)
-- keymap("i", "!", "!<c-g>u", opts)
-- keymap("i", "?", "?<c-g>u", opts)
-- keymap("i", "[", "[<c-g>u", opts)
-- keymap("i", "]", "]<c-g>u", opts)

keymap("i", "<C-r>", "<C-r><C-o>", opts)
-- NOTE: When pasting content while in Insert mode with <C-r>, vim may treat the pasted text as
-- though it is literally typed, which can be a security concern. I say 'may treat' because from
-- what I've read, it sounds like this may have been fixed in some Vim 8.xxx version. This config
-- insures that the text is inserted literally, just like Normal mode (which is 'safe' by the way,
-- so if in doubt, just paste with Normal mode).

--}}}

-- move text {{{
keymap("n", "<A-j>", "<Esc>:m .+1<CR>==gi", opts)
keymap("n", "<A-k>", "<Esc>:m .-2<CR>==gi", opts)
keymap("v", "<A-j>", ":m .+1<CR>==", opts)
keymap("v", "<A-k>", ":m .-2<CR>==", opts)
keymap("v", "p", '"_dP', opts)
keymap("x", "J", ":move '>+1<CR>gv-gv", opts)
keymap("x", "K", ":move '<-2<CR>gv-gv", opts)
keymap("x", "<A-j>", ":move '>+1<CR>gv-gv", opts)
keymap("x", "<A-k>", ":move '<-2<CR>gv-gv", opts)

--}}}

-- quickfix {{{
keymap("n", "<leader>co", "<cmd>copen<CR>", opts)
keymap("n", "<leader>cc", "<cmd>cclose<CR>", opts)
keymap("n", "[q", "<cmd>cprev<CR>zz", opts)
keymap("n", "]q", "<cmd>cnext<CR>zz", opts)

--}}}

-- resize {{{
keymap("n", "<C-Up>", ":resize -2<CR>", opts)
keymap("n", "<C-Down>", ":resize +2<CR>", opts)
keymap("n", "<C-Left>", ":vertical resize -2<CR>", opts)
keymap("n", "<C-Right>", ":vertical resize +2<CR>", opts)

--}}}

-- tabs {{{
keymap("n", "[t", ":tabp<CR>", opts)
keymap("n", "]t", ":tabn<CR>", opts)

--}}}

-- get file info for current buffer
-- relative path 
keymap("n", "<leader>cfr", "<cmd>let @+=expand(\"%\")<CR>", opts)
-- absolute path 
keymap("n", "<leader>cfa", "<cmd>let @+=expand(\"%:p\")<CR>", opts)
-- filename 
keymap("n", "<leader>cff", "<cmd>let @+=expand(\"%:t\")<CR>", opts)
-- directory name
keymap("n", "<leader>cfd", "<cmd>let @+=expand(\"%:p:h\")<CR>", opts)

-- Always move by visual line, useful when navigating wrapped lines
keymap("n", "k", "gk", opts)
keymap("n", "j", "gj", opts)
keymap("n", "0", "g0", opts)
keymap("n", "$", "g$", opts)

-- Display time
-- FIXME: How to show just 24H time? Returns invalid escape sequence 
-- keymap("n", "<leader>0", ":!date +\%R<CR>", opts)
keymap("n", "<leader>]", ":!date<CR>", opts)

-- profile performance {{{
vim.cmd[[
  function! ProfileStart()
    profile start ~/profile.log
    profile func *
    profile file *
  endfunction

  function! ProfileEnd()
    profile pause
    noautocmd qall!
  endfunction

]]

keymap("n", "<leader>ps", "<cmd>call ProfileStart()<CR>", opts)
keymap("n", "<leader>pe", "<cmd>call ProfileEnd()<CR>", opts)

--}}}

--}}}

-- Plugins {{{
-- cmp --{{{
-- NOTE: keymaps in cmp.lua

--}}}

-- FZF --{{{
-- NOTE: neovim uses fzf-lua
-- keymap("n", "<C-p>", ":GFiles!<CR>", opts)
-- keymap("n", "<C-b>", ":Buff!<CR>", opts)
-- keymap("n", "<C-m>", ":Marks!<CR>", opts)
-- keymap("n", "<C-e>", ":FZF!<CR>", opts)
-- keymap("n", "<C-s>", ":Ag!<SPACE>", opts)
-- keymap("n", "<C-t>", ":Tags<CR>", opts)

--}}}

-- FZF-lua --{{{
keymap("n", "<C-p>", "<cmd>lua require('fzf-lua').git_files()<CR>", opts)
keymap("n", "<C-b>", "<cmd>lua require('fzf-lua').buffers()<CR>", opts)
keymap("n", "<C-m>", "<cmd>lua require('fzf-lua').marks()<CR>", opts)
keymap("n", "<C-e>", "<cmd>lua require('fzf-lua').files()<CR>", opts)
keymap("n", "<C-f>", "<cmd>lua require('fzf-lua').oldfiles()<CR>", opts)
-- keymap("n", "<C-s>", "<cmd>lua require('fzf-lua').grep()<CR>", opts)
keymap("n", "<C-s>", "<cmd>lua require('fzf-lua').live_grep()<CR>", opts)
-- keymap("n", "<C-t>", "<cmd>lua require('fzf-lua').tags()<CR>", opts)
  -- NOTE: conflicts with moving back in the taglist. DUH!
keymap("n", "<leader>t", "<cmd>lua require('fzf-lua').tags()<CR>", opts)

-- diagnostics_document	
-- diagnostics_workspace	
-- lsp_code_actions	
-- lsp_declarations	
-- lsp_definitions	
-- lsp_document_diagnostics	
-- lsp_document_symbols	
-- lsp_implementations	
-- lsp_incoming_calls	
-- lsp_live_workspace_symbols	
-- lsp_outgoing_calls	
-- lsp_references
-- lsp_typedefs	
-- lsp_workspace_diagnostics	
-- lsp_workspace_symbols	

--}}}

-- LSP --{{{
-- NOTE: LSP related keymaps are kept within the lsp/handlers.lua file

--}}}

-- telescope --{{{
-- keymap("n", "<C-p>", ":Telescope git_files<CR>", opts)
-- keymap("n", "<C-b>", ":Telescope buffers<CR>", opts)
-- keymap("n", "<C-m>", ":Telescope marks<CR>", opts)
-- keymap("n", "<C-e>", ":Telescope find_files<CR>", opts)
-- keymap("n", "<C-s>", ":Telescope live_grep<CR>", opts)
-- keymap("n", "<C-f>", ":Telescope oldfiles<CR>", opts)

--}}}

-- gitsigns --{{{
keymap("n", "[c", ":Gitsigns prev_hunk<CR>", opts)
keymap("n", "]c", ":Gitsigns next_hunk<CR>", opts)

--}}}

-- nvim-tree --{{{
-- keymap("n", "-", )
-- keymap("n", "-", "<cmd>NvimTreeToggle<CR>", opts)
-- keymap("n", "<leader>e", "<cmd>NvimTreeToggle<CR>", opts)
-- keymap("n", "<Escape>", "<cmd>NvimTreeClose<CR>", opts)

--}}}

-- neogit--{{{
keymap("n", "<leader>n", "<cmd>Neogit<CR>", opts)

--}}}

-- nnn{{{
-- keymap("n", "<leader>e", "<cmd>NnnPicker<CR>", opts)
keymap("n", "<leader>e", "<cmd>NnnPicker %:p:h<CR>", opts)

--}}}

-- startify {{{
keymap("n", "<leader>sc", "<cmd>SClose<CR>", opts)
keymap("n", "<leader>sl", "<cmd>SLoad<CR>", opts)

--}}}

-- toggleterm {{{
local status_ok, toggleterm = pcall(require, "toggleterm.terminal")

if status_ok then
  local gitui = toggleterm.Terminal:new({
    cmd = "gitui",
    hidden = true,
    shade_terminals = true,
    direction = 'float', -- horizontal, vertical, float, tab
    auto_scroll = true,
    float_opts = {
      -- border = 'single',
      -- width = function()
      --   return math.floor(vim.o.columns * 0.9)
      -- end,
      -- height = function()
      --   return math.floor(vim.o.lines * 0.9)
      -- end,

    }

  })

  -- local time = Terminal:new({
  local time = toggleterm.Terminal:new({
    cmd = "date +%R",
    hidden = true,
    shade_terminals = true,
    direction = 'float', -- horizontal, vertical, float, tab
    auto_scroll = true,
    close_on_exit = false,
    -- size = 20,
    float_opts = {
      -- border = 'single',
      width = 20,
      height = 5,
      -- width = function()
      --   return math.floor(vim.o.columns * 0.4)
      -- end,
      -- height = function()
      --   return math.floor(vim.o.lines * 0.4)
      -- end,

    },

  })

  function _toggle_gitui()
    gitui:toggle()
  end

  function _toggle_time()
    time:toggle()
  end

  keymap("n", "<leader>h", "<cmd>ToggleTerm<CR>", opts)
  keymap("n", "<leader>g", "<cmd>lua _toggle_gitui()<CR>", opts)
  -- keymap("n", "<leader>]", "<cmd>lua _toggle_time()<CR>", opts)

end

-- 
-- }}}

-- vim-windowswap {{{
-- Run command on window you'd like to move, then change to the window you want to swap with, and
-- run command again. Boom!
keymap("n", "<leader>sw", ":call WindowSwap#EasyWindowSwap()<CR>", opts)

--}}}

-- vim-workspace --{{{
-- keymap("n", "<leader>W", ":ToggleWorkspace<CR>", opts)

--}}}

-- vgit --{{{
  -- keymaps = {
  --   ['n <C-k>'] = 'hunk_up',
  --   ['n <C-j>'] = 'hunk_down',
  --   ['n <leader>gs'] = 'buffer_hunk_stage',
  --   ['n <leader>gr'] = 'buffer_hunk_reset',
  --   ['n <leader>gp'] = 'buffer_hunk_preview',
  --   ['n <leader>gb'] = 'buffer_blame_preview',
  --   ['n <leader>gf'] = 'buffer_diff_preview',
  --   ['n <leader>gh'] = 'buffer_history_preview',
  --   ['n <leader>gu'] = 'buffer_reset',
  --   ['n <leader>gg'] = 'buffer_gutter_blame_preview',
  --   ['n <leader>glu'] = 'project_hunks_preview',
  --   ['n <leader>gls'] = 'project_hunks_staged_preview',
  --   ['n <leader>gd'] = 'project_diff_preview',
  --   ['n <leader>gq'] = 'project_hunks_qf',
  --   ['n <leader>gx'] = 'toggle_diff_preference',
  -- },

--}}}

-- zen-mode{{{
keymap("n", "<leader>z", "<cmd>ZenMode<CR>", opts)

--}}}

--}}}
