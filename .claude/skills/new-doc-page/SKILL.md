---
name: new-doc-page
description: Create a new Mintlify doc page — writes the MDX file and registers it in docs.json navigation. Use when adding any new page to the docs site.
disable-model-invocation: false
---

When creating a new doc page, always complete BOTH steps. Skipping either breaks the site.

## Step 1: Determine placement

Ask (or infer from context):
- Which tab does this page belong to? (`admin/`, `users/`, `developers/`, or `reference/`)
- Which group within that tab?
- What is the page slug (the path without `.mdx`, e.g. `admin/channels/signal`)?
- What is the page title and description?

## Step 2: Create the MDX file

Write the file at `<slug>.mdx` with this frontmatter:

```mdx
---
title: "<title>"
description: "<one-line description>"
---
```

Use Mintlify components (`<Warning>`, `<Tip>`, `<Note>`, `<Card>`, etc.) — no raw HTML. Icons use Lucide.

## Step 3: Register in docs.json

Open `docs.json` and add the slug string to the correct `navigation.tabs[*].groups[*].pages` array. The slug must match the file path exactly (no `.mdx` extension, forward slashes, relative to repo root).

## Step 4: Verify

Tell the user to run `mintlify dev` and navigate to the new page to confirm it appears in the nav and renders correctly.
