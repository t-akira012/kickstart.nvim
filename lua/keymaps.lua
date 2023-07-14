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

-- h.nmap("<C-b>", ":Ex<CR>")

h.nmap("q", "<nop>")
h.nmap("x", '"_x')
h.nmap("s", '"_s')
h.nmap("c", '"_c')
h.vmap("x", '"_x')
h.vmap("s", '"_s')
h.vmap("c", '"_c')

h.nmap("<Leader>z", ":res <CR>:vertical res<CR>")
h.nmap("<Leader>x", "<C-w>=")

-- h.nmap("<Leader>e", ":e<CR>")
-- h.nmap("<Leader>w", ":w<CR>")
-- h.nmap("<Leader>q", ":q<CR>")

h.nmap("<Leader>t", ":tabnew<CR>")
h.nmap("<Leader>s", ":new<CR>")
h.nmap("<Leader>v", ":vnew<CR>")

-- h.nmap("<Leader><Leader>", "<C-w>w")
-- h.nmap("<Leader>h", "<C-w>h")
-- h.nmap("<Leader>j", "<C-w>j")
-- h.nmap("<Leader>k", "<C-w>k")
-- h.nmap("<Leader>l", "<C-w>l")

h.imap("<C-r>", "<C-r><C-p>")
h.nmap("<C-h>", "<CMD>GBrowse<CR>")
-- カーソル下文字列を置換
-- http://miniman2011.blog55.fc2.com/blog-entry-295.html
-- https://vim-jp.org/vim-users-jp/2009/08/25/Hack-62.html
-- カーソル範囲にyankで置換
-- https://baqamore.hatenablog.com/entry/2016/07/07/201856
vim.cmd([[
  nnoremap <expr> RR ':%s ?\<' . expand('<cword>') . '\>?'
  vnoremap <expr> RR ':s ?\<' . expand('<cword>') . '\>?'
  vnoremap SS :s/
  xnoremap <expr> p 'pgv"'.v:register.'ygv<esc>'

  " add current date
  " iabbrev <expr> ddd strftime('%Y-%m-%d (%aaa)')
  iabbrev <expr> lll strftime('%-m/%d %a')
  iabbrev <expr> ddd strftime('%Y%m%d %a')
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
h.usercmd("GenerateWeeklyTodo", generate_weekly_todo)
local generate_weekly_head = function()

	for i = 0, 6 do
		local bufnr = vim.api.nvim_get_current_buf()
		local cursor = vim.api.nvim_win_get_cursor(0)
		local row = cursor[1]
		local day = vim.fn.strftime("%-m/%d %a", vim.fn.localtime() + i * 24 * 60 * 60)
		local str = ('### ' .. day)
		vim.api.nvim_buf_set_lines(bufnr, row - 1, row - 1, false, { str })
	end
end
h.usercmd("GenerateWeeklyHead", generate_weekly_head)

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
	local dir = '$HOME/Documents/doc/'
	vim.api.nvim_command(':vs' .. dir)
end
local create_new_daily_memo = function()
	local dir = '$HOME/Documents/doc/daily/'
	local today = vim.fn.strftime("%Y-%m-%d", vim.fn.localtime())
	vim.api.nvim_command(':vs' .. dir .. today .. '.md')
end
local open_memo = function()
	local file = '$HOME/Documents/doc/bucket-list.md'
	vim.api.nvim_command(':vs' .. file)
end
local open_flow = function()
	local file = '$HOME/Documents/doc/daily/flow.md'
	vim.api.nvim_command(':vs' .. file)
end

h.usercmd("Doc", open_document_dir)
h.usercmd("Docnew", create_new_daily_memo)
h.usercmd("Docflow", open_flow)
h.usercmd("Docmemo", open_memo)
h.nmap('--', '<CMD>Doc<CR>')
h.nmap('-=', '<CMD>Docnew<CR>')
h.nmap('==', '<CMD>Docmemo<CR>')

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
		inoremap <buffer>       <C-l> <C-o>:GenerateWeeklyTodo<CR>
		inoremap <buffer>       <C-g> <C-o>:GenerateWeeklyHead<CR>
		inoremap <expr><buffer> <C-d> strftime('%-m/%-d %a')
		inoremap <expr><buffer> <C-t> strftime('%H:%M')
		abbr <buffer> tt - [ ]
		]])
	end
})

return {}
