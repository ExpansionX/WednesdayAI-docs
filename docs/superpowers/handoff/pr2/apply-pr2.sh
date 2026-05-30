#!/usr/bin/env bash
# PR2 apply script - run from the WednesdayAI-docs repo root.
# Copies validated, build-tested pages into place and swaps in the new docs.json.
# Idempotent. One directory deletion is a separate manual step (see README-APPLY.md).
set -euo pipefail

HERE="docs/superpowers/handoff/pr2"
[ -d "$HERE/pages" ] || { echo "run from repo root (cannot find $HERE)"; exit 1; }

echo "==> Copying ${HERE}/pages -> repo root"
( cd "$HERE/pages" && find . -name '*.mdx' -print0 ) | while IFS= read -r -d '' f; do
  rel="${f#./}"
  mkdir -p "$(dirname "$rel")"
  cp "$HERE/pages/$rel" "$rel"
done

echo "==> Installing new docs.json"
cp "$HERE/docs.json" docs.json

echo
echo "Pages copied and docs.json installed."
echo "MANUAL STEP (see README-APPLY.md): stop tracking and delete the old"
echo "developers/providers directory - it has been superseded by admin/providers."
echo "Then stage everything, run mint dev, commit, push, and open PR 2."
