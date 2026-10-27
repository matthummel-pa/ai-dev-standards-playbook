---
description: Run or edit a theme repo locally with WordPress Studio and Vite (up, dev, get, branch, use, clear, doctor)
argument-hint: "[up | dev | get <repo> | branch <name> | use | clear | status | down | doctor]"
---

Local dev for a Sage theme repo: $ARGUMENTS

Follow the `sage-project` skill. Run `bash ~/code/ai-dev-standards-playbook/scripts/wp-local.sh <command>` from the theme repo (use `-C <dir>` if the shell is elsewhere).

1. No argument: run `status`. If the site isn't running, run `up`.
2. `dev` is long-running: start it in the background and report the URL. Don't poll it.
3. If a command fails, run `doctor` once, fix what it names, retry once. Report the exact error if it still fails.
4. Reply with the site URL and what the theme folder points to.
