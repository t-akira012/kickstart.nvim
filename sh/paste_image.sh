#!/bin/bash
# 使い方
# $ paste_image.sh 元のマークダウンファイル名 DIR

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
DIR_NAME=$2

# 今のカレントディレクトリをチェックして、minioフラグを立てる
FOR_MINIO_UPLOAD=0
MINIO_FILE="$(git -C $DIR_NAME rev-parse --show-toplevel 2>/dev/null)"/.obsidian.minio
if ls -a  >/dev/null 2>&1; then
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
