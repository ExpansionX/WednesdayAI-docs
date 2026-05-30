# PR 2 - Users tab staging manifest

Authored against `WednesdayAI-core/docs/` (fork base v2026.3.2) plus the PR2 gap audit.
All pages keep `audience: user` frontmatter. Australian English, "you" voice, root-relative links without extension. Operator/config detail kept out (lives in Admin tab).

## Files in this manifest (users tab only)

### Edited (enriched + corrected)
- `users/what-is-wednesdayai.mdx` - added memory, scheduling, file/voice as headline capabilities; added Memory + Files cards.
- `users/messaging.mdx` - added memory-vs-context section, file/image/voice sharing, group mention behaviour, corrected `/think` levels to `off|minimal|low|medium|high|xhigh|adaptive`, inbound batching/debounce note. Replaced stale `/new claude-3-5-sonnet` example with alias + `anthropic/claude-opus-4-6`.
- `users/commands.mdx` - added `/context`, `/usage cost|full|off`, `/reasoning on|off|stream`, `/queue`, group `/activation mention|always`, the `:` separator (`/think: high`); fixed `/think` level set; flagged `!`/`/bash` as disabled-by-default (Warning); noted Discord `/voice` vs `/tts`.
- `users/troubleshooting.mdx` - added "bot does not respond in a group" entry; softened localhost/CLI steps to "ask your admin / if you self-host"; replaced stale model names with `/model` picker + `anthropic/claude-opus-4-6`; added "Model is not allowed" error row.
- `users/tools/index.mdx` - replaced generic prose with real tool inventory, each with a "what you can ask" line: web search (Brave), web fetch, code/shell, file read/write, browser, image, pdf, memory, cron/scheduling, message (send to other chats), sessions_spawn (sub-task), node/device actions. Removed the Perplexity claim (core `web_search` is Brave only - confirmed in `docs/tools/index.md` and `docs/tools/web.md`).
- `users/pairing/first-channel.mdx` - iMessage card now points at the live page; added "what if I get a pairing code?" section (8-char code, ~1h expiry).
- `users/pairing/whatsapp.mdx` - added "in a group? mention/ping the bot" section + group troubleshooting accordion. Converted steps to <Steps>. Softened QR expiry wording (source says expiry without a fixed 20s figure).
- `users/pairing/telegram.mdx` - added native slash-commands section (type `/` in chat). Converted to <Steps>.
- `users/pairing/discord.mdx` - fixed `/think` ("set reasoning depth", not toggle); documented `/voice` (Discord reserves `/tts`); converted to <Steps>; expanded command table.

### New
- `users/pairing/imessage.mdx` - sourced from `channels/imessage.md` + `channels/bluebubbles.md` + `channels/pairing.md`; user-facing only (no imsg/BlueBubbles config). Covers pairing-mode codes, group mention-by-pattern behaviour, multi-device, attachments link.
- `users/memory.mdx` - durable cross-session memory; sourced from `concepts/memory.md`. Memory-vs-context, "ask the bot to remember", recall/update/forget, what not to store, group privacy note. Kept implementation detail (Markdown files, vector index, memoryFlush) OUT.
- `users/files.mdx` - sharing files/images/voice notes; sourced from `tools/index.md` (image tool) + `tools/pdf.md`. Includes per-channel support summary and TTS reply note.

## Required docs.json navigation changes (NOT done here - content only)

The three new pages must be added to the Users tab nav in `docs.json`. Suggested placement:

- `users/pairing/imessage` -> "Getting started" group, after `users/pairing/discord`.
- `users/memory` -> "Talking to your AI" group, after `users/commands`.
- `users/files` -> "Talking to your AI" group (or its own), after `users/memory`.

## Accuracy decisions / sources

- Model ids: used current ids from `concepts/model-providers.md` (`anthropic/claude-opus-4-6`, `anthropic/claude-sonnet-4-5`, `openai/gpt-5.2`) and the `opus` alias pattern; otherwise let `/model` (picker) stand in. Removed all `claude-3-5-sonnet` / `gpt-4o`.
- `/think` levels: full set `off|minimal|low|medium|high|xhigh|adaptive` per `tools/thinking.md`. Noted `adaptive` is provider-managed default on newer Claude, `xhigh` is model-limited.
- `/tts` vs `/voice`: confirmed in `tools/slash-commands.md` (Discord native command is `/voice`).
- `!`/`/bash`: `commands.bash` defaults `false` and needs `tools.elevated` allowlists -> flagged as off by default.
- Group behaviour: default activation is `mention` per `channels/group-messages.md` and `channels/imessage.md`.
- Pairing codes: 8 chars, uppercase, expire ~1 hour, capped at 3 pending/channel per `channels/pairing.md`. Did not surface the 3-pending cap to users (operator detail).
- Inbound debounce default 2000ms per `concepts/messages.md`; described as "batched within a few seconds" rather than a fixed number to keep it user-friendly and avoid drift if defaults change.

## Uncertainties / things to double-check before merge

1. **Voice notes inbound (STT):** `files.mdx` says voice notes are transcribed and answered "on channels that support it". `tools/index.md`/`pdf.md` cover image/PDF clearly, but I did not find an explicit per-channel inbound voice-transcription matrix in the sources I read. Phrased conditionally ("on channels that support it"). Verify against a voice/STT doc (e.g. `talk`/`audio` config) before publishing if you want to be more definite.
2. **WhatsApp QR expiry time:** previous page said 20s; `channels/pairing.md` does not state the WhatsApp QR window. I softened to "expire quickly" rather than asserting a number. Confirm the real value if you want it back.
3. **docs.json nav:** the three new pages will 404 in nav until added (see section above). Content links between pages already use the final paths.
4. **`/users/tools/index` vs `/users/tools`:** internal links use `/users/tools/index` to match the existing docs.json entry. If nav is later simplified to `/users/tools`, update the cross-links in `what-is-wednesdayai.mdx`, `files.mdx`, `first-channel.mdx`.
