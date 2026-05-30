# PR 1 - Structure (docs.json) + Brand Refresh - Implementation Plan & Hand-off

> Execute in a Claude session opened **directly on the `WednesdayAI-docs` repo**
> (`/data/Code/WednesdayAI-docs`). Design rationale:
> `docs/superpowers/specs/2026-05-30-docs-brand-structure-refresh-design.md`.
> Branch already created: **`feat/docs-json-brand-refresh`**.
> Exact file contents are in THIS folder as ready-to-copy artifacts.

## Context (the why)

The site shows no Users/Admins/Developers tabs because the repo configures Mintlify via the
**deprecated `mint.json`** schema, which the current platform ignores for tab rendering. The 42
content pages already exist, split across `admin/ users/ developers/ reference/`. The fix: migrate
to **`docs.json`** (new nested `navigation.tabs[].groups[].pages` schema) and apply the WednesdayAI
brand (indigo/violet/pink, Space Grotesk + Inter, brick-W logo, slate dark mode) via `docs.json`
fields + a custom `style.css`. PR 1 is pure config/theme - no content moves.

## Artifacts in this folder (copy these into place)

| Artifact file            | Copy to (repo root unless noted) |
|--------------------------|-----------------------------------|
| `DOCS_JSON_EXACT.json`   | `docs.json`                       |
| `STYLE_CSS_EXACT.css`    | `style.css`                       |
| `LOGO_LIGHT.svg`         | `assets/logo-light.svg`           |
| `LOGO_DARK.svg`          | `assets/logo-dark.svg`            |
| `FAVICON.svg`            | `assets/favicon.svg`              |

Quick apply (from repo root):

    cp docs/superpowers/handoff/DOCS_JSON_EXACT.json docs.json
    cp docs/superpowers/handoff/STYLE_CSS_EXACT.css style.css
    cp docs/superpowers/handoff/LOGO_LIGHT.svg assets/logo-light.svg
    cp docs/superpowers/handoff/LOGO_DARK.svg  assets/logo-dark.svg
    cp docs/superpowers/handoff/FAVICON.svg    assets/favicon.svg

## Steps (in order)

1. Check out `feat/docs-json-brand-refresh`.
2. Copy the five artifacts into place (table above).
3. Stop tracking the deprecated `mint.json` (delete the file and stage its removal). It is fully
   replaced by `docs.json`; leaving both confuses the build.
4. The staging dir `assets/brand-source/` holds source PNGs and must NOT ship. Untrack and delete
   that folder, or add the path `assets/brand-source/` to `.gitignore`. The PNGs were staged only in
   case you prefer a photographic mark; the SVGs are the crisp default for nav chrome.
5. Confirm `docs.json` references `style.css` (it sets `"css": "/style.css"`). Harmless if the
   running Mintlify version also auto-loads a root `style.css`.
6. Verify locally (next section). Fix anything that does not render.
7. Commit in grouped chunks (use `scripts/committer` if present):
   - feat(config): migrate mint.json to docs.json with audience tabs
   - feat(brand): apply WednesdayAI brand theme, brick-W assets, custom CSS
8. Push and open **PR 1** against `main`:
   - Title: Docs: migrate to docs.json (audience tabs) + WednesdayAI brand refresh
   - Body: root cause (legacy mint.json) + two visible fixes (tabs render; brand applied), with
     before/after Playwright screenshots.
   - Add CHANGELOG + dev log if the docs repo follows that convention (mirror core repo section 16).

## Verification (do not skip)

Mintlify local dev from repo root:
- Install CLI if absent: `npm i -g mint`  (or mintlify, per repo standard).
- `mint dev`  serves http://localhost:3000 by default.

Playwright MCP:
- Confirm **four tabs**: Administrators, Users, Developers, Reference - each with its sidebar groups.
- Dark mode: background reads **purple-slate `#0f172a`** (not black); primary indigo; headings
  Space Grotesk; body Inter; brick-W logo present.
- Spot-check one page per tab loads with the correct sidebar.
- Screenshot light + dark, full page, for the PR.

If `mint dev` errors on the schema, run the CLI with no args for validation output and reconcile
against https://mintlify.com/docs.json. The `theme` must be supported
(mint, maple, palm, willow, linden, almond, aspen); the artifact uses `mint`. Legacy `prism` does
NOT apply to the new schema.

## Definition of done

- [ ] docs.json present, mint.json removed.
- [ ] Four audience tabs render with full sidebars (Playwright-verified).
- [ ] Brand colours, Space Grotesk/Inter fonts, brick-W logo + favicon applied light & dark.
- [ ] style.css polish visible (card hover, indigo focus, code-block theme), reduced-motion safe.
- [ ] No content .mdx files moved or renamed.
- [ ] assets/brand-source/ not shipped.
- [ ] PR opened with before/after screenshots.

## Notes on style.css selectors

Mintlify class names vary by version. `STYLE_CSS_EXACT.css` uses defensive attribute selectors
(`a[class*="card"]`, `[aria-current="page"]`). After `mint dev` is up, inspect the DOM; if a polish
rule does not apply, adjust that one selector to the real class name. Brand intent is commented per
rule.

---

# PR 2 (later) - Content enrichment

After PR 1 merges: produce a per-page gap audit mapping thin docs-site pages to richer sources in
the core repo `docs/` folder (`/data/Code/WednesdayAI-core/docs/`, 743 md files). Get user approval
on the audit, then enrich tab-by-tab (admin -> users -> developers -> reference), each a reviewable
commit. Australian English, brand tone (direct, "you/we"), accuracy verified against source.
