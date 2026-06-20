-- leaf_preview の純粋ロジックに対するテスト
-- 実行: nvim -l test/leaf_preview_spec.lua (リポジトリルートから)
package.path = './lua/?.lua;' .. package.path

local leaf = require('leaf_preview')

local function assert_eq(actual, expected, label)
  assert(actual == expected, ('%s: expected=%s actual=%s'):format(label, tostring(expected), tostring(actual)))
end

local function assert_list_eq(actual, expected, label)
  assert(#actual == #expected, ('%s: length expected=%d actual=%d'):format(label, #expected, #actual))
  for i = 1, #expected do
    assert(actual[i] == expected[i], ('%s[%d]: expected=%s actual=%s'):format(label, i, expected[i], actual[i]))
  end
end

-- validate: 正常系は nil を返す
assert_eq(leaf.validate('markdown', '/tmp/a.md'), nil, 'validate markdown+path is ok')

-- validate: markdown 以外はエラー文字列
assert(leaf.validate('lua', '/tmp/a.lua') ~= nil, 'validate non-markdown is error')

-- validate: ファイル名が空はエラー
assert(leaf.validate('markdown', '') ~= nil, 'validate empty path is error')

-- validate: ファイル名が nil はエラー
assert(leaf.validate('markdown', nil) ~= nil, 'validate nil path is error')

-- build_command: leaf --watch <file> のリストを返す
assert_list_eq(leaf.build_command('/tmp/a.md'), { 'leaf', '--watch', '/tmp/a.md' }, 'build_command watch')

print('ALL TESTS PASSED')
