local status_ok, vinegar = pcall(require, "vim-vinegar")
-- local status_ok, vinegar = pcall(require, "vinegar")
if not status_ok then
  return
end

vinegar.setup {
  -- FIXME: I don't think this is working like you think it's working...
  vim.cmd[[
    let g.netrw_banner = 0
    let g.netrw_altfile = 1
    let g:netrw_browse_split = 0
    let g:netrw_hide = 0
    let g:netrw_liststyle = 3
    let g:netrw_sizestyle = "H"
    let g:netrw_winsize = 33
  ]]
}

