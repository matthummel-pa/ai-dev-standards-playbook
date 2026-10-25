---
paths:
  - "**/*.blade.php"
  - "**/*.{html,md,mdx}"
  - "**/robots.txt"
---

# SEO and analytics

Covers Google and Bing.

## 1. Search intent
* **One dominant intent per page:**
  * **Informational:** how-tos, guides, explainers.
  * **Commercial:** comparisons, feature breakdowns, "best of" lists.
  * **Transactional:** pricing pages, direct sales, sign-ups.
* **One primary query per page.** Let related long-tail queries rank through depth of content.
* **Front-load the answer.** State the main takeaway in the opening paragraph.
* **No keyword stuffing.**
* **No cannibalization.** Before writing, check whether an existing page already targets the query. Update or redirect instead of publishing a second page on the same topic.

## 2. Topical authority
* **Pillar and spoke:** build a comprehensive pillar page per core subject, linked to focused spoke articles.
* **Contextual internal links:** link spokes to the pillar and to sibling articles with descriptive, natural anchor text.
* Every new post links to at least two related pages and is linked from at least one existing page.

## 3. Technical SEO
* Logical URL structures, canonical tags, Open Graph meta, XML sitemaps, and sensible `robots.txt` rules.
* Meta titles under 60 characters and meta descriptions under 160.
* Descriptive alt text on meaningful images.
* One URL per page. Redirect trailing-slash and non-slash variants to the canonical version, and keep cached copies in sync.
* Changing or deleting a URL means adding a 301 redirect in the same change.
* No broken internal links at launch or after a restructure.

## 4. Schema markup
* Output clean Schema.org structured data as JSON-LD: Organization, Article, Product, FAQPage, HowTo.
* For local clients add LocalBusiness with name, address, phone, hours, and service area.
* Schema must match what's visible on the page. Validate before shipping.

## 5. Answer Engine Optimization (AEO)
* Phrase subheadings as explicit user questions (H2s and H3s) where it reads naturally.
* Answer directly under the heading, then follow with bullets, numbered lists, or concise tables so search summaries and LLMs can parse and cite the content.

## 6. E-E-A-T
* **First-hand proof:** original data, case studies, your own screenshots, or genuine expert commentary.
* **Clear attribution:** author bios, external source citations, and editorial disclosures.
* Keep facts consistent across pages: years of experience, job titles, service lists, and location.
* Disclose affiliate links where they appear.

## 7. Local SEO
* For clients with a physical location or service area, keep name, address, and phone identical on the site, Google Business Profile, and Bing Places.
* Give each location or service area its own page only when it has distinct content.

## 8. Core Web Vitals
* Pass Core Web Vitals at the 75th percentile of real users: LCP at or under 2.5 s, INP at or under 200 ms, CLS at or under 0.1.
* Treat PageSpeed Insights and Lighthouse scores (aim for 90+ on mobile) as diagnostics, not a pass/fail gate. A good lab score does not guarantee good field data.
* Implementation rules are in `wordpress-stack.md`.

## 9. Audience growth
* Build in retention: sticky navigation, lead magnets, inline newsletter opt-ins, and contextual internal recommendations.

## 10. Measurement strategy
* Every production build implements custom event tracking for key business interactions (form submissions, CTA clicks, video plays, scroll depth) using Google Tag Manager or a custom data layer.
* Write a short tracking plan first: event name, trigger, parameters, and the business question it answers.
* Use consistent `snake_case` event names across projects.

## 11. Google Analytics 4
* Instrument event-based tracking (`gtag.js` or GTM) with standardized parameters.
* Enable enhanced measurement for outbound clicks, site search, and file downloads.
* Enforce privacy: Google Signals management, consent mode v2, and zero PII in any event or URL.
* Mark the real conversions as key events.
* Test in GTM preview and GA4 DebugView before publishing a container.

## 12. Bing Webmaster Tools and IndexNow
* Verify domains through the Bing Webmaster Tools API or DNS TXT records.
* Implement IndexNow (official WordPress plugin or API hook) to push content updates, additions, and deletions to Bing.
* Monitor crawl health, index status, and keyword performance through the Bing Webmaster APIs.
* Verify the same properties in Google Search Console and submit the sitemap to both.

## 13. Official documentation
* [Google Analytics 4 Developer Documentation](https://developers.google.com/analytics/devguides/collection/ga4)
* [Google Tag Manager Developer Guides](https://developers.google.com/tag-platform/tag-manager)
* [Bing Webmaster Tools Documentation](https://www.bing.com/webmaster/help/webmaster-guidelines-30fba23a)
* [IndexNow Protocol Specification](https://www.indexnow.org/documentation)
