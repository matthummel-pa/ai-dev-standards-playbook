---
name: token-discipline
description: "Spend fewer credits on a coding session. Use when starting work, planning a fix, or the user asks to use fewer tokens, credits, or a cheaper model."
---

# Token discipline

One task per session. A session that plans, edits five files, and deploys costs more than three short ones.

Before reading code:

- Ask which file. Do not explore the repo to find it.
- Do not read a built CSS bundle, `node_modules`, `vendor`, or `public/build`.
- Read the function, not the file, when the file is long.

Model choice:

- Faster model for `/pb-fix` and `/pb-ship`.
- Stronger model for `/pb-plan` only.

Checks:

- Let CI run pint, phpcs, and the build. Do not re-run a check that just passed.
- Batch questions. One message with three questions is cheaper than three round trips.

Context:

- Keep the always-on rule under 1 KB. Project facts live in a path-scoped rule, not in every reply.
- When the thread gets long, start a new session with the files and the decision named. Do not paste the old thread.
