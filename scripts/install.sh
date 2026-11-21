#!/usr/bin/env bash
# One-time setup. Run in Git Bash (Windows), WSL or macOS:
#   git clone https://github.com/matthummel-pa/ai-dev-standards-playbook.git ~/code/ai-dev-standards-playbook
#   bash ~/code/ai-dev-standards-playbook/scripts/install.sh
# 1. Copies the playbook into ~/.claude (scripts/sync.sh).
# 2. Adds a SessionStart hook to ~/.claude/settings.json so every new Claude Code session
#    pulls the latest playbook and re-installs it when it changed.
set -euo pipefail

repo="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
dest="${CLAUDE_CONFIG_DIR:-$HOME/.claude}"
settings="$dest/settings.json"
mkdir -p "$dest"

bash "$repo/scripts/sync.sh" --no-pull --force

hook_cmd="bash \"$repo/scripts/sync.sh\""
[ -f "$settings" ] || echo '{}' > "$settings"
[ -f "$settings.bak-playbook" ] || cp "$settings" "$settings.bak-playbook"

merge() {
  HOOK_CMD="$hook_cmd" SETTINGS="$settings" "$@" <<'JS'
const fs = require('fs');
const file = process.env.SETTINGS, cmd = process.env.HOOK_CMD;
const s = JSON.parse(fs.readFileSync(file, 'utf8') || '{}');
s.hooks = s.hooks || {};
const list = s.hooks.SessionStart = s.hooks.SessionStart || [];
const has = list.some(g => (g.hooks || []).some(h => (h.command || '').includes('ai-dev-standards-playbook') || (h.command || '').includes('scripts/sync.sh')));
if (!has) list.push({ matcher: 'startup', hooks: [{ type: 'command', command: cmd, timeout: 30 }] });
fs.writeFileSync(file, JSON.stringify(s, null, 2) + '\n');
console.log(has ? 'SessionStart hook already present.' : 'Added SessionStart hook.');
JS
}

if command -v node >/dev/null 2>&1; then
  merge node -
elif command -v python3 >/dev/null 2>&1 || command -v python >/dev/null 2>&1; then
  py="$(command -v python3 || command -v python)"
  HOOK_CMD="$hook_cmd" SETTINGS="$settings" "$py" - <<'PY'
import json, os
f, cmd = os.environ['SETTINGS'], os.environ['HOOK_CMD']
s = json.load(open(f, encoding='utf-8')) if os.path.getsize(f) else {}
lst = s.setdefault('hooks', {}).setdefault('SessionStart', [])
has = any('scripts/sync.sh' in (h.get('command') or '') for g in lst for h in g.get('hooks', []))
if not has:
    lst.append({'matcher': 'startup', 'hooks': [{'type': 'command', 'command': cmd, 'timeout': 30}]})
json.dump(s, open(f, 'w', encoding='utf-8'), indent=2); open(f, 'a').write('\n')
print('SessionStart hook already present.' if has else 'Added SessionStart hook.')
PY
else
  echo "Need node or python to edit $settings. Add this SessionStart hook by hand:" >&2
  echo "  $hook_cmd" >&2
  exit 1
fi

echo "Installed. Backup of your settings: $settings.bak-playbook"
echo "New Claude Code sessions now pull this repo and refresh ~/.claude automatically."
