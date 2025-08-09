#!/usr/bin/env bash
set -euo pipefail

# Simple lints: ensure each markdown has an H1 and < 2000 lines
fail=0
while IFS= read -r -d '' f; do
  if ! grep -q '^# ' "$f"; then
    echo "Missing H1: $f"; fail=1
  fi
  if [[ $(wc -l < "$f") -gt 2000 ]]; then
    echo "Too long (>2000 lines): $f"; fail=1
  fi
done < <(find . -name '*.md' -print0)
exit $fail
