return {
  'smoka7/hop.nvim',
  version = '*',
  opts = {
    keys = 'etovxqpdygfblzhckisuran',
  },
  keys = {
    {
      '<Leader><Leader>',
      function()
        require('hop').hint_words()
      end,
      mode = { 'n', 'x', 'o' },
      desc = 'Hop Word',
    },
  },
}
