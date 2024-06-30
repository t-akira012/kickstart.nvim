return {
  'phaazon/hop.nvim',
  config = function()
    require('hop').setup { keys = 'qwerasdfyuiophjkl' }
    vim.keymap.set('n', '<leader><leader>', '<CMD>HopWord<CR>', { silent = true })
  end,
}
