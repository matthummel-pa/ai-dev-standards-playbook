---
name: doc-references
description: "Canonical reference docs for Matt's stack (WordPress, Roots, Tailwind, web platform, TypeScript, React/Next/Node/Nest, accessibility, SEO) and the rule for verifying against them. Use before writing code that touches an API you have not checked this session, when a hook, class, CSS feature or browser-support question comes up, or when asked which source to trust."
---

# Reference docs: where to verify

Training data goes stale. Before shipping code that depends on an API signature, a hook's parameters, a CSS feature, or a framework convention, check the official source below with `WebFetch`. Prefer these over blog posts, Stack Overflow, and memory. Cite the page you used in the PR or reply.

## How to use this skill

1. Find the row for the thing you are unsure about.
2. `WebFetch` the **entry point** (or a deeper page from it) and read only what you need.
3. If the official doc disagrees with what you were about to write, the doc wins. Say so in one line.
4. Don't fetch for things that cannot have changed (how `for` loops work, what a nonce is). Do fetch for anything versioned: WordPress hooks, Sage/Acorn internals, Tailwind v4 syntax, Next.js routing, Node APIs, browser support.

Project `.claude/settings.json` (from `templates/project/`) already allows `WebFetch` on every domain listed here, so no permission prompt.

---

## WordPress and Roots (default stack)

| Source | Entry point | Use it for |
| --- | --- | --- |
| WordPress Developer Resources | https://developer.wordpress.org/ | The only source for core hooks, functions, classes, deprecations and return types. Sub-sites: `/reference/` (code reference), `/block-editor/` (Gutenberg, `block.json`, `@wordpress/*`), `/rest-api/`, `/coding-standards/`, `/plugins/`, `/themes/`. |
| Roots (Sage, Acorn, Bedrock, Trellis) | https://roots.io/ | Sage 10/11 theme structure, Blade, Composers, `vite.config.js`, Acorn service providers. |
| Bedrock | https://roots.io/bedrock/ | 12-factor WordPress layout, Composer-managed core/plugins, `.env`, `config/environments/`. |
| WP Bones — WordPress environments | https://wpbones.com/docs/getting-started/wordpress-environments | Reference for how `WP_ENVIRONMENT_TYPE` / local-staging-production setups are handled. WP Bones itself is a Laravel-style **plugin** framework; it is not part of the Sage/Bedrock stack, so borrow the environment ideas, not the framework. |
| Freemius Help Center | https://freemius.com/help/ | Monetizing a plugin or theme: SDK setup (`fs_dynamic_init`), plans and pricing, licensing, trials, free/pro builds, checkout, and the Developer Dashboard. Use it for Freemius behavior; the `wp-freemius` skill covers the common SDK patterns. |
| Tailwind CSS | https://tailwindcss.com/ | v4 `@theme`, `@custom-variant`, `@utility`, Vite plugin. v3 `tailwind.config.js` answers are usually wrong for v4; check before answering. |

## Web platform (HTML, CSS, JS, browser support)

| Source | Entry point | Use it for |
| --- | --- | --- |
| MDN Web Docs | https://developer.mozilla.org/ | First stop for any HTML element, CSS property, Web API or JS built-in. Has browser-compat tables. |
| HTML Living Standard (WHATWG) | https://html.spec.whatwg.org/multipage/ | Settling arguments MDN leaves open: parsing rules, element content models, form semantics. |
| W3C | https://www.w3.org/ | CSS and accessibility specs (WCAG 2.1/2.2, ARIA). Use for normative wording, not tutorials. |
| ARIA Authoring Practices Guide | https://www.w3.org/WAI/ARIA/apg/ | Keyboard and ARIA patterns for widgets (menus, tabs, dialogs, comboboxes). Copy the pattern, don't invent one. |
| web.dev | https://web.dev/ | Core Web Vitals (LCP, INP, CLS), performance and PWA guidance from the Chrome team. Use for the 90+ mobile CWV target. |
| Modern CSS Solutions | https://moderncss.dev/ | Practical modern CSS patterns (container queries, `:has()`, fluid type, grid). Good for "is there a no-JS way". |
| Can I use | https://caniuse.com/ | Browser support for a feature before relying on it. Check this for anything newer than ~2022. |
| cssdb | https://cssdb.org/ | Stage of upcoming CSS features and what PostCSS Preset Env polyfills. |
| JavaScript.info | https://javascript.info/ | Plain-language explanations of JS language features and DOM. Tutorial, not a spec. |

## TypeScript, React, Node (non-WordPress and headless work)

| Source | Entry point | Use it for |
| --- | --- | --- |
| TypeScript | https://www.typescriptlang.org/docs/ | Types, `tsconfig` options, utility types, narrowing. |
| React | https://react.dev/ | Hooks, Server Components, current recommended patterns. Old `reactjs.org` advice is outdated. |
| Next.js | https://nextjs.org/docs | App Router, routing, data fetching, caching, image optimization. Versions change often; read the version banner. |
| Node.js | https://nodejs.org/docs/ | Built-in modules, `fs`/`path`/`fetch`, release schedule and LTS status. |
| NestJS | https://docs.nestjs.com/ | Modules, providers, controllers, guards, pipes when building a Nest API. |

## SEO

| Source | Entry point | Use it for |
| --- | --- | --- |
| Ahrefs | https://ahrefs.com/ | Keyword and backlink research; `/blog/` and `/seo/` for how-to guides. Treat traffic and difficulty numbers as estimates, and never quote them as a client's own metrics. |

## Staying current (not for verification)

These are reading lists, not reference docs. Don't cite them as the source for an API fact.

| Source | Entry point | Use it for |
| --- | --- | --- |
| Frontend Tools (gamtiq) | https://github.com/gamtiq/frontend-tools | Curated list of front-end tooling when choosing a library. |
| JavaScript Weekly | https://javascriptweekly.com/ | Weekly JS news. |
| CSS Weekly | https://cssweekly.co/ | Weekly CSS news. |

---

## Precedence when sources disagree

1. The project's own code and `CLAUDE.md` (match what's already there).
2. The official doc for that tool (table above).
3. The spec (WHATWG, W3C) for platform behavior.
4. Everything else.

## What not to do

- Don't paste large passages from any of these sites into code comments, docs or replies. Link and paraphrase.
- Don't treat a newsletter or GitHub list as proof something is production-ready. Check `caniuse` and the official doc.
- Don't fetch a site's homepage and stop. Go to the specific reference page and read the signature or the compat table.
