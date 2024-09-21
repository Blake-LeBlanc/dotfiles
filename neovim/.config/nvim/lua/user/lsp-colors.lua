local status_ok, lsp_colors = pcall(require, "lsp_colors")
if not status_ok then
  return
end

-- To change a preset, give corresponding key new value.
-- To disable any functionality, set corresponding key's value to `false`
lsp_colors.setup({
  Error = "#db4b4b",
  Warning = "#e0af68",
  Information = "#0db9d7",
  Hint = "#10B981"
})

