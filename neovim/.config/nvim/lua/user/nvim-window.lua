local status_ok, nvim_window = pcall(require, "nvim-window")
if not status_ok then
  return
end

nvim_window.setup({
  -- FIXME: set keybinding
  -- Once installed you need to add a key binding, as nvim-window doesn't define any
  -- key bindings for you. You can set up a binding like so:
  --
  -- map <silent> <leader>w :lua require('nvim-window').pick()<CR>

})

