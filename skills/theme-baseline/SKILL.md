---
name: theme-baseline
description: "Local WordPress theme development and a live SSH deploy. Use when setting up a theme, bringing one up to the shared baseline, or shipping a site you host. Product themes that ship as a zip keep their release workflow."
---

# Theme baseline

Shared standards come from the Cursor playbook plugin. Do not paste playbook rules into the theme.

## Local

On a Mac, use WordPress Studio and `scripts/wp-local.sh`. Never run plain `wp` against a Studio site. After a Blade change, run `view:clear`.

On this Linux environment, PHP, Composer, Node, and WP-CLI are installed. WordPress Studio is not. Run pint, phpcs, and `npm run build` here. Do not install a second WordPress unless the task asks.

## What to copy from the furthest-along theme

- A short `CLAUDE.md` (stack, local command, deploy, gotchas). `.cursor/rules` holds project facts.
- Pint, and `wp-review` in CI.
- A separate public docs repo for support guides. The theme does not vendor the guide.

Do not copy another theme's product: bookings, menus, Freemius, or a demo bar.

## Deploy

A site you host deploys from `.github/workflows/deploy.yml`: build, SSH into the GitHub `production` environment, health check, rollback. The site URL is the live site named in `CLAUDE.md`. There is no staging job. Do not publish through hPanel, and do not install a zip on a staging copy.

Secrets stay in the GitHub `production` environment (`HOSTINGER_SSH_HOST`, `HOSTINGER_SSH_PORT`, `HOSTINGER_SSH_USER`, `HOSTINGER_SSH_KEY`, `HOSTINGER_WP_PATH`, variables `SITE_URL` and `THEME_SLUG`). Never commit them. Do not run the deploy unless the task says to ship.

A theme sold as a zip keeps the `theme-latest` release. Do not point that release at the portfolio site's SSH deploy.

Spend the session with the `token-discipline` skill.
