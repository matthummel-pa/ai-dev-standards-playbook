---
paths:
  - "**/*.{css,scss,html,js,jsx,ts,tsx}"
  - "**/*.blade.php"
---

# Frontend, UX and brand

## 1. Design systems and tokens
* Work directly with Figma variables, auto-layout, responsive grids on an 8pt spacing baseline, and semantic color palettes.
* Map design tokens to Tailwind theme values or CSS custom properties. One source of truth; no hard-coded hex values in components.

## 2. Design-to-code
* Translate visual designs 1:1 into Tailwind CSS utility classes or CSS custom properties.
* Respect fluid typography (`clamp()`), flexbox and grid mechanics, and aspect ratios.
* Build mobile-first.

## 3. User-centered structure
* Enforce clear visual hierarchy.
* Define every interaction state: hover, focus, active, disabled. Add loading, empty, and error states for anything dynamic.
* Use micro-interactions to support conversion, never to decorate.
* Respect `prefers-reduced-motion`.

## 4. Accessibility (WCAG 2.2 AA)
* Meet contrast ratios: 4.5:1 for body text, 3:1 for large text and UI components.
* One `<h1>` per page, with sequential headings below it.
* Provide a skip link and full keyboard navigation with a visible focus indicator.
* Use semantic HTML first. Add ARIA only where native elements fall short.
* Every form field has a visible label. Errors are announced and explained in plain words.
* Touch targets are at least 24 by 24 CSS pixels; aim for 44.
* Decorative images get an empty `alt`. Meaningful images get a description of what they show, not keywords.

## 5. Brand identity
* Deliver coherent brand guidelines: logo marks, typography pairings, color application, and visual tone.
* For client work, build from the client's design or a clear reference. Flag when a job needs a designer instead of guessing.

## 6. Asset production
* Give step-by-step direction or layout specs for custom illustrations, SVG assets, social banners, and UI iconography in Figma and Adobe Photoshop.

## 7. Asset optimization
* Specify export parameters: `@2x` retina scale, compressed SVG paths, and lossy or lossless WebP conversion.
* Optimize for web delivery without visible degradation.
* Size hero images to their largest rendered width. Don't ship a 2560px image to a 1200px slot.
* Open Graph images: 1200 by 630, under 300 KB.
