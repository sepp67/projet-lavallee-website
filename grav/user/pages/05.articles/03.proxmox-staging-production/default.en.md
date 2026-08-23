---
title: 'Why I split staging and production across two Proxmox nodes'
subtitle: 'How a self-hosted platform moved from a single Proxmox node to infrastructure split between staging and production.'
published_label: 'June 2, 2026'
date: 06-02-2026
template: article
---

When I bought the domain name **lavallee.tech** in 2021, my goal was simple: learn, experiment, and host a few services for local non-profits. Back then, a single Proxmox node installed on a second-hand Dell OptiPlex was more than enough. I deployed a handful of YunoHost virtual machines, hosted several websites, and provided cloud and messaging services to various associations. Five years later, the infrastructure has changed a lot. What started as a small self-hosting project gradually became a platform hosting production services, development environments, monitoring systems, and custom applications. That growth eventually forced me to rethink the architecture entirely.

<figure class="prose-figure">
  <img src="/articles/proxmox-staging-production/before-after-proxmox.png" alt="Architecture before and after: moving from a single Proxmox node to a staging / production split.">
  <figcaption>The infrastructure before and after separating the staging and production environments.</figcaption>
</figure>

## The original architecture

The platform initially ran on a Dell OptiPlex 3040 with an Intel i5-6500 processor and 16 GB of RAM. For several years, this single machine hosted all the services:

- Cloud and messaging services for local associations
- Nextcloud and Matrix deployments
- WordPress sites
- Monitoring systems
- Development projects
- Production applications

The simplicity of a single-node infrastructure had many advantages. There was only one machine to administer, and resources were easy to manage. As long as the number of services stayed limited, this approach worked surprisingly well.

## When growth becomes a problem

The first major shift was the introduction of a real staging / production deployment cycle. At first, I only hosted a few WordPress sites. Deployments were simple and the risk tied to production changes stayed low. That changed when I started developing and deploying my own applications. A monitoring infrastructure was added. A reverse proxy architecture was set up. The lavallee.tech site became a project in its own right. An IP camera video streaming application was deployed. A French electronic invoicing application entered development. Every new project now needed both a production environment and a staging environment. Over time, the infrastructure grew to nearly twenty virtual machines. At that point, the limits of the original hardware became impossible to ignore.

## Memory that had become insufficient

The Dell OptiPlex 3040 is limited to 16 GB of RAM.

Today, this node hosts:

- 1 AzuraCast VM
- 1 Proxmox monitoring VM
- 4 YunoHost VMs for local associations
- 2 WordPress VMs
- 1 production reverse proxy VM
- 1 lavallee.tech VM
- 1 Facturier VM
- 1 video streaming VM
- The equivalent of these applications in staging
- 2 monitoring VMs for the application platform
- 1 Ansible control VM

The clearest sign that the infrastructure had hit its limits was that the staging environment could no longer stay powered on permanently. To guarantee the stability of production services, I had to shut down all the staging virtual machines. Even with about ten VMs stopped, memory usage stayed close to 80%. At that point, it was no longer possible to add more memory, since the machine had already reached its maximum capacity. The infrastructure had simply outgrown the original server's capabilities.

## Why add a second Proxmox node?

Rather than replacing the existing machine, I decided to add a second Proxmox node. The new server is a Dell OptiPlex 7010 with an Intel i7-3770 processor and 32 GB of RAM. I deliberately chose a second-hand workstation again. Many homelabs rely on professional server hardware, but in my case memory capacity usually matters more than raw processor power. Second-hand Dell OptiPlex machines are inexpensive, reliable, compact, and easy to find. Above all, they offer an excellent cost-to-capacity ratio for a self-hosted infrastructure. Adding this second node immediately raised available memory from 16 GB to 48 GB while keeping the budget reasonable.

## Separating staging and production

The main goal of the new node is to physically separate production and staging workloads. Previously, the two environments shared the same hardware. This setup was acceptable early in the project but became increasingly difficult to maintain as the number of applications grew. The new architecture is much simpler:

<figure class="prose-figure">
  <img src="/articles/proxmox-staging-production/proxmox-two-nodes.png" alt="Proxmox datacenter showing the two-node architecture.">
  <figcaption>The current Proxmox datacenter. Production and staging workloads are now spread across two distinct physical servers.</figcaption>
</figure>

| Node | CPU | RAM | Role |
|---|---|---|---|
| Dell OptiPlex 3040 | Intel i5-6500 | 16 GB | Production |
| Dell OptiPlex 7010 | Intel i7-3770 | 32 GB | Staging |

### Production node

- Services for the associations
- Nextcloud
- Matrix
- WordPress sites
- Publicly accessible applications
- Reverse proxy services

### Staging node

- Application development
- Deployment validation
- Infrastructure testing
- Experimental projects

This separation provides better resource isolation and makes it possible to keep staging environments available at all times. More importantly, it brings the organization of the infrastructure closer to what you'd find in professional environments.

## Reducing dependency on some YunoHost instances

YunoHost played an important role in the platform's growth. It let me quickly deploy services like Nextcloud or Matrix and was an excellent entry point into self-hosting. However, as the number of services increased, some limitations appeared. Each YunoHost instance requires a dedicated virtual machine and consumes significantly more memory than a containerized deployment. Monitoring several YunoHost instances also becomes more complex as the infrastructure grows. For these reasons, I chose to use this restructuring as an opportunity to progressively migrate some collaborative services to Docker deployments managed with Ansible. The goal isn't to fully replace YunoHost, but to use a more flexible model where it makes sense.

## Building centralized monitoring

Another important motivation behind this restructuring is observability. As new applications and virtual machines were added, monitoring became fragmented. Several monitoring solutions were deployed over time, including a platform dedicated to Proxmox as well as separate monitoring environments for the applications. The long-term goal is to centralize monitoring around a platform based on Prometheus, Grafana and Loki. Instead of monitoring each environment separately, the whole infrastructure will be visible from a single point. This will simplify incident diagnosis, improve overall visibility, and make it easier to understand resource consumption across all nodes.

## Preparing for future projects

The infrastructure is also being prepared to host new applications. One of the most important projects currently in development is a French electronic invoicing platform capable of generating Factur-X invoices from PDF documents. This application needs a real staging environment to test new features before they go to production. Having dedicated staging infrastructure removes a significant obstacle to development and lets projects evolve faster.

## What's next?

The goal of this restructuring isn't simply to add more memory. It's an opportunity to rethink an infrastructure that has changed considerably since 2021. What started as a small self-hosted environment for a handful of associations has become a platform hosting production services, development environments, monitoring systems, and custom applications. By separating staging from production, migrating some workloads to Docker, and building a centralized monitoring platform, the infrastructure becomes easier to maintain, easier to evolve, and better prepared for future projects. The Dell OptiPlex 3040 did its job remarkably well. Adding a second Proxmox node is, in the end, just another step in the platform's evolution.
