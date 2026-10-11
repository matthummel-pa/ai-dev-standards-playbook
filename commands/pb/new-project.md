---
description: Set up a new or existing repo with the playbook project template (CLAUDE.md, settings, ship workflow)
argument-hint: "[theme slug] [site url]"
---

Set up this repo with the playbook template: $ARGUMENTS

1. Run `bash ~/code/ai-dev-standards-playbook/scripts/new-project.sh <slug> <site-url>` from the repo root.
   It copies `templates/project/` without overwriting existing files and lists what it skipped.
2. Fill the TODOs in the new `CLAUDE.md` from what the repo actually contains (stack, commands, local dev).
3. Merge anything it skipped by hand, keeping the project's existing choices.
4. `/pb:ship` (no auto-merge on this first PR).
