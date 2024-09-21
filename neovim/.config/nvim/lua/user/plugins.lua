local fn = vim.fn

-- Packer setup and config {{{
-- Automatically install packer
local install_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
if fn.empty(fn.glob(install_path)) > 0 then
	PACKER_BOOTSTRAP = fn.system({
		"git",
		"clone",
		"--depth",
		"1",
		"https://github.com/wbthomason/packer.nvim",
		install_path,
	})
	print("Installing packer close and reopen Neovim...")
	vim.cmd([[packadd packer.nvim]])
end

-- Autocommand that reloads neovim whenever you save the plugins.lua file
-- vim.cmd([[
--   augroup packer_user_config
--     autocmd!
--     autocmd BufWritePost plugins.lua source <afile> | PackerSync
--   augroup end
-- ]])

-- Use a protected call so we don't error out on first use
local status_ok, packer = pcall(require, "packer")
if not status_ok then
	return
end

-- Have packer use a popup window
packer.init({
 	display = {
 		open_fn = function()
 			return require("packer.util").float({ border = "rounded" })
 		end,
 	},
 })

--}}}

-- Plugins {{{
return packer.startup(function(use)
  use('wbthomason/packer.nvim')
  use('lewis6991/impatient.nvim')
  use('ahmedkhalf/project.nvim')
  use('alvan/vim-closetag')
  use({ 'andymass/vim-matchup', requires = 'nvim-treesitter/nvim-treesitter' })
  use('dkarter/bullets.vim')
  use('farmergreg/vim-lastplace')
  -- use({ 'folke/todo-comments.nvim', -- NOTE: major slowdown during scrolling
  --   requires = 'nvim-lua/plenary.nvim'
  -- })
  -- use('folke/which-key.nvim') -- NOTE: weird keybinds that interfere w vim, not worth it
  use('ggandor/leap.nvim')
  use('godlygeek/tabular')
  -- use('habamax/vim-asciidoctor')
  use({ 'iamcco/markdown-preview.nvim', run = function() vim.fn["mkdp#util#install"]() end, })
  -- use('janko-m/vim-test')
  use({ 'JoosepAlviste/nvim-ts-context-commentstring', requires = 'nvim-treesitter/nvim-treesitter' })
  -- use('lukas-reineke/indent-blankline.nvim') -- Introd slowdowns during large scrolls/redraws?
  -- use('luukvbaal/stabilize.nvim') -- NOTE: coming to vim core in the not too distant future
  use('markonm/traces.vim')
  use('mhinz/vim-startify')
  use('moll/vim-bbye')
  -- use('nvim-neorg/neorg')
  use({ 'numToStr/Comment.nvim',
    requires = {
      'nvim-treesitter/nvim-treesitter',
      'JoosepAlviste/nvim-ts-context-commentstring',
    },
  })
  use('nvim-lua/plenary.nvim')
  use('nvim-treesitter/nvim-treesitter')
  use('obreitwi/vim-sort-folds')
  -- use('Shatur/neovim-session-manager')
  -- use({ 'folke/persistence.nvim',
  --   event = 'BufReadPre', -- this will only start session saving when an actual file was opened
  --   module = 'persistence',
  --   config = function()
  --     require('persistence').setup({
  --       dir = vim.fn.expand(vim.fn.stdpath("config") .. "/sessions/"), -- directory where session files are saved
  --       options = { "buffers", "curdir", "tabpages", "winsize" }, -- sessionoptions used for saving
  --     })
  --   end,
  -- })
  use('tpope/vim-endwise')
  -- use({ 'tpope/vim-rails', ft = 'ruby' })
  use('tweekmonster/startuptime.vim')
  use('vim-scripts/fountain.vim')
  use('wellle/targets.vim') -- allows search direction to LEFT of cursor position
  -- use('wesQ3/vim-windowswap')
  use('windwp/nvim-autopairs')

  -- color hex etc {{{
  use('norcalli/nvim-colorizer.lua')
  -- use({ 'RRethy/vim-hexokinase', run = 'cd ~/.local/share/nvim/site/pack/packer/start/vim-hexokinase && make hexokinase' })

  --}}}

  -- colorschemes {{{
  use('ajgrf/parchment')
  use({ "catppuccin/nvim", as = "catppuccin" })
  use('cocopon/iceberg.vim')
  use('davidosomething/vim-colors-meh')
  use('folke/tokyonight.nvim')
  use('gruvbox-community/gruvbox')
  use('habamax/vim-gruvbit')
  use('jaredgorski/fogbell.vim')
  use('jonathanfilip/vim-lucius')
  use('karoliskoncevicius/distilled-vim')
  use('lifepillar/vim-gruvbox8')
  use('lifepillar/vim-solarized8')
  use('Lokaltog/vim-monotone')
  use('lunarvim/darkplus.nvim')
  use('marko-cerovac/material.nvim')
  use({ 'mcchrish/zenbones.nvim', requires = "rktjmp/lush.nvim" })
  use('mvpopuk/inspired-github.vim')
  use('pbrisbin/vim-colors-off')
  use('pgdouyon/vim-yin-yang')
  use('robertmeta/nofrils')
  use('sainnhe/gruvbox-material')
  use('Soares/base16.nvim')
  use('stefanvanburen/rams.vim')
  use('https://git.sr.ht/~swalladge/antarctic-vim')

  -- Nopes
  -- use('Alligator/accent.vim')
  -- use('adigitoleo/vim-mellow')
  -- use('cidem/yui')
  -- use('cocopon/iceberg.vim')
  -- use('fxn/vim-monochrome')
  -- use('hardselius/warlock')
  -- use('koron/vim-monochromenote')
  -- use('p00f/alabaster_dark.nvim')
  -- use('rockerBOO/boo-colorscheme-nvim')
  -- use('ryanpcmcquen/true-monochrome_vim')
  -- use({ 'https://git.sr.ht/~swalladge/paper.vim' }) --FIXME: name clash
  -- use('YorickPeterse/vim-paper') --FIXME: name clash
  -- use('zekzekus/menguless')

  --}}}

  -- completion {{{
  use('hrsh7th/nvim-cmp')
  use('hrsh7th/cmp-buffer')
  use('hrsh7th/cmp-nvim-lsp')
  use('hrsh7th/cmp-nvim-lua')
  use('hrsh7th/cmp-path')
  use('saadparwaiz1/cmp_luasnip')

  --}}}

  -- file explorers {{{
  -- use('tpope/vim-vinegar')
  -- use('tpope/vim-eunuch')

  -- use('kyazdani42/nvim-tree.lua')

  use('luukvbaal/nnn.nvim')

  -- use('vifm/vifm.vim')

  --}}}

  -- fzf --{{{
  use('ibhagwan/fzf-lua')
  use({ 'junegunn/fzf', run = './install --bin', })
  -- use('junegunn/fzf.vim')

  --}}}

  -- git and diff related {{{
  use('lewis6991/gitsigns.nvim')
  use ({ 'sindrets/diffview.nvim', requires = 'nvim-lua/plenary.nvim' })
  use('so-fancy/diff-so-fancy')
  -- use ({ 'tanvirtin/vgit.nvim', requires = 'nvim-lua/plenary.nvim' })
  -- use ({ 'TimUntersberger/neogit', requires = 'nvim-lua/plenary.nvim' })
    -- NOTE: cool, just not convinced it's necessary. The workflow is a little wonky IMO
  use('whiteinge/diffconflicts')
  --}}}

  -- LSP and related {{{
  use('folke/lsp-colors.nvim')
  use('folke/trouble.nvim')
  -- use('j-hui/fidget.nvim')
  use('jose-elias-alvarez/null-ls.nvim')
  use({ 'neovim/nvim-lspconfig', requires = 'hrsh7th/nvim-cmp' })

  -- Installers and related
  -- nvim-lsp-installer
  -- use('williamboman/nvim-lsp-installer')
  -- mason installer
  use('williamboman/mason.nvim')
  use('williamboman/mason-lspconfig.nvim')
  -- use('WhoIsSethDaniel/mason-tool-installer.nvim')

  -- Automated 'wrapper' for nvim-lspconfig and mason related
  -- use('VonHeikemen/lsp-zero.nvim')

  --}}}

  -- snippets{{{
  use('L3MON4D3/LuaSnip')
  use('rafamadriz/friendly-snippets')

  --}}}

  -- statusline related {{{
  -- use({ 'feline-nvim/feline.nvim' })
  -- use({ 'nvim-lualine/lualine.nvim' })
  -- use({ 'rebelot/heriline.nvim' })
  -- use('sunaku/vim-modusline')

  --}}}

  -- surround {{{
  use('kylechui/nvim-surround')

  --}}}

  -- telescope{{{
  -- use('nvim-telescope/telescope.nvim')
  -- use({ 'nvim-telescope/telescope-fzf-native.nvim', run = 'make' })
  -- use('kelly-lin/telescope-ag')

  --}}}

  -- terminal related{{{
  -- use('akinsho/toggleterm.nvim') -- NOTE: While it's convenient, the colors within vim are awful

  --}}}

  -- window selection {{{
  -- NOTE: leap provides for nav between windows with `gs`
  -- use('https://gitlab.com/yorickpeterse/nvim-window')
  -- use('gbrlsnchs/winpick.nvim')

  --}}}

  -- zen modes {{{
  use('folke/zen-mode.nvim')
  -- use('Pocco81/true-zen.nvim')

  --}}}

--}}}

-- Automatically set up your configuration after cloning packer.nvim
-- Put this at the end after all plugins
if PACKER_BOOTSTRAP then
    require("packer").sync()
  end
end)
