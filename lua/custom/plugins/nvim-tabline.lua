return {
  'crispgm/nvim-tabline',
  dependencies = { 'nvim-tree/nvim-web-devicons' }, -- optional
  config = function()
    require('tabline').setup {
      show_index = false,
      brackets = { '', '' },
      show_icon = true,
    }
    vim.opt.showtabline = 2
  end,
}
