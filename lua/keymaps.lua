local vim = vim
local h = require('helper')

vim.g.mapleader = " "

h.nmap(";", ":")
h.nmap("j", "gj")
h.nmap("k", "gk")
h.imap("jj", "<ESC>")

h.nmap("<C-b>", ":Ex<CR>")

h.nmap("q", "<nop>")
h.nmap("x", '"_x')
h.nmap("s", '"_s')
h.nmap("c", '"_c')
h.vmap("x", '"_x')
h.vmap("s", '"_s')
h.vmap("c", '"_c')

-- 選択文字列を置換
-- https://www.pandanoir.info/entry/2018/01/13/150000

h.vmap("<Leader>gg", ":ToGithub<cr>")
h.nmap("<Leader>gg", ":ToGithub<cr>")
h.nmap("<Leader>b", ":! ")
h.nmap("<Leader>-", ":split<CR>")
h.nmap("<Leader>\\", ":vsplit<CR>")
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

h.nmap("gb", ":ToGithub<CR>")

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
]])

-- LSP
-- local bufopts = { noremap = true, silent = true, buffer = bufnr }
-- -- 定義ジャンプ
-- vim.keymap.set("n", "gd", vim.lsp.buf.definition, bufopts)
-- -- Code hint
-- vim.keymap.set("n", "K", vim.lsp.buf.hover, bufopts)
-- -- code format
-- vim.keymap.set("n", "gf", vim.lsp.buf.format)
-- -- カーソル下の変数をコード内で参照している箇所を一覧表示
-- vim.keymap.set("n", "gr", vim.lsp.buf.references)
-- -- 変数リネーム
-- vim.keymap.set("n", "gn", vim.lsp.buf.rename)

-- func

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

-- cmd

-- vim.cmd([[
--   autocmd BufNewFile,BufRead Dockerfile* set filetype=dockerfile
--   autocmd BufNewFile,BufRead docker-compose.yml,docker-compose.yaml set filetype=yaml.docker-compose
--   autocmd BufNewFile,BufRead */cloudformation/*.yaml,'/cf*.yaml set filetype=yaml.cloudformation
--   autocmd BufNewFile,BufRead *.go setlocal noexpandtab tabstop=4 shiftwidth=4 softtabstop=4
--
--
--   abbrev env! #!/usr/bin/env
--   command! Reload :source $HOME/.config/nvim/init.lua
--
--   let g:docdir="$HOME/Dropbox/doc"
--
--   function VimCheat()
--     let l:sheet = "$HOME/.config/nvim/builtin-vim-cheat-sheet"
--     execute ":vs ".l:sheet
--   endfunction
--   command! VimCheat call VimCheat()
--
--   function MarkdownCmd()
--     set syntax=markdown
--
--     function SaveTodayFile(title)
--       let b:today=strftime('%Y-%m-%d')
--       execute ":f ".g:docdir."/".b:today.a:title.".md"
--     endfunction
--
--     function ToggleCheckbox()
--         let l:curs = winsaveview()
--         let l:line = getline('.')
--         if l:line =~ '\-\s\[\s\]'
--           let l:result = substitute(l:line, '-\s\[\s\]', '- [x]', '')
--           call setline('.', l:result)
--           call winrestview(l:curs)
--         elseif l:line =~ '\-\s\[x\]'
--           let l:result = substitute(l:line, '-\s\[x\]', '- [ ]', '')
--           call setline('.', l:result)
--           call winrestview(l:curs)
--         else
--           let l:result = '- [ ] '.l:line
--           call setline('.', l:result)
--           let pos = getpos(".")
--           " let pos[1] += 0
--           let pos[2] += 7
--           call setpos(".", pos)
--         end
--     endfunction
--
--     nnoremap <Leader>O :call SaveTodayFile("_")<left><left>
--     nnoremap <Leader>o :call ToggleCheckbox()<CR>
--     nnoremap <Leader>T <ESC>i<C-R>=g:today<CR><ESC>
--   endfunction
--
--   autocmd BufRead,BufNewFile *.md :call MarkdownCmd()
--
--   " doc
--   if getcwd() == expand(g:docdir)
--
--     nnoremap <Leader>D :! $HOME/bin/doc sync
--     inoremap <C-T> <C-R>=g:today<CR>
--   fi
-- ]])
