#!/usr/bin/env bash

set -euo pipefail

function usage {
  echo "Usage: $0 <service> <env>" >&2
  exit 1
}

[[ $# -ge 1 ]] || usage
service="$1"
shift

[[ $# -ge 1 ]] || usage
environment="$1"
shift


stateBucket="do-foundations-$environment-terraform"
stateKey="$service/$environment.tfstate"

tfCliArgsInit=(
  "-backend-config=region=${AWS_REGION:-"$(aws configure get region)"}"
  "-backend-config=bucket=$stateBucket"
  "-backend-config=key=$stateKey"
)

echo "export TF_CLI_ARGS_init='${tfCliArgsInit[*]}'"
