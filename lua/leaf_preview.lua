-- leaf を描画エンジンとして、現在の Markdown を隣の vsplit に表示するプラグイン
local M = {}

-- 現在のバッファがプレビュー可能かを判定する純粋関数。
-- 正常なら nil、不正ならエラー理由の文字列を返す(フォールバックせず明示)。
function M.validate(filetype, filepath)
  if filetype ~= 'markdown' then
    return 'leaf-preview: markdownバッファではありません'
  end
  if filepath == nil or filepath == '' then
    return 'leaf-preview: 保存済みファイルがありません'
  end
  return nil
end

-- 端末で起動する leaf コマンドを組み立てる純粋関数。
-- --watch により、ソース保存時に隣のプレビューが自動更新される。
function M.build_command(filepath)
  return { 'leaf', '--watch', filepath }
end

-- 現在の Markdown を隣の vsplit に leaf でプレビューする。
-- 不正やコマンド不在は明示通知して中断し、成否を真偽値で返す。
function M.open()
  local filetype = vim.bo.filetype
  local filepath = vim.api.nvim_buf_get_name(0)

  local err = M.validate(filetype, filepath)
  if err then
    vim.notify(err, vim.log.levels.ERROR)
    return false
  end

  if vim.fn.executable('leaf') ~= 1 then
    vim.notify('leaf-preview: leafコマンドが見つかりません', vim.log.levels.ERROR)
    return false
  end

  local source_win = vim.api.nvim_get_current_win()
  vim.cmd('rightbelow vsplit')
  vim.cmd('enew')
  vim.fn.jobstart(M.build_command(filepath), { term = true })
  vim.api.nvim_set_current_win(source_win)
  return true
end

return M
