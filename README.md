# projet-lavallee-website

**Grav application image for lavallee.tech, built on the shared `grav-runtime`.**

This repository contains the project-specific layer of the lavallee.tech website:
theme, multilingual content, contact functionality and non-secret configuration.

It uses the same runtime and deployment architecture as the other Grav applications
in the stack.

## Where does it fit?

```text
                         grav-runtime
                              │
                  ┌───────────┴───────────┐
                  ▼                       ▼
            projet-gites       projet-lavallee-website
                                      ↑
                                 YOU ARE HERE
                  │                       │
                  └───────────┬───────────┘
                              ▼
                   ansible-role-grav-site
                              │
                              ▼
                     persistent instance
```

This repository is a second concrete application of the same architecture used by
`projet-gites`: the application changes, while the runtime and deployment mechanism
remain reusable.

## Responsibilities

### What it does

- Provides the `lavallee-theme` Grav theme.
- Provides the lavallee.tech website content.
- Provides French, English and German versions of the website.
- Provides the project-specific `contact` plugin.
- Provides non-secret Grav configuration.
- Provides the initial content used to seed a new instance.
- Builds a deployable application image derived from `grav-runtime`.
- Provides automated application and persistence tests.

### What it does not do

- Does not provide or maintain PHP.
- Does not provide or maintain Nginx.
- Does not provide Grav Core.
- Does not contain production SMTP secrets.
- Does not implement production deployment logic.
- Does not manage persistent production data after initialization.
- Does not manage DNS, TLS or the reverse proxy.

Those responsibilities are deliberately separated between `grav-runtime`,
`ansible-role-grav-site` and the surrounding infrastructure.

## Quick Start

Requirements:

- Docker
- Docker Compose v2

Start the development environment:

```bash
docker compose -f compose.dev.yml up -d --build
```

Open:

```text
Site:  http://localhost:8080
Admin: http://localhost:8080/admin
```

The development credentials defined in `compose.dev.yml` are disposable and must not
be used in production.

Stop and remove the local development environment:

```bash
docker compose -f compose.dev.yml down -v
```

Run the complete local test suite:

```bash
sh tests/run-all.sh
```

## Tested & Supported

| Component | Support |
|---|---|
| Base runtime | `grav-runtime` |
| Deployment | `ansible-role-grav-site` |
| Local runtime | Docker + Docker Compose v2 |
| Languages | French / English / German |
| Application packaging | Docker image |
| Container registry | GHCR |
| Versioning | Explicit release tags |

The automated tests cover:

- image build;
- container startup and health;
- application/theme/plugin presence;
- multilingual routes;
- contact form presence;
- persistence across container restarts.

The production application image is published as:

```text
ghcr.io/sepp67/projet-lavallee
```

Production deployments should always reference an explicit version.

## Documentation & Related Components

Full documentation:

**https://docs.lavallee.tech/grav-stack/applications/projet-lavallee/**

Related repositories:

- [`grav-runtime`](https://github.com/sepp67/grav-runtime) — shared Grav runtime.
- [`projet-gites`](https://github.com/sepp67/projet-gites) — another application built on the same architecture.
- [`ansible-role-grav-site`](https://github.com/sepp67/ansible-role-grav-site) — reusable deployment role.

## License

MIT