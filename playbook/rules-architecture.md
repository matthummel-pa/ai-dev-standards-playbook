# Rules architecture: what loads when

Every always-on line costs tokens in every session. Put guidance where it loads only when it's needed.

This is the Cursor playbook. Edit `rules/**/*.md`, then run `python3 scripts/export-cursor.py`. Cursor loads the generated `.cursor/rules/**/*.mdc` files. Do not hand-edit the `.mdc` copies.

| Layer | Where | Loads | Use for |
| --- | --- | --- | --- |
| Core rule | `.cursor/rules/core.mdc` | Every session, every project | 5–10 lines that are true everywhere |
| Path rules | `.cursor/rules/**/*.mdc` with `globs` | When a matching file is in context | Coding standards for a file type |
| Skills | `skills/<name>/SKILL.md` | Description always; body only when used | Long playbooks: writing, SEO, design, architecture |
| Commands | `commands/pb/*.md` | Only when you type `/pb-…` | Repeatable workflows |
| Project `CLAUDE.md` | repo root | Every session in that repo | Project facts, commands, hard no's (≤ 2 KB) |
| Project rules | repo `.cursor/rules/` | By path in that repo | Private infra, product catalogs, deploy specifics |

Cursor command ids: `pb-ship`, `pb-fix`, `pb-plan`, `pb-review`, `pb-new-project`, `pb-new-theme`, `pb-dev`.

## Decide where new guidance goes

1. True for every project and under one line? → `rules/core.md`.
2. About a file type? → a rule with `paths:` (exported as `globs`).
3. A procedure or a long checklist? → a skill.
4. Something you trigger on purpose? → a command.
5. Names a host, path, plugin, login or client? → the project repo, never here.

## Install

- Every project: Cursor → Customize → Plugins → Add from GitHub → this repo (`.cursor-plugin/plugin.json`).
- This machine: `scripts/sync.sh` copies skills to `~/.cursor/skills/` and rules to `~/.cursor/rules/playbook/`.
- Do not copy the rule bodies into each theme repo.

`scripts/sync.sh` also copies the same files into `~/.claude` for Claude Code. Those commands stay `/pb:ship` and the rest. Cursor is the playbook those copies follow.

## Precedence to remember

- User skills (`~/.cursor/skills`) and the plugin skills are the same text. If a skill shows up twice, keep the plugin and delete the `~/.cursor/skills` copy.
- Project subagents win over personal ones with the same name.
- User rules load with project rules; neither overrides the other, so keep them consistent.
- Commands here are namespaced (`/pb-ship`) so they never shadow a project's own `/ship`.
