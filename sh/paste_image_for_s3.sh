#!/bin/bash
# ref. https://reona.dev/posts/20200620
# Modified for S3 upload

# 使い方
# $ paste_image_for_s3.sh 元のマークダウンファイル名

# .envファイルの読み込み
if [ -f .env ]; then
  export $(cat .env | grep -v '^#' | xargs)
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
MD_FILENAME=$*

if [[ $(uname) == "Darwin" ]]; then 
  if ! type pbpaste > /dev/null 2>&1 ; then
    echo pngpaste: command not found >&2
    exit 1
  fi
  if ! type magick > /dev/null 2>&1 ; then
    echo magick: command not found >&2
    exit 1
  fi
fi
if [[ $XDG_SESSION_TYPE == "wayland" ]]; then 
  if ! type wl-paste > /dev/null 2>&1 ; then
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
trap "rm -rf $TEMP_DIR" EXIT

gen_file_name(){
  IMAGE_NAME=${MD_FILENAME}${NUMBER}.png
  LOCAL_PATH=${TEMP_DIR}/${IMAGE_NAME}
  S3_PATH=${IMAGE_NAME}
}

check_exists_s3(){
  # S3に同名のファイルが存在するかチェック
  gen_file_name
  NUMBER=0
  while aws s3 ls s3://${S3_BUCKET}/${S3_PATH} --endpoint-url ${S3_ENDPOINT_URL} > /dev/null 2>&1; do
    NUMBER=$(( 1 + $NUMBER ))
    gen_file_name
  done
}

check_exists_s3

if [[ $(uname) == "Darwin" ]]; then 
  # tifで出力後に、png変換
  pngpaste ${LOCAL_PATH%.png}.tif && \
      magick ${LOCAL_PATH%.png}.tif $LOCAL_PATH
  RESULT=$?
fi
 
if [[ $XDG_SESSION_TYPE == "wayland" ]]; then 
  wl-paste --type image/png > $LOCAL_PATH
  RESULT=$?
fi

# 画像が保存できた場合はS3にアップロード
if [ $RESULT = 0 ]; then
  # S3にアップロード
  aws s3 cp $LOCAL_PATH s3://${S3_BUCKET}/${S3_PATH} --endpoint-url ${S3_ENDPOINT_URL} > /dev/null
  
  if [ $? = 0 ]; then
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
    echo $MARKDOWN_IMAGE_SYNTAX
  else
    echo "Failed to upload to S3" >&2
    exit 1
  fi
fi
