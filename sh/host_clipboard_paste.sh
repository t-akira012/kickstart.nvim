#!/bin/sh
# Read text from the SSH client, never from this Mac's clipboard.
set -eu

case "${1:-}" in
  mac)
    if ! nc -z -G 1 127.0.0.1 2222 2>/dev/null; then
      echo 'Mac clipboard SSH forward is not active' >&2
      exit 1
    fi
    exec ssh -T -o BatchMode=yes -o ConnectTimeout=2 -p 2222 127.0.0.1 /usr/bin/pbpaste
    ;;
  windows)
    if ! nc -z -G 1 127.0.0.1 2223 2>/dev/null; then
      echo 'Windows clipboard SSH forward is not active' >&2
      exit 1
    fi
    exec nc -G 2 127.0.0.1 2223
    ;;
  *)
    echo 'Specify mac or windows clipboard source' >&2
    exit 1
    ;;
esac
