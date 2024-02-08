#!/usr/bin/env bash

set -euo pipefail

function usage {
  echo "Usage: $0 <env>" >&2
  exit 1
}

service=runtime

[[ $# -ge 1 ]] || usage
environment=$1
shift

echo "Deploying $service-$environment... " >&2
echo >&2

eval "$(./terraform-env.sh "$service" "$environment")"

echo -n "- Initialising terraform... " >&2
if ! result="$(terraform init)"; then
	echo 'failed' >&2
	echo >&2
	echo "$result" >&2
	exit 1
fi
echo 'done' >&2

echo -n "- Running terraform apply... " >&2
if ! result="$(terraform apply)"; then
	echo 'failed' >&2
	echo >&2
	echo "$result" >&2
	exit 1
fi
echo 'done' >&2

echo >&2
echo 'Deployment complete' >&2
