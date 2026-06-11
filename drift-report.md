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
| `api.runtime.*` method signatures | Method signatures missing | `developers/sdk/index.mdx` expanded with key methods per sub-API |
| `OpenClawPluginToolContext` full field table | 9 fields; docs showed ~4 | `developers/agent-tools.mdx` updated with full field table |
| `api.registerCommand()` full guide | Table entry only; no guide | `developers/plugins/register-command.mdx` created |
| `api.registerWebSearchProvider()` guide | No guide | `developers/plugins/web-search-provider.mdx` created |
| System prompt `sections.*` full catalogue | Section list only; no mode types | `admin/gateway/system-prompt.mdx` updated with full catalogue table |
| `before_prompt_build` `prependContext` return field | Hook listed but `prependContext` undocumented | `developers/hooks.mdx` updated with example and both return fields |
| `HealthSummary` full field schema | Fields in prose only | `admin/gateway/health-checks.mdx` updated with full schema table |
| Node.js version (22 → 24) | 6 pages listed Node 22 | Fixed across all 6 pages |

### Known gaps remaining (prioritised)

No high-priority gaps. Next audit should check:

| Surface | Source to check | Notes |
| ------- | --------------- | ----- |
| `runtime.channel.*` internals | `src/plugins/runtime/channel.ts` | Intentionally undocumented; only relevant for channel adapter authors |
| `ProviderPlugin` / `api.registerProvider()` | `src/plugins/types.ts` | No provider authoring guide exists |
| `api.registerService()` / `OpenClawPluginService` | `src/plugins/types.ts` | No background-service guide exists |
| `api.registerGatewayMethod()` | `src/plugins/types.ts` | No RPC registration guide exists |

### How to maintain

1. Run `pnpm docs:drift` to regenerate the page-staleness section.
2. After any significant source change (new SDK export, new config key, new hook fired), add a row to "Known gaps remaining".
3. When a gap is fixed, move it to "Fixed in this cycle" with the PR reference.
4. At each release, archive the "Fixed" list and reset it for the new cycle.
