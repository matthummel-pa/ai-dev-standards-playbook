---
name: content-writer
description: "Editorial voice, readability and multi-pass editing for site copy, posts and emails. Use when writing or editing visitor-facing text, or when asked to edit someone's writing (adds Editor's Notes)."
---

# Cursor AI Rule File: The Master Content Writer & Editor

This file establishes strict editorial guidelines, formatting standards, and readability guardrails. Generated text must be engaging, grammatically clean, consistent in tone, and easy to scan on a phone.

---

## 1. Tone, voice, and consistency

### Core objective

Uniform, authoritative, approachable voice. No jarring shifts in person or style.

### Rules and guardrails

- **Perspective:** first-person singular (**I / my**). Never mix with **we / our** in the same page or post, except when quoting a team or referring to WordPress/core (“we” as the platform).
- **Brand vocabulary:** shops, agencies, developers, learners, WordPress, plugins, web apps. GitHub is GitHub (not “our repo farm”).
- **Formatting uniformity:**
  - **Headings:** Title Case for standalone H1/H2 labels; sentence case for H3 and for any heading that is a full sentence or question (`Do you take agency overflow?`).
  - **UI:** sentence case for buttons, nav, and form labels, matching the live theme.
  - **Punctuation:** Oxford comma. American-style periods inside quotation marks ("like this.").

---

## 2. Readability and engagement

### Core objective

Write for digital scanners. Make value easy to grab on a phone.

### Rules and guardrails

- **The 3-sentence wall:** no paragraph over 3–4 sentences. Split walls.
- **Sentence variance:** mix short punches (under 10 words) with medium sentences. No run-ons.
- **Formatting anchors:** bold only the few terms that matter (field keys, product names). Not every other word.
- **Punchy lists:** one fragment or short sentence per bullet. No multi-sentence bullets.
- **Active voice first:** rewrite passive into active when it still sounds like the owner (“I built the form,” not “The form was built”).

---

## 3. Readability and editing workflow

When asked to review, edit, or write content, run this multi-pass audit. Edit **field defaults or post copy**, not Blade chrome, unless the string is UI chrome.

1. **Pass 1: Clarity and fluff**
   - Cut filler and jargon: “use” not “utilize”; “to” not “in order to”; “works” not “impactful.”
2. **Pass 2: Grade level**
   - Target Flesch–Kincaid **grade 7–8**. Conversational, not academic. Keep accurate technical nouns (WordPress, Vite, Sage).
3. **Pass 3: Structure**
   - Hierarchy is Blade/HTML (`h1`–`h3`), not Markdown `#` in PHP fields. No two consecutive sections that repeat the same idea.
4. **Feedback delivery**
   - When the owner asks you to **edit their writing**, do not only paste the rewrite. Add a short **Editor’s Notes** bullet list of why (e.g. “Split paragraph 2 for mobile; dropped we/our; Oxford comma in the shop list”).
