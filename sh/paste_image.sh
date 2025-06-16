#!/bin/bash
# Wrapper script for paste_image_for_local.sh and paste_image_for_s3.sh
# 使い方
# $ paste_image.sh 元のマークダウンファイル名

# スクリプトのディレクトリを取得
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# .envファイルが存在する場合は読み込む
if [ -f .env ]; then
  export $(cat .env | grep -v '^#' | xargs)
fi

# FOR_S3_UPLOADの値に応じて適切なスクリプトを呼び出す
if [ "$FOR_S3_UPLOAD" = "true" ] || [ "$FOR_S3_UPLOAD" = "1" ]; then
  # S3アップロード用スクリプトを実行
  exec "$SCRIPT_DIR/paste_image_for_s3.sh" "$@"
else
  # ローカル保存用スクリプトを実行
  exec "$SCRIPT_DIR/paste_image_for_local.sh" "$@"
fi