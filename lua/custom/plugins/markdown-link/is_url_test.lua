local is_url = require('custom.plugins.markdown-link.is_url')

local pass = 0
local fail = 0

local function assert_true(input)
  if is_url(input) then
    pass = pass + 1
  else
    fail = fail + 1
    print('FAIL: expected true for: ' .. input)
  end
end

local function assert_false(input)
  if not is_url(input) then
    pass = pass + 1
  else
    fail = fail + 1
    print('FAIL: expected false for: ' .. input)
  end
end

-- scheme付きURL
assert_true('https://example.com')
assert_true('http://example.com/path?q=1')
assert_true('file:///home/user/doc.pdf')
assert_true('s3://bucket/key')

-- IP
assert_true('192.168.1.1')
assert_true('10.0.0.1:8080')
assert_true('http://192.168.1.1:3000/path')

-- localhost
assert_true('localhost')
assert_true('localhost:3000')
assert_true('localhost:3000/path')

-- FQDN
assert_true('example.com')
assert_true('sub.example.com')
assert_true('example.co.jp')

-- URLではないもの
assert_false('')
assert_false('hello')
assert_false('just some text')
assert_false('no dot here')
assert_false('123')

print(string.format('\nResults: %d passed, %d failed', pass, fail))
if fail > 0 then
  os.exit(1)
end
