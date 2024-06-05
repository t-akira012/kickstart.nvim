local vim = vim
local h = require 'helper'

--- TODO ------------------------------------------------------------------------------------------

local generate_weekly_todo = function()
    for i = 0, 6 do
        local bufnr = vim.api.nvim_get_current_buf()
        local cursor = vim.api.nvim_win_get_cursor(0)
        local row = cursor[1]
        local day = vim.fn.strftime('%-m/%d %a', vim.fn.localtime() + i * 24 * 60 * 60)
        local str = ('- [ ] ' .. day)
        vim.api.nvim_buf_set_lines(bufnr, row - 1, row - 1, false, { str })
    end
end
h.usercmd('AddWeeklyTodo', generate_weekly_todo)
local generate_weekly_head = function()
    for i = 0, 6 do
        local bufnr = vim.api.nvim_get_current_buf()
        local cursor = vim.api.nvim_win_get_cursor(0)
        local row = cursor[1]
        local day = vim.fn.strftime('%-m/%d %a', vim.fn.localtime() + i * 24 * 60 * 60)
        local str = ('# ' .. day)
        vim.api.nvim_buf_set_lines(bufnr, row - 1, row - 1, false, { str })
    end
end
h.usercmd('AddWeeklyHead', generate_weekly_head)

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

local open_document_dir = function()
    local dir = '$MEMO_DIR/'
    vim.api.nvim_command(':vs' .. dir)
end
h.usercmd('Doc', open_document_dir)

local open_home_memo = function()
    local dir = '$MEMO_DIR/'
    vim.api.nvim_command(':vs' .. dir .. 'home.md')
end
h.usercmd('DocOpenHomeMemo', open_home_memo)

local open_flow_memo = function()
    local dir = '$MEMO_DIR/'
    vim.api.nvim_command(':vs' .. dir .. 'flow.md')
end
h.usercmd('DocOpenFlowMemo', open_flow_memo)

local open_draft_memo = function()
    local dir = '$MEMO_DIR/'
    vim.api.nvim_command(':vs' .. dir .. 'draft.md')
end
h.usercmd('DocOpenDraftMemo', open_draft_memo)

local create_new_daily_memo = function()
    local dir = '$MEMO_DIR/daily/'
    local today = vim.fn.strftime('%Y-%m-%d', vim.fn.localtime())
    vim.api.nvim_command(':vs' .. dir .. today .. '.md')
end
h.usercmd('DocOpenDailyMemo', create_new_daily_memo)
local create_new_weekly_memo = function()
    local dir = '$MEMO_DIR/weekly/'
    local year = vim.fn.strftime('%Y', vim.fn.localtime())
    local week_num = vim.fn.strftime('%W', vim.fn.localtime())
    vim.api.nvim_command(':vs' .. dir .. year .. '-W' .. week_num .. '.md')
end
h.usercmd('DocOpenWeeklyMemo', create_new_weekly_memo)

h.nmap('--', '<CMD>DocOpenFlowMemo<CR>')
h.nmap('==', '<CMD>DocOpenDraftMemo<CR>')
-- h.nmap('-=', '<CMD>DocOpenHomeMemo<CR>')
h.nmap('-d', '<CMD>DocOpenDailyMemo<CR>')
h.nmap('-w', '<CMD>DocOpenWeeklyMemo<CR>')

--- CREAMTE MEMO ------------------------------------------------------------------------------------------

-- メモファイルを開く関数
-- '-m'に続く1桁の数字のためのマッピングを設定
vim.api.nvim_set_keymap('n', '-m', "<cmd>lua vim.cmd('vs $MEMO_DIR/memo.md')<CR>", { noremap = true, silent = true })
for i = 0, 9 do
    vim.api.nvim_set_keymap('n', '-m' .. i, "<cmd>lua vim.cmd('vs $MEMO_DIR/memo" .. i .. ".md')<CR>",
        { noremap = true, silent = true })
end

----------------------------------------------------------------------------------------------------------
-- Paste Image on Markdown
local paste_image = function()
    -- シェルスクリプトの出力を現在のバッファに挿入
    vim.cmd 'r! ~/.config/nvim/sh/paste_image.sh'
end
h.usercmd('PasteImage', paste_image)
h.nmap('<Leader>S', '<CMD>PasteImage<CR>')

----------------------------------------------------------------------------------------------------------
-- Toogle Term on TMUX
local toggle_term_on_tmux = function()
    vim.cmd 'r! ~/bin/tmux-popup.sh'
end
h.usercmd('ToggleTermOnTmux', toggle_term_on_tmux)
h.nmap('<c-j>', '<CMD>ToggleTermOnTmux<CR>')

----------------------------------------------------------------------------------------------------------
-- for Bash
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
-- for Markdown
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
