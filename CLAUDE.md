# CLAUDE.md

私用 kickstart.nvim。`$HOME/.config/nvim` へ symlink して使用する。

## 構成（コア）
- `init.lua` — エントリポイント。L30 `require('lazy').setup({...})`、L191 `{ import = 'custom.plugins' }`、末尾で `require 'options' / 'keymaps' / 'functions'` を読む
- `lua/options.lua` — vim オプション
- `lua/keymaps.lua` — キーマップ（`local h = require 'helper'`）
- `lua/functions.lua` — autocmd・関数（`local h = require 'helper'`）
- `lua/helper.lua` — keymaps/functions 共通ヘルパ
- `after/ftplugin/` — filetype 別設定

## 外部プラグイン（git repo から取得）
- `init.lua` L30 の lazy.setup 内 — kickstart 本体が定義
- `lua/custom/plugins/*.lua` — 1 ファイル 1 spec。各ファイルが git repo を指す lazy spec を `return`。L191 の import で一括読み込み。`*.bak` `*.old` は無効

## 自作プラグイン（本 repo 内に実装したコード）
- `lua/<name>.lua` — 純粋ロジック
- `plugin/<name>.lua` — コマンド登録（起動時に自動ロード）
- `lua/custom/plugins/<name>/` — ディレクトリ構成の自作モジュール
- `test/` — 自作ロジックのテスト。素の Lua アサーション（`nvim -l <spec>` で実行）

## 規約
- フォーマット: stylua（`column_width=160`, `indent_width=2`, シングルクォート優先, `no_call_parentheses=true`）
- プラグイン追加は `lua/custom/plugins/` に新規ファイルを置き lazy spec を return する
- `make clear` → `clear.sh`、`make commit` → `npx git-cz`
- `lazy-lock.json` は gitignore 対象
