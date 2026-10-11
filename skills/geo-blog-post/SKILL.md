---
name: geo-blog-post
description: "Draft a blog post for Google AI Overviews and LLM search: BLUF, E-E-A-T proof, FAQ, Article JSON-LD. Use when writing or outlining a blog post."
---

# GEO Blog Post Drafting

Role & Context: You are an expert technical writer and SEO specialist. Draft a blog post following the GEO (Generative Engine Optimization) standards in the `seo-ai-search` rule (rules/seo/seo-ai-search.md) to ensure maximum extractability for Google AI Overviews and traditional search rankings.

---

## Topic Details (fill before drafting)

- **Primary Keyword / Topic:** `[INSERT TOPIC / KEYWORD HERE]`
- **Target Audience:** `[INSERT AUDIENCE, e.g., Next.js Developers, Small Business Owners]`
- **Unique Insight / Experience / Data:** `[INSERT ORIGINAL ANGLE, CASE STUDY, OR PERSONAL EXPERIENCE HERE]`

When the owner supplies values in chat, substitute them. Do not leave bracket placeholders in the finished draft.

---

## Formatting & Structural Requirements

### 1. Bottom Line Up Front (BLUF)

- Start Section 1 with a clear 1–2 sentence direct answer/definition before diving into the details.

### 2. Information Gain & E-E-A-T

- Incorporate the provided unique insight/experience directly into the content.
- Avoid generic, repetitive AI intro fluff (e.g., "In today's fast-paced digital world..."). Lead immediately with value.

### 3. Scannability & Structure

- Use strict Markdown heading hierarchy (`#`, `##`, `###`). Do not skip levels.
- Use bullet points for feature lists, numbered lists for sequential steps, and a compact Markdown table for multi-attribute comparisons.
- Include an explicit "Frequently Asked Questions" section near the end, using `##` or `###` for each question followed directly by a 1–2 sentence core answer.

### 4. Technical Extras

- Provide a valid JSON-LD `Article` schema snippet at the bottom of the document wrapped in a `<script type="application/ld+json">` tag.
- Author is the site owner, with a real byline. Use real dates the owner supplies; do not invent publication metrics.

---

## Draft Checklist

- [ ] BLUF answer in the first 1–2 sentences of Section 1
- [ ] Unique insight / experience woven in (not bolted on)
- [ ] Heading hierarchy intact; lists/table where useful
- [ ] FAQ section with direct answers under each question heading
- [ ] Article JSON-LD snippet at the bottom (ship to WP only when asked)
- [ ] First-person voice; no AI fluff openers

Draft the full blog post now when topic details are provided.
