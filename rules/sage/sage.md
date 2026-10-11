---
paths:
  - "app/**/*.php"
  - "resources/views/**/*.blade.php"
  - "resources/js/**"
  - "resources/css/**"
  - "vite.config.js"
---

# Sage (Roots) themes

Sage 10/11 themes: Blade, Acorn, Tailwind, Vite. Follow the official docs, not classic PHP themes or page builders.

## Docs first
- Sage: https://roots.io/sage/docs/ · Templates: https://roots.io/sage/docs/theme-templates/
- Compiling assets: https://roots.io/sage/docs/compiling-assets/ · Deployment: https://roots.io/sage/docs/deployment/
- Verify hooks, parameters and deprecations at https://developer.wordpress.org/reference/ before writing code.

## Templates
- The WordPress template hierarchy still applies; Blade lives in `resources/views/`.
- Chrome lives in `sections/` (`header`, `footer`, `sidebar`); reusable chunks in `partials/`; named page templates in `template-*.blade.php`.
- Data comes from View Composers (`app/View/Composers/`) or small `App\` helpers, not from logic in Blade.
- Visitor-facing copy belongs in editable fields (the project's field registry or ACF), not hardcoded in Blade. UI chrome is the exception.
- After Blade edits, clear compiled views: `wp acorn view:clear`.

## PHP and JS
- PHP 8.2+, typed functions, named functions in the `App` namespace. Guard clauses first, happy path last.
- Match the project's Pint/PHPCS style; run the formatter after PHP edits.
- Prefer server-rendered HTML. Keep JS small: Web APIs, `init*` functions imported from `resources/js/app.js`, early return when the DOM node is missing.
- Don't add React, Radix, shadcn, page builders, Kadence or a theme-options screen unless the owner asks.

## Front end
- Tailwind utilities in Blade; shared look in the project's CSS. No CSS-in-JS.
- Mobile first. Media get width/height or an aspect ratio; lazy-load below the fold; WebP/AVIF for new assets.
- Native HTML before ARIA; visible focus; WCAG 2.1 AA contrast in light and dark mode.

## Assets and build
- Vite `base` must match the live theme folder (`/wp-content/themes/<slug>/public/build/`).
- `npm run build` writes `public/build/` (gitignored). The theme fatals without a Vite manifest.
- `npm run dev` is local HMR only.

## Data and APIs
- WordPress APIs, transients and WP-CLI. Fetch only the fields you use; fail soft when a remote API is down.
- `WP_Query`: `no_found_rows => true` when not paginating; don't sort on unindexed meta.

## Docs and changelog
- Comment non-obvious logic only; PHPDoc/JSDoc on public functions.
- Add a `CHANGELOG.md` line for user-visible changes.
