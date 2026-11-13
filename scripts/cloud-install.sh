#!/usr/bin/env bash
# Idempotent toolchain for a WordPress agent: PHP 8.3, Composer, WP-CLI.
# Node 22 is already on the image. Does not install or start WordPress.
set -euo pipefail

export DEBIAN_FRONTEND=noninteractive
root() { if [ "$(id -u)" -eq 0 ]; then "$@"; else sudo "$@"; fi; }

if ! php -v 2>/dev/null | grep -q 'PHP 8\.3'; then
  root apt-get update
  root apt-get install -y --no-install-recommends \
    php-cli php-xml php-mbstring php-curl php-zip unzip ca-certificates
fi

if ! command -v composer >/dev/null 2>&1; then
  curl -fsSL https://getcomposer.org/installer | root php -- --install-dir=/usr/local/bin --filename=composer
fi

if ! command -v wp >/dev/null 2>&1; then
  curl -fsSL -o /tmp/wp-cli.phar https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
  php /tmp/wp-cli.phar --info >/dev/null
  root install -m 755 /tmp/wp-cli.phar /usr/local/bin/wp
  rm -f /tmp/wp-cli.phar
fi

if ! command -v node >/dev/null 2>&1; then
  node_bin=""
  if [ -x /exec-daemon/node ]; then
    node_bin=/exec-daemon/node
  else
    node_bin="$(find "${HOME}/.nvm/versions/node" -type f -name node -path '*/bin/node' 2>/dev/null | head -n 1 || true)"
  fi
  [ -n "$node_bin" ] || { echo "Node 22 is expected on the image." >&2; exit 1; }
  root ln -sfn "$node_bin" /usr/local/bin/node
  root ln -sfn "$(dirname "$node_bin")/npm" /usr/local/bin/npm
fi

php -v
composer --version
wp cli version
node -v
npm -v
