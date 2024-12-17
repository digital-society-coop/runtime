#!/usr/bin/env bash

set -euo pipefail

export SERVICE=observe

echo "Deploying $SERVICE" >&2
echo >&2

kubectl apply -f kube-state-metrics.yaml

export MANAGED_DOMAIN="$SERVICE.$RUNTIME_DOMAIN"
BASE64_ROOT_OBSERVE_PASSWORD=$(echo -n "$OBSERVE_ROOT_USER_PASSWORD" | openssl base64 -A)

export BASE64_ROOT_OBSERVE_PASSWORD

# shellcheck disable=SC2016
opentelemetry_operator_variables='$NAMESPACE'

envsubst "$opentelemetry_operator_variables" <opentelemetry-operator.yaml | kubectl apply -f -

# shellcheck disable=SC2016
openobserve_variables='$SERVICE
  $NAMESPACE
  $MANAGED_DOMAIN
  $OBSERVE_ROOT_USER_EMAIL
  $BASE64_ROOT_OBSERVE_PASSWORD'

envsubst "$openobserve_variables" <observe.yaml | kubectl apply -f -

echo >&2
echo 'Deployment complete' >&2
