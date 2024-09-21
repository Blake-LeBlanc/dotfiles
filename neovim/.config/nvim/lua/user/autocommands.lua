vim.cmd [[
  augroup _general_settings
    autocmd!
    autocmd FileType qf,help,man,lspinfo nnoremap <silent> <buffer> q :close<CR>
    " autocmd TextYankPost * silent!lua require('vim.highlight').on_yank({higroup = 'Visual', timeout = 200})
    " autocmd BufWinEnter * :set formatoptions-=cro
    autocmd FileType qf set nobuflisted
  augroup end

  augroup _git
    autocmd!
    autocmd FileType gitcommit setlocal wrap
    autocmd FileType gitcommit setlocal spell
  augroup end

  augroup _markdown
    autocmd!
    autocmd FileType markdown setlocal wrap
    autocmd FileType markdown setlocal spell
  augroup end

  augroup _auto_resize
    autocmd!
    autocmd VimResized * tabdo wincmd =
  augroup end

  " augroup _alpha
  "   autocmd!
  "   autocmd User AlphaReady set showtabline=0 | autocmd BufUnload <buffer> set showtabline=2
  " augroup end

  " colorscheme related {{{
  " distilled {{{
  function! DistilledEdits() abort
    " NOTE: The popupmenu is made up of the following components
    "   Pmenu – normal item
    "   PmenuSel – selected item
    "   PmenuSbar – scrollbar
    "   PmenuThumb – thumb of the scrollbar

    " hi Comment cterm=italic

    " hi clear StatusLine
    " hi clear StatusLineNC
    hi clear EndOfBuffer
    hi clear NonText

    " hi StatusLine   ctermbg=0 ctermfg=8 cterm=NONE guibg=#213245 guifg=#6194ba gui=NONE
    " hi StatusLineNC ctermbg=0 ctermfg=8 cterm=NONE guibg=#213245 guifg=#6194ba gui=NONE
    hi EndOfBuffer  ctermbg=0 ctermfg=8 cterm=NONE guibg=NONE    guifg=#6194ba gui=NONE
    hi NonText      ctermbg=0 ctermfg=8 cterm=NONE guibg=NONE    guifg=#6194ba gui=NONE

    hi clear Cursor
    hi clear Normal
    hi clear Title
    hi clear Visual
    hi clear Pmenu
    hi clear PmenuSbar
    hi clear ErrorMsg
    hi clear SignColumn

    " Change 'common' text color, original is #e4e4dd, default comment color is #6194ba
    " v1{{{
    " hi Cursor           ctermbg=7    ctermfg=NONE cterm=NONE           guibg=#cacabc  guifg=NONE     gui=NONE
    " hi Normal           ctermbg=0    ctermfg=7    cterm=NONE           guibg=#24364b  guifg=#cacabc  gui=NONE
    " hi Title            ctermbg=NONE ctermfg=7    cterm=BOLDUNDERLINE  guibg=NONE     guifg=#cacabc  gui=BOLDUNDERLINE
    " hi Visual           ctermbg=NONE ctermfg=7    cterm=REVERSE        guibg=NONE     guifg=#cacabc  gui=REVERSE
    " hi Pmenu            ctermbg=7    ctermfg=0    cterm=NONE           guibg=#cacabc  guifg=#24364b  gui=NONE
    " hi PmenuSbar        ctermbg=7    ctermfg=NONE cterm=NONE           guibg=#cacabc  guifg=NONE     gui=NONE
    " hi ErrorMsg         ctermbg=1    ctermfg=7    cterm=NONE           guibg=#e76d6d  guifg=#cacabc  gui=NONE

    "}}}

    "v2 {{{
    " hi Cursor           ctermbg=7    ctermfg=NONE cterm=NONE           guibg=#c1c1b1  guifg=NONE     gui=NONE
    " hi Normal           ctermbg=0    ctermfg=7    cterm=NONE           guibg=#24364b  guifg=#c1c1b1  gui=NONE
    " hi Title            ctermbg=NONE ctermfg=7    cterm=BOLDUNDERLINE  guibg=NONE     guifg=#c1c1b1  gui=BOLDUNDERLINE
    " hi Visual           ctermbg=NONE ctermfg=7    cterm=REVERSE        guibg=NONE     guifg=#c1c1b1  gui=REVERSE
    " hi Pmenu            ctermbg=7    ctermfg=0    cterm=NONE           guibg=#c1c1b1  guifg=#24364b  gui=NONE
    " hi PmenuSbar        ctermbg=7    ctermfg=NONE cterm=NONE           guibg=#c1c1b1  guifg=NONE     gui=NONE
    " hi ErrorMsg         ctermbg=1    ctermfg=7    cterm=NONE           guibg=#e76d6d  guifg=#c1c1b1  gui=NONE

    "}}}

    "v3 {{{
    " hi Cursor           ctermbg=7    ctermfg=NONE cterm=NONE           guibg=#96b8d1  guifg=NONE     gui=NONE
    " hi Normal           ctermbg=0    ctermfg=7    cterm=NONE           guibg=#24364b  guifg=#96b8d1  gui=NONE
    " hi Title            ctermbg=NONE ctermfg=7    cterm=BOLDUNDERLINE  guibg=NONE     guifg=#96b8d1  gui=BOLDUNDERLINE
    " hi Visual           ctermbg=NONE ctermfg=7    cterm=REVERSE        guibg=NONE     guifg=#96b8d1  gui=REVERSE
    " hi Pmenu            ctermbg=7    ctermfg=0    cterm=NONE           guibg=#96b8d1  guifg=#24364b  gui=NONE
    " hi PmenuSbar        ctermbg=7    ctermfg=NONE cterm=NONE           guibg=#96b8d1  guifg=NONE     gui=NONE
    " hi ErrorMsg         ctermbg=1    ctermfg=7    cterm=NONE           guibg=#e76d6d  guifg=#96b8d1  gui=NONE

    "}}}

    "v4 {{{
    " hi Cursor           ctermbg=7    ctermfg=NONE cterm=NONE           guibg=#abc6da  guifg=NONE     gui=NONE
    " hi Normal           ctermbg=0    ctermfg=7    cterm=NONE           guibg=#24364b  guifg=#abc6da  gui=NONE
    " hi Title            ctermbg=NONE ctermfg=7    cterm=BOLDUNDERLINE  guibg=NONE     guifg=#abc6da  gui=BOLDUNDERLINE
    " hi Visual           ctermbg=NONE ctermfg=7    cterm=REVERSE        guibg=NONE     guifg=#abc6da  gui=REVERSE
    " hi Pmenu            ctermbg=7    ctermfg=0    cterm=NONE           guibg=#abc6da  guifg=#24364b  gui=NONE
    " hi PmenuSbar        ctermbg=7    ctermfg=NONE cterm=NONE           guibg=#abc6da  guifg=NONE     gui=NONE
    " hi ErrorMsg         ctermbg=1    ctermfg=7    cterm=NONE           guibg=#e76d6d  guifg=#abc6da  gui=NONE

    "}}}

    " ##ACTIVE##
    "v5 {{{
    hi Cursor           ctermbg=7    ctermfg=NONE cterm=NONE           guibg=#99b2c4  guifg=NONE     gui=NONE
    hi Normal           ctermbg=0    ctermfg=7    cterm=NONE           guibg=#24364b  guifg=#99b2c4  gui=NONE
    hi Title            ctermbg=NONE ctermfg=7    cterm=BOLDUNDERLINE  guibg=NONE     guifg=#99b2c4  gui=BOLDUNDERLINE
    hi Visual           ctermbg=NONE ctermfg=7    cterm=REVERSE        guibg=NONE     guifg=#99b2c4  gui=REVERSE
    " hi Pmenu            ctermbg=7    ctermfg=0    cterm=NONE           guibg=#080d11  guifg=#99b2c4  gui=NONE
    " hi Pmenu            ctermbg=7    ctermfg=0    cterm=NONE           guibg=#111923  guifg=#99b2c4  gui=NONE
    " hi Pmenu            ctermbg=7    ctermfg=0    cterm=NONE           guibg=#3a5879  guifg=#99b2c4  gui=NONE
    " hi Pmenu            ctermbg=7    ctermfg=0    cterm=NONE           guibg=#406286  guifg=#99b2c4  gui=NONE
    " hi Pmenu            ctermbg=7    ctermfg=0    cterm=NONE           guibg=#476b94  guifg=#99b2c4  gui=NONE
    " hi Pmenu            ctermbg=7    ctermfg=0    cterm=NONE           guibg=#547fad  guifg=#99b2c4  gui=NONE
    " hi Pmenu            ctermbg=7    ctermfg=0    cterm=NONE           guibg=#244a4b  guifg=#99b2c4  gui=NONE
    " hi Pmenu            ctermbg=7    ctermfg=0    cterm=NONE           guibg=#4a4b24  guifg=#99b2c4  gui=NONE
    hi Pmenu            ctermbg=7    ctermfg=0    cterm=NONE           guibg=#244b39  guifg=#99b2c4  gui=NONE
    hi PmenuSbar        ctermbg=7    ctermfg=NONE cterm=NONE           guibg=#99b2c4  guifg=NONE     gui=NONE
    hi ErrorMsg         ctermbg=1    ctermfg=7    cterm=NONE           guibg=#e76d6d  guifg=#99b2c4  gui=NONE
    hi ColorColumn      ctermbg=8    ctermfg=7    cterm=NONE           guibg=#213245  guifg=#99b2c4  gui=NONE

    "}}}

  endfunction

  "}}}

  " monotone {{{
  function! MonotoneEdits() abort
    " let g:monotone_color = [120, 100, 70] " HSL array, affects the default font color
    " let g:monotone_secondary_hue_offset = 200 " offset secondary colors by x degrees from above monotone_color
    " let g:monotone_emphasize_comments = 1 " default 0, uses secondary color for comment font
    let g:monotone_contrast_factor = 0.92 " default 1.0

  endfunction

  "}}}

  " zenbones {{{
  function! ZenbonesEdits() abort
    set background=light

  endfunction

  "}}}

  augroup MyColors
    autocmd!
    autocmd ColorScheme distilled call DistilledEdits()
    autocmd ColorScheme zenbones call ZenbonesEdits() 
    autocmd ColorScheme monotone call MonotoneEdits()
  augroup END

  "}}}

  " Toggle and Retain Zoom {{{
  " ToggleZoom() and RetainZoomStatus() are handy for moving vim instance tiles around in dwm
  function! ToggleZoom()
      let g:zoom_status = get(g:, 'zoom_status', 0)
      if g:zoom_status == 0
          " Not currently zoomed, so lets zoom in
          wincmd _
          wincmd |
          let g:zoom_status = 1
      else
          " Currently zoomed in, so lets zoom out
          wincmd =
          let g:zoom_status = 0
      endif
  endfunction

  function! RetainZoomStatus()
      " Assume that if we haven't called ToggleZoom() before then all windows
      " are probably meant to be equal (set g:zoom_status to 0)
      let g:zoom_status = get(g:, 'zoom_status', 0)
      if g:zoom_status == 0
          wincmd =
      else
          wincmd _
          wincmd |
      endif
  endfunction

  augroup zoom
      autocmd!
      autocmd VimResized * call RetainZoomStatus()
  augroup END

  nnoremap <silent><C-w>0 :call ToggleZoom()<CR>

"}}}

" function! ClearSignColumn() abort
"   hi clear SignColumn
"
" endfunction

" Autoformat
" augroup _lsp
"   autocmd!
"   autocmd BufWritePre * lua vim.lsp.buf.formatting()
" augroup end

" augroup general
"   autocmd!
"   call ClearSignColumn()
"   
" augroup END

  autocmd ColorScheme * hi clear SignColumn
  autocmd ColorScheme * hi Comment cterm=NONE

"remove trailing spaces on save and preserve cursor position {{{
" https://stackoverflow.com/a/1618401
" fun! <SID>StripTrailingWhitespaces()
"   let l = line(".")
"   let c = col(".")
"   %s/\s\+$//e
"   call cursor(l, c)
" endfun
"
" augroup StripTrailingWhiteSpaces
"   autocmd!
"   autocmd BufWritePre * :call <SID>StripTrailingWhitespaces()
" augroup END
" " NOTE: If you want this to apply only to certain filetypes, you can modify this last line to
" "   replace the * as follows: autocmd FileType c,cpp,java, ... etc

"}}}

"todo syntax highlighting list  {{{
"NOTE: See :h :syn-keyword
"NOTE: See :h :group-name

if has('autocmd') && v:version > 701
  augroup Todo
    autocmd!
    autocmd Syntax * call matchadd(
      \ 'Todo',
      \ '\v\W\zs<(NOTE|INFO|IDEA|TODO|FIXME|CHANGED|BUG|HACK|REVIEW|TEMP|QUESTION|ANSWER|UPDATE)>'
      \)
  augroup END
endif

"}}}

" disable search highlight automatically upon leave {{{
" FIXME: Somehow corrupts the commandline output area with junk
" https://github.com/neovim/neovim/issues/5581#issuecomment-268268488
" fu! HlSearch()
"     let s:pos = match(getline('.'), @/, col('.') - 1) + 1
"     echom s:pos . '|' . col('.')
"     if s:pos != col('.')
"         call StopHL()
"     endif
" endfu
"
" fu! StopHL()
"     if !v:hlsearch || mode() isnot 'n'
"         return
"     else
"         let cmd="\<c-\>\<c-n>:let v:hlsearch=0\<cr>\<c-l>"
"         sil call feedkeys(cmd, 'n')
"     endif
" endfu
"
" augroup SearchHighlight
" au!
"     au CursorMoved * call HlSearch()
"     au InsertLeave * call StopHL()
" augroup end
"
" " https://github.com/neovim/neovim/issues/5581#issuecomment-268362912
" noremap <expr> <Plug>(StopHL) execute('nohlsearch')[-1]
" noremap! <expr> <Plug>(StopHL) execute('nohlsearch')[-1]
"
" function s:StopHL()
"     if !v:hlsearch
"         return
"     else
"         call feedkeys("\<Plug>(StopHL)", "m")
"     endif
" endfunction
"
"}}}

]]

