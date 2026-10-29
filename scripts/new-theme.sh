#!/usr/bin/env bash
# Scaffold a new Sage 11 theme repo with the playbook's standards, ready to run locally.
#
#   bash ~/code/ai-dev-standards-playbook/scripts/new-theme.sh <slug> <site-url> ["Theme Name"] [flags]
#
# Flags:  --github    create a private repo under matthummel-pa and push (needs `gh auth login`)
#         --no-site   skip the local WordPress Studio site
#         --no-build  skip npm install and the first Vite build
#         --no-git    skip git init and the first commit
# Env:    CODE_DIR (default ~/code) · COMPOSER_BIN (e.g. "php /path/composer.phar")
#
# Steps: composer create-project roots/sage → rename (style.css, composer.json, package.json,
# Vite base) → playbook template (CLAUDE.md, .claude, .github, tools) → npm install + build →
# git init → optional GitHub repo → optional Studio site (wp-local.sh up).
set -euo pipefail

here="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=/dev/null
. "$here/lib-wp.sh"

github=0 site=1 build=1 gitinit=1 pos=()
for a in "$@"; do
  case "$a" in
    --github) github=1 ;;
    --no-site) site=0 ;;
    --no-build) build=0 ;;
    --no-git) gitinit=0 ;;
    -h | --help) sed -n '2,15p' "${BASH_SOURCE[0]}" | sed 's/^# \{0,1\}//'; exit 0 ;;
    --*) die "unknown flag $a" ;;
    *) pos+=("$a") ;;
  esac
done

slug="${pos[0]:-}" url="${pos[1]:-}" name="${pos[2]:-}"
[ -n "$slug" ] && [ -n "$url" ] || die 'usage: new-theme.sh <slug> <https://site-url> ["Theme Name"] [--github] [--no-site] [--no-build] [--no-git]'
[[ "$slug" =~ ^[a-z][a-z0-9-]*$ ]] || die "slug must be lowercase letters, digits and hyphens (got '$slug')"
url_re='^https?://[^:/?#[:space:]][^/?#[:space:]]*([/?#][^[:space:]]*)?$' # scheme, a real host, then optional path/query/fragment
[[ "$url" =~ $url_re ]] || die "site url must be an HTTP(S) URL with a host (got '$url')"
url="${url%/}"
if [ -z "$name" ]; then
  name="$(printf '%s' "$slug" | tr '-' ' ' | awk '{for(i=1;i<=NF;i++)$i=toupper(substr($i,1,1)) substr($i,2)}1')"
fi

dest="${CODE_DIR:-$HOME/code}/$slug"
[ ! -e "$dest" ] || die "$dest already exists"

ensure_php
ensure_node
have git || die "git not found"
# Check the --github contract now, before anything is created, so a failure never leaves a half-built folder.
if [ "$github" = 1 ]; then
  [ "$gitinit" = 1 ] || die "--github cannot be combined with --no-git"
  have gh || die "gh not found (scoop install gh)"
  gh auth status >/dev/null 2>&1 || die "gh is not logged in (run: gh auth login)"
fi

edit() { sed -E "$2" "$1" >"$1.tmp" && mv "$1.tmp" "$1"; } # edit <file> <sed -E expression>

say "Creating roots/sage in $dest"
composer_run create-project roots/sage "$dest" --no-interaction --prefer-dist --no-progress
cd "$dest"
rm -rf .git # create-project can leave history behind; this repo starts clean

say "Renaming to $name ($slug)"
sage_version="$(sed -n 's/^Version:[[:space:]]*//p' style.css | head -1 | tr -d '\r')"
e_name="$(sed_escape "$name")" e_url="$(sed_escape "$url")" # a URL like ?a=1&b=2 must stay data, not sed syntax
edit style.css "s|^(Theme Name:[[:space:]]+).*|\1$e_name|; s|^(Theme URI:[[:space:]]+).*|\1$e_url|; s|^(Description:[[:space:]]+).*|\1Custom Sage theme for $e_name.|; s|^(Version:[[:space:]]+).*|\10.1.0|; s|^(Author:[[:space:]]+).*|\1Matt Hummel|; s|^(Author URI:[[:space:]]+).*|\1https://matthummel.com|"
edit vite.config.js "s|base: '/app/themes/sage/public/build/'|base: '/wp-content/themes/$slug/public/build/'|"
grep -q "/wp-content/themes/$slug/public/build/" vite.config.js || die "could not set the Vite base; Sage's vite.config.js changed"

# JSON files are edited with node so key order and escaping stay valid.
SLUG="$slug" NAME="$name" URL="$url" node -e '
const fs = require("fs"), e = process.env;
const c = JSON.parse(fs.readFileSync("composer.json", "utf8"));
c.name = "matthummel/" + e.SLUG;
c.description = "Sage 11 theme for " + e.NAME;
c.homepage = e.URL;
c.authors = [{ name: "Matt Hummel", homepage: "https://matthummel.com" }];
delete c.support;
fs.writeFileSync("composer.json", JSON.stringify(c, null, 2) + "\n");
const p = JSON.parse(fs.readFileSync("package.json", "utf8"));
p.name = e.SLUG;
p.version = "0.1.0";
fs.writeFileSync("package.json", JSON.stringify(p, null, 2) + "\n");
'
composer_run update --lock --no-interaction --quiet # refresh the lock hash after the name change

cat >>.gitignore <<'EOF'
.env.*
!.env.example
.claude/settings.local.json
*.log
.DS_Store
Thumbs.db
EOF

say "Adding the playbook project template"
bash "$here/new-project.sh" "$slug" "$url" >/dev/null
edit CLAUDE.md "s|^TODO: one line on the stack.*|Sage $sage_version (Roots), Blade, Tailwind v4, Vite, Acorn, PHP 8.3. Repo root = theme folder \`$slug\`.|"
edit CLAUDE.md "s|Owner: TODO\.|Owner: Matt Hummel.|"
# shellcheck disable=SC2016 # backticks are literal Markdown, not command substitution
edit CLAUDE.md 's|PHP style: TODO \(`vendor/bin/pint` or `phpcs`\)|PHP style: `vendor/bin/pint`|'
# shellcheck disable=SC2016
edit CLAUDE.md 's|^- Local WP: TODO.*|- Local WP: `bash ~/code/ai-dev-standards-playbook/scripts/wp-local.sh up` (WordPress Studio). After Blade edits: `wp-local.sh clear`. HMR: `wp-local.sh dev`.|'

cat >README.md <<EOF
# $name

Sage $sage_version theme (Blade, Tailwind v4, Vite, Acorn, PHP 8.3). Repo root is the theme folder \`$slug\`.
Site: $url

## Local development

Needs PHP 8.3, Composer, Node 22, and the WordPress Studio CLI (\`npm install -g wp-studio\`).

\`\`\`bash
bash ~/code/ai-dev-standards-playbook/scripts/wp-local.sh up     # Studio site + theme linked and active
bash ~/code/ai-dev-standards-playbook/scripts/wp-local.sh dev    # Vite hot reload
\`\`\`

Build for production: \`npm run build\`. PHP style: \`vendor/bin/pint\`.
Project notes for AI agents are in \`CLAUDE.md\`.
EOF

if [ "$build" = 1 ]; then
  say "npm install"
  npm install --no-audit --no-fund
  say "npm run build"
  npm run build
fi

if [ "$gitinit" = 1 ]; then
  git init -q -b main
  git -c core.safecrlf=false add -A # silences Windows LF/CRLF warnings; commits stay LF
  git commit -q -m "chore: scaffold Sage $sage_version theme with playbook template"
  say "git: initial commit on main"
  if [ "$github" = 1 ]; then
    gh repo create "matthummel-pa/$slug" --private --source . --remote origin --push
  fi
fi

if [ "$site" = 1 ]; then
  if [ "$build" = 1 ]; then bash "$here/wp-local.sh" up || echo "Local site not started; fix the error above, then run: wp-local.sh up" >&2
  else say "Skipping the local site (needs a build). Run: wp-local.sh up"; fi
fi

cat <<EOF

Done: $dest
  Next:  cd $dest
         bash $here/wp-local.sh dev        # Vite HMR
  Open CLAUDE.md and fill the remaining TODOs (copy location, dark mode, reference docs).
  GitHub hardening (branch protection, secrets): tools/github-setup.sh and tools/hostinger-secrets.sh.
EOF
