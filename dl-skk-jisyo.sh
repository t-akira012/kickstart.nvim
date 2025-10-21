#!/bin/bash

# SKK辞書のダウンロードスクリプト
# ダウンロードしたい辞書を DICTIONARIES 配列に指定してください

set -e

# 辞書ディレクトリの作成
SKK_DIR="$HOME/.skk"
mkdir -p "$SKK_DIR"

# ダウンロードする辞書のリスト（必要なものをコメントアウト/追加）
DICTIONARIES=(
  # 基本辞書（いずれか1つを選択）
  "SKK-JISYO.L"           # 最大サイズ・おすすめ
  # "SKK-JISYO.ML"        # 中間サイズ
  # "SKK-JISYO.M"         # 中サイズ
  # "SKK-JISYO.S"         # 最小サイズ

  # 専門辞書（必要に応じて追加）
  # "SKK-JISYO.geo"       # 地名
  # "SKK-JISYO.jinmei"    # 人名
  # "SKK-JISYO.fullname"  # フルネーム
  # "SKK-JISYO.station"   # 駅名
  # "SKK-JISYO.propernoun" # 固有名詞
  # "SKK-JISYO.law"       # 法律用語
  # "SKK-JISYO.edict"     # 英和辞書
  # "SKK-JISYO.assoc"     # 略語
  # "SKK-JISYO.lisp"      # 動的変換
  # "SKK-JISYO.zipcode"   # 郵便番号
  # "SKK-JISYO.okinawa"   # 沖縄方言
  # "SKK-JISYO.china_taiwan" # 中国・台湾地名
)

# ベースURL
BASE_URL="https://skk-dev.github.io/dict"

echo "SKK辞書をダウンロードしています..."
echo "対象: ${DICTIONARIES[@]}"
echo ""

# 各辞書をダウンロード
for DICT in "${DICTIONARIES[@]}"; do
  # コメント行をスキップ
  [[ "$DICT" =~ ^#.*$ ]] && continue

  echo "ダウンロード中: $DICT"
  DICT_URL="$BASE_URL/${DICT}.gz"
  DICT_FILE="$SKK_DIR/$DICT"

  # ダウンロードと展開
  if curl -fL "$DICT_URL" -o "$SKK_DIR/${DICT}.gz" 2>/dev/null; then
    gunzip -f "$SKK_DIR/${DICT}.gz"
    echo "  ✓ 完了: $DICT_FILE"
  else
    echo "  ✗ エラー: $DICT のダウンロードに失敗しました"
  fi
  echo ""
done

echo "========================================="
echo "SKK辞書のダウンロードが完了しました"
echo "保存先: $SKK_DIR"
echo "ユーザー辞書: $SKK_DIR/skkeleton (自動作成)"
echo "========================================="
