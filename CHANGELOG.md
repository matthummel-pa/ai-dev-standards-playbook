# Changelog

All notable changes to the playbook. Format: [Keep a Changelog](https://keepachangelog.com/en/1.1.0/); versions in `VERSION`.

## [1.4.1] - 2026-10-30

### Added
- `skills/doc-references`: Freemius Help Center (https://freemius.com/help/) as the reference for plugin/theme monetization; `freemius.com` added to the project template's `WebFetch` allowlist.

## [1.4.0] - 2026-10-25

### Added
- `skills/sage-project`: start a new Sage 11 theme, or clone, run and branch an existing theme repo locally with WordPress Studio and Vite.
- `scripts/new-theme.sh` (`/pb:new-theme`): `composer create-project roots/sage`, rename, Vite `base` set to `/wp-content/themes/<slug>/public/build/`, project template, install, build, first commit. `--github` creates a private repo; `--no-site` skips Studio.
- `scripts/wp-local.sh` (`/pb:dev`): `doctor`, `up`, `down`, `status`, `use`, `dev`, `clear`, `wp`, `list`, `get <repo>`, `branch <name>`. One Studio site per theme folder; the repo is linked in (junction on Windows), and `branch` makes a worktree per branch and repoints the site at it.
- `scripts/lib-wp.sh`: shared checks. Writes a private `php.ini` when PHP lacks openssl, mbstring, curl, zip or fileinfo (scoop), without touching the global config.

### Fixed
- `scripts/new-project.sh` exited 1 when no template file was skipped, which broke any caller using `set -e`.

## [1.3.0] - 2026-10-24

### Added
- `rules/wordpress/wordpress-stack.md`: default stack, when not to use it, blocks, performance, plugin policy, Git and deploy, testing and QA.
- `rules/frontend/frontend-ux.md`: design tokens, UX states, WCAG 2.2 AA, asset optimization.
- `rules/seo/seo-analytics.md`: search intent, topical authority, technical SEO, schema, AEO, E-E-A-T, GA4, GTM, Bing.
- `rules/marketing/marketing-copy.md`: voice, rule of one, trust and proof, repurposing, social, email.
- `rules/business/business-ops.md`: scopes, client communication, launch checklist, handoff, privacy, docs.
  These five absorb the personal topic files that used to sit in `~/.claude/rules/`. Personal voice, channels and process stay in a private overlay outside this repo.

### Fixed
- `skills/sage-architecture/SKILL.md`: restored the `*` prefixes on two PHPDoc lines that the bullet cleanup had turned into `-`.

### Changed
- Accessibility baseline is WCAG 2.2 AA everywhere (`core.md`, `sage.md` and `frontend-ux.md` were 2.1). `sage.md`: copy line allows blocks as well as fields.
- `rules/seo/seo-ai-search.md` and `skills/growth-design`: name "the site's SEO plugin" instead of a specific plugin.
- `README.md`: rules table lists the new folders.
- Core Web Vitals thresholds spelled out in `seo-analytics.md` (LCP 2.5 s, INP 200 ms, CLS 0.1 at the 75th percentile); canonical URL points to the original publisher; `wordpress-stack.md` also loads on JavaScript, JSX, TypeScript, and TSX files; README loading diagram lists the new rules.
- Removed Cursor references: `wp-review` rule, `content-writer` and `growth-design` skill titles, and the `.cursor` excludes in `templates/project` (`pack-theme.sh`, `deploy.yml`).
- Bullets use `-` in every rule file and the `sage-architecture` skill (the five new rules used `*`); `wordpress-stack.md` sections renumbered 1-7 (there was no section 4); stray blank line removed in `marketing-copy.md`.

## [1.2.1] - 2026-10-14

### Changed
- `README.md`: banner (light/dark), status badges, section nav, mermaid diagrams for auto-update, ship workflow and loading layers, collapsible skills/commands/layout tables, version table, footer with back-to-top.
- `docs/assets/`: banner SVGs.
- Docs site restyled to match: banner, badges, "Why" grid, emoji section headings, a "What's new" table generated from `CHANGELOG.md`, and a footer with back-to-top.

## [1.2.0] - 2026-10-14

### Added
- `docs/`: GitHub Pages site. `scripts/build-docs.py` renders `docs/src/template.html` with one card per rule, skill, command and agent read from their frontmatter, so a new `SKILL.md` appears on the site without editing HTML. Diagrams of the auto-update flow, what loads when, and the ship workflow. `.github/workflows/pages.yml` builds and deploys on every push to `main` that touches docs, rules, skills, commands, agents or `VERSION`.

### Changed
- `README.md`: rewritten for scanning — why it exists, what's inside (tables for skills and commands), install, auto-update, what loads when, what's new, and a link to the docs site.

## [1.1.0] - 2026-10-14

### Added
- `skills/doc-references/`: canonical reference docs for the stack (WordPress, Roots/Bedrock, Tailwind, MDN, WHATWG, W3C/ARIA APG, web.dev, Modern CSS, caniuse, cssdb, JavaScript.info, TypeScript, React, Next.js, Node, NestJS, Ahrefs, WP Bones environments) grouped by domain, with a verify-before-coding rule and source precedence.
- `templates/project/.claude/settings.json`: `WebFetch` allowed on every domain in `doc-references`, so verification never prompts.

### Changed
- `rules/core.md`: one line pointing to `doc-references` for versioned APIs.
- `templates/project/CLAUDE.md`: a "Reference docs" section.

## [1.0.0] - 2026-10-11

### Added
- `rules/`: always-on `core.md` (< 1 KB) plus path-scoped WordPress, Sage and AI-search rules.
- `skills/`: content-writer, growth-design, portfolio-seo, geo-blog-post, sage-architecture (on request).
- `commands/pb/`: `/pb:ship`, `/pb:fix`, `/pb:plan`, `/pb:review`, `/pb:new-project`.
- `agents/wp-reviewer.md` and `hooks/phpcs-on-edit.sh`.
- `templates/project/`: CLAUDE.md template, Claude settings, GitHub Actions deploy over SSH with health check and automatic rollback, setup scripts.
- `scripts/install.sh` + `scripts/sync.sh`: copy into `~/.claude` and auto-update on every Claude Code session start.
- `scripts/validate.py` + `validate.yml`: frontmatter, size budget, private-detail and CHANGELOG checks.
- `playbook/`: ship workflow, token discipline, rules architecture.

### Changed
- Rules imported from the matthummel theme (Oct 2026), with project-specific sections moved back to that repo. Ten always-on rules (~60 KB per session) became one 0.8 KB core rule; the rest load by path or on request.
