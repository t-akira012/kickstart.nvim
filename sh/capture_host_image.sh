#!/bin/sh
# Save a PNG from the selected SSH client without exposing binary data to Nvim.
set -eu

source=${1:-}
destination=${2:-}
if [ -z "$destination" ]; then
  echo 'usage: capture_host_image.sh mac|windows destination.png' >&2
  exit 1
fi

temporary=$(mktemp "${destination}.tmp.XXXXXX")
trap 'rm -f "$temporary"' EXIT

case "$source" in
  mac)
    if ! nc -z -G 1 127.0.0.1 2222 2>/dev/null; then
      echo 'Mac image SSH forward is not active' >&2
      exit 1
    fi
    ssh -T -o BatchMode=yes -o ConnectTimeout=2 -p 2222 127.0.0.1 \
      'tmp=$(mktemp /tmp/ssh-clipboard.XXXXXX.png) || exit; trap "rm -f $tmp" EXIT; if [ -x /opt/homebrew/bin/pngpaste ]; then tool=/opt/homebrew/bin/pngpaste; elif [ -x /usr/local/bin/pngpaste ]; then tool=/usr/local/bin/pngpaste; else tool=pngpaste; fi; "$tool" "$tmp" && cat "$tmp"' > "$temporary"
    ;;
  windows)
    if ! nc -z -G 1 127.0.0.1 2224 2>/dev/null; then
      echo 'Windows image SSH forward is not active' >&2
      exit 1
    fi
    nc -G 2 -w 10 127.0.0.1 2224 > "$temporary"
    ;;
  *)
    echo 'Specify mac or windows image source' >&2
    exit 1
    ;;
esac

signature=$(dd if="$temporary" bs=8 count=1 2>/dev/null | od -An -tx1 | tr -d ' \n')
if [ "$signature" != 89504e470d0a1a0a ]; then
  echo 'The SSH client clipboard did not provide a PNG image' >&2
  exit 1
fi

mv "$temporary" "$destination"
