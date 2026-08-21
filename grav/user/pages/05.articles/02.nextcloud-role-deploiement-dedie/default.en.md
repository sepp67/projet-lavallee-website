---
title: Why Nextcloud needs a dedicated deployment role rather than a generic Docker role
subtitle: A field report on deploying Nextcloud in a staging environment managed with Ansible and Docker.
published: June 8, 2026
template: article
---

As part of restructuring my infrastructure, I recently set up a staging environment separate from production. The goal was simple: validate new application versions before deploying them to production.

Most of my applications follow the same pattern:

- Pull a Docker image from GitHub Container Registry.
- Expose an HTTP port.
- Configure the reverse proxy.
- Check that the application works correctly.

This approach works perfectly for:

- Grav CMS
- Webcam Stream
- Facturier Demo
- Static websites

For this, I created a generic Ansible role named:

```text
staging_docker_app
```

This role simply performs:

1. Downloading the image.
2. Creating the container.
3. Exposing the port.
4. Starting the service.

For simple applications, this approach is efficient, reusable and easy to maintain.

Nextcloud, however, quickly exposed the limits of this method.

## The initial assumption

At first, I assumed Nextcloud could be deployed like any other application.

The configuration looked like this:

```yaml
app_name: nextcloud
app_image: ghcr.io/sepp67/ansible-role-nextcloud-stack:latest
app_container_name: nextcloud-staging
app_host_port: 18080
app_container_port: 80
```

The deployment appeared to succeed.

The container started.

The proxy worked.

But the application wasn't actually operational.

## Understanding the problem

Unlike a typical web application, Nextcloud isn't made up of a single service.

My deployment is composed of:

```text
Nextcloud Stack
├── Nextcloud
├── PostgreSQL
├── Redis
└── Cron
```

The Docker Compose file makes this clear:

```yaml
services:
  db:
    image: postgres

  redis:
    image: redis

  app:
    image: nextcloud

  cron:
    image: nextcloud
```

The main container depends on:

- PostgreSQL for data storage;
- Redis for caching and file locking;
- Cron tasks for background processing.

Starting only the Nextcloud container therefore leads to an incomplete deployment.

## A fundamental architectural difference

My generic role relied on the assumption:

```text
One application = One container
```

Nextcloud follows a different model:

```text
One application = Several cooperating services
```

This is a completely different deployment pattern.

Trying to handle both models in the same role quickly leads to:

- many special-case conditions;
- logic that's hard to follow;
- more complex maintenance;
- a loss of readability.

At that point, the generic role stops being genuinely generic.

## The right solution

Rather than complicating the existing role, I created a dedicated one:

```text
staging_nextcloud_stack
```

Responsibilities are now clearly separated.

### Generic role

```text
staging_docker_app
```

Used for:

- Grav
- Webcam Stream
- Facturier Demo
- Static websites

Responsibilities:

- download the image;
- create the container;
- expose the port;
- start the service.

### Dedicated Nextcloud role

```text
staging_nextcloud_stack
```

Responsibilities:

- create the persistent directories;
- generate the environment variables;
- generate the Docker Compose file;
- deploy PostgreSQL;
- deploy Redis;
- deploy Nextcloud;
- deploy Cron;
- start the whole stack.

## Reusing existing components

Another important lesson concerns reuse.

My infrastructure already had a role:

```text
docker_host
```

responsible for installing:

- Docker CE;
- Docker Compose Plugin;
- Buildx;
- Containerd.

At first, I had tried installing Docker directly from the Nextcloud role.

This created redundant responsibilities.

The final architecture became:

```text
docker_host
        │
        ▼
staging_nextcloud_stack
```

The Docker role manages Docker.

The Nextcloud role manages Nextcloud.

## Final architecture

The staging environment now looks like this:

```text
vm-proxy-staging
│
├── lavallee.staging.local
├── facturier.staging.local
├── grav.staging.local
├── webcam.staging.local
└── nextcloud.staging.local
```

Applications are deployed on dedicated virtual machines.

The Nextcloud VM contains:

```text
vm-nextcloud-staging
│
├── PostgreSQL
├── Redis
├── Nextcloud
└── Cron
```

The whole thing is deployed automatically with Ansible and Docker Compose.

## Conclusion

The goal of automation isn't to make every deployment identical.

The goal is to make every deployment predictable, maintainable and understandable.

For simple applications, a generic role is perfectly suited.

For applications made of several services, like Nextcloud, a dedicated role produces a cleaner, more durable architecture.

The lesson is simple:

> Generic roles should stay generic. Complex applications deserve their own deployment logic.
