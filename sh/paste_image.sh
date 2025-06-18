#!/bin/bash
# 使い方
# $ paste_image.sh 元のマークダウンファイル名

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# 今のカレントディレクトリをチェックして、minioフラグを立てる
FOR_MINIO_UPLOAD=0
if ls -a "$(git -C $PWD rev-parse --show-toplevel 2>/dev/null)"/.obsidian.minio >/dev/null 2>&1; then
  FOR_MINIO_UPLOAD=1
fi

# FOR_S3_UPLOADの値に応じて適切なスクリプトを呼び出す
if [ "$FOR_MINIO_UPLOAD" = 1 ]; then
  # S3アップロード用スクリプトを実行
  exec "$SCRIPT_DIR/paste_image_for_minio.sh" "$@"
else
  # ローカル保存用スクリプトを実行
  exec "$SCRIPT_DIR/paste_image_for_local.sh" "$@"
fi
