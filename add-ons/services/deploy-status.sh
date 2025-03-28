#!/usr/bin/env bash

set -euo pipefail

export SERVICE=status

echo "Deploying $SERVICE" >&2
echo >&2

export MANAGED_DOMAIN="$SERVICE.$RUNTIME_DOMAIN"

# shellcheck disable=SC2016
status_variables='$SERVICE
  $NAMESPACE
  $MANAGED_DOMAIN'

envsubst "$status_variables" <status.yaml | kubectl apply -f -

echo >&2
echo 'Deployment complete' >&2
