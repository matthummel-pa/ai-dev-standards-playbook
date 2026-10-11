# Automated ship workflow (WordPress / Sage on SSH hosting)

**Loop:** describe the change → `/pb:fix` or `/pb:ship` → PR opens with auto-merge → CI passes → squash-merge →
GitHub Actions builds the theme and deploys over SSH → health check → automatic rollback if the site is unhealthy.

## One-time setup per project

1. `/pb:new-project <theme-slug> <https://site>` in the repo (copies `templates/project/` without overwriting).
2. Host: enable SSH (Hostinger: hPanel → Advanced → SSH Access; Premium/Business plans and up).
3. In Git Bash/WSL from the repo:
   ```bash
   bash tools/github-setup.sh owner/repo       # squash-only, auto-merge, protected main, production environment
   bash tools/hostinger-secrets.sh owner/repo example.com   # deploy key + 5 secrets + SITE_URL/THEME_SLUG variables
   ```
4. Make sure CI has jobs named `build` and `wp-review` (or edit the required checks in `github-setup.sh`).
5. Merge the setup PR yourself, then watch the first **Deploy to production** run.

## What the deploy does

- Builds on the runner: `composer install --no-dev`, `npm ci && npm run build`, `pack-theme.sh`.
- Uploads the zip and `server-deploy.sh`; unpacks to `themes/.<slug>-next` (WordPress ignores dot folders).
- Keeps last build's hashed Vite assets for 14 days so cached pages never lose their CSS.
- Swaps with two renames (`<slug>` → `.<slug>-prev`, `.<slug>-next` → `<slug>`), clears Acorn and LiteSpeed caches.
- Health check: homepage 200, `/wp-json/` 200, no "critical error", theme CSS 200. Failure → swaps `.<slug>-prev` back.
- Doc-only merges skip deploy. Roll back by hand: Actions → Deploy → Run workflow with an older SHA.

## Approval

Opening the PR with `/pb:ship` is the approval. For a click-to-deploy gate, add yourself as a required reviewer on the
`production` environment in GitHub settings.
