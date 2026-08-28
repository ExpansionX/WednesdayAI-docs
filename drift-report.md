# Docs drift report v0.4.11

Generated 2026-08-28 by the docs coverage full pass. Source of truth for coverage state: `docs-surface.yaml` in WednesdayAI-core.

- `scripts/docs-surface-check.mjs --mode=pages` — 0 problems, 0 warnings (was 132 warnings at v0.4.8-era baseline)
- 45 new pages authored; 9 existing pages extended; all registered in `docs.json` nav (141 entries)
- Manifest coverage: 134 documented, 52 known-bad (`coverage: wrong`) carried as baseline

## Fixed since v0.4.8 report

- All 51 truly-missing pages from the manifest gap list are authored (tasks, backbone, agent-turn-runner, realtime voice API, config-writes, exec approvals, observability, learning, dream-cycle, media-understanding providers, pairing pages for signal/slack/matrix/msteams, groups, feishu, session, streaming, product-naming, context-engine, redis-session-cache, auto-reply, chunk-delivery, session-consumer-claims, plugin-hooks, prompt-caching, persona, cron, performance-diagnostics)
- `developers/plugins/realtime-voice-provider.mdx` (invented API: `createPlugin`/`VoiceSession`/16kHz PCM) deleted; redirects to `/developers/realtime-voice-api`
- Manifest `docs_page` paths remapped to the audience-prefixed site IA (57 prefix remaps + 74 by-id retargets)

## Remaining known-bad baseline (`coverage: wrong` — tracked in docs-surface.yaml)

Content-accuracy gaps on existing pages, keyed by surface id in the manifest. Highest severity first:

- `GAP-005` / `GAP-001-provider` / `GAP-002-provider` / `GAP-015-anthropic` — provider pages (google, anthropic) missing live-auth/extra-params/thinking content
- `slack-missing-event-subscriptions`, `slack-missing-media-section`, `slack-missing-replytomodebytype`, `slack-missing-historylimits` — slack channel page gaps
- `discord-missing-intents`, `discord-missing-threadbindings`, `discord-missing-pluralkit`, `discord-missing-configwrites` — discord channel page gaps
- `signal-missing-reaction-config`, `signal-missing-configwrites-and-media` — signal channel page gaps
- `config-session-redis-missing`, `config-web-section-missing` — reference/config gaps
- `cli-wednesdayai-alias-undocumented`, `cli-configure-subcommands-undocumented` — reference/cli gaps
- `api-rpc-missing-system-namespace`, `api-rpc-missing-hooks-plugins-namespaces`, `api-websocket-streaming-events-undocumented` — reference/api gaps
- `GAP-003-install`, `GAP-013` — getting-started staleness
- `GAP-007/008/009/017-sandboxing`, `GAP-010/011/012-secrets` — sandboxing/secrets key gaps
- `index-missing-community-channel-install-guidance`, `index-missing-routing-multiagent-link` — channels index gaps
- `gap-005` through `gap-014` (users) — users/commands, pairing, messaging gaps
- `GAP-001-contributing`, `GAP-002-overview`, `GAP-005-context-engine`, `GAP-003-channel-adapters`, `GAP-004-agent-signals`, `GAP-008-your-first-plugin`, `hooks-catalogue-bundled-hook-events-mismatch` — developer page staleness

These are follow-up work for the next accuracy pass (manual sweep precedent: PRs #16, #17).
