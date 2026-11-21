# sh

- nvimから呼び出すシェルスクリプト群

## あるもの

- `./paste_image.sh`: nvimのエディタ内部から、`Ctrl-v` で画像を貼り付けするだけのスクリプト。local/minio/s3向けに分岐

## SSH 接続元のクリップボード

Mac から SSH 接続している場合、テキストと画像の読み取りは SSH の `host-clipboard` 接続先を使う。remote machine 側の `~/.ssh/config` に、接続元へ戻る次の設定を利用者が追加する。認証に使う鍵は利用者が SSH config で指定する。

```sshconfig
Host host-clipboard
  HostName 127.0.0.1
  Port 2222
```

接続元から remote machine への SSH 接続には、`RemoteForward 2222 localhost:22` が必要。設定後、remote machine で `ssh -T host-clipboard /usr/bin/true` を実行して接続を確認する。

tmux で接続元ごとの `p` / `P` を Neovim に渡す設定では、Mac 側の `p` / `P` に `F13` / `F15`、Windows 側に `F14` / `F16` を送る。Neovim は通常・Visual モードでは接続元のクリップボードから貼り付け、挿入モードでは文字 `p` / `P` を入力する。`Alt-p` は端末で `Esc` と `p` に分かれ、挿入モードを抜けて貼り付けが起きるため使わない。

## 備考

- `./paste_image_for_s3.sh` は未完成
