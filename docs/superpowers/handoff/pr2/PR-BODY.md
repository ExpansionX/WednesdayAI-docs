## Summary

PR 2 of the docs refresh: a major **content correctness + enrichment** pass across all four
audience tabs, plus ~14 new pages and a tab move. Where PR 1 fixed structure and brand, this PR
fixes what the pages actually *say* - several contained content that did not match our fork
(openclaw v2026.3.2).

## Why

A per-tab audit against the core `docs/` folder (743 files) and live source found the docs were
not merely thin - several pages were **factually wrong**:

- Developer SDK pages documented a **fictional API** (`ToolDefinition`, `inputSchema`, `run()`,
  `HookContext`) that does not exist in `openclaw/plugin-sdk`.
- All provider pages used the **wrong model-config shape** (bare string instead of
  `{ primary: "anthropic/..." }`) and a non-existent `openclaw login` auth command.
- The CLI reference **invented commands** (`skills enable`, `devices revoke <id>`,
  `cron --schedule`) and omitted ~22 real ones.
- `dmPolicy` used a wrong enum (`ask`); ~6 internal links were broken; a stale note claimed
  channel guides were "being written".

## Changes

**Corrected + enriched all 42 existing pages** from authoritative core docs/source:
- **Developers**: rewrote `agent-tools`, `sdk/index`, `hooks`, `channel-adapters` around the real
  `api.registerTool` / `api.on` / `ChannelPlugin` adapter surface; expanded `overview`,
  `contributing`.
- **Reference**: `cli` now covers all ~45 commands (was ~22) and removes the invented ones;
  `config` documents ~36 root keys (was ~12); `api` adds `POST /v1/responses` and marks the RPC
  table non-exhaustive; `hooks-catalogue` corrected against the bundled `HOOK.md` files.
- **Users**: enriched the thin user pages - real tool inventory, memory-vs-context, file/voice
  sharing, group-mention behaviour, correct `/think` levels and command list.
- **Admin**: deepened `security` (mDNS, prompt-injection, sandboxing, control-plane risk),
  `configuration` (secrets, precedence), `remote-access` (TLS/reverse-proxy), `upgrading`,
  `troubleshooting`; fixed the `dmPolicy` enum and stale/broken channel index.

**~14 new pages**: admin/{multi-gateway, secrets, sandboxing, doctor},
admin/channels/{imessage, msteams, matrix}, users/{memory, files}, users/pairing/imessage,
developers/{analysis-runtime, agent-signals}, developers/plugins/{manifest, publishing}.

**Tab move**: the 7 provider pages move from **Developers** to **Administrators** (they are
operator/config content), with `docs.json` nav updated.

## Verification

Every page was assembled into a throwaway Mintlify project and built with `mint dev` - **zero
parse errors** across all 56 pages with the new nav. Provider-move and new pages confirmed
rendering via Playwright. One MDX issue found during validation (a bare `<url>` placeholder) was
fixed before this PR.

## Impact

Documentation only - no product code. Australian English, brand tone throughout. Internal links
reconciled. The provider-page move changes their URLs (`/developers/providers/*` ->
`/admin/providers/*`); cross-links updated accordingly.

## Benefits

Readers get accurate, copy-pasteable commands and config; developers get a real SDK reference;
operators get the full CLI/config surface and several previously-missing admin guides.

**Breaking changes:** provider page URLs changed (see Impact). No product/config changes.
