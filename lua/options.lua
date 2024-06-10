local vim = vim
local opt = vim.opt

vim.cmd 'autocmd!'

-- shell
-- opt.shell = "zsh"

-- Decrease update time
opt.updatetime = 250
opt.timeout = true
opt.timeoutlen = 500

opt.autochdir = true

-- https://github.com/willelz/nvim-lua-guide-ja/blob/master/README.ja.md
-- 検索ヒット件数を表示
opt.shortmess:remove { S = true }
-- Sync clipboard between OS and Neovim.
--  Remove this option if you want your OS clipboard to remain independent.
--  See `:help 'clipboard'`
opt.clipboard:append { 'unnamedplus' }

-- nobell
opt.belloff = 'all'
-- bufferを切り替える時に編集中ファイルの保存を警告しない
opt.hidden = true

-- speedup
opt.ttyfast = true
opt.relativenumber = false

-- nobackup, noswap
opt.undofile = false
opt.backup = false
opt.backupskip = { '/tmp/*', '/private/tmp/*' }
opt.swapfile = false

-- 色設定
-- set printfont="HackGenNerd:h11"

if os.getenv 'TERM_COLOR_MODE' == 'LIGHT' then
    opt.background = 'light'
    vim.cmd.colorscheme(os.getenv 'NVIM_COLOR_LIGHT')
else
    opt.background = 'dark'
    vim.cmd [[ let g:material_style='oceanic' ]]
    vim.cmd.colorscheme(os.getenv 'NVIM_COLOR_DARK')
end

-- ウィンドウ設定
-- 新規windowは右, 下に開く
opt.splitright = true
opt.splitbelow = true
-- ステータスラインを常に表示
opt.laststatus = 2
-- 行番号表示
vim.wo.number = true
-- Keep signcolumn on by default
vim.wo.signcolumn = 'yes'
-- カーソル位置を表示
opt.ruler = true
-- Enable Always cursor line highlight
opt.cursorline = true
-- 行末の1文字先までカーソルを移動できるように
opt.virtualedit = 'onemore'
-- タイトルをウィンドウ枠に表示
opt.title = true
-- 上下のスクロールに余裕を持たせる
opt.scrolloff = 10
-- Use True color syntax highlight
opt.termguicolors = true
-- floatwindow透過
opt.winblend = 0
-- 補完popup
opt.wildoptions = 'pum'
-- 補完window透過
opt.pumblend = 0
-- https://note.com/yasukotelin/n/na87dc604e042
vim.o.completeopt = 'menuone,noselect,noinsert'
-- マウスを使う
opt.mouse = 'a'
-- cmd行を表示
opt.showcmd = true
opt.cmdheight = 1

-- IME
-- 曖昧幅文字を全て全角
-- opt.ambiwidth = "double"
-- 挿入モードでのIME (使えない->,2:IMEモードを抜けると自動的にIMEをオフ)
opt.iminsert = 0
-- 検索モードでのIME
opt.imsearch = 0

-- undo
opt.undolevels = 300

-- 不可視文字を可視化
opt.list = true
-- opt.listchars:append({ tab = "» ", extends = "»", precedes = "«", trail = " " })
-- opt.listchars:append({ tab = "‥‥‥", eol = ".", extends = "»", precedes = "«", trail = " " })
opt.listchars:append { eol = '↲', extends = '»', precedes = '«', trail = ' ' }

-- ダブルクォート非表示対策 ( indentLine 対策 )
opt.conceallevel = 0

-- indent 系
-- オートインデント
opt.autoindent = true
-- スマートインデント(C like indent)
opt.smartindent = true
-- 括弧入力時の対応する括弧を表示
opt.showmatch = true
-- 対応括弧に<と>のペアを追加
opt.matchpairs = '(:),{:},[:],<:>'
-- 行の折り返しでインデントを考慮
opt.breakindent = true
-- 長い行を改行して表示
opt.wrap = true
-- 改行を超えてbackspaceを働かせる
opt.backspace = { 'start', 'eol', 'indent' }

-- Tab系
-- expandtab  Tab文字を半角スペースにする
opt.expandtab = true
-- tabstop    行頭以外のTab文字の表示幅（スペースいくつ分）
opt.tabstop = 2
-- shiftwidth 行頭でのTab文字の表示幅
opt.shiftwidth = 2
-- Tab in front of line inserts blanks
opt.smarttab = true

-- 置換系
-- interactive 置換
opt.inccommand = 'split'

-- 検索系
-- インクリメンタルサーチ
opt.incsearch = true
-- Set highlight on search
opt.hlsearch = true
-- 小文字のときのみ大文字小文字を無視
opt.ignorecase = true
opt.smartcase = true
-- 検索時に最後まで行ったら最初に戻る
opt.wrapscan = false
-- Finding files - Search down into subfolders
opt.path:append { '**' }
opt.wildignore:append { '*/node_modules/*' }

-- paste mode を自動で解除
vim.api.nvim_create_autocmd('InsertLeave', {
    pattern = '*',
    command = 'set nopaste',
})
-- paste mode を自動で解除
-- インサートモード時はハイライトを除去
vim.api.nvim_create_autocmd('InsertEnter', { command = 'set nohlsearch' })
vim.api.nvim_create_autocmd('InsertLeave', { command = 'set hlsearch' })

-- Add asterisks in block comments
opt.formatoptions:append { 'r' }

--set wildmode=list:longest

-- lsp
vim.lsp.handlers['textDocument/publishDiagnostics'] = vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics,
    { virtual_text = false })

-- other
vim.cmd [[
    " 不可視文字、インデント
    highlight NonText cterm=NONE guifg=#232323 gui=NONE
    highlight SpecialKey cterm=NONE guifg=#232323 gui=NONE

    " Browse Command
    command! -nargs=1 Browse silent exec '!open "<args>"'
]]

return {}
