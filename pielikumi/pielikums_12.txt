#!/usr/bin/env bash
set -euo pipefail

echo "[INFO] Noslēpumdatu ielāde no Infisical..."

: "${INFISICAL_API_URL:?INFISICAL_API_URL is required}"
: "${INFISICAL_UNIVERSAL_AUTH_CLIENT_ID:?client id is required}"
: "${INFISICAL_UNIVERSAL_AUTH_CLIENT_SECRET:?client secret is required}"
: "${INFISICAL_PROJECT_ID:?project id is required}"
: "${INFISICAL_ENV:?environment is required}"

export INFISICAL_TOKEN="$(infisical login \
  --method=universal-auth \
  --client-id="$INFISICAL_UNIVERSAL_AUTH_CLIENT_ID" \
  --client-secret="$INFISICAL_UNIVERSAL_AUTH_CLIENT_SECRET" \
  --silent \
  --plain)"

echo "[INFO] Programmatūras ielāde ar Infisical secrets..."

exec infisical run \
  --projectId="$INFISICAL_PROJECT_ID" \
  --env="$INFISICAL_ENV" \
  --path="/" \
  -- java -jar app.jar