local vim = vim
local h = require 'helper'

--- CHDIR ------------------------------------------------------------------------------------------

local change_current_directory = function()
  vim.cmd ':lcd %:h'
  vim.cmd ':pwd'
end

local show_file_path = function()
  local var = vim.fn.expand '%:p'
  print('Filepath: ' .. var)
end

local show_current_dir = function()
  local var = vim.fn.getcwd()
  print('PWD: ' .. var)
end

h.usercmd('ChangeCurrentDir', change_current_directory)
h.usercmd('Filepath', show_file_path)
h.usercmd('Pwd', show_current_dir)

--- DOC ------------------------------------------------------------------------------------------

-- TODO: open_memoに統合
local open_draft_memo = function()
  local file = 'DRAFT.md'
  local dir = os.getenv 'MEMO_DIR'
  local target = dir .. '/' .. file

  local win_count = vim.fn.winnr '$'
  local buf_name = vim.api.nvim_buf_get_name(0)
  local is_modified = vim.bo.modified

  if win_count == 1 and (buf_name == '' or buf_name == '[No Name]') and not is_modified then
    vim.api.nvim_command('edit ' .. target)
  else
    vim.api.nvim_command('vs ' .. target)
  end
end
h.usercmd('DocOpenDraftMemo', open_draft_memo)

local open_dialy_memo = function() -- ex. 2024-07.md
  -- local today = vim.fn.strftime('%Y-%m-%d', vim.fn.localtime())
  local today = vim.fn.strftime('%Y-%m', vim.fn.localtime())
  local dir = os.getenv 'MEMO_DIR'
  local target = dir .. '/' .. today .. '.md'

  local win_count = vim.fn.winnr '$'
  local buf_name = vim.api.nvim_buf_get_name(0)
  local is_modified = vim.bo.modified

  if win_count == 1 and (buf_name == '' or buf_name == '[No Name]') and not is_modified then
    vim.api.nvim_command('edit ' .. target)
  else
    vim.api.nvim_command('vs ' .. target)
  end
end

h.usercmd('DocOpenDailyMemo', open_dialy_memo)

h.nmap('--', '<CMD>DocOpenDraftMemo<CR>')
h.nmap('-d', '<CMD>DocOpenDailyMemo<CR>')

----------------------------------------------------------------------------------------------------------
-- Paste Image on Markdown
local paste_image = function()
  -- シェルスクリプトの出力を現在のバッファに挿入
  local basename = vim.fn.expand '%:r'
  vim.cmd('r! ~/.config/nvim/sh/paste_image.sh ' .. basename)
end
h.usercmd('PasteImage', paste_image)
h.nmap('<Leader>S', '<CMD>PasteImage<CR>')
h.imap('<C-v>', '<ESC><CMD>PasteImage<CR>')

----------------------------------------------------------------------------------------------------------
-- Toogle Term on TMUX
local toggle_term_on_tmux = function()
  local tmux_pane_pid = vim.fn.system 'tmux display-message -p "#{pane_pid}"'
  vim.fn.system('~/bin/tmux-popup.sh ' .. tmux_pane_pid)
end
h.usercmd('ToggleTermOnTmux', toggle_term_on_tmux)
h.nmap('<c-j>', '<CMD>ToggleTermOnTmux<CR>')

----------------------------------------------------------------------------------------------------------
-- bash abbr
vim.api.nvim_create_augroup('sh', { clear = true })
vim.api.nvim_create_autocmd('FileType', {
  group = 'sh',
  pattern = 'sh',
  callback = function()
    vim.cmd [[
		abbr <buffer> env! #!/usr/bin/env
		]]
  end,
})

----------------------------------------------------------------------------------------------------------
-- Markdown abbr
vim.api.nvim_create_augroup('markdown', { clear = true })
vim.api.nvim_create_autocmd('FileType', {
  group = 'markdown',
  pattern = 'markdown',
  callback = function()
    vim.cmd [[
		inoremap <expr><buffer> <C-d> strftime('%-m/%-d %a')
		inoremap <expr><buffer> <C-t> strftime('%H:%M')
		abbr <buffer> tt - [ ]
		]]
  end,
})

return {}
