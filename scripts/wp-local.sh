#!/usr/bin/env bash
# Run and edit any of Matt's Sage theme repos locally with WordPress Studio.
#
#   bash ~/code/ai-dev-standards-playbook/scripts/wp-local.sh <command> [args]
#   Tip: alias wpl='bash ~/code/ai-dev-standards-playbook/scripts/wp-local.sh'
#
# Run from inside a theme repo (or a worktree of it). Use -C <dir> to point elsewhere.
#
#   doctor           check tools and print the install line for anything missing
#   up               create or start the Studio site, link this repo in as the theme, activate it
#   down             stop the site
#   status           URL, PHP version and where the theme folder points
#   use              re-point the site's theme folder at THIS directory (switch to a worktree)
#   dev              Vite dev server with hot reload (npm run dev)
#   clear            clear Blade views (studio wp acorn view:clear)
#   wp <args...>     WP-CLI against the site
#   list             every site Studio knows about
#   get <repo>       clone a repo (name, or owner/name; default owner matthummel-pa) and run `up`
#   branch <name>    new sibling worktree ../<repo>-<name> on a new branch, deps installed, site pointed at it
#
# One Studio site per theme folder, at $STUDIO_DIR/<theme-folder> (default ~/Studio). The repo stays at
# $CODE_DIR/<repo> (default ~/code) and is linked into wp-content/themes with a junction (Windows) or symlink.
set -euo pipefail

here="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=/dev/null
. "$here/lib-wp.sh"

if [ "${1:-}" = "-C" ]; then cd "${2:?-C needs a directory}"; shift 2; fi
cmd="${1:-help}"
[ $# -gt 0 ] && shift

code_dir="${CODE_DIR:-$HOME/code}"
studio_dir="${STUDIO_DIR:-$HOME/Studio}"

need_studio() {
  have studio || die "WordPress Studio CLI not found. Install one of:
    npm install -g wp-studio
    irm https://wordpress.studio/install.ps1 | iex      (PowerShell)
  or turn on Settings → 'Studio CLI for terminal' in the Studio app. Then open a new terminal."
}

# Resolve the theme repo for the current directory.
repo_context() {
  repo="$(git rev-parse --show-toplevel 2>/dev/null || true)"
  [ -n "$repo" ] && [ -f "$repo/style.css" ] && [ -f "$repo/vite.config.js" ] \
    || die "Not a Sage theme repo (needs style.css and vite.config.js at the repo root). cd into one, or use -C <dir>."
  theme="$(theme_folder "$repo")"
  site="$studio_dir/$theme"
  link="$site/wp-content/themes/$theme"
}

studio_in() { (cd "$site" && studio "$@"); } # Studio acts on the site in the current directory

# Windows links are junctions made through PowerShell (no admin rights; cmd mangles quoted paths).
ps() { powershell.exe -NoProfile -NonInteractive -Command "$1"; }

link_exists() {
  if is_windows; then
    ps "if (Get-Item -LiteralPath '$(winpath "$link")' -Force -ErrorAction SilentlyContinue) { exit 0 } else { exit 1 }" >/dev/null 2>&1
  else
    [ -e "$link" ] || [ -L "$link" ]
  fi
}

link_theme() { # point $link at $repo, replacing only an existing link
  case "$link$repo" in *"'"*) die "paths containing a single quote are not supported" ;; esac
  mkdir -p "$(dirname "$link")"
  if link_exists; then
    if is_windows; then
      # Directory.Delete (not recursive) removes a junction without touching its target, and refuses a real non-empty folder.
      ps "[System.IO.Directory]::Delete('$(winpath "$link")')" >/dev/null 2>&1 || die "$link is a real folder, not a link. Move it aside first."
    else
      [ -L "$link" ] || die "$link is a real folder, not a link. Move it aside first."
      rm "$link"
    fi
  fi
  if is_windows; then
    ps "New-Item -ItemType Junction -Path '$(winpath "$link")' -Target '$(winpath "$repo")' | Out-Null" || die "could not create the junction at $link"
  else
    ln -s "$repo" "$link"
  fi
  say "Theme folder: $link → $repo"
}

link_target() { # print where $link points, or nothing
  link_exists || return 0
  if is_windows; then
    ps "(Get-Item -LiteralPath '$(winpath "$link")' -Force).Target" 2>/dev/null | tr -d '\r' | head -1 || true
  else
    readlink "$link" || true
  fi
}

case "$cmd" in
  doctor)
    bad=0
    row() { printf '%-10s %s\n' "$1" "$2"; }
    if have php; then row php "$(php -r 'echo PHP_VERSION;' | tr -d '\r')"; else row php "MISSING"; bad=1; fi
    for t in composer node npm git gh studio; do
      if [ "$t" = composer ] && [ -n "${COMPOSER_BIN:-}" ]; then row composer "via COMPOSER_BIN"
      elif have "$t"; then row "$t" "ok"
      else
        row "$t" "MISSING"
        [ "$t" = gh ] || bad=1 # gh is only needed for --github and `get`
      fi
    done
    have studio || echo "  studio: npm install -g wp-studio   (or: irm https://wordpress.studio/install.ps1 | iex)"
    { have composer || [ -n "${COMPOSER_BIN:-}" ]; } || echo "  composer: scoop install composer  (or set COMPOSER_BIN)"
    have php && (ensure_php && echo "  php extensions: ok") || bad=1
    exit "$bad"
    ;;

  up)
    need_studio
    repo_context
    prepare_theme "$repo"
    mkdir -p "$site"
    if [ -d "$site/wp-content" ]; then
      say "Starting Studio site $site"
      studio_in start
    else
      say "Creating Studio site $site (PHP 8.3)"
      studio_in create --path "$site" --php 8.3
    fi
    link_theme
    studio_in wp theme activate "$theme" || echo "Could not activate '$theme'. Studio may not follow the link; see 'status'." >&2
    studio_in wp rewrite structure '/%postname%/' >/dev/null || true
    if ! studio_in wp theme list --field=name | tr -d '\r' | grep -qx "$theme"; then
      echo "warning: Studio cannot see '$theme' through the link. For the direct-clone fallback, see Gotchas in the sage-project skill." >&2
    fi
    studio_in status
    echo "  Hot reload: bash $here/wp-local.sh dev"
    ;;

  down) need_studio; repo_context; studio_in stop ;;

  status)
    need_studio; repo_context
    studio_in status
    echo "Theme folder: $link → $(link_target)"
    ;;

  use)
    need_studio; repo_context
    [ -d "$site/wp-content" ] || die "No Studio site at $site yet. Run: wp-local.sh up"
    prepare_theme "$repo"
    link_theme
    studio_in wp acorn view:clear >/dev/null || true
    ;;

  dev) repo_context; ensure_node; (cd "$repo" && npm run dev) ;;

  clear) need_studio; repo_context; studio_in wp acorn view:clear ;;

  wp) need_studio; repo_context; studio_in wp "$@" ;;

  list) need_studio; studio list ;;

  get)
    name="${1:?usage: wp-local.sh get <repo|owner/repo>}"
    have gh || die "gh not found (scoop install gh), then gh auth login"
    case "$name" in */*) full="$name" ;; *) full="matthummel-pa/$name" ;; esac
    target="$code_dir/${full##*/}"
    if [ -d "$target/.git" ]; then say "$target already cloned"; else gh repo clone "$full" "$target"; fi
    cd "$target"
    exec bash "$here/wp-local.sh" up
    ;;

  branch)
    name="${1:?usage: wp-local.sh branch <name>}"
    repo_context
    [ -d "$site/wp-content" ] || die "No Studio site at $site yet. Run 'wp-local.sh up' from the main checkout first."
    tree="$(dirname "$repo")/$(basename "$repo")-${name//\//-}"
    if [ -e "$tree" ]; then
      # A previous run may have died after creating the worktree (deps, build, link); pick up from there.
      [ "$(git -C "$tree" rev-parse --path-format=absolute --git-common-dir 2>/dev/null)" = "$(git -C "$repo" rev-parse --path-format=absolute --git-common-dir)" ] \
        || die "$tree exists but is not a worktree of this repo"
      # feature/a and feature-a share a folder name; never point the site at the wrong branch.
      current="$(git -C "$tree" symbolic-ref --short HEAD 2>/dev/null || true)"
      [ "$current" = "$name" ] || die "$tree has '${current:-a detached HEAD}' checked out, not '$name' (names that differ only by / or - share a folder). Pick another branch name."
      say "Resuming existing worktree $tree"
    else
      git -C "$repo" worktree add -b "$name" "$tree"
    fi
    prepare_theme "$tree"
    cd "$tree"
    exec bash "$here/wp-local.sh" use
    ;;

  help | -h | --help) sed -n '2,22p' "${BASH_SOURCE[0]}" | sed 's/^# \{0,1\}//' ;;

  *) die "unknown command '$cmd'. Run: wp-local.sh help" ;;
esac
