#!/usr/bin/env bash
set -euo pipefail

APP_BASE_DIR="/opt/secret-thesis"
DOCKER_DIR="${APP_BASE_DIR}/infra/docker"

echo "1 scenarija izversana"

cd "${DOCKER_DIR}"

echo "ieprieksejo konteineru apstadisana"
docker compose -f docker-compose.scenarijs1.yml down || true

echo "Konteineru izveide un palaisana"
docker compose -f docker-compose.scenarijs1.yml up --build -d

echo "Parbaude"
docker ps