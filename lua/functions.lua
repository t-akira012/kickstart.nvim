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
		" inoremap <expr><buffer> <C-d> strftime('%-m/%-d %a')
		" inoremap <expr><buffer> <C-t> strftime('%H:%M')
		abbr <buffer> tt - [ ]
		]]
  end,
})

----------------------------------------------------------------------------------------------------------
-- ToggleCheckbox: 行頭チェックボックスを切り替え
function toggle_checkbox()
  local row, _ = unpack(vim.api.nvim_win_get_cursor(0))
  local line = vim.api.nvim_get_current_line()
  local indent, content = line:match '^(%s*)(.*)$'
  local new_line

  if content:match '^%- %[%s%] ' then
    -- 未チェック -> チェック済み
    new_line = indent .. content:gsub('^%- %[%s%] ', '- [x] ')
  elseif content:match '^%- %[x%] ' then
    -- チェック済み -> 未チェック
    new_line = indent .. content:gsub('^%- %[x%] ', '- [ ] ')
  else
    -- チェックボックスなし -> 未チェックを追加
    new_line = indent .. '- [ ] ' .. content
    move_cursor = true
  end

  vim.api.nvim_set_current_line(new_line)
  -- 必要に応じてカーソルを行末に移動
  if move_cursor then
    local col = #new_line
    vim.api.nvim_win_set_cursor(0, { row, col })
  end
end

vim.keymap.set('n', '<c-l>', toggle_checkbox, { noremap = true, silent = true })
vim.keymap.set('i', '<c-l>', toggle_checkbox, { noremap = true, silent = true })

-- ToggleList
vim.cmd [[

  " バッファローカル変数でトグル状態を管理
  function! s:InitToggleList()
      if !exists('b:toggle_list_enabled')
          let b:toggle_list_enabled = 0
      endif
  endfunction

  " ToggleList機能を切り替える関数
  function! ToggleList()
      " バッファローカル変数の初期化
      call s:InitToggleList()

      if b:toggle_list_enabled
          " トグルOFF: キーマッピングを無効化（バッファローカル）
          silent! iunmap <buffer> <Tab>
          silent! iunmap <buffer> <S-Tab>
          silent! iunmap <buffer> <C-M>
          silent! nunmap <buffer> <Tab>
          silent! nunmap <buffer> <S-Tab>
          silent! nunmap <buffer> <C-M>
          vnoremap <buffer> <Tab> >gv
          vnoremap <buffer> <S-Tab> <gv

          " format optionを戻す
          setlocal comments<
          setlocal formatoptions<

          let b:toggle_list_enabled = 0
          echo "ToggleList: OFF (buffer " . bufnr('%') . ")"
      else
          " トグルON: キーマッピングを設定（バッファローカル）
          " インサートモード
          inoremap <buffer> <Tab> <C-T>
          inoremap <buffer> <S-Tab> <C-D>
          " ノーマルモード
          nnoremap <buffer> <Tab> I<C-T><Esc>
          nnoremap <buffer> <S-Tab> I<C-D><Esc>
          " ビジュアルモード
          vnoremap <buffer> <Tab> >gv
          vnoremap <buffer> <S-Tab> <gv

          " format option
          setlocal comments=nb:>,
                \  comments+=b:-\ [\ ],b:-\ [x],b:-
                \  comments+=b:*,b:-,b:+,b:1.
          setlocal formatoptions-=c formatoptions+=jro

          let b:toggle_list_enabled = 1
          echo "ToggleList: ON (buffer " . bufnr('%') . ")"
      endif
  endfunction

  " バッファ固有の状態を確認する関数
  function! ToggleListStatus()
      call s:InitToggleList()
      if b:toggle_list_enabled
          echo "ToggleList: ON (buffer " . bufnr('%') . ")"
      else
          echo "ToggleList: OFF (buffer " . bufnr('%') . ")"
      endif
  endfunction

  " コマンドを定義
  command! ToggleList call ToggleList()
  command! ToggleListStatus call ToggleListStatus()

  " 初期設定: CTRL+T でToggleList実行
  " バッファ作成時に設定
  autocmd BufEnter * call s:InitToggleList() | inoremap <buffer> <C-t> <C-O>:call ToggleList()<CR>
  " ノーマルモードでも Option+T でToggleList実行
  autocmd BufEnter * nnoremap <buffer> <C-t> :call ToggleList()<CR>

]]

return {}
