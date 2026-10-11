#!/usr/bin/env bash
# Pack a built Sage theme (vendor + public/build, no dev files) as <slug>/ inside a zip.
# Usage: pack-theme.sh <theme_slug> <out.zip>
set -euo pipefail
slug="${1:?theme slug required}"; out="${2:?output zip required}"; case "$out" in /*) ;; *) out="$(pwd)/$out" ;; esac
root="$(pwd)"; stage="$(mktemp -d)"; trap 'rm -rf "$stage"' EXIT
[ -f "$root/public/build/manifest.json" ] || [ -f "$root/public/build/.vite/manifest.json" ] || { echo "No Vite manifest; run npm run build first" >&2; exit 1; }
mkdir -p "$stage/$slug"
tar -C "$root" \
  --exclude='.git' --exclude='.github' --exclude='.cursor' --exclude='.claude' --exclude='node_modules' \
  --exclude='docs' --exclude='tests' --exclude='.env' --exclude='.env.*' --exclude='*.log' --exclude='*.zip' \
  --exclude='CLAUDE.md' --exclude='AGENTS.md' --exclude='.mcp.json' --exclude='phpcs.xml*' --exclude='phpstan*' \
  --exclude='composer.lock' --exclude='package.json' --exclude='package-lock.json' --exclude='vite.config.*' \
  --exclude='resources/js' --exclude='resources/css' -cf - . | tar -C "$stage/$slug" -xf -
(cd "$stage" && zip -qr "$out" "$slug")
echo "Packed $out"
