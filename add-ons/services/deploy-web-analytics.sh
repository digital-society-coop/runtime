#!/usr/bin/env bash

set -euo pipefail

export SERVICE=web-analytics

echo "Deploying $SERVICE" >&2
echo >&2

export MANAGED_DOMAIN="$SERVICE.$RUNTIME_DOMAIN"
BASE64_SECRET=$(echo -n "$WEB_ANALYTICS_SECRET" | openssl base64 -A)
BASE64_POSTGRES_PASSWORD=$(echo -n "$WEB_ANALYTICS_POSTGRES_PASSWORD" | openssl base64 -A)

export BASE64_SECRET BASE64_POSTGRES_PASSWORD

# shellcheck disable=SC2016
variables='$SERVICE
  $NAMESPACE
  $MANAGED_DOMAIN
  $BASE64_SECRET
  $BASE64_POSTGRES_PASSWORD'

envsubst "$variables" <web-analytics.yaml | kubectl apply -f -

echo >&2
echo 'Deployment complete' >&2
