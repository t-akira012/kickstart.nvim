#!/usr/bin/env bash
# kickstart.nvim クリーンインストールスクリプト
# Neovim 関連キャッシュを全消去し、外部依存をインストールしてから検証する。

set -eu

clear_nvim_cache() {
  # Neovim の state/share/cache を全消去。次回起動時に lazy.nvim がプラグインを再導入する。
  rm -rf ~/.local/state/nvim/ ~/.local/share/nvim/ ~/.cache/nvim/
}

ensure_treesitter_cache_dir() {
  # tree-sitter CLI はロックファイル親ディレクトリを自動作成しない不具合がある。
  # parser ビルドが ENOENT で失敗するのを防ぐため事前作成する。
  mkdir -p ~/.cache/tree-sitter/lock
}

install_node_via_fnm() {
  # fnm で最新の Node を導入し、有効化する。
  # Mason 経由で vtsls を入れるため npm が PATH 上に必要となる。
  local latest_node_version
  latest_node_version=$(fnm ls-remote | tail -n 1)
  fnm install ${latest_node_version}
  fnm use ${latest_node_version}
}

install_python_formatters_via_uv() {
  # conform.nvim から呼ばれる Python フォーマッタを uv tool install で導入する。
  # mason-conform からは ignore_install 設定で除外済みのため、外部管理で完結する。
  uv tool install black
  uv tool install isort
  # PyPI パッケージ名は shandy-sqlfmt、実行コマンドは sqlfmt。
  uv tool install shandy-sqlfmt
}

check_command() {
  # 引数のコマンドが PATH 上に存在するか検査し、結果を標準出力に表示する。
  local command_name=${1}
  if command -v ${command_name} >/dev/null; then
    echo "[OK] ${command_name}"
  else
    echo "[NG] ${command_name} not found in PATH"
  fi
}

verify_runtime_deps() {
  # Node バージョン管理本体
  check_command fnm
  # Mason 経由 vtsls 導入時に必要
  check_command npm
  # tree-sitter-manager.nvim が parser ビルドのため直接呼び出す
  check_command tree-sitter
  # Python フォーマッタ管理基盤
  check_command uv
  # conform.nvim から呼び出される Python フォーマッタ群
  check_command black
  check_command isort
  check_command sqlfmt
}

main() {
  clear_nvim_cache
  ensure_treesitter_cache_dir
  install_node_via_fnm
  install_python_formatters_via_uv
  verify_runtime_deps
}

main
