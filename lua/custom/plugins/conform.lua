return {
  'stevearc/conform.nvim',
  config = function()
    require('conform').setup {
      formatters_by_ft = {
        lua = { 'stylua' },
        python = { 'ruff_format' },
        javascript = { 'deno_fmt' },
        typescript = { 'deno_fmt' },
        javascriptreact = { 'deno_fmt' },
        typescriptreact = { 'deno_fmt' },
        sql = { 'sqlfmt' },
        -- sh = { 'shfmt' },
        go = { 'gofmt' },
      },
      format_on_save = {
        lsp_fallback = true,
        timeout_ms = 500,
      },
    }
    require('conform').formatters.deno_fmt = {
      -- https://github.com/stevearc/conform.nvim/blob/5541c54cf2ab078a537838e1fb9d96ae47f71255/lua/conform/formatters/deno_fmt.lua#L13
      inherit = false,
      command = 'deno',
      args = function(self, ctx)
        return {
          'fmt',
          '--options-no-semicolons',
          '-',
        }
      end,
    }
  end,
}
