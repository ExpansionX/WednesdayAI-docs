# PR 2 — Content Gap Audit (docs site vs core docs/)

_2026-05-30. Four parallel audits (one per tab) against `WednesdayAI-core/docs/` + live source. Fork base: openclaw v2026.3.2._

## Headline

The 42 pages are not merely thin — several carry **factually wrong API/config/CLI content** that contradicts our fork. PR 2 is therefore **correctness first, enrichment second**. Highest-severity errors:

- **Developers/SDK API is fictional** in `developers/agent-tools.mdx` and `developers/sdk/index.mdx`: `ToolDefinition`, `inputSchema`, `run()`, `HookContext`, `PluginDefinition.tools[]` do **not** exist. Real surface: `api.registerTool({ name, description, parameters, execute(_id, params) })` returning `{ content: [...] }`; hooks via `api.on(name, handler)`. `your-first-plugin.mdx` is the one correct page — make it the template.
- **Provider config shape wrong** across all 7 provider pages: they show `agents.defaults.model: "claude-sonnet-4-6"` (bare string). Core: `agents.defaults.model: { primary: "anthropic/claude-sonnet-4-6" }` (nested, provider-prefixed). Auth shown as `openclaw login` — real path is `openclaw onboard` / `openclaw models auth …`.
- **`dmPolicy` enum drift** in `admin/security.mdx` and `admin/channels/index.mdx`: they use `ask`; the real enum is `pairing | allowlist | open | disabled`, placed under `channels.<channel>.dmPolicy` (the five working channel pages already do this correctly).
- **CLI page invents commands**: `skills enable/disable/install` (skills is read-only: list/info/check), `devices revoke/rotate` with wrong signatures, `cron --schedule` (real: `--cron`), `cron remove`/`cron logs` (real: `cron rm`/`cron runs`), `agents status` (not real), and a wrong global-flags table.
- **Broken internal links**: `/admin/multi-gateway`, `/admin/channels/{imessage,msteams,matrix}`, `/users/pairing/imessage`, a self-referential auth-monitoring link, and `developers/plugins/publishing`.
- **Stale note**: `admin/channels/index.mdx` says channel guides "are being written" — they all exist.

## Per-tab summary

### Administrators (strong; targeted fixes + 2 sections)
Gateway pages (configuration, authentication, remote-access, logging, health-checks) are deep and mostly accurate. Enrichment opportunities:
- **security.mdx** (thinnest vs source — core security doc is ~1150 lines): add mDNS hardening, control-plane tool risk, prompt-injection primer, sandboxing + per-agent access profiles, `session.dmScope`, condensed audit-output triage. Fix the `dmPolicy` enum/placement.
- **configuration.mdx**: add Secrets/SecretRef section + port/bind precedence table.
- **remote-access.mdx**: add TLS/reverse-proxy (nginx/Caddy) section + CLI-creds-over-`--url` note + `tlsFingerprint`.
- **authentication.mdx**: fix self-link; add gateway-token rotation checklist; expand trusted-proxy examples.
- **upgrading.mdx**: add `openclaw update` (source) full flow + Control-UI Update & Restart + `--tag`.
- **troubleshooting.mdx**: add failure-signature→cause table; Node-vs-Bun-after-upgrade entry.
- **channels/index.mdx**: remove stale note; fix dmPolicy example; fix/justify dead channel links; optionally widen the channel catalogue (~20 in core).
- Sources: `gateway/security/index.md`, `gateway/secrets.md`, `gateway/remote.md`, `gateway/trusted-proxy-auth.md`, `gateway/doctor.md`, `gateway/troubleshooting.md`, `install/updating.md`, `channels/index.md`.
- **Missing pages**: multi-gateway (linked, absent — `gateway/multiple-gateways.md`), secrets, doctor (dedicated), sandboxing, iMessage/BlueBubbles + msteams + matrix channel pages.

### Users (thinnest tab; biggest enrichment)
- **what-is-wednesdayai.mdx**: add persistent memory, scheduling, file/voice as headline capabilities.
- **messaging.mdx**: add memory-vs-context, file/image sharing, group-mention behaviour, correct `/think` levels (`off|minimal|low|medium|high|xhigh|adaptive`), debouncing note.
- **commands.mdx**: add missing real commands (`/context`, `/usage cost|full`, `/reasoning`, `/queue`, group `/activation`, `:` separator); flag `! `/`/bash` as off-by-default; fix `/think` set.
- **tools/index.mdx**: replace generic prose with the real tool inventory (image, pdf, message, sessions_spawn, node/device actions) each with a "what you can ask" line. Verify Perplexity claim (core built-in web_search is Brave only).
- **pairing pages**: fix broken iMessage link; add pairing-code note; Telegram slash-commands note; fix Discord `/think` ("set depth", not toggle) + `/voice`.
- **troubleshooting.mdx**: add "bot ignores me in a group"; soften operator/localhost steps to "ask your admin".
- Cross-cutting: stale model names (`claude-3-5-sonnet`/`gpt-4o`) → current or `<model>` placeholder.
- Sources: `concepts/memory.md`, `concepts/session.md`, `concepts/messages.md`, `tools/index.md`, `tools/slash-commands.md`, `tools/thinking.md`, `channels/pairing.md`, `channels/group-messages.md`.
- **Missing pages**: iMessage pairing, Memory, Sharing files/images/voice, (optional) Voice/TTS.

### Developers (correctness-critical)
- **Rewrite `agent-tools.mdx` and `sdk/index.mdx`** around the real `api.registerTool`/`AnyAgentTool` surface (mirror `your-first-plugin.mdx`). Remove phantom `ToolDefinition`/`HookContext`/`inputSchema`/`run()`.
- **hooks.mdx**: document the real lifecycle-hook catalogue (34 `PluginHookName` entries) via `api.on(...)` with fire-timing + mutation semantics; fix non-exported `HookContext` import; separate lifecycle hooks from standalone `HOOK.md` hooks.
- **channel-adapters.mdx**: replace invented flat object with the real `ChannelPlugin` adapter-composition model; fix `>=2026.3.2` peer-dep (pin policy says pin to `2026.3.2`).
- **providers/***: fix model-config shape + auth command everywhere; resolve audience mismatch (tagged `audience: admin` under Developers tab); the index exposes 7 of 33 — either expand or mark as curated subset.
- **overview.mdx**: expand extension types beyond 4; add `api.runtime` + plugin precedence.
- **contributing.mdx**: add `pnpm tsgo`, dev-log/CHANGELOG-for-features rule, plugin pin rule; verify security email vs SECURITY.md.
- Sources: `src/plugins/types.ts`, `src/plugin-sdk/index.ts`, `src/agents/tools/common.ts`, `src/hooks/`, `docs/plugins/*`, `docs/concepts/model-providers.md`, repo `CLAUDE.md`.
- **Missing pages**: plugin manifest reference, publishing, analysis runtime, agent signals, session-store adapters, web-search providers, custom providers (authoring), plugin commands, HTTP routes/webhooks.

### Reference (judged on coverage; major gaps + invented commands)
- **cli.mdx**: documents ~22 of ~48 commands. Add the ~22 missing top-level commands (nodes, node, browser, memory, secrets, plugins, acp, system, sandbox, approvals, webhooks, dns, tui, docs, setup, reset, completion, agent, directory, daemon, clawbot, voicecall) and the missing subcommands under models/message/agents/cron/gateway/config/onboard. **Fix invented commands** (skills enable/disable/install, devices revoke/rotate, cron --schedule/remove/logs, agents status) and the global-flags table (`--dev`, `--profile`, `--no-color`, `--update`, `-V`). Source: `docs/cli/index.md` + 46 per-command files.
- **config.mdx**: documents ~12 of ~30 root keys. Add `tools`, `approvals`, `commands`, `messages`, `plugins`, `skills`, `memory`, `secrets`, `auth`, `talk`/`audio`, `browser`, `acp`, `update`, `discovery`, `canvasHost`, `broadcast`; expand `gateway` sub-keys (controlUi, http.endpoints.responses, tls, remote, trustedProxy); add remaining channels. Source: `src/config/zod-schema.ts`.
- **api.mdx**: accurate but add `POST /v1/responses`, mark the RPC method table non-exhaustive (link `gateway call`), note control-UI HTTP surface + securityHeaders. Source: `docs/reference/rpc.md`, `docs/cli/gateway.md`, `zod-schema.ts:698-748`.
- **hooks-catalogue.mdx**: complete & accurate (the real 4 bundled hooks). Only add `hooks update` to the CLI block; spot-check each HOOK.md event/emoji.

## Suggested execution order (each a reviewable commit)
1. **Accuracy fixes** (cross-cutting, low-risk, high-value): dmPolicy enum, provider config shape + auth command, CLI invented commands, broken links, stale notes, model names, `/think` levels.
2. **Developers rewrite** (agent-tools, sdk, hooks, channel-adapters) — correctness-critical.
3. **Reference expansion** (cli, config, api) — coverage.
4. **Users enrichment** (the thin pages + the user-facing correctness items).
5. **Admin enrichment** (security/configuration/remote-access/upgrading/troubleshooting) + new pages.
6. **New pages** (multi-gateway, secrets, sandboxing, memory, file-sharing, plugin manifest/publishing, missing channels) — as scope allows.

Audience tagging note: the provider pages are operator-facing but sit under Developers. Decide whether to retag/move before enriching.
