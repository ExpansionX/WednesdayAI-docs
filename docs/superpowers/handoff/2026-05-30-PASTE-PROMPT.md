# Paste-ready prompt for the WednesdayAI-docs session

Open a Claude Code session with working directory `/data/Code/WednesdayAI-docs`, then paste:

---

Implement PR 1 of the docs brand + structure refresh. Everything you need is already in this repo:

- Plan: `docs/superpowers/handoff/2026-05-30-PR1-structure-brand-PLAN.md`
- Design spec: `docs/superpowers/specs/2026-05-30-docs-brand-structure-refresh-design.md`
- Ready-to-copy artifacts in `docs/superpowers/handoff/`:
  `DOCS_JSON_EXACT.json`, `STYLE_CSS_EXACT.css`, `LOGO_LIGHT.svg`, `LOGO_DARK.svg`, `FAVICON.svg`

We are already on branch `feat/docs-json-brand-refresh`.

Do this:
1. Read the plan and follow its steps exactly: copy the five artifacts into place
   (`docs.json`, `style.css`, `assets/logo-light.svg`, `assets/logo-dark.svg`, `assets/favicon.svg`),
   stop tracking and delete the old `mint.json`, and make sure the `assets/brand-source/` staging
   folder is not shipped (untrack+delete it, or gitignore it).
2. Run Mintlify locally (`mint dev`) and verify with Playwright that the four audience tabs
   (Administrators, Users, Developers, Reference) render with their sidebars, that dark mode is
   purple-slate not black, and that Space Grotesk/Inter + the brick-W logo are applied. Screenshot
   light and dark.
3. Commit in the two grouped chunks named in the plan, push, and open PR 1 against `main` with the
   title and body from the plan, including the before/after screenshots.

The root cause being fixed: the repo used the deprecated `mint.json` schema, which the current
Mintlify platform ignores for tab rendering - so the User/Admin/Developer tabs never appeared. The
new `docs.json` schema restores them, and the brand theme replaces the basic default Mintlify look.

After PR 1 is open, stop and report back - PR 2 (content enrichment) starts with a separate audit.

---
