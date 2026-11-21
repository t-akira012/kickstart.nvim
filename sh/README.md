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

## 備考

- `./paste_image_for_s3.sh` は未完成
