local is_url = require 'custom.plugins.markdown-link.is_url'

local function markdown_link()
  local clipboard = vim.fn.getreg '+'
  clipboard = clipboard:gsub('%s+$', '')

  if not is_url(clipboard) then
    -- クリップボードが長文・複数行でも判読できるよう、先頭1行かつ40文字で切り詰めて表示する
    local preview = clipboard:gsub('\n.*', '')
    if #preview > 40 then
      preview = preview:sub(1, 40) .. '...'
    end
    vim.notify('Clipboard is not a URL: ' .. preview, vim.log.levels.WARN)
    return
  end

  local start_pos = vim.fn.getpos "'<"
  local end_pos = vim.fn.getpos "'>"
  local start_row = start_pos[2]
  local start_col = start_pos[3]
  local end_row = end_pos[2]
  local end_col = end_pos[3]

  local lines = vim.api.nvim_buf_get_lines(0, start_row - 1, end_row, false)
  if #lines == 0 then
    return
  end

  -- ビジュアル行モード等で end_col が v:maxcol になるため、終端行のバイト長にクランプする
  local end_col_clamped = math.min(end_col, #lines[#lines])

  local selected
  if #lines == 1 then
    selected = lines[1]:sub(start_col, end_col_clamped)
  else
    lines[1] = lines[1]:sub(start_col)
    lines[#lines] = lines[#lines]:sub(1, end_col_clamped)
    selected = table.concat(lines, '\n')
  end

  if selected == '' then
    return
  end

  local replacement = '[' .. selected .. '](' .. clipboard .. ')'

  -- 複数行選択では replacement に改行が含まれるため、1要素=1行のリストへ分割する
  local replacement_lines = vim.split(replacement, '\n', { plain = true })

  vim.api.nvim_buf_set_text(0, start_row - 1, start_col - 1, end_row - 1, end_col_clamped, replacement_lines)
end

vim.keymap.set('v', '<Leader>l', function()
  local esc = vim.api.nvim_replace_termcodes('<Esc>', true, false, true)
  vim.api.nvim_feedkeys(esc, 'nx', false)
  vim.schedule(markdown_link)
end, { desc = 'Markdown Link from clipboard URL' })

return {}
