local vim = vim
local h = require 'helper'

vim.g.mapleader = ' '

-- Keymaps for better default experience
-- See `:help vim.keymap.set()`
vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })

-- Remap for dealing with word wrap
vim.keymap.set('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

h.nmap(';', ':')
h.nmap("'", ';')
h.imap('jj', '<ESC>')

h.nmap('q', '<nop>')
h.nmap('x', '"_x')
h.nmap('s', '"_s')
h.nmap('c', '"_c')
h.vmap('x', '"_x')
h.vmap('s', '"_s')
h.vmap('c', '"_c')

h.nmap('<Leader>z', ':res <CR>:vertical res<CR>')
h.nmap('<Leader>x', '<C-w>=')

h.nmap('<Leader>e', ':e<CR>')
h.nmap('<Leader>w', ':w<CR>')
h.nmap('<Leader>q', ':q<CR>')

h.nmap('<Leader>t', ':tabnew<CR>')
-- h.nmap("<Leader>s", ":new<CR>")
h.nmap('<Leader>v', ':vnew<CR>')

-- h.nmap("<Leader><Leader>", "<C-w>w")
h.nmap('<Leader>h', '<C-w>h')
h.nmap('<Leader>j', '<C-w>j')
h.nmap('<Leader>k', '<C-w>k')
h.nmap('<Leader>l', '<C-w>l')

h.imap('<C-r>', '<C-r><C-p>')
h.nmap('<Leader>H', '<CMD>GBrowse<CR>')

-- h.nmap("gb", ":vertical wincmd f<CR>")
h.nmap('gf', ':vertical wincmd f<CR>')

-- ESC で terminal を抜ける
h.tmap('<esc>', '<C-\\><C-n>')
-- カーソル下文字列を置換
-- http://miniman2011.blog55.fc2.com/blog-entry-295.html
-- https://vim-jp.org/vim-users-jp/2009/08/25/Hack-62.html
-- カーソル範囲にyankで置換
-- https://baqamore.hatenablog.com/entry/2016/07/07/201856
vim.cmd [[
  nnoremap <expr> gs ':%s/' . expand('<cword>') . '/'
  vnoremap <expr> gs ':s/' . expand('<cword>') . '/'
  xnoremap <expr> p 'pgv"'.v:register.'ygv<esc>'

  " 発音アクセント辞典
  nnoremap <silent> ma :silent !open 'mkdictionaries:///?category=ja-accent&text=<C-r>=expand("<cword>")<CR>' > /dev/null 2>&1 &<CR>:redraw!<CR>
  nnoremap <silent> mw :silent !open 'mkdictionaries:///?category=ja-accent&text=<C-r>=expand("<cWORD>")<CR>' > /dev/null 2>&1 &<CR>:redraw!<CR>
  vnoremap <silent> ma "zy:silent !open 'mkdictionaries:///?category=ja-accent&text=<C-r>=@z<CR>' > /dev/null 2>&1 &<CR>:redraw!<CR>

  " add current date
  inoreabbrev ddb <C-R>=substitute(system("date -v-1d '+\%Y-\%m-\%d (\%a)'"), '\n', '', 'g')<CR>
  inoreabbrev <expr> aaa strftime('# %Y-%m-%d (%a) %H:%M')
  inoreabbrev <expr> ddd strftime('%Y-%m-%d (%a)')
  inoreabbrev dda <C-R>=substitute(system("date -v+1d '+\%Y-\%m-\%d (\%a)'"), '\n', '', 'g')<CR>
  inoreabbrev <expr> lll strftime('%-m/%d %a')
  " iabbrev <expr> ddd strftime('%Y%m%d %a')
  iabbrev <expr> ttt strftime('%H:%M')

  " インデント増減
  inoremap <M-.> <C-O>>><C-O>A
  inoremap <M-,> <C-O><<<C-O>A

  " emacs like keybind
  nnoremap <C-a> 0i
  nnoremap <C-e> $a
  inoremap <C-d> <delete>
  inoremap <C-f> <right>
  inoremap <C-b> <left>
  inoremap <C-k> <C-O>D<C-O>i
  inoremap <C-a> <C-O>0<C-O>i
  inoremap <C-e> <C-O>$<C-O>a

  " Gbrowse to GBrowse
  command! -bar -bang -range=-1 -nargs=* -complete=customlist,fugitive#CompleteObject Gbrowse
        \ exe 'GBrowse ' . <q-args>
]]

return {}
