# Docs coverage report v0.4.2

This file tracks two distinct quality signals:

1. **Page staleness** (automated) — docs pages that have diverged from core source since the last sync, detected by `scripts/docs-drift.mjs --base <prev-tag> --head <current-tag>`.
2. **API surface coverage** (manually maintained) — known API surfaces with no corresponding docs page or section. Updated by hand each release cycle.

---

## Page staleness

- 0 persona page(s) likely missing/stale
- 0 covered, 1 unmapped

### Unmapped core docs (no persona rule)

- `CHANGELOG.md` — release changelog, not a docs page; skip

---

## API surface coverage gaps

These are API surfaces that exist in source but lack documentation. Work through this list before each major release.

### Fixed in this cycle (PR #6 + PR #7)

| Surface | Gap | Fix |
| ------- | --- | --- |
| `agents.defaults.systemPrompt` | No admin docs | `admin/gateway/system-prompt.mdx` created |
| `createSubsystemLogger` / `PluginLogger` | No developer API guide | `developers/plugins/logging.mdx` created |
| Session storage backends (`fs-jsonl` / `sqlite` / `postgres` / `redis`) | Stale doc claimed non-existent plugin registration API | `developers/plugins/session-store.mdx` rewritten |
| `message:transcribed`, `message:preprocessed` standalone hook events | Missing from hooks docs | `developers/hooks.mdx` updated |
| `openclaw health` scope gate + cache TTL | Missing from health-checks docs | `admin/gateway/health-checks.mdx` updated |
| `api.registerSessionStoreAdapter()` | Listed in SDK table but does not exist | Row removed from `developers/sdk/index.mdx` |

### Known gaps remaining (prioritised)

| Surface | Source to check | Priority |
| ------- | --------------- | -------- |
| `api.runtime.*` method signatures | `src/plugins/types.ts` PluginRuntime type | Medium — high-level table in `developers/sdk/index.mdx`; method signatures missing |
| `OpenClawPluginToolContext` fields | `src/plugins/types.ts` ~lines 73-88 | Medium — 9 fields in source; docs mention ~4 |
| `api.registerCommand()` full guide | `src/plugins/types.ts` OpenClawPluginCommandDefinition | Medium — table entry only; no guide |
| `api.registerWebSearchProvider()` guide | `src/plugins/types.ts` WebSearchProviderPlugin | Low |
| System prompt `sections.*` full catalogue | `src/config/types.system-prompt.ts` | Low — overview in `admin/gateway/system-prompt.mdx`; per-section detail missing |
| `before_prompt_build` return type: `prependContext` | `src/plugins/types.ts` PluginHookHandlerMap | Low — hook listed but `prependContext` field undocumented |
| `HealthSummary` full field schema | `src/commands/health.ts` | Low — fields described in prose; no formal table |

### How to maintain

1. Run `pnpm docs:drift` to regenerate the page-staleness section.
2. After any significant source change (new SDK export, new config key, new hook fired), add a row to "Known gaps remaining".
3. When a gap is fixed, move it to "Fixed in this cycle" with the PR reference.
4. At each release, archive the "Fixed" list and reset it for the new cycle.
