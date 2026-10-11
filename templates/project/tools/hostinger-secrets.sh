#!/usr/bin/env bash
# One-time: create a deploy key and store the Hostinger SSH details as GitHub environment secrets.
# Usage: hostinger-secrets.sh owner/repo example.com   (run from Git Bash/WSL/macOS)
# Values come from hPanel → Advanced → SSH Access.
set -euo pipefail
repo="${1:?usage: hostinger-secrets.sh owner/repo domain}"; domain="${2:?usage: hostinger-secrets.sh owner/repo domain}"
read -rp "SSH host (IP from hPanel): " host
read -rp "SSH port [65002]: " port; port="${port:-65002}"
read -rp "SSH username (from hPanel, starts with u): " user
read -rp "WordPress path [/home/$user/domains/$domain/public_html]: " wp
wp="${wp:-/home/$user/domains/$domain/public_html}"

key="$HOME/.ssh/${domain//./_}_deploy"
[ -f "$key" ] || ssh-keygen -t ed25519 -N '' -C 'github-actions-deploy' -f "$key"

echo
echo "Paste this public key into hPanel → Advanced → SSH Access → SSH keys → Add SSH key:"
cat "$key.pub"
read -rp "Press Enter once it's added…" _

ssh -i "$key" -p "$port" -o StrictHostKeyChecking=accept-new "$user@$host" "test -f '$wp/wp-config.php' && command -v wp >/dev/null && echo 'SSH + WP-CLI OK'"

gh secret set HOSTINGER_SSH_HOST --env production -R "$repo" -b "$host"
gh secret set HOSTINGER_SSH_PORT --env production -R "$repo" -b "$port"
gh secret set HOSTINGER_SSH_USER --env production -R "$repo" -b "$user"
gh secret set HOSTINGER_WP_PATH  --env production -R "$repo" -b "$wp"
gh secret set HOSTINGER_SSH_KEY  --env production -R "$repo" < "$key"
slug="$(basename "$(git rev-parse --show-toplevel 2>/dev/null || pwd)")"
read -rp "Theme folder name on the server [$slug]: " s; slug="${s:-$slug}"
gh variable set SITE_URL -R "$repo" -b "https://$domain"
gh variable set THEME_SLUG -R "$repo" -b "$slug"
echo "Secrets saved. The private key stays in $key — never commit it."
