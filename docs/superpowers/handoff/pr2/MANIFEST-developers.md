# PR2 — Developers tab staging manifest

_Authored 2026-05-30. All pages verified against live source in `WednesdayAI-core/src` (fork base v2026.3.2). Australian English, Mintlify MDX, `audience: developer` frontmatter preserved._

Scope: DEVELOPERS tab **excluding** `developers/providers/*` (moving to Admin, authored elsewhere — untouched).

## Files produced (in /tmp/pr2-staging/developers/)

### Rewritten for correctness
| File | What changed |
| ---- | ------------ |
| `overview.mdx` | Expanded extension types from 4 cards to the real register-method set (tools, hooks, channels, providers, HTTP/gateway, commands, services, storage/search). Added `api.runtime` section and the real plugin discovery precedence. Added `pnpm tsgo`, pin-to-2026.3.2 principle. |
| `hooks.mdx` | Full rewrite. Split **lifecycle hooks (in-plugin via `api.on`)** from **standalone HOOK.md hooks**. Removed the fictional `import { HookContext }`. Documented all 35 `PluginHookName` entries with fire timing + mutation semantics (mutating / observe-only / short-circuiting). Noted `model_call_ended` observe-only + serial + in-place usage/proxyMetadata mutation; `ownsCompaction`. |
| `channel-adapters.mdx` | Full rewrite. Replaced invented flat `{login,logout,status,send,handleEvent}` object with the real `ChannelPlugin<ResolvedAccount, Probe, Audit>` adapter-composition model (config/meta/capabilities required; ~18 optional adapter slots). Registration via `api.registerChannel(...)`. Fixed peer-dep `>=2026.3.2` → exact `2026.3.2`. |
| `agent-tools.mdx` | Full rewrite around real `api.registerTool({ name, description, parameters, execute(_id, params) })` returning `{ content: [{ type: "text", text }] }`. Removed `ToolDefinition`/`inputSchema`/`run()`. Added `AnyAgentTool`, `jsonResult`, param readers, `stringEnum`, optional tools, `ownerOnly`, tool factories, naming/conflicts, testing. |
| `sdk/index.mdx` | Full rewrite to real exports only. Documented the `register` entry + `OpenClawPluginApi` `register*` methods, all `api.runtime` sub-APIs, typebox helpers (`stringEnum`/`optionalStringEnum`). Flagged `resolveStateDir` as removed → `api.runtime.state.resolveStateDir()`. Reconciled the two manifest forms. Removed phantom `ToolDefinition`/`HookContext`. Fixed peer-dep to exact `2026.3.2`. |
| `contributing.mdx` | Added `pnpm tsgo` must-exit-0 step + warning. Added dev-log + CHANGELOG-for-features rule. Added plugin pin-to-2026.3.2 rule. Verified security email `security@expansionx.com.au` against `SECURITY.md` (correct, unchanged). |
| `plugins/your-first-plugin.mdx` | Light enrichment (page was already correct). Expanded extension-points table to "register with" methods incl. providers/commands. Added a `<Note>` clarifying `openclaw.plugin.json` (manifest, validation) vs `package.json` `"openclaw"` key (discovery). Added an "Other extension points" section. Fixed `What's next` links (`/reference/plugin-manifest` → `/developers/plugins/manifest`, `/reference/plugin-sdk` → `/developers/sdk`). Removed emoji from a code comment and a CLI sample line. |

### New pages
| File | Source |
| ---- | ------ |
| `plugins/manifest.mdx` | `docs/plugins/manifest.md` + `src/plugins/types.ts`. Required/optional fields, configSchema rules, `uiHints`, validation behaviour, native-deps note. |
| `plugins/publishing.mdx` | `docs/plugins/community.md` + `docs/cli/plugins.md`. Pre-publish checklist, npm publish, full `openclaw plugins` lifecycle (install/enable/update/inspect/uninstall), community-listing path. |
| `analysis-runtime.mdx` | `docs/plugins/analysis-runtime.md` + `src/plugins/runtime/types-analysis.ts`. `run`/`enqueue`, params, result statuses, memory-tool allow-list, lanes/admission/bounds, constraints. |
| `agent-signals.mdx` | `docs/plugins/agent-signals.md` + `src/infra/agent-signals.ts`. Modes (context/heartbeat; background/notify/steer unsupported), publish fields, helpers, heartbeat dispatch, prompt visibility, availability, dedupe/bounds. |

## Source-of-truth references used
- `src/plugins/types.ts` — `OpenClawPluginApi`, `OpenClawPluginDefinition`, `PluginHookName` (35 entries), per-hook event/result/handler-map types, `api.on` signature, `api.register*` methods.
- `src/agents/tools/common.ts` — `AnyAgentTool` (`AgentTool<any, unknown> & { ownerOnly? }`), `jsonResult`, `readStringParam`/`readNumberParam`/`readReactionParams`, `createActionGate`, `ToolAuthorizationError`.
- `src/plugin-sdk/index.ts` — confirmed exported symbols; `stringEnum`/`optionalStringEnum`; the `// resolveStateDir is runtime-internal and no longer exported` note; Channel adapter type re-exports.
- `src/channels/plugins/types.plugin.ts` — real `ChannelPlugin` composition + generics + slot list.
- `src/plugins/runtime/types-core.ts` — `api.runtime` sub-API tree (analysis/signals/state/config/media/tts/stt/system/events/tools/logging).
- `src/plugins/runtime/types-analysis.ts` — `AnalysisRunParams`/`AnalysisResult`/`AnalysisStatus`.
- `src/infra/agent-signals.ts` — modes, reject reasons, availability fields, bounds (100 global / 20 per target / 500-char summary).
- `docs/tools/plugin.md` — discovery precedence (config paths > workspace > global > bundled).
- `docs/cli/plugins.md` — install/update/uninstall flags + behaviour.
- `SECURITY.md` — confirmed `security@expansionx.com.au`.

## Corrections of audit assumptions
- **Plugin precedence order:** the gap audit wrote "workspace > global > bundled > config". The real scan order (per `docs/tools/plugin.md` + loader) is **config paths (`plugins.load.paths`) FIRST, then workspace, then global, then bundled**. Pages reflect the source order, not the audit's.
- **Security email:** confirmed correct as `security@expansionx.com.au` (audit asked to verify — no change needed).

## Items NOT fully confirmable in src/ (omitted or kept generic — verify before publish)
- **`api.registerHttpRoute` / `registerGatewayMethod` parameter shapes** are referenced by name only. The `OpenClawPluginHttpRouteParams` and `GatewayRequestHandler` types exist in `src/plugins/types.ts` / `src/gateway/server-methods/types.ts`, but I did not author a full HTTP-route worked example (no dedicated page in scope). The SDK page lists them at table level only — accurate but not deep. A future `developers/http-routes.mdx` could expand this.
- **`registerCommand` chat-command surface** — `OpenClawPluginCommandDefinition` is confirmed in `src/plugins/types.ts` (name/description/acceptsArgs/requireAuth/handler). Mentioned at table level; no worked example authored (out of scope).
- **`uiHints` `itemTemplate`** exists on `ChannelConfigUiHint` but not on `PluginConfigUiHint`; I documented only the plugin-manifest `uiHints` fields (label/help/placeholder/sensitive/advanced/tags) that are confirmed on `PluginConfigUiHint`.
- **`openclaw plugins list` output format** — I replaced the invented `✓ loaded` glyph with a plain `loaded` token. Exact column layout is illustrative; not asserted from a fixture.
- **`docs.json`/navigation registration** for the 4 new pages (`plugins/manifest`, `plugins/publishing`, `analysis-runtime`, `agent-signals`) is NOT done here — these are content files only. The nav must be wired in the docs-site `docs.json` when applying.

## Cross-link notes
- All internal links are root-relative without extension, pointing at `/developers/*` targets that exist in this set (or `/developers/providers` which is authored elsewhere).
- `your-first-plugin.mdx` links to `/developers/plugins/manifest` and `/developers/plugins/publishing` (both now created) and `/developers/sdk`.

## MDX-safety verification performed
- Table-cell pipes inside inline code escaped as `\|` (e.g. `T \| null`, `Record<string, unknown> \| undefined`).
- All `<...>` occurrences outside inline code are inside fenced code blocks (```ts/```typescript) — MDX does not parse those as JSX. Generics inside inline code (e.g. `ChannelPlugin<...>`) follow the same pattern the known-good `your-first-plugin.mdx` already used and builds cleanly.
- No emoji in body content (removed `✓`/`❌` from the inherited page).
