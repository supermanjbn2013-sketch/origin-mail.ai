#!/usr/bin/env bash
set -Eeuo pipefail

cd "$(dirname "$0")"

if ! command -v docker >/dev/null 2>&1; then
  echo "Docker is required. Install Docker Engine and the Docker Compose plugin first."
  exit 1
fi
if ! docker compose version >/dev/null 2>&1; then
  echo "Docker Compose plugin is required."
  exit 1
fi

if [[ ! -f .env ]]; then
  cp .env.example .env
  PASSWORD="$(openssl rand -base64 36 | tr -d '\n' | tr '/+' '_-')"
  sed -i "s|CHANGE_THIS_TO_A_LONG_RANDOM_PASSWORD|$PASSWORD|" .env
  echo "Created .env with a generated dashboard password."
fi

if grep -q 'mail.example.com' .env || grep -q 'CHANGE_THIS_TO_A_LONG_RANDOM_PASSWORD' .env; then
  echo "Edit .env and set DOMAIN to a DNS name pointing to this server."
  echo "Keep the generated dashboard password private."
  exit 1
fi

docker compose config --quiet
docker compose up -d
echo
echo "ORIGIN MAIL AI services started."
echo "Open the HTTPS domain configured in .env after DNS has propagated and Caddy has issued its certificate."
