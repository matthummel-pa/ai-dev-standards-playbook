# ⚡ AI Dev Standards & Playbook

> A running, always-updated guidebook, AI ruleset, and idea share for developers building fast, accessible portfolio sites, agency projects, and WordPress themes using **Claude Code** (Anthropic's CLI agent).

Created and maintained by **[Matt Hummel](https://matthummel.com)** — Full-stack & WordPress Developer in Gettysburg, PA.

---

## What's in here

```
rules/                     Path-scoped rules → ~/.claude/rules/playbook/
  core.md                    the only always-on rule (< 1 KB)
  wordpress/                 WordPress standards + review rules (load on *.php)
  sage/                      Sage/Roots conventions (load on app/, resources/, vite.config.js)
  seo/                       AI-search / GEO standards (load on Blade and SEO code)
skills/                    On-request skills → ~/.claude/skills/<name>/
  content-writer/            voice, readability, Editor's Notes
  growth-design/             CRO + design + front-end personas
  portfolio-seo/             portfolio/service SEO and on-page limits
  geo-blog-post/             blog drafting for AI Overviews
  sage-architecture/         ACF-in-PHP, Customizer dark mode, CI/CD, security
commands/pb/               Slash commands → /pb:ship /pb:fix /pb:plan /pb:review /pb:new-project
agents/                    Subagents (wp-reviewer)
hooks/                     Hook scripts (PHPCS on edit)
templates/project/         Drop-in kit for a theme repo: CLAUDE.md, settings, SSH deploy + rollback
playbook/                  Guides: ship workflow, token discipline, rules architecture
scripts/                   install, sync, new-project, validate
```

Everything is versioned here. Every change goes through a PR, gets a `CHANGELOG.md` line, and passes `validate.yml`.

---

## Install once (2 minutes)

In **Git Bash** (Windows), WSL or macOS:

```bash
git clone https://github.com/matthummel-pa/ai-dev-standards-playbook.git ~/code/ai-dev-standards-playbook
bash ~/code/ai-dev-standards-playbook/scripts/install.sh
```

`install.sh` copies the playbook into `~/.claude` and adds one **SessionStart hook** to `~/.claude/settings.json` (it keeps a backup in `settings.json.bak-playbook`).

## How auto-update works

1. You merge a change to this repo on GitHub.
2. The next time you start Claude Code anywhere, the hook runs `scripts/sync.sh`: `git pull --ff-only`, then re-copies rules, skills, commands, agents and hooks into `~/.claude`.
3. If nothing changed, it prints nothing. If something changed, it prints one line (`Playbook rules updated to abc1234 (…)`).

Rules load at session start, so a change shows up in the session **after** the one that pulled it. To apply right away: `bash ~/code/ai-dev-standards-playbook/scripts/sync.sh`, then restart Claude Code.

Copies (not symlinks) keep it working on Windows without Developer Mode, and Claude Code loads `~/.claude/rules/` without an approval prompt.

## Use it in a project

```bash
cd ~/code/my-theme
claude
/pb:new-project my-theme https://example.com
```

Then `/pb:fix …` and `/pb:ship` for daily work. See [playbook/automated-ship-workflow.md](playbook/automated-ship-workflow.md).

## Public vs private

This repo is public. It holds **generic** standards only. Project facts (hosts, paths, plugin names, local logins, product catalogs) stay in each project's own `CLAUDE.md` and `.claude/rules/`. `scripts/validate.py` blocks obvious private details and secrets.

## Change a rule

1. Branch, edit, add a `CHANGELOG.md` line, bump `VERSION` for anything that changes behavior.
2. Open a PR. `validate.yml` checks frontmatter, size budgets, private details and shell scripts.
3. Merge. Every machine picks it up on its next Claude Code session.

Read [playbook/rules-architecture.md](playbook/rules-architecture.md) before adding a rule: most new guidance belongs in a skill, not an always-on rule.
