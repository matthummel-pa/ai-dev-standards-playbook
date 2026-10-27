---
paths:
  - "**/*.php"
  - "**/*.js"
  - "**/*.jsx"
  - "**/*.ts"
  - "**/*.tsx"
  - "**/block.json"
  - "**/theme.json"
  - "**/composer.json"
  - "**/vite.config.*"
  - ".github/workflows/**"
---

# WordPress stack, performance and QA

Security lives in `wp-review.md`; coding standards, i18n, theme.json and accessibility in `wordpress.md`; official docs in the `doc-references` skill.

## 1. Stack
- **Standards:** lean, production-ready code. PHP 8.3 target (8.2 minimum), modern JavaScript (ES6+), WordPress Coding Standards.
- **Sage:** Sage 11 with Blade templating (`.blade.php`), Sage Composers for data loading, Tailwind CSS v4, and Vite for asset bundling. Keep templates decoupled from logic. Sage 10 projects keep Bud; don't migrate the bundler unless asked.
- **Blade stays thin.** Logic lives in `App` helpers and Composers with typed functions and explicit names. If a function can't be followed in half a minute, rewrite it.
- **Bedrock and Trellis:** use Bedrock for 12-factor structure, Composer dependency management, and `.env` config where the host allows it. Use Trellis for provisioning and zero-downtime deploys where applicable.

## 2. When not to use the default stack
- **Match what's there.** On an existing client site, work in its current theme, builder, and hosting setup. Don't introduce Sage, Bedrock, or Tailwind into a site that doesn't have them unless the job is a rebuild.
- **Say it first.** If the existing stack blocks the request or creates risk, explain the tradeoff and get a decision before changing architecture.
- **Shared hosting:** assume no SSH, no Composer on the server, and no Node. Build locally or in CI and deploy compiled assets.

## 3. Block development
- **Native Gutenberg:** build with `@wordpress/scripts`, `block.json` metadata, `@wordpress/components`, and InnerBlocks.
- **ACF blocks:** with ACF Pro, register through `block.json` and render with Blade components in Sage. Treat `acf_register_block_type` as legacy; use it only when maintaining older code.
- **Editing comes first.** wp-admin is part of the architecture. If an owner can't update hours or a product in a couple of minutes, the build isn't done.
- **Server-render by default.** Use dynamic blocks for anything driven by data. Keep front-end JavaScript out unless the block needs interaction.

## 4. Performance
- Target 90+ mobile PageSpeed and passing Core Web Vitals: LCP under 2.5s, low CLS, fast INP.
- Enqueue scripts and styles conditionally. Nothing loads site-wide unless it's used site-wide.
- Serve WebP or AVIF, lazy-load below-the-fold media, and set `width` and `height` on images.
- Keep the DOM light.
- Optimize `WP_Query`: set `no_found_rows` when not paginating, limit fields, avoid `posts_per_page => -1`, and cache expensive results in transients or the object cache.

## 5. Plugin policy
- **Small and focused.** Custom work lives in focused plugins or theme modules with standard hooks, PHPDoc, and a clean uninstall path. No kitchen-sink plugins.
- **Before recommending a plugin,** check that it's actively maintained, compatible with the current WordPress version, and doesn't duplicate something already installed.
- **Theme versus plugin:** presentation goes in the theme. Anything the site must keep after a theme change (post types, taxonomies, integrations) goes in a plugin.
- **No page builders** on new builds.
- **Free plugins bound for WordPress.org** follow the plugin directory guidelines: GPL-compatible, a unique prefix on everything, no bundled trackers, readme in the standard format.

## 6. Git and deployment
- Work on a branch. `main` stays deployable.
- Commit messages state what changed and why, in the imperative.
- Build assets in CI (GitHub Actions) or locally. Never edit files on the production server.
- Give every release a semantic version and a changelog entry.
- Back up the database and uploads before any deploy that touches data or plugins.

## 7. Testing and QA
- Run PHPCS with the WordPress Coding Standards ruleset. Fix errors; justify any ignored rule in a comment.
- Run PHPStan on plugins and theme `app/` code.
- Check at 360px, 768px, and 1280px or wider, in Chrome, Safari, and Firefox.
- Test with keyboard only and with a screen reader on any new interactive component.
- Test as an editor role, not just as an administrator.
- Turn on `WP_DEBUG` and `WP_DEBUG_LOG` in development. Ship with zero notices and warnings.
