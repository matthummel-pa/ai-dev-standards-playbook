---
name: sage-architecture
description: "Bespoke Sage/Roots architecture: ACF Pro field groups registered in PHP, a Customizer-driven dark-mode default, branch hygiene, security, the theme.json/Tailwind token bridge, and CI/CD for built theme deploys. Use when adding ACF fields, Customizer settings, new architecture, or touching deploy workflows."
---

# Sage bespoke architecture (2026)

Modular, secure, version-controlled, production-optimized Sage themes. Apply these **without ripping out what already works** in a project unless the owner asks to migrate.

- **Bespoke only:** no pre-made templates, child themes of a custom theme, or page-builder bloat.
- **Structured content** lives in programmatic custom fields (meta). Site-wide design variables go in the Customizer when the owner asks for them.
- **Modern CSS:** container queries, fluid type with `clamp()`, design tokens as CSS custom properties wired to Tailwind v4 `@theme`.

---

## 1. Automated ACF Pro field group registration abstract

When the owner asks for ACF Pro fields, do not use the ACF GUI or raw JSON sync. Register groups in PHP by extending this abstract class:

```php
<?php

declare(strict_types=1);

namespace App\Fields;

abstract class AbstractFieldRegistry
{
    abstract protected function getGroupKey(): string;

    abstract protected function getGroupTitle(): string;

    abstract protected function getFields(): array;

    abstract protected function getLocationRules(): array;

    /**
     * Bootstraps the ACF configuration on the appropriate WordPress hook.
     */
    public function init(): void
    {
        add_action('acf/init', [$this, 'registerFieldGroup']);
    }

    /**
     * Registers the compiled structural definition array with ACF Core.
     */
    public function registerFieldGroup(): void
    {
        if (! function_exists('acf_add_local_field_group')) {
            return;
        }

        acf_add_local_field_group([
            'key' => $this->getGroupKey(),
            'title' => $this->getGroupTitle(),
            'fields' => $this->getFields(),
            'location' => $this->getLocationRules(),
            'menu_order' => 0,
            'position' => 'normal',
            'style' => 'default',
            'label_placement' => 'top',
            'instruction_placement' => 'label',
            'active' => true,
        ]);
    }
}
```

Until ACF is requested, keep using the project's existing field registry.

---

## 2. Dark mode default from the Customizer

Site-wide **default** color mode belongs in the Customizer when that control is added; visitors can still override it with a header toggle saved in `localStorage`.

```php
// Inside an App\Customizer registry, when the owner asks for this control:
$wp_customize->add_setting('sage_color_mode_preference', [
    'default' => 'system',
    'type' => 'theme_mod',
    'capability' => 'edit_theme_options',
    'sanitize_callback' => function ($value) {
        return in_array($value, ['system', 'light', 'dark'], true) ? $value : 'system';
    },
]);

$wp_customize->add_control('sage_color_mode_preference', [
    'label' => __('Default color mode', 'sage'),
    'section' => 'title_tagline',
    'type' => 'select',
    'choices' => [
        'system' => __('Follow the operating system', 'sage'),
        'light' => __('Light', 'sage'),
        'dark' => __('Dark', 'sage'),
    ],
]);
```

Apply it in the root layout without dropping `language_attributes()`, keeping whatever dark class the project already uses:

```blade
<html @php(language_attributes()) @class(['dark' => $isDarkDefault])>
```

Tailwind v4 dark variants target that class in CSS (`@custom-variant dark (&:where(.dark, .dark *));`), not a v3 `darkMode` key. Don't rename an existing dark class across the CSS unless the owner asks.

---

## 3. Branches and repo hygiene

- `main` is production: PRs only, squash-merge, auto-merge when checks pass.
- Work branches: `feat/…`, `fix/…`, `chore/…`. No `staging` branch unless the owner creates one.
- `.gitignore` keeps `vendor/`, `node_modules/`, `public/build/`, `.env*`, `.cache` and deploy keys off the remote. Never commit SSH keys or PATs.

---

## 5. Senior WordPress engineering security and execution

- **Strict escaping and sanitization:** never assume data is safe. Escape template output (`esc_html()`, `esc_attr()`, `esc_url()`, `wp_kses_post()`). Blade `{!! !!}` only for trusted, already-escaped HTML.
- **Database efficiency:** on `WP_Query`, pass `'no_found_rows' => true` when pagination is not required, request only needed fields, and do not sort on unindexed meta.
- **Secure request handling:** every custom form, AJAX payload, or endpoint uses `wp_verify_nonce()` and capability checks (`current_user_can()`) where the action is privileged. Public contact form still needs a nonce.
- **CLS mitigation:** put aspect-ratio constraints on media containers (`aspect-[16/9]`, `aspect-square`, or explicit width/height) so images do not shove the layout.

---

---

## 9. Build, tokens and deploy

- **Tokens:** front-end utilities come from Tailwind v4 `@theme` in `resources/css/app.css`. `tailwind.config.js` exists only for the Gutenberg `theme.json` color/font map; keep the two aligned. Never hand-edit the generated `public/build/assets/theme.json`.
- **No committed build output:** `public/build/` is built in GitHub Actions (`npm ci && npm run build`, `composer install --no-dev`).
- **Secrets** live only in GitHub environment secrets or server environment variables; never in workflow YAML, options or JS.
- **Atomic deploys:** build on the runner, ship one complete theme, swap folders on the server, keep the previous build for rollback, purge the page cache, health-check, roll back automatically on failure. The ready-made version is `templates/project/.github/` in the ai-dev-standards-playbook repo.
