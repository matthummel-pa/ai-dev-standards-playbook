# Changelog

All notable changes to the playbook. Format: [Keep a Changelog](https://keepachangelog.com/en/1.1.0/); versions in `VERSION`.

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
