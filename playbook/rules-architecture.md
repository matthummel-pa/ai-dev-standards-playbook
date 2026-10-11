# Rules architecture: what loads when

Every always-on line costs tokens in every session. Put guidance where it loads only when it's needed.

| Layer | Where | Loads | Use for |
| --- | --- | --- | --- |
| Core rule | `~/.claude/rules/playbook/core.md` | Every session, every project | 5–10 lines that are true everywhere |
| Path rules | `~/.claude/rules/playbook/**` with `paths:` | When Claude reads or edits a matching file | Coding standards for a file type |
| Skills | `~/.claude/skills/<name>/SKILL.md` | Description always; body only when used | Long playbooks: writing, SEO, design, architecture |
| Commands | `~/.claude/commands/pb/*.md` | Only when you type `/pb:…` | Repeatable workflows |
| Project `CLAUDE.md` | repo root | Every session in that repo | Project facts, commands, hard no's (≤ 2 KB) |
| Project rules | repo `.claude/rules/` | By path in that repo | Private infra, product catalogs, deploy specifics |

## Decide where new guidance goes

1. True for every project and under one line? → `rules/core.md`.
2. About a file type? → a rule with `paths:`.
3. A procedure or a long checklist? → a skill.
4. Something you trigger on purpose? → a command.
5. Names a host, path, plugin, login or client? → the project repo, never here.

## Precedence to remember

- Personal skills (`~/.claude/skills`) win over project skills with the same name, so playbook skills use names projects don't.
- Project subagents win over personal ones with the same name.
- User rules load before project rules; neither overrides the other, so keep them consistent.
- Commands here are namespaced (`/pb:ship`) so they never shadow a project's own `/ship`.
