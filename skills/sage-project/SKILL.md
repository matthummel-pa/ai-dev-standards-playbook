---
name: sage-project
description: "Create a new Sage 11 (Roots) WordPress theme project and run or edit any of Matt's theme repos locally with WordPress Studio and Vite. Use when asked to start, scaffold, or set up a new WordPress theme or Sage project, to clone a theme repo and get it running locally, to open a branch of a theme in its own working copy, or when local WordPress, Studio, or Vite hot reload won't start."
---

# Sage project: scaffold and local dev

Two scripts in the playbook repo do the work. Run them; don't re-type their steps by hand.

| Need | Command |
| --- | --- |
| New theme repo | `bash ~/code/ai-dev-standards-playbook/scripts/new-theme.sh <slug> <https://site> ["Theme Name"]` (or `/pb:new-theme`) |
| Anything local | `bash ~/code/ai-dev-standards-playbook/scripts/wp-local.sh <command>` (or `/pb:dev`) |

`wp-local.sh` commands: `doctor` · `up` · `down` · `status` · `use` · `dev` · `clear` · `wp …` · `list` · `get <repo>` · `branch <name>`. Run `help` for the one-line meanings.

## New project
1. Ask only for what is missing: slug (lowercase, hyphens; it becomes the theme folder), production URL, display name.
2. Run `new-theme.sh`. It runs `composer create-project roots/sage`, then:
   - renames `style.css`, `composer.json`, `package.json`;
   - sets the Vite `base` to `/wp-content/themes/<slug>/public/build/` (Sage's default is the Bedrock path, wrong on classic hosting);
   - adds the playbook template (`CLAUDE.md`, `.claude/`, `.github/`, `tools/`);
   - installs, builds, makes the first commit on `main`;
   - creates the Studio site (skip with `--no-site`). `--github` also creates a private `matthummel-pa/<slug>` repo and pushes.
3. Fill the remaining `TODO`s in the new `CLAUDE.md` from the real repo (where copy lives, dark-mode class, tokens file). Don't invent them.
4. Branch protection and deploy secrets are separate and need Matt: `tools/github-setup.sh` and `tools/hostinger-secrets.sh`. Don't run them unasked.

Defaults: repo at `~/code/<slug>`; Studio site at `~/Studio/<slug>` (`CODE_DIR`, `STUDIO_DIR` override). Stack is the playbook default (Sage 11, Blade, Tailwind v4, Vite, PHP 8.3). On an existing client site, match what is there instead (`wordpress-stack.md` §2).

## Edit an existing repo locally
- Not cloned yet: `wp-local.sh get <name>` clones from `matthummel-pa` (or `owner/name`) and runs `up`.
- Cloned: `cd` into it, `wp-local.sh up`, then `wp-local.sh dev` for hot reload.
- Second branch at once: `wp-local.sh branch fix/footer` makes a sibling worktree `../<repo>-fix-footer`, installs deps, and points the site's theme folder at it. Run `up` once first (`branch` stops if the site doesn't exist). If `branch` fails partway, run it again: it resumes the worktree it already made. `wp-local.sh use` from any worktree switches the site back to that checkout.
- After Blade edits: `wp-local.sh clear`.

How it fits together: one Studio site per theme folder name (read from the Vite `base`, so a repo called `matthummel-theme` maps to the `matthummel` site). The repo is linked into `wp-content/themes/<folder>` (junction on Windows, symlink elsewhere), so the repo stays where it is and git sees every change. `use` swaps the link target; it never deletes real folders and refuses to replace one.

## Gotchas
- **Studio CLI missing:** `npm install -g wp-studio`, or turn on "Studio CLI for terminal" in the Studio app, then open a new terminal. Commands verified against the official Studio CLI docs: https://developer.wordpress.com/docs/developer-tools/studio/cli/
- **scoop PHP lacks openssl/mbstring/curl/zip:** the scripts detect this and use a private `php.ini` (`~/.cache/playbook-php/`). The global config is never edited. `COMPOSER_BIN="php /path/composer.phar"` overrides Composer if it isn't on PATH.
- **"Vite manifest not found" / theme fatals:** the build is missing. `up` builds it once; rerun `npm run build`.
- **Link works with Studio's default file access** (verified on Studio CLI 2.0.4 on Windows: theme active, front end and Vite assets served through the junction). If a future Studio version stops following links, `up` warns. Direct-clone fallback (the scripts then stop managing that site): `up` has already created the link, so remove the link first, without touching the repo. Windows: `powershell -NoProfile -Command "[System.IO.Directory]::Delete('<site>\wp-content\themes\<folder>')"`; macOS/Linux: `rm <site>/wp-content/themes/<folder>` (no trailing slash). Then `git clone <repo-url> <site>/wp-content/themes/<folder>`, run `composer install`, `npm install` and `npm run build` there, and use `studio wp theme activate <folder>` from the site folder. `up`, `use` and `branch` refuse a real folder, so drive that site with `studio` directly.
- Run `wp-local.sh doctor` first when anything fails.
- Local only. These scripts never deploy; staging and production follow the project's own `CLAUDE.md`.
