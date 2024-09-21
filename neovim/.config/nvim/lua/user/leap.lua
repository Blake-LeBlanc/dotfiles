local status_ok, leap = pcall(require, "leap")
if not status_ok then
  return
end

-- require('leap').set_default_keymaps()
leap.set_default_keymaps()

