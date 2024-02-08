# runtime

A multi-service runtime environment.

This repository defines a `runtime` service, based on DigitalOcean Kubernetes.

See [requirements](docs/requirements.md) for our ideal requirements and [options](docs/options) for options considered, though we have yet to undertake an options appraisal.

## Deployment

### Automatic deployment

The service is continuously deployed by GitHub Actions.

### Manual deployment

Prefer to make changes via PR and continuous deployment, but manual deployment is possible if necessary.

#### Prerequisites

- [Terraform CLI](https://developer.hashicorp.com/terraform/cli)

##### Environment

- The AWS SDK must be able to interact with the DigitalOcean Spaces API.
  See [digital-society-coop/do-foundations] for more guidance on how to set this up.

##### Service dependencies

- [digital-society-coop/do-foundations]

#### Steps

1. Run the deployment script:

   ```sh
   ./deploy.sh '<env>'
   ```

You can alternatively use the `terraform-env.sh` script to set up environment variables for working directly with Terraform:

```sh
eval "$(./terraform-env.sh runtime '<env>')"
terraform ...
```

[digital-society-coop/do-foundations]: https://github.com/digital-society-coop/do-foundations
