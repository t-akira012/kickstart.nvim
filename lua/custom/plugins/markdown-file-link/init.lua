local parse = require 'custom.plugins.markdown-file-link.parse'

local function expand_file_link()
  local line = vim.api.nvim_get_current_line()
  local col = vim.fn.col '.'

  local found = parse.find(line, col)
  if not found then
    vim.notify('カーソル下に [path] がありません', vim.log.levels.WARN)
    return
  end

  local path = found.inner
  -- 相対パスは編集中ファイルのディレクトリ基準で実在確認する。ファイル・ディレクトリの両方を許可する
  local base = vim.fn.expand '%:p:h'
  local fullpath = vim.fn.fnamemodify(base .. '/' .. path, ':p')
  if vim.fn.filereadable(fullpath) == 0 and vim.fn.isdirectory(fullpath) == 0 then
    vim.notify('パスが存在しません: ' .. path, vim.log.levels.WARN)
    return
  end

  local replacement = '[' .. parse.label(path) .. '](' .. path .. ')'
  local row = vim.fn.line '.' - 1
  vim.api.nvim_buf_set_text(0, row, found.open - 1, row, found.close, { replacement })
end

vim.keymap.set('n', '<Leader>L', expand_file_link, { desc = 'Markdown file link from [path]' })

return {}
