# Changelog

All notable changes to the playbook. Format: [Keep a Changelog](https://keepachangelog.com/en/1.1.0/); versions in `VERSION`.

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
