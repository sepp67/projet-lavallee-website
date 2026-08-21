---
title: "Adding MFA without breaking what's there: an architect's take"
subtitle: Rolling out MFA is the first concrete step of an identity infrastructure project
published: June 22, 2026
template: article
---

## The problem a simple plugin doesn't solve

You may recognize this situation. Your authentication system relies on an **OpenLDAP** directory that's been in place for years. It powers your **Nextcloud**, maybe other internal applications. Everything works. Nobody wants to touch it.

And then comes the question that keeps coming back: *"Why isn't MFA enabled everywhere yet?"*

The honest answer is often: because nobody knows how to do it without breaking everything.

Credential theft has become the number one entry point in the majority of security incidents. A password alone, however complex, is no longer enough to protect an account. Cyber insurers know it, auditors know it, and more and more clients and partners now ask for it explicitly before signing a contract. MFA (multi-factor authentication) is no longer a security nicety — it has become a baseline expectation.

The question isn't **whether** to do it. It's knowing **how** to do it without rethinking everything.

## Three paths, only one that prepares for the future

Looking at the options available for adding MFA to an existing infrastructure, you generally run into three paths.

**Migrate to an all-in-one identity solution.** This is the promise of a modern, integrated platform that handles everything. But in practice, it's a long, expensive and risky project: you have to migrate the directory, reconfigure every application, train the teams, and accept a transition window during which anything can break.

**Add an MFA plugin specific to a single application.** In our case, PrivacyIDEA happens to offer a native plugin for Nextcloud. It's fast, cheap, and it works. But it solves the problem for a single application. If tomorrow you need to protect a VPN, another web application, or server access, you have to start over with another tool, another logic, another maintenance burden.

**Add a central identity layer, without touching what's there.** This is the least intuitive option at first glance, because it means introducing new components. But it's the only one that touches neither the directory nor the applications, and that lays the groundwork to secure the rest of the infrastructure later.

We chose the third path. That's the heart of this article: why this choice, how it's built technically, and what it makes possible once it's in place.

## The architecture chosen: two roles, clearly separated

<figure class="prose-figure">
  <img src="/articles/mfa-keycloak-privacyidea/add-MFA-fr.png" alt="Integrating two-factor authentication without disrupting what already works.">
</figure>

The most important decision in this project wasn't a choice of tool, but a choice of **separation of responsibilities**. Rather than looking for a single product that would do everything, we introduced two components between the directory and the applications, each with a precise role.

### Keycloak, as a single point of passage

The first component is **Keycloak**, used as an *Identity Provider*. Its role: become the single point through which all of the organization's authentications flow. Keycloak connects to the existing OpenLDAP directory — without modifying it — and it's now the one receiving login requests, instead of each application individually.

Concretely, Nextcloud no longer checks a password against the directory itself. It delegates that check to Keycloak. For the user, nothing changes in appearance. For the organization, everything changes in structure: there is now a single place to decide authentication rules, instead of one rule per application.

### PrivacyIDEA, second-factor specialist

The second component is **PrivacyIDEA**. It's worth being precise about what it is, because it's often a source of confusion: PrivacyIDEA is **not** an identity provider. It's a **token server**. Its role is limited to one thing, but it does it very well: registering a second factor (OTP token, mobile app, etc.) for each directory user, and verifying the value entered at login time.

Keycloak itself natively offers a token enrollment mechanism. Why not just use that? Because its options remain limited to simple scenarios. PrivacyIDEA, on the other hand, is designed to manage **authentication workflows** — and that's precisely what justifies its presence in the architecture rather than a sole dependency on Keycloak.

## Authentication as a process, not a checkbox

Authentication isn't a binary operation. It's a chain of checks, which can stay very simple or become quite rich depending on the organization's needs. This is a point often overlooked when approaching MFA as a simple switch to flip — when it's actually a workflow to design.

In the simplest scenario we implemented:

- Keycloak checks the password directly against the OpenLDAP directory.
- PrivacyIDEA, in parallel, checks only the value of the one-time code (OTP).

Each component does one thing, and does it well. But the architecture allows going further: it's possible to also pass the password to PrivacyIDEA, which can then use it as a trigger for more elaborate scenarios — requiring a different factor depending on the user's profile, adapting the policy based on the connection context, or chaining several checks. This is flexibility that Keycloak's native mechanism alone doesn't offer at this stage.

A point often overlooked in MFA rollouts: what happens for a user logging in for the first time, with no second factor registered yet? This is a case the architecture must handle explicitly — the workflow must be able to detect the absence of a token and trigger an enrollment journey, rather than simply blocking the user. It's a detail, but it's often the one that decides whether an MFA rollout goes smoothly or generates a stream of support tickets.

At this stage, none of the existing applications needed to be deeply reconfigured. OpenLDAP remains the reference directory, unchanged. Nextcloud keeps working normally, simply reconnected to Keycloak instead of the directory directly.

## Why this "heavier-looking" architecture is actually the right call

This is where the architect's thinking really matters. An MFA plugin specific to Nextcloud would have solved the immediate problem faster. But it would also have closed the door on everything that naturally follows once MFA is in place: securing other applications, other types of access, with the same consistency.

By placing Keycloak at the center, we didn't just protect Nextcloud. We created a single point of passage able to absorb, without rebuilding, the security needs of the coming years. That's the difference that separates a one-off fix from an investment in infrastructure — and it's exactly the kind of trade-off an architect should make explicit before laying the first brick, rather than discovering it when a second need shows up.

### OpenID Connect: opening the door to web applications

Once Keycloak is in place, a new possibility opens up: connecting any web application compatible with **OpenID Connect** (OIDC).

OpenID Connect is an open protocol — in the same way HTTP is for the web — that defines how an application delegates authentication of its users to an external identity provider. It works around three elements:

- The **OpenID Provider (OP)**: that's Keycloak. It authenticates the user and issues a token.
- The **ID Token**: a JWT-formatted token that attests the user has indeed been authenticated, and carries some of their information.
- The **Relying Party (RP)**: the client application — the one the user actually wants to use. It trusts the token issued by Keycloak instead of handling authentication itself.

What makes this protocol valuable for an organization is what it doesn't change. An application connected via OpenID Connect keeps its own configuration, its own user groups, its own internal permissions. Only authentication is delegated. Where integrating a new authentication system usually takes weeks of dedicated development, an OIDC-compatible application can generally be connected to Keycloak in a matter of hours.

### RADIUS: the same logic for VPNs and servers

Web authentication isn't the only ground to secure. VPN access and connections to virtual machines usually rely on a different protocol: **RADIUS**.

The same identity architecture, built for web MFA, extends naturally to these uses. The principle stays identical: a central authentication point, able to verify a password and a second factor, whatever the channel — a web page, a VPN connection, or server access.

That's where the initial investment really pays off. The organization doesn't deploy one MFA tool for Nextcloud, another for the VPN, a third for the servers. It deploys a single authentication policy, applied consistently wherever it's needed.

## What to remember

MFA is never a standalone project. It's always the first building block of an identity infrastructure project.

The difference matters when evaluating it: an MFA project ends when the second factor works. An identity infrastructure project keeps producing value with every new connected application, every newly secured access, with no need to start over from a blank page.

That's exactly the kind of architecture I know how to design and put in place: start from an existing system, without breaking it, and build on top of it an identity layer able to absorb the security needs of years to come.

If your company is in this situation (an OpenLDAP, a Nextcloud, or any other existing system) with an MFA need that looks like the first of a long series of security needs, let's talk. That's precisely the kind of project I support.
