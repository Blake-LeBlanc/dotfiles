local options = {
  backup = true,
  writebackup = true,
  swapfile = true,
  undofile = true,
  completeopt = { "menuone", "noselect" }, -- mostly for cmp
  conceallevel = 0,                        -- makes `` visible in markdown files
  fileencoding = "utf-8",                  -- encoding written to a file
  mouse = "a",                             -- allow mouse to be used in neovim
  pumheight = 0,
  laststatus = 2,                          -- 2 for statusline plugins, 3 for "global" statusline
  showmatch = false,
  showcmd = true,
  wildmenu = true,
  wildmode = "list:longest,list:full",
  wildignore = "*.o,*.obj,*.bak,*.exe",

  showtabline = 1,

  smartindent = true,
  expandtab = true,                        -- convert tabs to spaces
  shiftwidth = 2,                          -- the number of spaces inserted for each indentation
  tabstop = 2,                             -- insert 2 spaces for a tab

  -- splitscroll -- TODO: set once implemented https://github.com/vim/vim/pull/10682
  splitbelow = true,
  splitright = true,
  termguicolors = true,
  updatetime = 200,                        -- default 4000
  -- updatecount = 200,                       -- default 200 
  cursorline = false,

  number = false,
  relativenumber = false,
  numberwidth = 4,                         -- default 4
  signcolumn = "yes",

  wrap = false,
  scrolloff = 5,
  -- sidescrolloff = 8,
  guifont = "monospace:h17",               -- the font used in graphical neovim applications
  foldenable = true,
  foldmethod = "marker",
  autoread = true,
  joinspaces = true,
  startofline = false,
  textwidth = 100,
  colorcolumn = '+1',
}

for k, v in pairs(options) do
  vim.opt[k] = v
end

vim.cmd [[
  " set whichwrap+=<,>,[,],h,l
  set iskeyword+=-
  set formatoptions=tcrqn1jp
  let g:loaded_matchparen=1 " disable native matchparen highlight plugin from loading
  set history=1000

  set rulerformat=%30(%=\:b%n%y%m%r%w\ %l,%c%V\ %P%)

  set title

  set nrformats=

  " fix corrupt symbols
  let &t_TI = ""
  let &t_TE = ""

  " let g:terminal_color_*

  "list related {{{
  " Indents list structures using - or *. Does some other things, but I'm not sure about those...
  "   https://superuser.com/questions/131950/indentation-for-plain-text-bulleted-lists-in-vim
  "   :h comments
  "   :h format-comments
  " set comments =s1:/*,ex:*/,://,b:#,:%,:XCOMM,n:>,fb:-,fb:[+],fb:[x],fb:[*],fb:[-]
  " set comments +=fb:*
  " set comments +=fb:-

  "}}}

  "search related {{{
  " NOTE: See autocommands.lua for auto-removing highlight

  " set hlsearch " highlight searches
  set nohlsearch " do NOT highlight searches
  set incsearch " search as characters are entered
  set ignorecase " makes search results case-insensitive
  set smartcase " capitalized searches search for capital occurence, lower-case is case insensitive
  " nnoremap <silent><leader>. :noh<CR>
  nnoremap <silent>// :noh<CR>
  set gdefault " searches default to global, that way you don't always have to suffix it with /g
  " vnoremap // y/\V<C-R>"<CR>
  " NOTE: This allows you to search any visually selected text by pressing `//`.
  " https://vim.fandom.com/wiki/Search_for_visually_selected_text

  set shortmess-=S " displays search index
  set shortmess+=c

  "}}}

  "speed and responsiveness {{{
  set lazyredraw
  set ttimeoutlen=10 " default 50
  set ttyfast
  " set ttyscroll=3 " unknown option
  " set tsl=3 " unknown option
  set synmaxcol=500 " default 3000, reducing may help with performance

  " potentially speed up regex related processes surrounding ruby files
  set re=1
  let g:ruby_path=''
  let ruby_no_expensive=1

  "}}}

  "statusline {{{
  " set noshowmode
  set report=0 " threshold for reporting line changes

  " from modusline
  " set statusline=%<%f\ %h%m%r%=%-14.(%l,%c%V%)\ %P

  " set statusline=
  " set statusline+=%<%f
  " set statusline+=%h%m%r
  " set statusline+=%=%-14 %P

  " set statusline=%F%m%r%h%w[%L][%{&ff}]%y[%p%%][%04l,%04v]
  "                | | | | |  |   |      |  |     |    |
  "                | | | | |  |   |      |  |     |    +-- current column
  "                | | | | |  |   |      |  |     +-- current line
  "                | | | | |  |   |      |  +-- current % into file
  "                | | | | |  |   |      +-- current syntax
  "                | | | | |  |   +-- current fileformat
  "                | | | | |  +-- number of lines
  "                | | | | +-- preview flag in square brackets
  "                | | | +-- help flag in square brackets
  "                | | +-- readonly flag in square brackets
  "                | +-- modified flag in square brackets
  "                +-- full path to file in the buffer

  "}}}

  "visual whitespace {{{
  "set listchars=tab:»·,trail:·,nbsp:·
  " set listchars=tab:>-,trail:·,nbsp:_,extends:+,precedes:+
  " set listchars=tab:»·,trail:·,nbsp:_,extends:+,precedes:+
  "set listchars+=tab:\|\ " show indent lines
  " set list
  set nolist

  "}}}

]]

--}}}
