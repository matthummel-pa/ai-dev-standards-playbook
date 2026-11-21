#!/usr/bin/env bash
# Playbook health check. Read-only: it reports, it never deletes.
#   bash scripts/doctor.sh                    install drift, line endings, load budget, stray skills
#   bash scripts/doctor.sh worktrees <repo>   worktrees whose branch PR is merged (prints removal commands)
set -uo pipefail

repo="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
dest="${CLAUDE_CONFIG_DIR:-$HOME/.claude}"
problems=0
warn() { echo "  ! $*"; problems=$((problems + 1)); }
ok() { echo "  ok $*"; }

worktrees() {
  local main="${1:?usage: doctor.sh worktrees <repo>}"
  command -v gh >/dev/null 2>&1 || { echo "gh CLI needed"; exit 1; }
  echo "Worktrees of $main (main checkout skipped):"
  git -C "$main" worktree list --porcelain | awk '/^worktree /{p=$2} /^branch /{sub("refs/heads/","",$2); print p "\t" $2}' |
    while IFS=$'\t' read -r path branch; do
      [ "$path" = "$(git -C "$main" rev-parse --show-toplevel)" ] && continue
      # A modified .gitignore counts as clean enough to list; anything else is real work.
      dirty="$(git -C "$path" status --porcelain 2>/dev/null | grep -vc ' \.gitignore$' || true)"
      state="$(cd "$main" && gh pr list --head "$branch" --state all --json state --jq '.[0].state // "NO PR"' 2>/dev/null)"
      printf '  %-45s %-8s dirty=%s  %s\n' "$(basename "$path")" "$state" "$dirty" "$branch"
      if [ "$state" = "MERGED" ] && [ "$dirty" = "0" ]; then
        echo "    git -C \"$main\" worktree remove --force \"$path\" && git -C \"$main\" branch -D \"$branch\""
      fi
    done
}

if [ "${1:-}" = "worktrees" ]; then worktrees "${2:-}"; exit 0; fi

echo "Install drift (repo vs $dest)"
drift=0
for pair in "rules:rules/playbook" "commands/pb:commands/pb" "agents:agents/playbook" "hooks:hooks/playbook"; do
  src="${pair%%:*}"; dst="${pair##*:}"
  diff -rq "$repo/$src" "$dest/$dst" >/dev/null 2>&1 || { warn "$src differs from $dest/$dst"; drift=1; }
done
for s in "$repo"/skills/*/; do
  diff -rq "$s" "$dest/skills/$(basename "$s")" >/dev/null 2>&1 || { warn "skill $(basename "$s") differs or is missing"; drift=1; }
done
[ "$drift" = 0 ] && ok "installed copy matches the repo"
[ "$drift" = 1 ] && echo "    fix: bash scripts/sync.sh --no-pull --force"

echo "Line endings"
if grep -rlU $'\r' "$dest/hooks/playbook" "$dest/rules/playbook" "$dest/commands/pb" 2>/dev/null | head -3 | grep -q .; then
  warn "CRLF found in installed files; run sync.sh --force"
else ok "no CRLF in installed files"; fi

echo "Load budget"
core=$(wc -c < "$repo/rules/core.md")
if [ "$core" -le 1024 ]; then ok "core.md is $core bytes (limit 1024)"; else warn "core.md is $core bytes (limit 1024)"; fi
for ext in php md blade.php; do
  total=0
  for f in "$repo"/rules/*/*.md; do
    case "$ext" in
      php) grep -qE '\*\*/\*\.php' "$f" && total=$((total + $(wc -c < "$f"))) ;;
      md) grep -qE '\*\*/\*\.md|\{[^}]*md[^}]*\}|\*\*/\*\.\{md' "$f" && total=$((total + $(wc -c < "$f"))) ;;
      blade.php) grep -q 'blade.php' "$f" && total=$((total + $(wc -c < "$f"))) ;;
    esac
  done
  echo "  playbook rules loaded when a .$ext file is touched: about $total bytes"
done

echo "Skills outside the playbook (not tracked, so not synced across machines)"
extra=0
while IFS= read -r d; do
  n="$(basename "$d")"
  [ "$n" = "synced" ] && continue
  grep -qx "$n" "$dest/.playbook-manifest" 2>/dev/null || { warn "$n is in $dest/skills but not in the repo"; extra=1; }
done < <(find "$dest/skills" -mindepth 1 -maxdepth 1 -type d 2>/dev/null)
[ "$extra" = 0 ] && ok "none"

echo
[ "$problems" = 0 ] && echo "All good." || echo "$problems item(s) to look at."
