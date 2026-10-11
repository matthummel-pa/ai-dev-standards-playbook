#!/usr/bin/env bash
# One-time GitHub settings for hands-off merging. Run on your computer: bash tools/github-setup.sh
# Needs: gh auth login (repo admin).
set -euo pipefail
repo="${1:?usage: github-setup.sh owner/repo}"

# Squash-only merges, auto-merge on, delete head branches after merge.
gh api -X PATCH "repos/$repo" \
  -F allow_auto_merge=true -F delete_branch_on_merge=true \
  -F allow_squash_merge=true -F allow_merge_commit=false -F allow_rebase_merge=false >/dev/null

# main: PRs only, must pass CI "build" and "wp-review"; no reviews required (solo dev).
gh api -X PUT "repos/$repo/branches/main/protection" --input - >/dev/null <<'JSON'
{
  "required_status_checks": { "strict": false, "contexts": ["build", "wp-review"] },
  "enforce_admins": false,
  "required_pull_request_reviews": null,
  "restrictions": null,
  "allow_force_pushes": false,
  "allow_deletions": false
}
JSON

# Production environment (holds the SSH secrets; deploys only from main).
gh api -X PUT "repos/$repo/environments/production" --input - >/dev/null <<'JSON'
{ "deployment_branch_policy": { "protected_branches": true, "custom_branch_policies": false } }
JSON

echo "Done. Next: add the five production secrets (see notebook Step 2)."
