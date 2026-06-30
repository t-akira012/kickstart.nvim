return {
  dir = vim.fn.stdpath 'config' .. '/lua/custom/plugins/markdown-file-link',
  name = 'markdown-file-link',
  ft = 'markdown',
  config = function()
    require 'custom.plugins.markdown-file-link'
  end,
}
