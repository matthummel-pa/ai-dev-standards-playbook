---
description: Scaffold a new Sage 11 theme repo (Vite, Tailwind v4, playbook template) and start its local Studio site
argument-hint: "<slug> <https://site-url> [\"Theme Name\"]"
---

Create a new Sage theme project: $ARGUMENTS

Follow the `sage-project` skill.

1. If the slug or URL is missing, ask for just those. Derive the display name from the slug unless given.
2. Run `bash ~/code/ai-dev-standards-playbook/scripts/new-theme.sh <slug> <url> "<name>"`. Add `--github` only if Matt said to create the GitHub repo. If it stops on a missing tool, run `wp-local.sh doctor`, tell Matt the one install line, and stop.
3. Open the new `CLAUDE.md` and replace the remaining `TODO`s with facts from the generated repo. Leave anything you can't verify as `TODO`.
4. Reply in 4 lines: repo path, local site URL (or why there isn't one), how to start hot reload, what Matt must do by hand (GitHub protection and deploy secrets).
