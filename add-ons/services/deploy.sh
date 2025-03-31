#!/usr/bin/env bash

set -euo pipefail

echo "Deploying services... " >&2
echo >&2

export NAMESPACE="runtime"

./deploy-web-analytics.sh

./deploy-observe.sh

./deploy-status.sh

echo >&2
echo 'Deployment of services complete' >&2
