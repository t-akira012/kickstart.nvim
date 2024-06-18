return {
  'delphinus/telescope-memo.nvim',
  config = function()
    vim.keymap.set('n', '--', '<CMD>Telescope memo list<CR>')
    vim.keymap.set('n', '-g', '<CMD>Telescope memo live_grep<CR>')
    pcall(require('telescope').load_extension, 'memo')
  end,
}
