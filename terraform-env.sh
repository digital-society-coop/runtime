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

if [[ -z "${EXTERNAL_DNS_TOKEN+x}" ]]; then
  echo "Missing required environment variable: EXTERNAL_DNS_TOKEN" >&2
  exit 1
fi

stateBucket="do-foundations-$environment-terraform"
stateKey="$service/$environment.tfstate"

tfCliArgsInit=(
  "-backend-config=region=${AWS_REGION:-"$(aws configure get region)"}"
  "-backend-config=bucket=$stateBucket"
  "-backend-config=key=$stateKey"
)

tfCliArgsPlan=(
  "-var=environment=$environment"
  "-var=external_dns_token=$EXTERNAL_DNS_TOKEN"
  "-var-file=$environment.tfvars"
)

# shellcheck disable=SC2206
tfCliArgsApply=(
  ${tfCliArgsPlan[@]}
)

echo "export TF_CLI_ARGS_init='${tfCliArgsInit[*]}'"
echo "export TF_CLI_ARGS_plan='${tfCliArgsPlan[*]}'"
echo "export TF_CLI_ARGS_apply='${tfCliArgsApply[*]}'"
