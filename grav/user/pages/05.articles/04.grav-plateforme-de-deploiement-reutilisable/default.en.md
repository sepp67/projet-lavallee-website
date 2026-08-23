---
title: 'From Deploying One Website to Designing a Reusable Deployment Platform'
subtitle: 'What a simple Grav CMS deployment taught me about persistence, lifecycle boundaries, and maintainable architecture.'
template: article
published_label: August 23, 2026
date: '23-08-2026 12:00'
---

Many technical architectures do not start on a whiteboard.

They start with a concrete problem.

In my case, the initial requirement was relatively simple: automatically deploy a Grav CMS website used for internal documentation to a virtual machine.

Docker for the runtime environment, Ansible for deployment — at first glance, nothing particularly complex.

The real architectural question emerged later:

> **How can I redeploy the application at any time without putting user-generated data at risk?**

From this initially simple constraint, a reusable deployment architecture gradually emerged.

---

## The first problem: the application is replaceable, its data is not

Grav is a flat-file CMS. Content is therefore stored primarily as files rather than in a traditional database.

This makes Grav particularly attractive for small websites and documentation systems: the technical stack remains lightweight, with no additional database to operate and maintain.

But this simplicity introduces an important deployment boundary.

The application can be rebuilt at any time from a defined artifact.

The content, however, evolves during operation.

A user edits a page.

An administrator uploads an image.

Accounts are created.

Configuration changes.

As soon as the system enters production, it acquires a state that can no longer necessarily be reconstructed from the Git repository.

The first architectural decision was therefore:

> **A deployment may replace the application, but it must never replace its persistent data.**

The relevant data was therefore separated from the lifecycle of the container.

A container can be removed and recreated. The content remains in place.

The initial problem was solved.

But only for one website.

---

## Then came the second website

New projects subsequently created the need for additional Grav websites.

At that point, I could simply have copied the existing setup.

A new Docker Compose file.

Adapted Ansible code.

A few new variables.

Deployment complete.

With only two projects, that would probably even have been the fastest solution.

But every new project would then have acquired its own variation of the same deployment logic.

By the next Grav update, new questions would have appeared:

Which projects need to be updated?

Which version uses which PHP runtime?

Where has the deployment logic already been updated?

Which variation supports rollback?

The small amount of time saved on the second project would gradually have turned into a maintenance cost.

So the question changed.

It was no longer:

> *How do I deploy this Grav website?*

It became:

> **How do I build a mechanism that can deploy and maintain different Grav websites in the same way?**

That was the point where a deployment problem became an architecture problem.

---

## Lifecycle, not code, defines the boundaries

The analysis showed that what appeared to be a single system was actually composed of several elements with different lifecycles:

```text
Runtime
    ≠
Website / application
    ≠
User data
    ≠
Deployment mechanism
```

The **runtime**, for example, changes when Grav, PHP, or system dependencies are updated.

The **website** changes when templates, plugins, or project-specific features are developed.

**User data** evolves independently during normal operation.

And the **deployment mechanism** changes for entirely different reasons — for example, when health checks, secret handling, or rollback procedures are improved.

Managing all of these elements as one project simply because they collectively make up a website would artificially couple components that evolve at different speeds and for different reasons.

That was precisely the coupling I wanted to avoid.

---

## Three repositories, three responsibilities

This reasoning led to an architecture built around three clearly separated technical components.

### `grav-runtime` — the shared runtime environment

The runtime provides the technical foundation:

* Grav;
* PHP;
* required system components;
* common runtime configuration.

It knows nothing about holiday cottages, documentation websites, or any other business-specific content.

Its responsibility is exclusively:

> **Provide a reproducible Grav runtime environment.**

---

### The website repository — the actual project

A repository such as `projet-gites`, on the other hand, contains what makes a specific website unique:

* project-specific configuration;
* templates;
* plugins;
* design;
* initial content.

The project itself does not need to determine how a server should be prepared or how deployment should be performed.

It describes the website.

Not the deployment platform.

---

### `ansible-role-grav-site` — the deployment mechanism

The third component automates deployment.

The Ansible role is responsible for tasks such as preparing the required environment, provisioning persistent directories, integrating configuration and secrets, starting the requested image version, and verifying the application's state afterwards.

One principle is essential:

> **The role should not need to know which website it is deploying.**

It receives a versioned application and the required configuration.

The deployment logic therefore remains independent of the specific project.

---

## Persistent data creates a fourth boundary

The three Git repositories, however, represent only part of the architecture.

Alongside them exists a fourth domain:

**the persistent state of the running instance.**

```text
                 grav-runtime
                      │
                      ▼
               Website artifact
                      │
                      ▼
            ansible-role-grav-site
                      │
                      ▼
                Grav instance
                      │
             ┌────────┴────────┐
             ▼                 ▼
        Application       Persistent data
        replaceable       must survive
```

This distinction has an important consequence.

Git repositories, container images, and deployment code can be reproduced.

Production user data, on the other hand, must be preserved, backed up, and potentially migrated when versions change.

This gives the term “deployment” a much more precise meaning.

---

## Installation is only the beginning

In a single-server project, a great deal of attention is often given to the initial installation.

Over the full lifecycle of a system, however, installation is probably the least interesting operation.

A website is installed once.

It may then run for years.

The important questions therefore become:

**How is it updated?**

**How can I return to the previous version if a release causes problems?**

**How is persistent data protected?**

**How do I migrate to a new runtime version?**

The model changes from:

> **install**

to:

> **deploy → update → rollback → migrate**

That changes the perspective.

The objective is no longer simply to get software running on a server.

The objective is to **make its entire technical lifecycle controllable**.

---

## Rollback is not an emergency procedure

Rollback is a good example.

One approach would be to develop a dedicated recovery script and hope that it works on the day it is eventually needed.

I chose a different approach.

As far as possible, a rollback should be the same operation as a normal deployment — only with a different version.

If version `1.4.0`, for example, causes problems, the previously known stable version `1.3.2` simply becomes the desired state again.

The deployment mechanism remains unchanged.

This reduces special-case logic exactly where it is least desirable: during an incident.

---

## The second instance is the real architecture test

It is easy to call an architecture “reusable” while only one project is using it.

Things become interesting with the second project.

That is when you discover which assumptions were genuinely generic and which ones were unconsciously tied to the first project.

Which names were hard-coded?

Which directories were project-specific?

Which ports were taken for granted?

Which configuration belongs to the platform, and which belongs to the application?

The second instance is therefore more than just another user of the platform.

It is an architecture test.

Every project-specific assumption exposed at this stage helps define the boundary between platform and application more precisely.

---

## What I learned from this project

Technically, this solution relies on well-known tools.

Grav.

Docker.

Ansible.

Git.

None of them is particularly unusual on its own.

For me, the interesting part is therefore not the choice of tools.

It is the definition of their responsibilities.

A concrete problem — running an internal documentation website while preserving its state — first led to an automated deployment.

Additional projects then revealed that deployment itself was not the real problem.

The real problem was **maintainability across multiple projects and over several years**.

The main lesson I take from this project is:

> **Architecture boundaries should not be defined only by what components do, but also by how and why they change.**

If the runtime, application, user data, and deployment mechanism follow different lifecycles, those boundaries should also be visible in the architecture.

The result is not a spectacularly complex platform.

Quite the opposite.

The goal is to build a platform where the next project becomes easier than the first — and where the tenth project does not require ten times as much deployment logic.

That, to me, is the real value of reusable architecture.
