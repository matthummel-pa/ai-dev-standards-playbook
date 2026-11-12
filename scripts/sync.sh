#!/usr/bin/env bash
# Pull the Cursor playbook and copy it into ~/.cursor (and ~/.claude, for Claude Code).
# Runs from a SessionStart hook (silent unless something changed) or by hand.
#   bash scripts/sync.sh            pull + install
#   bash scripts/sync.sh --no-pull  install only
# Installs (real files, no symlinks, so it works on Windows, WSL, macOS and in Cowork):
#   rules/    → ~/.claude/rules/playbook/        (always-on core.md + path-scoped rules)
#   skills/*  → ~/.claude/skills/<name>/          (tracked in .playbook-manifest)
#   commands/ → ~/.claude/commands/pb/           (/pb:ship, /pb:fix, /pb:plan, /pb:review, /pb:new-project, /pb:new-theme, /pb:dev)
#   agents/   → ~/.claude/agents/playbook/
#   hooks/    → ~/.claude/hooks/playbook/
# Cursor (same revision stamp; skills mirror ~/.claude, rules mirror .cursor/rules):
#   .cursor/rules → ~/.cursor/rules/playbook/
#   skills/*      → ~/.cursor/skills/<name>/     (tracked in .playbook-manifest)
set -uo pipefail

repo="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
dest="${CLAUDE_CONFIG_DIR:-$HOME/.claude}"
stamp="$dest/.playbook-version"
manifest="$dest/.playbook-manifest"

no_pull=0
force=0
for arg in "$@"; do
  case "$arg" in
    --no-pull) no_pull=1 ;;
    --force) force=1 ;;
  esac
done

if [ "$no_pull" -eq 0 ]; then
  # Never block a session: short timeout, fast-forward only, ignore network errors.
  if command -v timeout >/dev/null 2>&1; then
    timeout 20 git -C "$repo" pull --ff-only --quiet >/dev/null 2>&1 || true
  else
    GIT_HTTP_LOW_SPEED_LIMIT=1000 GIT_HTTP_LOW_SPEED_TIME=10 git -C "$repo" pull --ff-only --quiet >/dev/null 2>&1 || true
  fi
fi

head="$(git -C "$repo" rev-parse --short HEAD 2>/dev/null || echo unknown)"
[ -f "$stamp" ] && [ "$(cat "$stamp")" = "$head" ] && [ "$force" -eq 0 ] && exit 0

mkdir -p "$dest/rules" "$dest/skills" "$dest/commands" "$dest/agents" "$dest/hooks"

replace_dir() { # $1 source, $2 target
  rm -rf "$2"
  [ -d "$1" ] && cp -R "$1" "$2"
}

replace_dir "$repo/rules"        "$dest/rules/playbook"
replace_dir "$repo/commands/pb"  "$dest/commands/pb"
replace_dir "$repo/agents"       "$dest/agents/playbook"
replace_dir "$repo/hooks"        "$dest/hooks/playbook"
chmod +x "$dest/hooks/playbook/"*.sh 2>/dev/null || true

# Skills sit one level deep, so remove only the ones this playbook installed last time.
if [ -f "$manifest" ]; then
  while IFS= read -r name; do
    [ -n "$name" ] && rm -rf "${dest:?}/skills/$name"
  done < "$manifest"
fi
: > "$manifest"
for dir in "$repo"/skills/*/; do
  name="$(basename "$dir")"
  rm -rf "${dest:?}/skills/$name"
  cp -R "$dir" "$dest/skills/$name"
  echo "$name" >> "$manifest"
done

# Cursor reads user skills from ~/.cursor/skills. Rules go to ~/.cursor/rules/playbook
# for local mirrors. Installing the plugin (see README) is what applies them in every project.
cursor="${CURSOR_CONFIG_DIR:-$HOME/.cursor}"
cursor_manifest="$cursor/.playbook-manifest"
mkdir -p "$cursor/rules" "$cursor/skills"
replace_dir "$repo/.cursor/rules" "$cursor/rules/playbook"
if [ -f "$cursor_manifest" ]; then
  while IFS= read -r name; do
    [ -n "$name" ] && rm -rf "${cursor:?}/skills/$name"
  done < "$cursor_manifest"
fi
: > "$cursor_manifest"
for dir in "$repo"/skills/*/; do
  name="$(basename "$dir")"
  rm -rf "${cursor:?}/skills/$name"
  cp -R "$dir" "$cursor/skills/$name"
  echo "$name" >> "$cursor_manifest"
done

echo "$head" > "$stamp"
# One line only, so a session start costs almost nothing in context.
echo "Playbook rules updated to $head ($(git -C "$repo" log -1 --format=%s 2>/dev/null))."
