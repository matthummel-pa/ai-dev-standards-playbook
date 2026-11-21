---
name: playbook-guides
description: Read Matt's AI dev playbook guides before a ship, plan, rules change, or when asked how standards load. Use for token discipline, rules architecture, and the automated ship workflow. Do not paste the guides into always-on rules.
---

# Playbook guides

The repo at `~/code/ai-dev-standards-playbook` is the source of truth. Installed copies under `~/.claude` are not; edit the repo, then run `scripts/sync.sh`.

Read the matching guide before acting. Do not summarize a guide into a new always-on rule.

| Guide | Read it when |
| --- | --- |
| `playbook/rules-architecture.md` | Deciding whether guidance is a core rule, a path rule, a skill, a command, or a project file |
| `playbook/token-discipline.md` | A session is getting long, or you are about to open large files and logs |
| `playbook/automated-ship-workflow.md` | The user asks to ship, plan a release, or rely on `/pb:ship` |

Commands (`/pb:ship`, `/pb:fix`, `/pb:plan`, `/pb:review`, `/pb:new-theme`, `/pb:dev`, `/pb:blueprint`, `/pb:new-project`) live in `~/.claude/commands/pb/`.

Project facts (hosts, client names, deploy paths) stay in that repo's own `CLAUDE.md`. Do not copy them into the playbook.
