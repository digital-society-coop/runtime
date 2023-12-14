# Requirements

This uses the [MoSCoW method] to prioritise requirements for a general-purpose service runtime.

[MoSCoW method]: https://en.wikipedia.org/wiki/MoSCoW_method

## Must support running OCI images

OCI images are maximally flexible, supporting everything from large and complex runtime environments to single binary builds.
They also encourage immutable and reproducible builds.

## Must have low minimum cost

We don't anticipate running a large volume of production workloads, at least initially, or on all instances of the platform.
As such, we want the minimum cost (e.g. platform with no workloads, and/or very quiet workloads) to be as low as possible.

We also wish to be able to deploy new environments with minimal manual steps (accepting some manual steps may be required at launch, such as granting permission to repositories).

## Must have UK and EU data centres

We are likely to work primarily with UK and EU organisations.
To meet their regulations we may need to limit where we host workloads/data.

## Must have a low per-service setup effort and cost

We don't want platform-imposed effort or cost to be a major factor when deciding whether to deploy a new service or augment an existing one.
This lets us architect better for other requirements.

## Must have 99.9%+ uptime for platform and workloads

The platform functionality (e.g. deployments, monitoring) should have 99.9% availability or more.
The platform should have the necessary features (e.g. auto-scaling, redundancy, self-healing) to support workloads with 99.9% availability or more.
When unavailability occurs that can't be automatically resolved, operators should be notified swiftly.

## Must have low operational overhead

Operational work is tedious and takes time from mission-critical work, so we want to minimise how much we have to do.
This applies both to the platform (e.g. we don't want to be patching instances, applying frequent updates, or migrating to new APIs) and workloads (e.g. they should self-heal).

Put another way, we want to reach our availability thresholds with no manual involvement.

## Must support automated deployments for workloads

We believe automated deployments is critical for quality at pace.

## Must support secure handling of sensitive configuration (secrets)

Sensitive configuration is required for many services, and it's essential to handle it securely (e.g. minimise exposure within and without the platform).

## Must support connecting to external services

Workloads need to be able to communicate with external services, e.g. databases, queues, object stores, 3rd party APIs.

## Must support a variety of workloads

In particular, should support both stateless (e.g. web services) and stateful (e.g. clustered services) workloads.

## Must have some longevity and stability

We don't want to have to re-platform regularly due to the platform becoming redundant.

## Must be able to securely expose HTTPS endpoints

Public-facing workloads should generally be exposed through HTTPS.
The platform must support configuration of DNS, certificates, etc. that are required to support this.
Services must be able to restrict which ports are exposed.

## Must be able to debug workloads

Must be able to identify the causes of issues, e.g. service errors, poor performance, cost spikes.

## Should be an ethical vendor

We are a socially-minded organisation, and as such prefer to work with vendors who take their social responsibility seriously.

## Should not lock us in to a single vendor

E.g. workloads and/or configuration should be portable to other vendors.
This gives us a recourse if vendors change their prices, terms, or operation in an unfavourable way.

## Should support automated TLS certificate management

TLS certificate provisioning and renewal should be automated by the platform.

## Should allow me to measure the performance of the service

We would like to be able to continuously improve services driven by measuring the performance of services in terms that make sense for the service.
E.g. number of active users, session duration, tail latency.

## Could provide an overview of the performance of all my services

In order to streamline our operations, we could capture performance of all services centrally and present them through a unified dashboard.

## Could support more advanced features for service evolution

E.g. blue-green/canary deployments.

## Could support more advanced observability features

E.g. centralised logs, OpenTelemetry, tracing networked services, ...

## Could support more advanced network security

E.g. private networking, network policies, complex WAF rules (e.g. rate-limiting, suspicious traffic detection).
