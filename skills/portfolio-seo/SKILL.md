---
name: portfolio-seo
description: "Portfolio and service-site SEO: dual audience (shops and developers), skill-first keywords, case-study layout, strict on-page limits. Use when writing or auditing portfolio, service or project pages."
---

# Portfolio SEO playbook

This rulebook balances friendly shop-owner copy with technical precision. Use it to audit and write content that can rank for WordPress and web craft, show real work, and stay readable for both shops and developers.

---

## Dual-audience targeting

Structure project write-ups and blog posts so two readers can both get value:

- **Shop / agency (non-tech):** clear outcome, plain words, what they can edit or hand over. No fake metrics.
- **Developer / peer:** stack, repo, snippets, how it ships (Sage, Tailwind, Vite, GitHub).

The home and About **audience doors** already name these people. Do not add a fifth persona.

---

## SEO keyword blueprint

Prefer phrases that match work the owner actually does. Lead with craft, not city.

| Service pillar | Shop intent | Technical intent |
| --- | --- | --- |
| WordPress | `hire a WordPress developer` / custom theme | Sage 11 custom theme, page fields, Vite — not ACF unless the owner asks |
| Web apps | `WordPress site for my shop` | custom frontend (Sage, Tailwind, Blade), plugins, other web apps |
| Power Platform | `automate workflows with Power Platform` | custom connectors / APIs when it fits; it is **not** the main offer |

Do not stuff all three pillars into every H1. One primary phrase per page. Secondary phrases belong in body copy, once or twice.

---

## Content layout (translation layer)

When writing a **post or long project narrative**, use this order. Skip layers that would require fake screenshots or invented results.

### 1. Business hook (top)

- Warm, specific, jargon-light. First person.
- Tangible truth only: what the site is for, who can edit it, that it ships. No “increased sales” unless the owner supplies a real number.
- Analogies are fine if they stay accurate (a database as a filing cabinet).

### 2. Showcase and proof (middle)

- Real URLs, screenshots already in the theme, GitHub, writing.
- Explain *why* a layout or stack was chosen for that shop or project.
- Work cards stay concept + place + stack (`template-projects.blade.php`). Do not turn them into testimonial blocks.

### 3. Code vault (bottom)

- Snippets, repos, or workflow detail for developers.
- Lead with a plain transition, first person, not “Hey fellow devs!” theater. Example: `The implementation is below if you want to copy it.`
- Use the existing Code page / post `pre` styles. Fence language in post HTML (`language-php`, `language-js`), not a new snippet library.

---

## Strict on-page SEO limits

- **Title tags:** under **60 characters**. When setting a document title: `[Service or topic] | Brand` (skill-first; no city stuffing). Short page H1s (`Work`, `About`) stay as they are; do not rename every H1 into a keyword string.
- **Meta descriptions:** under **155 characters**. End with a direct CTA that matches the site (`Say hello`, `See example sites`). First person. Not “See how we automated this workflow.”
- **Location density:** do **not** require a city name on marketing pages. Demo places on Work cards are fine. One personal bio mention is optional, not a ranking tactic.
- **Readability:** paragraphs **3 sentences max** on landing fields (stricter than the general 3–4 in the `content-writer` skill). This file wins on landing length; the content-writer file still wins on grammar, glossary, and I/my.
- **Code blocks:** in posts, set a language on the block so highlight.js can run. In Blade, keep current `<pre class="snippet"><code>`.

---

## Execution

1. Decide whether the change is a **field default**, a **post**, or a **template**. Prefer fields and posts for keyword copy.
2. Apply dual audience without splitting the page into two unrelated sites.
3. Check titles/meta length, paragraph caps, skill-first wording, and “no fake proof” before presenting the edit.
4. When editing the owner’s writing, add **Editor’s Notes** (`content-writer` skill).
