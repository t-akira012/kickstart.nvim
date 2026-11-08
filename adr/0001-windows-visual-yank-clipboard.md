# ADR 0001: Windows の Visual yank は `+` レジスタへコピーする

- 日付: 2026-11-08
- 状態: 採用

## 背景

Visual モードの `y` は選択範囲を yank した後、`pbcopy` を実行してホストのクリップボードへコピーする。Windows の `cmd.exe` から起動した Neovim でも `pbcopy` が実行され、コピー時に失敗する。

## 決定

Windows (`has('win32') == 1`) では yank 先レジスタの内容と種類を `+` レジスタへ設定する。Neovim のクリップボード連携を使い、外部の `pbcopy` を実行しない。その他の環境では `pbcopy` の処理を継続する。

## 理由と影響

`lua/options.lua` で `clipboard=unnamedplus` を設定済みであり、Windows でも `+` レジスタが OS クリップボードへの窓口になる。レジスタの種類も渡すことで、行単位の選択を含む yank の情報を保つ。明示したレジスタへの yank も、従来のホストクリップボードへのコピー動作を維持する。

Windows での実動作は Windows 上の Neovim で確認する必要がある。
