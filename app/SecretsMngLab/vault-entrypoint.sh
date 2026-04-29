#!/usr/bin/env bash
set -euo pipefail

echo "[INFO] Noslēpumdatu ielāde no Vault..."

: "${VAULT_ADDR:?VAULT_ADDR is required}"
: "${VAULT_TOKEN:?VAULT_TOKEN is required}"
: "${VAULT_DB_ROLE:?VAULT_DB_ROLE is required}"
: "${VAULT_STATIC_SECRET_PATH:?VAULT_STATIC_SECRET_PATH is required}"

echo "[INFO] Dinamisko noslēpumdatu pieprasījums"
DB_CREDS_JSON="$(vault read -format=json database/creds/${VAULT_DB_ROLE})"

export SPRING_DATASOURCE_URL="jdbc:postgresql://postgres:5432/secretlab"
export SPRING_DATASOURCE_USERNAME="$(echo "$DB_CREDS_JSON" | jq -r '.data.username')"
export SPRING_DATASOURCE_PASSWORD="$(echo "$DB_CREDS_JSON" | jq -r '.data.password')"

echo "[INFO] Statisko noslēpumdatu nolase"
export APP_JWT_SECRET="$(vault kv get -field=jwt_secret "$VAULT_STATIC_SECRET_PATH")"
export APP_API_KEY="$(vault kv get -field=api_key "$VAULT_STATIC_SECRET_PATH")"
export AWS_ACCESS_KEY_ID="$(vault kv get -field=aws_access_key_id "$VAULT_STATIC_SECRET_PATH")"
export AWS_SECRET_ACCESS_KEY="$(vault kv get -field=aws_secret_access_key "$VAULT_STATIC_SECRET_PATH")"
export AWS_SECRET_ACCESS_KEY="$(vault kv get -field=internal-token "$VAULT_STATIC_SECRET_PATH")"


vault kv get -field=private_key "$VAULT_STATIC_SECRET_PATH" > /tmp/private_key.pem
chmod 600 /tmp/private_key.pem
export APP_PRIVATE_KEY_PATH="/tmp/private_key.pem"

echo "[INFO] Programmatūras "

exec java -jar app.jar