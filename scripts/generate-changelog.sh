#!/usr/bin/env bash
# generate-changelog.sh — regenerate changelog.mdx from docs-sync git history.
#
# Finds "docs: sync …" commits (one per core release, matched on SUBJECT only),
# diffs *.mdx + docs.json between consecutive syncs, merges repeat syncs of the
# same version, and emits changelog.mdx (newest version first).
#
# Usage: bash scripts/generate-changelog.sh   (run from repo root, then commit
# the regenerated changelog.mdx as part of the docs-sync PR).
set -euo pipefail

cd "$(git rev-list --show-toplevel 2>/dev/null || echo .)"

OUT="changelog.mdx"

# Collect sync commits oldest→newest: "<hash>\t<date>\t<subject>"
# Filter on the subject ($3) — git log --grep would also match merge-commit
# bodies that quote sync subjects.
mapfile -t Syncs < <(
    git log --format='%H%x09%cI%x09%s' |
        awk -F'\t' 'tolower($3) ~ /^docs: sync/ {print}' | tac
)

if [[ ${#Syncs[@]} -eq 0 ]]; then
    echo "error: no 'docs: sync' commits found" >&2
    exit 1
fi

# The oldest sync diffs against the repo's root commit (baseline).
Root=$(git rev-list --max-parents=0 HEAD)

version_of() {
    local subject=$1
    if [[ $subject =~ v?([0-9]+\.[0-9]+\.[0-9]+) ]]; then
        printf 'v%s' "${BASH_REMATCH[1]}"
    else
        printf ''   # unversioned sync (e.g. "docs: sync from core")
    fi
}

date_of() { printf '%s' "${1%%T*}"; }   # YYYY-MM-DD from ISO 8601

# ---- Build entries: merge consecutive syncs that share a version ----------
# Entry fields: base-hash, tip-hash (newest sync of the version), date, title.
# Syncs is oldest→newest; a "run" is consecutive indices sharing one version.
# base = sync just before the run's oldest (or the repo root), tip/date = run's
# newest member.
Entries=()
i=0
n=${#Syncs[@]}
while ((i < n)); do
    IFS=$'\t' read -r tip date subject <<<"${Syncs[$i]}"
    ver=$(version_of "$subject")
    # Absorb newer syncs of the same version into this run.
    j=$i
    while ((j + 1 < n)); do
        IFS=$'\t' read -r next_tip next_date next_subject <<<"${Syncs[$((j + 1))]}"
        [[ $(version_of "$next_subject") == "$ver" ]] || break
        tip=$next_tip
        date=$next_date
        j=$((j + 1))
    done
    if ((i == 0)); then
        base=$Root
    else
        IFS=$'\t' read -r base _ _ <<<"${Syncs[$((i - 1))]}"
    fi
    title=${ver:-"Docs sync"}
    Entries+=("${base}|${tip}|$(date_of "$date")|${title}")
    i=$((j + 1))
done

# ---- Emit -------------------------------------------------------------------

# classify <status-letter> <old-path>
classify() {
    case $1 in
        A*) printf '✨ New' ;;
        D*) printf '🗑️ Removed' ;;
        R*) printf '🔀 Renamed' ;;
        *)  printf '✏️ Updated' ;;
    esac
}

# counts <numstat-blob> <path> → "adds<TAB>dels" (0<TAB>0 when absent)
counts() {
    awk -F'\t' -v k="$2" '$3==k{print $1"\t"$2; found=1; exit} END{if(!found) print "0\t0"}' <<<"$1"
}

emit_version() {
    local base=$1 tip=$2 date=$3 title=$4
    echo "## ${title} — ${date}"
    echo

    local statuses numstats navchange=""
    statuses=$(git diff -M --name-status "$base" "$tip" -- '*.mdx' \
        ':(exclude)docs/superpowers/**' ':(exclude)drift-report.md')
    numstats=$(git diff -M --numstat "$base" "$tip" -- '*.mdx' \
        ':(exclude)docs/superpowers/**' ':(exclude)drift-report.md')
    [[ -n $(git diff --name-only "$base" "$tip" -- docs.json) ]] && navchange=1

    if [[ -z $statuses && -z $navchange ]]; then
        echo "_No page-level changes detected._"
        echo
        return
    fi

    echo "| Change | Page |"
    echo "|---|---|"

    while IFS=$'\t' read -r status old new; do
        [[ -z $status ]] && continue
        local label key page stat adds dels
        label=$(classify "$status")
        # Numstat paths: renames are listed under the new path, others under
        # the (single) path.
        if [[ $status == R* || $status == C* ]]; then
            key=$new
            page="\`$old\` → [\`$new\`](/${new%.mdx})"
        elif [[ $status == D* ]]; then
            key=$old
            page="\`$old\`"
        else
            key=$old
            page="[\`$old\`](/${old%.mdx})"
        fi
        if [[ $status == D* ]]; then
            stat=""
        else
            IFS=$'\t' read -r adds dels <<<"$(counts "$numstats" "$key")"
            stat=" (+${adds:-0}/−${dels:-0})"
        fi
        echo "| ${label}${stat} | ${page} |"
    done <<<"$statuses"

    [[ -n $navchange ]] && echo "| 🧭 Nav | navigation updated (\`docs.json\`) |"
    echo
}

{
    cat <<'EOF'
---
title: "Changelog"
description: "What changed in these docs with each WednesdayAI release."
---

These are the documentation changes made with each WednesdayAI release,
generated from the docs-sync git history. For the full product changelog, see
[CHANGELOG.md on GitHub](https://github.com/ExpansionX/WednesdayAI-core/blob/main/CHANGELOG.md).

EOF

    # Newest first
    for ((j = ${#Entries[@]} - 1; j >= 0; j--)); do
        IFS='|' read -r base tip date title <<<"${Entries[$j]}"
        emit_version "$base" "$tip" "$date" "$title"
    done
} > "$OUT"

echo "wrote $OUT with ${#Entries[@]} entries"
