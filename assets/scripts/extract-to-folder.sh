#!/usr/bin/env bash
# Extract each archive into a subfolder named after it using file-roller.
# e.g. a.zip -> a/
#
# Usage: extract-to-folder.sh ARCHIVE...

set -euo pipefail

DEBUG_LOG="${EXTRACT_LOG:-/tmp/extract-to-folder.log}"
{
  echo "=== $(date '+%F %T') invoked with: $# args ==="
  printf '  arg: %q\n' "$@"
  echo "  cwd: $(pwd)"
  echo "  PATH: $PATH"
  echo "  DISPLAY=$DISPLAY WAYLAND_DISPLAY=${WAYLAND_DISPLAY:-} XDG_RUNTIME_DIR=${XDG_RUNTIME_DIR:-} DBUS_SESSION_BUS_ADDRESS=${DBUS_SESSION_BUS_ADDRESS:-}"
  echo "  file-roller: $(command -v file-roller 2>/dev/null || echo NOT FOUND)"
} >>"$DEBUG_LOG" 2>&1

if ! command -v file-roller >/dev/null 2>&1; then
  printf 'extract-to-folder: file-roller not available\n' >&2
  exit 1
fi

extract_one() {
  local archive=$1 base dirname dest
  archive=$(realpath -- "$archive")
  [ -f "$archive" ] || {
    printf 'extract-to-folder: not a file: %s\n' "$archive" >&2
    return 1
  }

  base=$(basename -- "$archive")
  dirname=$(dirname -- "$archive")

  # folder name = archive name minus its extension (handling compound ones)
  case "$base" in
    *.tar.gz | *.tar.bz2 | *.tar.xz | *.tar.zst | *.tar.lz4 | *.tar.lz)
      dest="${base%.tar.*}"
      ;;
    *.tar)
      dest="${base%.tar}"
      ;;
    *)
      dest="${base%.*}"
      ;;
  esac

  file-roller "--extract-to=$dirname/$dest" --force "$archive"
  rc=$?
  echo "  [$base] -> $dest rc=$rc" >>"$DEBUG_LOG" 2>&1
  return "$rc"
}

failed=0
for archive in "$@"; do
  extract_one "$archive" || failed=1
done
exit "$failed"
