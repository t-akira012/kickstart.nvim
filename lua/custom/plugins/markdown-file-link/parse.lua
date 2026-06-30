local M = {}

-- 行 line とカーソル列 col(1始まりバイト) から、カーソルを含む [ ... ] を探す。
-- ] の直後が ( の展開済みリンクは対象外として nil を返す。
-- 戻り値: { inner=中身, open=[ の1始まり列, close=] の1始まり列 } / 見つからなければ nil
function M.find(line, col)
  local search_from = 1
  while true do
    local open = line:find('[', search_from, true)
    if not open then
      return nil
    end
    local close = line:find(']', open + 1, true)
    if not close then
      return nil
    end
    if col >= open and col <= close then
      if line:sub(close + 1, close + 1) == '(' then
        return nil
      end
      return { inner = line:sub(open + 1, close - 1), open = open, close = close }
    end
    search_from = close + 1
  end
end

-- パスから拡張子込みのファイル名(basename)を取り出す
function M.label(path)
  return path:match('[^/]+$') or path
end

return M
