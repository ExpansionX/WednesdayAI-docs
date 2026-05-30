# PR2 Reference Tab - Staging Manifest

_Authored 2026-05-30. Scope: the REFERENCE tab. Judged on coverage + accuracy. All claims verified against `WednesdayAI-core` `docs/cli/index.md`, `src/config/zod-schema.ts`, `src/gateway/server-methods/*`, `src/hooks/bundled/*/HOOK.md`, and `src/gateway/openresponses-http.ts`._

## Files produced

| File | Lines | Status |
| ---- | ----- | ------ |
| `reference/cli.mdx` | ~698 | Rewritten - complete + corrected |
| `reference/config.mdx` | ~843 | Rewritten - all root keys + expanded gateway |
| `reference/api.mdx` | ~288 | Expanded - `/v1/responses`, non-exhaustive RPC table, control-UI surface |
| `reference/hooks-catalogue.mdx` | ~149 | Minimal correctness fixes |

Frontmatter (`title`/`sidebarTitle`/`description`/`audience`) preserved on all four.

## cli.mdx - coverage

Every top-level command from `docs/cli/index.md` is now present and grouped:

setup, onboard, configure, completion, reset, uninstall, update, gateway, daemon, status, health, doctor, logs, dashboard, tui, qr, models, channels, pairing, devices, config, secrets, directory, dns, agent, agents, sessions, acp, message, skills, hooks, plugins, memory, nodes, node, approvals, sandbox, browser, system, cron, security, webhooks, docs, clawbot, voicecall.

Subcommand sets expanded to real values for: models, message, agents, cron, gateway, config, onboard, channels, devices, nodes, browser, system.

### Corrections applied (previously invented/wrong)

- **Global flags**: replaced the wrong `--log-level`/`--verbose`/`--json` global table with the real globals: `--dev`, `--profile`, `--no-color`, `--update`, `-V/--version`. Per-command `--json`/`--verbose`/`--log-level` noted as per-command, not global.
- **skills**: now read-only (`list`/`info`/`check`). Explicit Note that `enable`/`disable`/`install` do NOT exist; pointed to `npx clawhub` + `skills.allowBundled`/`skills.load.extraDirs`.
- **devices**: corrected to `list`/`approve`/`reject`/`remove`/`clear`/`rotate`/`revoke` with the real `--device`/`--role`/`--scope` signatures and `--latest`/`--pending` flags.
- **cron**: `--cron` (not `--schedule`); `cron rm` canonical (aliases remove/delete); `cron runs --id <id>` (not `cron logs`). Warning block spells out the add-payload constraints.
- **agents**: removed the non-existent `agents status`; documented real `list`/`add`/`bindings`/`bind`/`unbind`/`delete`.
- **pairing**: `list`/`approve` only; Warning that `deny` and `list --all` do not exist.
- **login command removed**: the old page's `openclaw login` is not in the command tree; auth is under `openclaw models auth ...` / `openclaw onboard`. Reframed accordingly.

### Unconfirmed / synopsis-only (flagged in-page with "see --help")

- `openclaw completion`, `openclaw directory`, `openclaw clawbot`, `openclaw voicecall` - present in the command tree; per-flag detail not in `docs/cli/index.md`, documented at synopsis level.
- `openclaw acp` - synopsis only; deferred to `/cli/acp`.
- `message` subcommand per-flag detail deferred to `/cli/message` (only `send`/`poll` examples given, which are confirmed).

## config.mdx - coverage

All 36 strict root keys from `OpenClawSchema` are now documented or summarised:

$schema, meta, env, wizard, diagnostics, logging, cli, update, browser, ui, secrets, auth, acp, models, nodeHost, agents, tools, bindings, broadcast, audio, media, messages, commands, approvals, session, cron, hooks, web, channels, discovery, canvasHost, talk, gateway, memory, skills, plugins.

(`nodeHost` and `web` are mentioned in the root-keys table; `media` documented as `media.preserveFilenames`.)

### gateway sub-keys expanded (verified against schema lines 587-765)

mode, customBindHost, controlUi.* (enabled/basePath/root/allowedOrigins/allowInsecureAuth/dangerously* flags), auth.rateLimit (maxAttempts/windowMs/lockoutMs/exemptLoopback), auth.trustedProxy (userHeader required, requiredHeaders, allowUsers), trustedProxies, allowRealIpFallback, channelHealthCheckMinutes, tls.* (enabled/autoGenerate/certPath/keyPath/caPath), remote.* (url/transport/token/tlsFingerprint/sshTarget/sshIdentity), reload.*, http.endpoints.chatCompletions, http.endpoints.responses.* (maxBodyBytes/maxUrlParts/files{allowUrl,urlAllowlist,allowedMimes,maxBytes,maxChars,pdf{maxPages,maxPixels,minTextChars}},images{...}), http.securityHeaders.strictTransportSecurity, gateway.tools.deny/allow, gateway.nodes.browser.

### Enums verified against schema

- `gateway.bind`: auto | lan | loopback | custom | tailnet
- `gateway.mode`: local | remote
- `gateway.auth.mode`: none | token | password | trusted-proxy
- `gateway.reload.mode`: off | restart | hot | hybrid
- `gateway.remote.transport`: ssh | direct
- `tools.profile`: minimal | coding | messaging | full
- `tools.sessions.visibility`: self | tree | agent | all
- `commands.native`/`nativeSkills`: auto | on | off (defaults to "auto")
- `commands.ownerDisplay`: raw | hash
- `messages.ackReactionScope`: group-mentions | group-all | direct | all | off | none
- `logging.level`: silent | fatal | error | warn | info | debug | trace
- `memory.backend`: builtin | qmd | external; `memory.citations`: auto | on | off
- `discovery.mdns.mode`: off | minimal | full
- `update.channel`: stable | beta | dev
- `auth.profiles.*.mode`: api_key | oauth | token
- `acp.stream.deliveryMode`: live | final_only
- `skills.install.nodeManager`: npm | pnpm | yarn | bun
- `cron.failureAlert.mode` / `failureDestination.mode`: announce | webhook
- `browser.profiles.*.driver`: clawd | extension
- `diagnostics.otel.protocol`: http/protobuf | grpc

### Channels

Built-in channel list corrected to the real schema set: whatsapp, telegram, discord, slack, signal, imessage, bluebubbles, googlechat, msteams, irc (schema `ChannelsSchema` uses `.passthrough()` for extension channels - noted). Added iMessage/BlueBubbles example; BlueBubbles flagged as the recommended modern iMessage path.

dmPolicy enum kept correct: pairing | allowlist | open | disabled (matches the five good channel pages, not the drifted `ask`).

Preserved the page's strong structural intro: JSON5, strict-root rejection, hot-reload table, `$include`, env substitution, config RPC (apply/patch with baseHash + rate limit).

## api.mdx - coverage

- Added **`POST /v1/responses`** (OpenResponses endpoint, confirmed at `src/gateway/openresponses-http.ts:284`), disabled-by-default, with the files/images/pdf URL-fetch hardening config (`gateway.http.endpoints.responses.*`).
- Marked the RPC method table **NON-EXHAUSTIVE** with a Note pointing to `openclaw gateway call <method>`. Replaced the inaccurate flat table with a grouped, source-verified list extracted from `src/gateway/server-methods/*` (config.*, sessions.*, chat.*, channels.*, cron.*, update.run, device.pair.*/device.token.*, node.*, models.list, doctor.memory.status, browser.request, exec.approval(s).*, secrets.*, skills.*, tts.*/talk.*, wizard.*).
- **Corrected** the prior table's invented method names: `gateway.status`/`gateway.call`/`health.probe`/`tools.invoke`/`logs.tail` were partly wrong. `gateway status|health|probe` are CLI helpers over the handshake, not RPC methods - documented as such in a Note. `tools.invoke` is HTTP-only (`POST /tools/invoke`). `logs.tail` confirmed real and kept.
- Pairing/devices RPCs corrected to `device.pair.*` and `device.token.*` (not `pairing.*`/`devices.*`); nodes to `node.*`.
- Added control-UI HTTP surface note + `gateway.http.securityHeaders.strictTransportSecurity`.
- Kept the accurate WS handshake / protocol-3 / deviceToken / auth-modes / config-RPC-rate-limit content. Added `none` auth mode row.

### Unconfirmed / intentionally generic

- `/v1/responses` request body shown with a single `input` string example (the OpenAI Responses shape); full field set deferred to the endpoint - kept minimal and accurate rather than inventing fields.

## hooks-catalogue.mdx - corrections (minimal)

Verified each event/emoji against `src/hooks/bundled/<name>/HOOK.md`:

- **session-memory**: events corrected to `command:new` + `command:reset` (was only `command:new`); writes-to path corrected to `<workspace>/memory/YYYY-MM-DD-slug.md`. Emoji 💾 confirmed.
- **bootstrap-extra-files**: event `agent:bootstrap` confirmed; config example corrected to the real shape (`hooks.internal.entries.<name>.paths`, with `hooks.internal.enabled` as a sibling - HOOK.md shows `paths` not nested under `config`). Emoji 📎 confirmed.
- **command-logger**: event corrected from `command:*` to `command`. Emoji 📝 confirmed.
- **boot-md**: event corrected from `gateway:start` to `gateway:startup`; requires `workspace.dir` + `hooks.internal.enabled`. Emoji 🚀 confirmed.
- Added `openclaw hooks update <name>` to the CLI block (and `info`/`check` ordering tidied).
- Removed the prior reference to a non-exported `HookContext` type in the "Writing a hook" pointer (kept the link to /developers/hooks).

## Cross-page notes

- All internal links are root-relative without `.md`/`.mdx`.
- Australian English (colour, summarise, initialise, behaviour).
- Markdown-table inline-code `|` escaped as `\|`; `<...>` inside inline code in tables matches the existing site's proven-building convention (no `\<` needed - existing live pages use the same pattern).
- The literal `rm` token (`cron rm`) is present and correct in cli.mdx - it tripped a local shell-guard during authoring, worked around via a generator; final file content is correct.

## Anything still to verify by a human/build

1. Run the Mintlify build on these four pages to confirm no MDX parse errors (angle-bracket convention matches existing pages, so low risk).
2. Confirm anchor slugs used in cross-links resolve: `/reference/cli#openclaw-hooks`, `/reference/config#hooks-incoming-webhooks-and-lifecycle-hooks` (Mintlify auto-slug from headings - the config heading "## `hooks` - Incoming webhooks and lifecycle hooks" should slugify to that anchor; verify in build).
3. `openclaw secrets migrate` is referenced in `docs/cli/index.md` command tree but its exact flags were not enumerated - documented at synopsis level.
