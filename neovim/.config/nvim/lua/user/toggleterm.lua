local status_ok, toggleterm = pcall(require, "toggleterm")
if not status_ok then
  return
end

toggleterm.setup({
  shade_terminals = true,
  direction = 'tab', -- horizontal vertical float tab
  auto_scroll = true,
  float_opts = {
    border = 'single',
    -- width = function()
    --   return math.floor(vim.o.columns * 0.9)
    -- end,
    -- height = function()
    --   return math.floor(vim.o.lines * 0.9)
    -- end,

  }

})

