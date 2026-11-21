---
description: Senior WordPress/Sage review of the current branch or a PR (any project)
argument-hint: "[PR number]"
---

Review $ARGUMENTS. With a PR number: `gh pr view` + `gh pr diff`; otherwise the branch vs `origin/main`.
Use the **wp-reviewer** subagent, then summarize blockers in plain language and ask whether to fix them now.
Post to the PR with `gh pr review --comment` only if asked.
