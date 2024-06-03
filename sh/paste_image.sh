#!/bin/bash
# ref. https://reona.dev/posts/20200620
 
if ! type pbpaste > /dev/null 2>&1 ; then
  echo pngpaste: command not found >&2
  exit 1
fi
if ! type convert > /dev/null 2>&1 ; then
  echo convert: command not found >&2
  exit 1
fi
 
IMAGE_DIR=images/
 
if [[ ! -d $IMAGE_DIR ]]; then
    if [[ -f $IMAGE_DIR ]]; then
          echo Directory path already existed
          exit 1
    fi
    mkdir -p $IMAGE_DIR
fi
 
IMAGE_NAME=$(date +%Y%m%d-%H%M%S)
IMAGE_PATH=$IMAGE_DIR$IMAGE_NAME
 
# 保存するファイル名と同一のものが存在する場合は、エラーで処理を終了する。
if [[ -e $IMAGE_PATH ]]; then
  echo File already existed
  exit 1
fi
 
# tifで出力後に、png変換
pngpaste $IMAGE_PATH.tif && \
    convert $IMAGE_PATH.tif $IMAGE_PATH.png
RESULT=$?
 
# 画像が保存できた場合はMarkdownに画像を展開する。
if [ $RESULT = 0 ]; then
  MARKDOWN_IMAGE_SYNTAX="![]($IMAGE_PATH.png)"
  echo $MARKDOWN_IMAGE_SYNTAX

  # 中間ファイルの削除
  rm -rf $IMAGE_PATH.tif
fi
