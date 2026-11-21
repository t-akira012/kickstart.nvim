# ADR 0002: SSH 接続元のクリップボード読み取りに接続名を使う

- 日付: 2026-11-21
- 状態: 採用

## 背景

SSH 接続中の Neovim は、接続元 Mac のクリップボードを読むために remote machine の `127.0.0.1:2222` からリバース転送経由で接続元の `pbpaste` を実行する。従来のスクリプトは IP アドレスとポートを直接指定していたため、SSH config にある接続元向けの認証設定を選択できず、接続元の SSH サーバーを有効にした後も公開鍵認証に失敗した。

## 決定

テキストと画像の読み取りスクリプトは SSH 接続名 `host-clipboard` を使う。remote machine の SSH config には、利用者が `HostName 127.0.0.1` と `Port 2222` を設定し、認証に必要な設定も利用者自身が管理する。スクリプトとリポジトリには鍵名や鍵のパスを書かない。

接続元から remote machine への SSH 接続では、`RemoteForward 2222 localhost:22` を使用する。転送先の `localhost:22` は接続元 Mac の SSH サーバーを指す。

## 理由と影響

接続先と認証設定を SSH config にまとめることで、スクリプトが利用者の鍵の選択に関与せずに接続元のクリップボードを読める。コピー側の tmux/OSC 52 と Windows 向けの読み取り経路は変更しない。画像の読み取りも同じ接続名を使うが、画像データでの動作確認は別途必要。

`ssh -T host-clipboard /usr/bin/true` と `sh/host_clipboard_paste.sh mac` の成功を remote machine で確認した。テキストの読み取りでは、クリップボードの内容は表示せず終了状態のみ確認した。
