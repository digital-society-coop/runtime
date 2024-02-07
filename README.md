# runtime

A multi-service runtime environment.

This repository defines a `runtime` service, based on DigitalOcean Kubernetes.

See [requirements](docs/requirements.md) for our ideal requirements and [options](docs/options) for options considered, though we have yet to undertake an options appraisal.

## Deployment

The service is continuously deployed by GitHub Actions.

### Manual deployment

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

[digital-society-coop/do-foundations]: https://github.com/digital-society-coop/do-foundations
