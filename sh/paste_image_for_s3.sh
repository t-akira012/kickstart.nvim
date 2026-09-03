#!/bin/bash
# ref. https://reona.dev/posts/20200620
# Modified for S3 upload

# 使い方
# $ paste_image_for_s3.sh 元のマークダウンファイル名

# .envファイルの読み込み
if [ -f .env ]; then
  set -a
  # shellcheck source=/dev/null
  . ./.env
  set +a
fi

# 環境変数のチェック
if [ -z "$S3_BUCKET" ]; then
  echo "Error: S3_BUCKET is not set in .env" >&2
  exit 1
fi

if [ -z "$S3_ENDPOINT_URL" ]; then
  echo "Error: S3_ENDPOINT_URL is not set in .env" >&2
  exit 1
fi

# デフォルト値の設定
MD_FILENAME=$1
OPERATING_SYSTEM=$(uname)
RESULT=1

if [ "${OPERATING_SYSTEM}" = "Darwin" ]; then
  if ! type pngpaste > /dev/null 2>&1; then
    echo pngpaste: command not found >&2
    exit 1
  fi
  if ! type magick > /dev/null 2>&1 ; then
    echo magick: command not found >&2
    exit 1
  fi
fi
if [ "${XDG_SESSION_TYPE}" = "wayland" ]; then
  if ! type wl-paste > /dev/null 2>&1; then
    echo wl-paste: command not found >&2
    exit 1
  fi
fi

# AWS CLIの確認
if ! type aws > /dev/null 2>&1 ; then
  echo aws: command not found >&2
  exit 1
fi

# 一時ディレクトリを使用
TEMP_DIR=$(mktemp -d)
cleanup() {
  if [ -n "${TEMP_DIR}" ]; then
    if [ -d "${TEMP_DIR}" ]; then
      rm -rf "${TEMP_DIR}"
    fi
  fi
}
trap cleanup EXIT

gen_file_name() {
  IMAGE_NAME=${MD_FILENAME}${NUMBER}.png
  LOCAL_PATH=${TEMP_DIR}/${IMAGE_NAME}
  TIF_PATH=${TEMP_DIR}/${MD_FILENAME}${NUMBER}.tif
  S3_PATH=${IMAGE_NAME}
}

check_exists_s3() {
  # S3に同名のファイルが存在するかチェック
  gen_file_name
  NUMBER=0
  while aws s3 ls "s3://${S3_BUCKET}/${S3_PATH}" --endpoint-url "${S3_ENDPOINT_URL}" > /dev/null 2>&1; do
    NUMBER=$(( 1 + NUMBER ))
    gen_file_name
  done
}

check_exists_s3

if [ "${OPERATING_SYSTEM}" = "Darwin" ]; then
  # tifで出力後に、png変換
  pngpaste "${TIF_PATH}"
  RESULT=$?
  if [ "${RESULT}" -eq 0 ]; then
    magick "${TIF_PATH}" "${LOCAL_PATH}"
    RESULT=$?
  fi
fi
 
if [ "${XDG_SESSION_TYPE}" = "wayland" ]; then
  wl-paste --type image/png > "${LOCAL_PATH}"
  RESULT=$?
fi

# 画像が保存できた場合はS3にアップロード
if [ "${RESULT}" -eq 0 ]; then
  # S3にアップロード
  if aws s3 cp "${LOCAL_PATH}" "s3://${S3_BUCKET}/${S3_PATH}" --endpoint-url "${S3_ENDPOINT_URL}"; then
    # S3のURLを生成
    # エンドポイントURLから公開URLを生成
    if [ -n "$S3_PUBLIC_URL" ]; then
      # カスタム公開URLが設定されている場合
      S3_URL="${S3_PUBLIC_URL}/${S3_PATH}"
    else
      # エンドポイントURLから自動生成
      S3_URL="${S3_ENDPOINT_URL}/${S3_BUCKET}/${S3_PATH}"
    fi
    
    # Markdownの画像構文を出力
    MARKDOWN_IMAGE_SYNTAX="![]($S3_URL)"
    echo "${MARKDOWN_IMAGE_SYNTAX}"
  else
    echo "Failed to upload to S3" >&2
    exit 1
  fi
fi
