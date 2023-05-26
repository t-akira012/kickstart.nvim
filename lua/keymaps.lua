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
h.imap("jj", "<ESC>")

h.nmap("<C-b>", ":Ex<CR>")

h.nmap("q", "<nop>")
h.nmap("x", '"_x')
h.nmap("s", '"_s')
h.nmap("c", '"_c')
h.vmap("x", '"_x')
h.vmap("s", '"_s')
h.vmap("c", '"_c')

h.nmap("<Leader>b", ":! ")
h.nmap("<Leader>-", ":split<CR>")
h.nmap("<Leader>\\", ":vsplit<CR>")
h.nmap("<Leader>e", ":e<CR>")
h.nmap("<Leader>w", ":w<CR>")
h.nmap("<Leader>q", ":q<CR>")
h.nmap("<Leader>s", ":new<CR>")
h.nmap("<Leader>v", ":vnew<CR>")
h.nmap("<Leader>z", ":res <CR>:vertical res<CR>")
h.nmap("<Leader>Z", "<C-w>=")
h.nmap("<Leader>x", "<C-w>=")
h.nmap("<Leader>h", "<C-w>h")
h.nmap("<Leader>j", "<C-w>j")
h.nmap("<Leader>k", "<C-w>k")
h.nmap("<Leader>l", "<C-w>l")
h.nmap("<Leader><Leader>", "<C-w>w")
h.imap("<C-r>", "<C-r><C-p>")

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

  ab env! #!/usr/bin/env
  ab tt - [ ]
]])

local change_current_directory = function()
	vim.cmd(":lcd %:h")
	vim.cmd(":pwd")
end

local show_file_path = function()
	local var = vim.fn.getcwd()
	print("file_path: " .. var)
end

local show_current_dir = function()
	local var = vim.fn.expand("%:p")
	print("file_path: " .. var)
end

h.usercmd("Cd", change_current_directory)
h.usercmd("Pwd", show_current_dir)
h.usercmd("Filepath", show_file_path)

return {}
