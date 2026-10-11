---
description: Fix a bug or make a small change end to end, then ship it (any project)
argument-hint: "<what's wrong or what to change>"
---

Task: $ARGUMENTS

1. Find the code with `rg`; read only what you need (never whole multi-hundred-KB files).
2. Make the smallest correct change that matches existing patterns.
3. Verify it (the project's build/test, or a page check).
4. Run `/pb:ship`. Report in 3 lines: what changed, where, PR link.
Ask only if the fix needs a product decision (copy, design direction, pricing).
