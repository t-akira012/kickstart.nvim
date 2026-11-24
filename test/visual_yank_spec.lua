-- nvim --headless -u NONE -l test/visual_yank_spec.lua
package.path = './lua/?.lua;' .. package.path

local reads, copies = 0, {}
vim.g.clipboard = {
  name = 'write-only-test',
  copy = {
    ['+'] = function() end,
    ['*'] = function() end,
  },
  paste = {
    ['+'] = function()
      reads = reads + 1
      error('Clipboard reads must not happen during yank')
    end,
    ['*'] = function()
      reads = reads + 1
      error('Clipboard reads must not happen during yank')
    end,
  },
  cache_enabled = 0,
}
vim.opt.clipboard = 'unnamedplus'
vim.env.TMUX = 'visual-yank-test'
vim.env.SSH_CONNECTION = 'visual-yank-test'
local original_has = vim.fn.has
vim.fn.has = function(feature)
  if feature == 'mac' then
    return 1
  elseif feature == 'win32' then
    return 0
  end
  return original_has(feature)
end
local original_system = vim.fn.system
vim.fn.system = function(command, input)
  copies[#copies + 1] = { command = command, text = input }
  return ''
end
dofile './lua/keymaps.lua'

local function check(keys, expected, register)
  vim.cmd 'enew!'
  vim.api.nvim_buf_set_lines(0, 0, -1, false, { '日本語 abc', 'second line' })
  vim.api.nvim_win_set_cursor(0, { 1, 0 })
  local before = #copies
  vim.cmd.normal { args = { keys }, bang = false }
  assert(reads == 0, 'yank must not read the clipboard')
  assert(#copies == before + 1, 'yank must send the captured selection')
  assert(vim.deep_equal(copies[#copies].command, { 'tmux', 'load-buffer', '-w', '-' }), 'SSH yank must copy through tmux')
  assert(copies[#copies].text == expected, 'copied text differs: ' .. vim.inspect(copies[#copies]))
  if register then
    assert(vim.fn.getreg(register) == expected, 'explicit register was not preserved')
  end
end

check('vly', '日本')
check('Vy', '日本語 abc\n')
check('Vjy', '日本語 abc\nsecond line\n')
check('vl"ay', '日本', 'a')
check('vl"+y', '日本')
check('vl"*y', '日本')
check(vim.keycode '<C-v>' .. 'jly', '日\nse')
vim.fn.system = original_system
vim.fn.has = original_has
assert(#vim.api.nvim_get_autocmds { event = 'TextYankPost' } == 0, 'capture autocmd leaked')
print('PASS: visual yank copies character, line, multiline, named and block registers without clipboard reads')
