return {
  'stevearc/conform.nvim',
  config = function()
    require('conform').setup {
      formatters_by_ft = {
        lua = { 'stylua' },
        python = { 'isort', 'black' }, -- isort > black の順序で実行
        javascript = { 'deno_fmt' },
        typescript = { 'deno_fmt' },
        javascriptreact = { 'deno_fmt' },
        typescriptreact = { 'deno_fmt' },
        sql = { 'sqlfmt' },
        -- sh = { 'shfmt' },
        go = { 'gofmt' },
      },
      formatters = {
        black = {
          args = { '--line-length', '200', '--stdin-filename', '$FILENAME', '-' },
        },
        isort = {
          args = { '--profile', 'black', '--line-length', '200', '--stdout', '--filename', '$FILENAME', '-' },
        },
      },
      format_on_save = {
        lsp_fallback = true,
        timeout_ms = 1000,
      },
    }
    require('conform').formatters.deno_fmt = {
      -- https://github.com/stevearc/conform.nvim/blob/5541c54cf2ab078a537838e1fb9d96ae47f71255/lua/conform/formatters/deno_fmt.lua#L13
      inherit = false,
      command = 'deno',
      args = function(self, ctx)
        return {
          'fmt',
          '--line-width',
          '150',
          '--options-no-semicolons',
          '-',
        }
      end,
    }
  end,
}
