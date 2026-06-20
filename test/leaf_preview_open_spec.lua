-- leaf_preview.open() の副作用挙動に対する統合テスト
-- 実行: nvim -l test/leaf_preview_open_spec.lua (リポジトリルートから)
-- 前提: このコンテナには leaf が無いため、不正系のみ検証する。
package.path = './lua/?.lua;' .. package.path

local leaf = require('leaf_preview')

local function win_count()
  return #vim.api.nvim_list_wins()
end

-- markdown 以外のバッファでは open は false を返し、ウィンドウを増やさない
vim.bo.filetype = 'lua'
local before = win_count()
local ok = leaf.open()
assert(ok == false, 'non-markdown: open should return false')
assert(win_count() == before, 'non-markdown: window count must not change')

-- markdown だが leaf 不在のため open は false を返し、ウィンドウを増やさない
vim.cmd('enew')
vim.bo.filetype = 'markdown'
vim.api.nvim_buf_set_name(0, '/tmp/leaf_preview_test.md')
before = win_count()
ok = leaf.open()
assert(ok == false, 'leaf absent: open should return false')
assert(win_count() == before, 'leaf absent: window count must not change')

print('ALL OPEN TESTS PASSED')
