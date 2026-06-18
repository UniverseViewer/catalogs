#!/bin/bash
set -euo pipefail

# Build a .tar distribution archive of the catalogs tree.
# Usage: ./dist.sh [output-archive] (default: catalogs.tar).

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ARCHIVE="${1:-${SCRIPT_DIR}/catalogs.tar}"

cd "${SCRIPT_DIR}"

find . -type f \( \
    -name '*.tar' -o \
    -name '*.dat' -o \
    -name 'manifest.json' -o \
    -name '.htaccess' -o \
    -name '*.gz' -o \
    -name 'LICENSE' -o \
    -name '*.py' -o \
    -name '*.md' \
  \) -print0 \
  | while IFS= read -r -d '' file; do
      # Skip a .dat file when a sibling .gz with the same basename exists
      if [[ "$file" == *.dat && -f "${file%.dat}.gz" ]]; then
        continue
      fi
      printf '%s\0' "$file"
    done \
  | tar --null --no-recursion -cf "$ARCHIVE" -T -

echo "Created $ARCHIVE"
