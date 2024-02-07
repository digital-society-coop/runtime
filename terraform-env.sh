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

tfCliArgs=(
  '-input=false'
)

tfCliArgsInit=(
  ${tfCliArgs[@]}
  "-backend-config=region=${AWS_REGION:-"$(aws configure get region)"}"
  "-backend-config=bucket=$stateBucket"
  "-backend-config=key=$stateKey"
  '-lockfile=readonly'
  '-reconfigure'
)

tfCliArgsPlan=(
  ${tfCliArgs[@]}
  "-var=environment=$environment"
  "-var-file=$environment.tfvars"
)

tfCliArgsApply=(
  ${tfCliArgsPlan[@]}
  '-auto-approve'
)

echo "export TF_CLI_ARGS_init='${tfCliArgsInit[@]}'"
echo "export TF_CLI_ARGS_plan='${tfCliArgsPlan[@]}'"
echo "export TF_CLI_ARGS_apply='${tfCliArgsApply[@]}'"
