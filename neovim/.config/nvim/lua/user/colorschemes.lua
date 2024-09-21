vim.g.monotone = { italic_comments = false }
vim.g.neobones = { italic_comments = false }
vim.g.off = { italic_comments = false }
vim.g.yin = { italic_comments = false }
vim.g.zenbones = { italic_comments = false }

vim.cmd [[

" monotone {{{
" FIXME: Any way to invert the colorscheme?
" try
  " let g:monotone_color = [120, 5, 15] " HSL array, affects the default font color
  " let g:monotone_secondary_hue_offset = 200 " offset secondary colors by x degrees from above monotone_color
  " let g:monotone_emphasize_comments = 1 " default 0, uses secondary color for comment font
  " let g:monotone_contrast_factor = 0.85 " default 1.0
" endtry

"}}}

try
  set background=dark

  " colorscheme catppuccin
  " colorscheme darkplus
  " colorscheme distilled
  " colorscheme fogbell
  " colorscheme fogbell_lite
  " colorscheme fogbell_light
  " colorscheme grayscale
  " colorscheme gruvbox-material
  " colorscheme iceberg
  " colorscheme inspired-github
  " colorscheme lucius
  " colorscheme meh
  " colorscheme monotone
  " colorscheme nofrils-dark
  " colorscheme nofrils-light
  " colorscheme nofrils-sepia
  " colorscheme off
  " colorscheme paper
  " colorscheme parchment
  " colorscheme solarized8
  " colorscheme solarized8_flat
  " colorscheme solarized8_low
  " colorscheme yang
  " colorscheme yin

  " Bones
  " colorscheme duckbones
  " colorscheme forestbones
  " colorscheme kanagawabones
  " colorscheme neobones
  " colorscheme nordbones
  " colorscheme rosebones
  " colorscheme seoulbones
  " colorscheme tokyobones
  " colorscheme vimbones
  " colorscheme zenbones
  " colorscheme zenburned
  colorscheme zenwritten

catch /^Vim\%((\a\+)\)\=:E185/
  colorscheme default
  set background=dark
endtry

]]

-- NOTE: I think what you're after here may be better ran through an autocommand of some sort
-- if (vim.g.colors_name == 'zenbones') then
--   vim.cmd [[
--     set background=light
-- 
--   ]]
-- end
-- 
-- if (vim.g.colors_name == 'off') then
--   vim.cmd [[
--     set background=dark
-- 
--   ]]
-- end

