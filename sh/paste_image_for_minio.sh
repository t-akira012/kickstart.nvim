#!/bin/bash
# ref. https://reona.dev/posts/20200620
# Modified for MinIO upload using mc command

# 使い方
# $ paste_image_for_minio.sh 元のマークダウンファイル名

SCRIPT_DIR=$(cd "$(dirname "$0")" || exit 1; pwd)
# shellcheck source=/dev/null
. "${SCRIPT_DIR}/.env"

# 環境変数のチェック
if [ -z "$MINIO_BUCKET" ]; then
  echo "Error: MINIO_BUCKET is not set in .env" >&2
  exit 1
fi

if [ -z "$MINIO_ALIAS" ]; then
  echo "Error: MINIO_ALIAS is not set in .env" >&2
  exit 1
fi

if [ -z "$MINIO_PUBLIC_URL" ]; then
  echo "Error: MINIO_PUBLIC_URL is not set in .env" >&2
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

# mc コマンドの確認
if ! type mc > /dev/null 2>&1 ; then
  echo mc: command not found >&2
  echo '$ brew install minio/stable/mc'
  exit 1
fi

# alias未設定なら設定する
if ! mc alias list | rg "${MINIO_ALIAS}" >/dev/null 2>&1; then
  # shellcheck disable=SC2153
  mc alias set "${MINIO_ALIAS}" "${MINIO_INTERNAL_URL}" --insecure "${MINIO_USER}" "${MINIO_PASS}"
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
  MINIO_PATH=${MINIO_ALIAS}/${MINIO_BUCKET}/${IMAGE_NAME}
}

check_exists_minio() {
  # MinIOに同名のファイルが存在するかチェック
  gen_file_name
  NUMBER=0
  while mc stat "${MINIO_PATH}" > /dev/null 2>&1; do
    NUMBER=$(( 1 + NUMBER ))
    gen_file_name
  done
}

check_exists_minio

if [ "${OPERATING_SYSTEM}" = "Darwin" ]; then
  # tifで出力後に、png変換
  pngpaste "${LOCAL_PATH}.tif"
  RESULT=$?
  if [ "${RESULT}" -eq 0 ]; then
    magick "${LOCAL_PATH}.tif" "${LOCAL_PATH}"
    RESULT=$?
  fi
fi
 
if [ "${XDG_SESSION_TYPE}" = "wayland" ]; then
  wl-paste --type image/png > "${LOCAL_PATH}"
  RESULT=$?
fi

# 画像が保存できた場合はMinIOにアップロード
if [ "${RESULT}" -eq 0 ]; then
  # MinIOにアップロード
  if mc cp "${LOCAL_PATH}" "${MINIO_PATH}"; then
    MINIO_URL="${MINIO_PUBLIC_URL}/${MINIO_BUCKET}/${IMAGE_NAME}"
    
    # Markdownの画像構文を出力
    MARKDOWN_IMAGE_SYNTAX="![]($MINIO_URL)"
    echo "${MARKDOWN_IMAGE_SYNTAX}"
  else
    echo "Failed to upload to MinIO" >&2
    exit 1
  fi
fi
