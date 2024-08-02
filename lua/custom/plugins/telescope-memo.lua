return {
  'delphinus/telescope-memo.nvim',
  config = function()
    vim.keymap.set('n', 'mm', '<CMD>Telescope memo list<CR>')
    vim.keymap.set('n', 'mg', '<CMD>Telescope memo live_grep<CR>')
    pcall(require('telescope').load_extension, 'memo')
  end,
}
