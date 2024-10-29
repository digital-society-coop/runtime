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

function deploy {
  echo "Deploying $1 $service-$environment... " >&2
  echo >&2

  cd "$1"

  eval "$(./terraform-env.sh "$service" "$environment")"

  echo -n "- Initialising terraform... " >&2
  if ! result="$(terraform init -input=false -lockfile=readonly)"; then
    echo 'failed' >&2
    echo >&2
    echo "$result" >&2
    exit 1
  fi
  echo 'done' >&2

  echo -n "- Running terraform apply... " >&2
  if ! result="$(terraform apply -auto-approve -input=false)"; then
    echo 'failed' >&2
    echo >&2
    echo "$result" >&2
    exit 1
  fi
  echo 'done' >&2

  cd ..

  echo >&2
  echo 'Deployment complete' >&2
}

deploy "cluster"

deploy "add-ons"
