return {
  'stevearc/oil.nvim',
  config = function()
    require('oil').setup {
      delete_to_trash = false,
      columns = {
        'icon',
        -- 'permissions',
        -- 'size',
        -- 'mtime',
      },
      view_options = {
        show_hidden = true,
      },
      float = {
        padding = 0,
        max_width = 0.9,
        max_height = 0.8,
        border = 'rounded',
        win_options = {
          winblend = 0,
        },
        get_win_title = nil,
        preview_split = 'auto',
        override = function(conf)
          return conf
        end,
      },
      confirmation = {
        max_width = 0.9,
        min_width = { 40, 0.4 },
        width = nil,
        max_height = 0.9,
        min_height = { 5, 0.1 },
        height = nil,
        border = 'rounded',
        win_options = {
          winblend = 0,
        },
      },
      progress = {
        max_width = 0.9,
        min_width = { 40, 0.4 },
        width = nil,
        max_height = { 10, 0.9 },
        min_height = { 5, 0.1 },
        height = nil,
        border = 'rounded',
        minimized_border = 'none',
        win_options = {
          winblend = 0,
        },
      },
    }
    vim.keymap.set('n', '<Leader>o', '<CMD>lua require("oil").open_float(".")<CR>')
  end,
}
