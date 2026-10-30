#!/usr/bin/env bash
# Copy templates/project into the current repo without overwriting anything.
# Usage (from the project root): bash ~/code/ai-dev-standards-playbook/scripts/new-project.sh <theme_slug> <site_url>
set -euo pipefail
repo="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
slug="${1:?theme slug}"; url="${2:?site url (https://example.com)}"
name="$(basename "$(pwd)")"
src="$repo/templates/project"
# Escape what is special in a sed replacement (backslash, &, and the # delimiter) so values stay data.
esc() { printf '%s' "$1" | sed -e 's/[\\&#]/\\&/g'; }
e_name="$(esc "$name")"; e_slug="$(esc "$slug")"; e_url="$(esc "$url")"
skipped=()
while IFS= read -r -d '' f; do
  rel="${f#"$src"/}"
  if [ -e "$rel" ]; then skipped+=("$rel"); continue; fi
  mkdir -p "$(dirname "$rel")"
  sed -e "s#{{PROJECT_NAME}}#$e_name#g" -e "s#{{THEME_SLUG}}#$e_slug#g" -e "s#{{SITE_URL}}#$e_url#g" "$f" > "$rel"
  case "$rel" in *.sh) chmod +x "$rel" ;; esac
  echo "added   $rel"
done < <(find "$src" -type f -print0)
for s in "${skipped[@]:-}"; do
  if [ -n "$s" ]; then echo "skipped $s (exists — merge by hand)"; fi
done
