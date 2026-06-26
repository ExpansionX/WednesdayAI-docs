---
name: sync-check
description: Compare docs against the WednesdayAI-core repo to find stale, missing, or inaccurate coverage. Use after core changes or before a docs release.
disable-model-invocation: true
---

# Sync Check: WednesdayAI-docs vs WednesdayAI-core

The core product repo is at `github.com/ExpansionX/WednesdayAI-core`. This skill checks whether docs are accurate and complete relative to the current state of that codebase.

$ARGUMENTS — optional: a specific area to focus on (e.g. "hooks", "CLI flags", "SDK exports"). If omitted, do a full pass.

## What to check

Run through the following checks. Report each finding with: the doc file, the specific claim or gap, and what the core source shows.

1. **Config keys** — `reference/config.mdx` vs config schema in core. Flag any keys that are missing, renamed, or have wrong types/defaults.

2. **CLI flags** — `reference/cli.mdx` vs CLI source/help output. Flag missing or changed flags.

3. **Hooks** — `reference/hooks-catalogue.mdx` and `developers/hooks.mdx` vs hook definitions in core. Flag missing hooks, wrong signatures, or stale event names.

4. **SDK exports** — `developers/sdk/index.mdx` vs SDK index/types. Flag missing exports or changed APIs.

5. **Channel-specific requirements** — each `admin/channels/*.mdx` vs channel adapter source. Flag changed prerequisites, config keys, or pairing flows.

6. **Provider config** — each `developers/providers/*.mdx` vs provider source. Flag changed env vars, model lists, or config options.

## Output format

For each finding:
- **File:** `path/to/file.mdx`
- **Issue:** what is wrong or missing
- **Core source:** where in core you found the discrepancy (file or symbol)
- **Severity:** `stale` (claim is wrong) | `missing` (feature not documented) | `obsolete` (doc covers removed feature)

Summarize with a count by severity at the end.
