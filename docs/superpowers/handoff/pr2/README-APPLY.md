# PR 2 - Apply & Open (content enrichment + provider move)

Run in a Claude session (or shell) opened on the **WednesdayAI-docs repo root**
(`/data/Code/WednesdayAI-docs`). Branch `feat/content-enrichment` already exists with the
gap audit committed; check it out.

Everything here is **already build-validated**: all 56 pages + the new `docs.json` were
assembled into a throwaway Mintlify project and `mint dev` compiled them with **zero parse
errors**, and the provider-move + new pages were confirmed rendering via Playwright. Your job
is mechanical: apply, delete one superseded directory, build once more, and open the PR.

## What this PR does

1. **Enriches + corrects all 42 existing pages** from the core `docs/` folder, fixing real
   inaccuracies (fictional SDK API, wrong provider config shape, invented CLI commands,
   `dmPolicy` enum drift, broken links, stale notes). See the four `MANIFEST-*.md` files.
2. **Adds ~14 new pages**: admin/{multi-gateway,secrets,sandboxing,doctor},
   admin/channels/{imessage,msteams,matrix}, users/{memory,files}, users/pairing/imessage,
   developers/{analysis-runtime,agent-signals}, developers/plugins/{manifest,publishing}.
3. **Moves the 7 provider pages** from the Developers tab to the Administrators tab
   (`developers/providers/*` -> `admin/providers/*`) and updates `docs.json` nav accordingly.

## Steps

1. Check out `feat/content-enrichment`.
2. From repo root, run the apply script:

       bash docs/superpowers/handoff/pr2/apply-pr2.sh

   It copies all staged pages into place and installs the new `docs.json`.

3. **Delete the superseded provider directory.** The 7 provider pages now live under
   `admin/providers/`; the old `developers/providers/` directory must be removed from the repo
   (untrack it in git and delete it from disk - a standard `git` directory removal). The apply
   script intentionally does not do this for you.

4. Stage everything:

       git add -A

5. **Verify the build** (this is the gate - do not skip):

       mint dev

   Confirm: no parse errors in the CLI output; the four tabs render; provider pages appear under
   **Administrators -> AI providers**; the new pages appear in their groups; spot-check a couple
   of rewritten pages (developers/agent-tools, admin/security) in the browser.

6. **Commit** in grouped chunks (suggested):
   - `fix(docs): correct SDK API, provider config, CLI commands, dmPolicy, broken links`
   - `feat(docs): enrich admin/users/developers/reference pages from core docs`
   - `feat(docs): add new pages (multi-gateway, secrets, sandboxing, memory, files, ...)`
   - `refactor(docs): move provider pages to Administrators tab + update nav`

   (Or one squashed commit if you prefer - the PR is the review unit.)

7. Push `feat/content-enrichment` and open **PR 2** with the body in `PR-BODY.md`.

## Notes / things to confirm at review (from the manifests)

- **Inbound voice-note transcription** (users/files, users/messaging) is phrased conditionally
  ("on channels that support it") - confirm against the audio/talk docs if you want it definite.
- **WhatsApp QR expiry** time was softened to "expires quickly" (the old "20 seconds" was
  unverified) - restore a number if you can confirm it.
- **Plugin discovery precedence**: pages follow the source order (config paths first, then
  workspace > global > bundled), which corrected the audit's phrasing.
- A few CLI flag sets that upstream does not enumerate are documented at synopsis level with a
  "see `openclaw <cmd> --help`" pointer (e.g. `secrets migrate`).
- The per-tab `MANIFEST-*.md` files in this folder list every file authored and any per-page
  uncertainties.

## After merge

Optional follow-ups noted by the authors (not in this PR): worked-example pages for
`registerHttpRoute`/`registerGatewayMethod`/`registerCommand`; a fuller channel catalogue
(~20 channels) on admin/channels/index.
