return {
  dir = vim.fn.stdpath 'config' .. '/lua/custom/plugins/markdown-link',
  name = 'markdown-link',
  event = 'VeryLazy',
  config = function()
    require 'custom.plugins.markdown-link'
  end,
}
