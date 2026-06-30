-- markdown-file-link の純粋ロジック(parse)に対するテスト
-- 実行: nvim -l test/markdown_file_link_spec.lua (リポジトリルートから)
package.path = './lua/?.lua;' .. package.path

local parse = require('custom.plugins.markdown-file-link.parse')

local function assert_eq(actual, expected, label)
  assert(actual == expected, ('%s: expected=%s actual=%s'):format(label, tostring(expected), tostring(actual)))
end

-- find: カーソルが [..] 内なら inner と1始まり位置を返す
local line = 'see [./plugin/test.lua] here'
local found = parse.find(line, 6)
assert(found ~= nil, 'find: ブラケット内なら非nil')
assert_eq(found.inner, './plugin/test.lua', 'find inner')
assert_eq(found.open, 5, 'find open col (= [ の列)')
assert_eq(found.close, 23, 'find close col (= ] の列)')

-- find: カーソルが [ の直上でも検出する
assert(parse.find(line, 5) ~= nil, 'find: [ の上で検出')

-- find: カーソルが ] の直上でも検出する
assert(parse.find(line, 23) ~= nil, 'find: ] の上で検出')

-- find: ブラケット外では nil
assert_eq(parse.find(line, 1), nil, 'find: ブラケット外は nil')

-- find: すでに [..](..) 形式（] の直後が ( ）は対象外
assert_eq(parse.find('[test.lua](./plugin/test.lua)', 2), nil, 'find: 展開済みリンクは nil')

-- label: 拡張子込みのファイル名を返す
assert_eq(parse.label('./plugin/test.lua'), 'test.lua', 'label: 相対パスの basename')
assert_eq(parse.label('test.lua'), 'test.lua', 'label: スラッシュなしはそのまま')
assert_eq(parse.label('../a/b/c.md'), 'c.md', 'label: 親参照付き basename')

print('markdown_file_link_spec: all passed')
