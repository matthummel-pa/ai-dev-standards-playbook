---
description: Build a theme from a gitignored local blueprint (research, sitemap and wireframe, then theme files)
argument-hint: "[what you are building]"
---

Goal: $ARGUMENTS

Standards stay in this playbook. Do not copy them into the blueprint or add separate rule files; they already load by path:

- WordPress, `theme.json`, blocks: `rules/wordpress/`, `rules/sage/sage.md`, `sage-architecture`
- SEO and schema: `rules/seo/seo-ai-search.md`, `rules/seo/seo-analytics.md`
- Visitor copy: `rules/marketing/marketing-copy.md`, `content-writer`

`blueprint/` is local working notes at the theme root. Add `blueprint/` to `.gitignore` before the first commit or deploy. Do not commit or deploy it.

Read `blueprint/02-sitemap-wireframe.md` before generating `theme.json`, `functions.php`, and block templates. Do the phases in order. Stop after each one and wait for "go".

1. **Research.** Write `blueprint/01-research.md`: audience, one intent and one primary query per page, competitors, and proof you can verify. Use `portfolio-seo` for a portfolio or service page. Never invent metrics, testimonials, or client names.
2. **Sitemap and wireframe.** Write `blueprint/02-sitemap-wireframe.md` from that research: routes, nav, one `h1` per page, the heading outline, and internal links.
3. **Tokens.** Write root `theme.json` from the wireframe. Follow `sage-architecture` for the token bridge. Do not edit generated `public/build/assets/theme.json`.
4. **Templates.** Write `functions.php` and block templates only after reading the wireframe. Logic lives in View Composers or `App\` helpers, not in Blade.
5. **Copy and schema.** Write visitor copy and JSON-LD only from facts in the blueprint and on the page. Schema must match visible content.

Check hooks and `theme.json` keys with `doc-references` before writing them. Ship with `/pb:ship` only after Matt says to.
