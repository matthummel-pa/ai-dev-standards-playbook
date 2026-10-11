# Spend fewer credits

- **One task per session.** `/clear` between unrelated tasks. A long thread re-sends everything each turn.
- **Name the file or symptom.** "FAQ chevron in dark mode" beats "something looks off": Claude greps instead of reading.
- **Never read huge files whole.** Big compiled or legacy CSS gets `rg`, not Read. Project `CLAUDE.md` should name them.
- **Pick the model for the job.** Sonnet for `/pb:fix` and `/pb:ship`; Opus for `/pb:plan` on large work and hard debugging; Haiku for docs and changelog edits.
- **Batch small asks** into one `/pb:fix`: "fix A, B and C" is one context load instead of three.
- **Let CI check, not chat.** Format, lint and build run in Actions; `/pb:ship` runs only the checks a change touches.
- **`/compact`** before a long second half instead of starting over.
- **Keep always-on context tiny.** `core.md` < 1 KB, project `CLAUDE.md` ≤ 2 KB; everything else by path or on request.
- **Pre-approve safe commands** in `.claude/settings.json` so routine pushes and PRs don't stop for prompts.
