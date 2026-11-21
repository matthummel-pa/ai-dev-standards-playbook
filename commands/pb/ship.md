---
description: Checks, commit, push, PR with auto-merge (any project)
---

Ship the current work. Don't ask questions unless a check fails in a way you can't fix.

1. `git status`. Nothing secret or built may be staged (`.env*`, `vendor/`, `node_modules/`, `public/build/`, `dist/`).
2. On the default branch? Create `feat/…`, `fix/…` or `chore/…` named for the change.
3. Run only the checks that apply, as the project's `CLAUDE.md` lists them (formatter, linter, build). Fix and re-run once.
4. Visible change → one line in `CHANGELOG.md` if the project keeps one.
5. Conventional commit; `git push -u origin <branch>`.
6. `gh pr create --fill`; if the repo allows auto-merge: `gh pr merge --auto --squash --delete-branch`.
7. Reply in 3 lines: PR link, checks running, what happens on green.
