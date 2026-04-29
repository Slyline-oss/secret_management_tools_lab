#!/usr/bin/env bash
set -euo pipefail

SCENARIO="${1:-scenario1}"
DEPLOY_DIR="/opt/secret-thesis/deploy/${SCENARIO}"

echo "Izvēršana ${SCENARIO}"

cd "$DEPLOY_DIR"

echo "Deployment files:"
ls -la

echo "iepriekšējo konteineru apstadīšana"
docker compose -p "$SCENARIO" -f docker-compose.yml down || true

echo "Konteineru izveidošana un palaišana"
docker compose -p "$SCENARIO" -f docker-compose.yml up --build -d

echo "Pārbaude:"
docker ps

echo "Izvēršana pabeigta"