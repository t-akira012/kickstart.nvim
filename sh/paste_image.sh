#!/bin/bash
# ref. https://reona.dev/posts/20200620

# 使い方
# $ paste_image.sh 元のマークダウンファイル名

MD_FILENAME=$*

if [[ $(uname) == "Darwin" ]]; then 
  if ! type pbpaste > /dev/null 2>&1 ; then
    echo pngpaste: command not found >&2
    exit 1
  fi
  if ! type convert > /dev/null 2>&1 ; then
    echo convert: command not found >&2
    exit 1
  fi
fi
if [[ $XDG_SESSION_TYPE == "wayland" ]]; then 
  if ! type wl-paste > /dev/null 2>&1 ; then
    echo wl-paste: command not found >&2
    exit 1
  fi
fi
 
IMAGE_DIR=images/
 
if [[ ! -d $IMAGE_DIR ]]; then
    if [[ -f $IMAGE_DIR ]]; then
          echo Directory path already existed
          exit 1
    fi
    mkdir -p $IMAGE_DIR
fi

gen_file_path(){
  IMAGE_NAME=${MD_FILENAME}${NUMBER}
  IMAGE_PATH=${IMAGE_DIR}${IMAGE_NAME}
}

check_exits_file(){
# 保存するファイル名と同一のものが存在する場合は、ファイル名をインクリメント
  gen_file_path
  NUMBER=0
  while [ -e $IMAGE_PATH.png ];do
    NUMBER=$(( 1 + $NUMBER ))
    gen_file_path
  done
}

check_exits_file
 
if [[ $(uname) == "Darwin" ]]; then 
  # tifで出力後に、png変換
  pngpaste $IMAGE_PATH.tif && \
      convert $IMAGE_PATH.tif $IMAGE_PATH.png
  RESULT=$?
fi
 
if [[ $XDG_SESSION_TYPE == "wayland" ]]; then 
  wl-paste --type image/png > $IMAGE_PATH.png
  RESULT=$?
fi
 
# 画像が保存できた場合はMarkdownに画像を展開する。
if [ $RESULT = 0 ]; then
  MARKDOWN_IMAGE_SYNTAX="![]($IMAGE_PATH.png)"
  echo $MARKDOWN_IMAGE_SYNTAX

  # 中間ファイルの削除
  rm -rf $IMAGE_PATH.tif
fi
