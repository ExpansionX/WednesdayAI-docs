# Docs drift report v0.4.11

Generated 2026-08-29 after the full coverage pass, the 52-item accuracy sweep, and the merge of `docs/cognitive-substrate-0d` into `main`.

## Gate results

- `docs-surface-check --mode=pages`: **0 problems, 0 warnings**
- Manifest (`docs-surface.yaml` in core): 190 tracked surfaces, **all `coverage: documented`** (0 gap, 0 wrong)
- Site nav: **420 pages**, 0 missing files
- Redirects: **287** (260 auto-generated path-prefix + 27 manual), 0 destinations outside nav
- Internal links: 0 broken occurrences (was 1,787 across 567 targets before the redirect pass)

## What this state reflects

1. **Full coverage pass (2026-08-28/29)**: 51 missing pages authored against source; 9 manifest path remaps to the audience-prefixed site IA; docs.json nav registration.
2. **Accuracy sweep**: all 52 tracked `coverage: wrong` items resolved against source (providers auth, channel config keys, CLI/API/reference corrections, sandbox + secrets limits, user commands, developer pages).
3. **Merge of `docs/cognitive-substrate-0d`** (merge commit `d17c2e3`): reconciled with the externally synced main (PRs #18-#22); source-verified sections preserved; richer sync versions kept where they were supersets.
4. **Sync-orphan registration**: 279 pages brought by the sync PRs were on disk but unregistered; now in 22 labeled nav groups. `changelog.mdx` stays navbar-linked by design.
5. **Post-merge accuracy**: `/tts` real subcommands, `session.maintenance` enum (`enforce`/`warn`), flat system-state RPC names, trusted npm publishing section (OIDC workflow, invocation identity, sealed inventories), agent-turn durable delay + boot recovery (#403), cron outcomes as `agent.turn` producers, isolated-heartbeat event ownership.

## Regenerating

Run from the core repo:

```bash
node scripts/docs-surface-check.mjs --mode=pages --docs-root=/data/Code/WednesdayAI-docs
```

Known follow-ups live as `docs-coverage`-labelled issues / WAI ledger items keyed by surface id, per AGENTS.md §15.
