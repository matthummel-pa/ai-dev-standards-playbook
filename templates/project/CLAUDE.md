# {{PROJECT_NAME}} — agent brief

<!-- Keep this file under ~2 KB. Shared standards load from the ai-dev-standards-playbook
     (~/.claude/rules/playbook, skills, /pb:* commands). Put only project facts here. -->

TODO: one line on the stack (e.g. Sage 11, Blade, PHP 8.3, Tailwind v4, Vite). Repo root = theme folder `{{THEME_SLUG}}`.
Production: {{SITE_URL}}. Owner: TODO.

## How work ships
branch → PR (`/pb:ship`) → checks green → auto-merge (squash) → `deploy.yml` builds and swaps the theme over SSH →
health check → auto-rollback if unhealthy. Roll back by hand: Actions → Deploy → Run workflow with an older SHA.

## Commands
- Build: `npm run build` · Dev: `npm run dev` · PHP style: TODO (`vendor/bin/pint` or `phpcs`)
- Local WP: TODO (WordPress Studio `studio wp …`, or wp-env). After Blade edits: `wp acorn view:clear`.

## Project facts and hard no's
- TODO: where visitor copy lives (field registry, ACF, wp-admin).
- TODO: dark-mode class, design tokens file, anything agents must not change.

## Reference docs
Official sources and the verify-before-coding rule: `doc-references` skill (playbook). Project-specific docs: TODO.

## Ask first
DNS, PHP version, production database writes, deleting content/users/plugins, spending money, secrets.
