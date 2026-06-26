# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Platform

Mintlify docs site. Config is in `docs.json` (schema, nav tree, theme, icons, fonts). The old `mint.json` name is replaced — `docs.json` is the canonical config.

Preview locally: `mintlify dev` (global CLI, no package.json).

## Content structure

| Directory | Audience |
|-----------|----------|
| `admin/` | Administrators |
| `users/` | End users |
| `developers/` | Plugin/integration developers |
| `reference/` | Config, CLI, hooks, API |
| `assets/` | SVGs and brand images |

All content files are `.mdx`. Frontmatter fields in use: `title`, `description`, `audience`.

## Adding a new page — two-step requirement

Every new page needs **both**:
1. The `.mdx` file at the correct path
2. A matching entry in `docs.json` under `navigation.tabs[*].groups[*].pages`

Missing either step means the page is either unreachable (no nav entry) or breaks the nav (entry with no file). Use the `/new-doc-page` skill to handle both steps together.

## Mintlify components

Use Mintlify MDX components for callouts and layout — not raw HTML. Common ones: `<Warning>`, `<Tip>`, `<Note>`, `<Info>`, `<Card>`, `<CardGroup>`, `<Tabs>`, `<Tab>`, `<Steps>`, `<Step>`, `<Accordion>`, `<AccordionGroup>`, `<CodeGroup>`. Icons use the Lucide library (configured in `docs.json`).

## Core repo relationship

The underlying product lives at `github.com/ExpansionX/WednesdayAI-core`. Docs must stay accurate with that codebase — config keys, CLI flags, hook signatures, SDK exports. Use the `/sync-check` skill to surface stale or missing coverage after core changes.
