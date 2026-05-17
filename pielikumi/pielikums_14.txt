#!/usr/bin/env bash
set -euo pipefail

TOOL="$1"
CONTAINER="$2"
RUNS="${3:-5}"

echo "Riks: $TOOL"
echo "Konteiners: $CONTAINER"
echo "Meginajumi: $RUNS"
echo

SUM=0

for i in $(seq 1 "$RUNS"); do
  START=$(date +%s.%N)

  if [ "$TOOL" = "vault" ]; then
    docker exec "$CONTAINER" sh -c \
      'vault read -format=json database/creds/secretlab-app-role >/dev/null'

  elif [ "$TOOL" = "infisical" ]; then
    docker exec "$CONTAINER" sh -c '
        TOKEN=$(infisical login \
        --method=universal-auth \
        --client-id="$INFISICAL_UNIVERSAL_AUTH_CLIENT_ID" \
        --client-secret="$INFISICAL_UNIVERSAL_AUTH_CLIENT_SECRET" \
        --silent \
        --plain)

        INFISICAL_TOKEN="$TOKEN" infisical export \
        --format=json \
        --projectId="$INFISICAL_PROJECT_ID" \
        --env="$INFISICAL_ENV" \
        --path="/" >/dev/null
    '
  else
    echo "Use: vault | infisical"
    exit 1
  fi

  END=$(date +%s.%N)
  TIME=$(awk "BEGIN {print $END - $START}")

  echo "Run $i: ${TIME}s"

  SUM=$(awk "BEGIN {print $SUM + $TIME}")

  sleep 1
done

AVG=$(awk "BEGIN {print $SUM / $RUNS}")

echo
echo "Videjais atbildes laiks: ${AVG}s"