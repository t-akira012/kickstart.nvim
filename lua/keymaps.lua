local vim = vim
local h = require('helper')

vim.g.mapleader = " "

-- Keymaps for better default experience
-- See `:help vim.keymap.set()`
vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })

-- Remap for dealing with word wrap
vim.keymap.set('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

h.nmap(";", ":")
h.nmap("'", ";")
h.imap("jj", "<ESC>")

h.nmap("q", "<nop>")
h.nmap("x", '"_x')
h.nmap("s", '"_s')
h.nmap("c", '"_c')
h.vmap("x", '"_x')
h.vmap("s", '"_s')
h.vmap("c", '"_c')

h.nmap("<Leader>z", ":res <CR>:vertical res<CR>")
h.nmap("<Leader>x", "<C-w>=")

h.nmap("<Leader>e", ":e<CR>")
h.nmap("<Leader>w", ":w<CR>")
h.nmap("<Leader>q", ":q<CR>")

h.nmap("<Leader>t", ":tabnew<CR>")
h.nmap("<Leader>s", ":new<CR>")
h.nmap("<Leader>v", ":vnew<CR>")

-- h.nmap("<Leader><Leader>", "<C-w>w")
h.nmap("<Leader>h", "<C-w>h")
h.nmap("<Leader>j", "<C-w>j")
h.nmap("<Leader>k", "<C-w>k")
h.nmap("<Leader>l", "<C-w>l")

h.imap("<C-r>", "<C-r><C-p>")
h.nmap("<Leader>H", "<CMD>GBrowse<CR>")

-- h.nmap("gb", ":vertical wincmd f<CR>")
h.nmap("gf", ":vertical wincmd f<CR>")

-- ESC で terminal を抜ける
h.tmap("<esc>", "<C-\\><C-n>")
-- カーソル下文字列を置換
-- http://miniman2011.blog55.fc2.com/blog-entry-295.html
-- https://vim-jp.org/vim-users-jp/2009/08/25/Hack-62.html
-- カーソル範囲にyankで置換
-- https://baqamore.hatenablog.com/entry/2016/07/07/201856
vim.cmd([[
  nnoremap <expr> gs ':%s/' . expand('<cword>') . '/'
  vnoremap <expr> gs ':s/' . expand('<cword>') . '/'
  xnoremap <expr> p 'pgv"'.v:register.'ygv<esc>'


  " add current date
  inoreabbrev ddb <C-R>=substitute(system("date -v-1d '+\%Y-\%m-\%d (\%a)'"), '\n', '', 'g')<CR>
  inoreabbrev <expr> ddt strftime('%Y-%m-%d (%a) %H:%M')
  inoreabbrev <expr> ddd strftime('%Y-%m-%d (%a)')
  inoreabbrev dda <C-R>=substitute(system("date -v+1d '+\%Y-\%m-\%d (\%a)'"), '\n', '', 'g')<CR>
  inoreabbrev <expr> lll strftime('%-m/%d %a')
  " iabbrev <expr> ddd strftime('%Y%m%d %a')
  iabbrev <expr> ttt strftime('%H:%M')
]])

local generate_weekly_todo = function()
    for i = 0, 6 do
        local bufnr = vim.api.nvim_get_current_buf()
        local cursor = vim.api.nvim_win_get_cursor(0)
        local row = cursor[1]
        local day = vim.fn.strftime("%-m/%d %a", vim.fn.localtime() + i * 24 * 60 * 60)
        local str = ('- [ ] ' .. day)
        vim.api.nvim_buf_set_lines(bufnr, row - 1, row - 1, false, { str })
    end
end
h.usercmd("AddWeeklyTodo", generate_weekly_todo)
local generate_weekly_head = function()
    for i = 0, 6 do
        local bufnr = vim.api.nvim_get_current_buf()
        local cursor = vim.api.nvim_win_get_cursor(0)
        local row = cursor[1]
        local day = vim.fn.strftime("%-m/%d %a", vim.fn.localtime() + i * 24 * 60 * 60)
        local str = ('# ' .. day)
        vim.api.nvim_buf_set_lines(bufnr, row - 1, row - 1, false, { str })
    end
end
h.usercmd("AddWeeklyHead", generate_weekly_head)

local change_current_directory = function()
    vim.cmd(":lcd %:h")
    vim.cmd(":pwd")
end

local show_file_path = function()
    local var = vim.fn.expand("%:p")
    print("Filepath: " .. var)
end

local show_current_dir = function()
    local var = vim.fn.getcwd()
    print("PWD: " .. var)
end

h.usercmd("ChangeCurrentDir", change_current_directory)
h.usercmd("Filepath", show_file_path)
h.usercmd("Pwd", show_current_dir)

-- doc

local open_document_dir = function()
    local dir = '$MEMO_DIR/'
    vim.api.nvim_command(':vs' .. dir)
end
h.usercmd("Doc", open_document_dir)

local open_home_memo = function()
    local dir = '$MEMO_DIR/'
    vim.api.nvim_command(':vs' .. dir .. 'home.md')
end
h.usercmd("DocOpenHomeMemo", open_home_memo)

local open_flow_memo = function()
    local dir = '$MEMO_DIR/'
    vim.api.nvim_command(':vs' .. dir .. 'flow.md')
end
h.usercmd("DocOpenFlowMemo", open_flow_memo)

local create_new_daily_memo = function()
    local dir = '$MEMO_DIR/daily/'
    local today = vim.fn.strftime("%Y-%m-%d", vim.fn.localtime())
    vim.api.nvim_command(':vs' .. dir .. today .. '.md')
end
h.usercmd("DocOpenDailyMemo", create_new_daily_memo)
local create_new_weekly_memo = function()
    local dir = '$MEMO_DIR/weekly/'
    local year = vim.fn.strftime("%Y", vim.fn.localtime())
    local week_num = vim.fn.strftime("%W", vim.fn.localtime())
    vim.api.nvim_command(':vs' .. dir .. year .. '-W' .. week_num .. '.md')
end
h.usercmd("DocOpenWeeklyMemo", create_new_weekly_memo)

h.nmap('--', '<CMD>DocOpenFlowMemo<CR>')
h.nmap('-=', '<CMD>DocOpenHomeMemo<CR>')
h.nmap('-d', '<CMD>DocOpenDailyMemo<CR>')
h.nmap('-w', '<CMD>DocOpenWeeklyMemo<CR>')


-- メモファイルを開く関数
-- '-m'に続く1桁の数字のためのマッピングを設定
vim.api.nvim_set_keymap('n', '-m', "<cmd>lua vim.cmd('vs $MEMO_DIR/memo.md')<CR>",
    { noremap = true, silent = true })
for i = 0, 9 do
    vim.api.nvim_set_keymap('n', '-m' .. i, "<cmd>lua vim.cmd('vs $MEMO_DIR/memo" .. i .. ".md')<CR>",
        { noremap = true, silent = true })
end

-- for Bash
vim.api.nvim_create_augroup('sh', { clear = true })
vim.api.nvim_create_autocmd('FileType', {
    group = 'sh',
    pattern = 'sh',
    callback = function()
        vim.cmd([[
		abbr <buffer> env! #!/usr/bin/env
		]])
    end
})
-- for Markdown
vim.api.nvim_create_augroup('markdown', { clear = true })
vim.api.nvim_create_autocmd('FileType', {
    group = 'markdown',
    pattern = 'markdown',
    callback = function()
        vim.cmd([[
		inoremap <expr><buffer> <C-d> strftime('%-m/%-d %a')
		inoremap <expr><buffer> <C-t> strftime('%H:%M')
		abbr <buffer> tt - [ ]
		]])
    end
})

return {}
