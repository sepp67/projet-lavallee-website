---
title: Home
template: homepage
metadata:
  description: "I design, deploy and maintain reproducible Linux infrastructure built on open source technologies, with digital sovereignty as a design principle."
---

<section class="hero">
  <div class="wrap">
    <div class="eyebrow">open source infrastructure consultant</div>
    <h1>Digital sovereignty, deployed with method.</h1>
    <p class="hero-sub">I design, deploy and maintain reproducible Linux infrastructure — communication, files, mobile devices — for organizations that want to take back control of their digital tools, without depending on a single vendor.</p>
    <div class="cta-row">
      <a href="#flagships" class="btn btn-primary btn-lg">See my flagship projects →</a>
      <a href="#contact" class="btn btn-ghost btn-lg">Get in touch</a>
    </div>

    <div class="diagram">
      <svg viewBox="0 0 1040 220" fill="none" xmlns="http://www.w3.org/2000/svg" aria-hidden="true">
        <g stroke="var(--line-strong)" stroke-width="1">
          <path d="M60,180 C220,180 220,60 380,60"/>
          <path d="M380,60 C520,60 520,150 660,150"/>
          <path d="M660,150 C800,150 800,70 980,70"/>
          <path d="M380,60 C420,110 420,150 380,180"/>
          <path d="M380,180 L200,180"/>
        </g>
        <circle r="4" fill="var(--amber)" class="pulse" style="offset-path:path('M60,180 C220,180 220,60 380,60 C520,60 520,150 660,150 C800,150 800,70 980,70');"/>

        <g font-family="JetBrains Mono, monospace" font-size="11" fill="var(--paper-dim)">
          <circle cx="60" cy="180" r="5" fill="var(--muted)"/>
          <text x="60" y="204" text-anchor="middle">user</text>

          <circle cx="200" cy="180" r="5" fill="var(--blue)"/>
          <text x="200" y="204" text-anchor="middle" fill="var(--blue)">/e/OS</text>

          <circle cx="380" cy="60" r="6" fill="var(--amber)"/>
          <text x="380" y="40" text-anchor="middle" fill="var(--amber)">matrix-synapse</text>

          <circle cx="380" cy="180" r="5" fill="var(--blue)"/>
          <text x="380" y="204" text-anchor="middle" fill="var(--blue)">nextcloud</text>

          <circle cx="660" cy="150" r="5" fill="var(--muted)"/>
          <text x="660" y="174" text-anchor="middle">reverse proxy</text>

          <circle cx="980" cy="70" r="6" fill="var(--paper)"/>
          <text x="980" y="50" text-anchor="middle" fill="var(--paper)">managed infra</text>
        </g>
      </svg>
      <div class="diagram-caption">// separation of concerns — every building block stays independently replaceable</div>
    </div>
  </div>
</section>

<section class="problem">
  <div class="wrap">
    <div class="section-head">
      <h2>The problem</h2>
    </div>
    <p>Leaving proprietary platforms has become a concrete concern — GDPR, strategic dependency, rising costs. But replacing Slack, Teams or an MDM with an open source alternative isn't enough if it's <strong>hand-rolled</strong>, poorly secured, or impossible to maintain over time.</p>
    <p>I do the work that turns a promising open source tool into <strong>reliable infrastructure</strong>: automated, reproducible, documented, and maintainable after I'm gone.</p>
  </div>
</section>

<section id="ce-que-je-fais">
  <div class="wrap">
    <div class="section-head">
      <span class="num">// what i do</span>
      <h2>The full lifecycle of a service</h2>
      <p>I work across the whole chain: architecture, deployment, automation, updates, monitoring and incident response.</p>
    </div>

    <div class="skills-grid">
      <div class="skill-item">
        <span class="key">expertise.01</span>
        <h4>Linux administration</h4>
        <p>Installation, configuration, operations, updates, diagnostics and incident response in production. The goal: infrastructure that stays observable, documented and operable over time.</p>
        <div class="pill-tags"><span>Debian</span><span>Ubuntu</span><span>Networking</span><span>System services</span><span>Troubleshooting</span></div>
      </div>

      <div class="skill-item">
        <span class="key">expertise.02</span>
        <h4>Automation & deployment</h4>
        <div class="flow">deploy → update → rollback → migrate</div>
        <p>Ansible describes the expected state of the machines, Docker controls the application environment, Git makes it possible to know exactly what's deployed.</p>
        <div class="pill-tags"><span>Ansible</span><span>Docker</span><span>Docker Compose</span><span>Git</span><span>CI/CD</span></div>
      </div>

      <div class="skill-item">
        <span class="key">expertise.03</span>
        <h4>Infrastructure architecture</h4>
        <p>Separating responsibilities rather than building monolithic systems: runtime, application, persistent data, secrets, reverse proxy and deployment don't share the same lifecycle.</p>
        <div class="pill-tags"><span>Architecture</span><span>Reproducibility</span><span>Idempotence</span><span>Lifecycle management</span></div>
      </div>

      <div class="skill-item">
        <span class="key">expertise.04</span>
        <h4>Identity & security</h4>
        <p>Environments combining MFA, RADIUS, LDAP/Active Directory and identity federation. Secrets management, privilege limitation, separation of responsibilities.</p>
        <div class="pill-tags"><span>IAM</span><span>MFA</span><span>privacyIDEA</span><span>RADIUS</span><span>LDAP/AD</span><span>Keycloak</span><span>OIDC</span><span>SAML</span></div>
      </div>
    </div>
  </div>
</section>

<section id="flagships">
  <div class="wrap">
    <div class="section-head">
      <h2>My areas of expertise</h2>
      <p>Three stacks, one method — and a possible combination for organizations that want to go all the way with their digital sovereignty.</p>
    </div>

    <div class="flagships">
      <div class="flag matrix">
        <span class="flag-tag">stack: matrix</span>
        <h3>Sovereign communication with Matrix</h3>
        <p>Complete Matrix/Synapse infrastructure — encrypted messaging, bridges to WhatsApp, Telegram, Signal — to leave Slack or Teams without losing touch with the people you talk to. Multi-server architecture, strict separation of responsibilities, ready for strong authentication.</p>
        <a href="/en/etudes-de-cas/matrix" class="flag-link">See the Matrix case study →</a>
      </div>
      <div class="flag mobile">
        <span class="flag-tag">stack: /e/os + nextcloud</span>
        <h3>Sovereign mobile fleet</h3>
        <p>Enrollment process for refurbished smartphones running /e/OS, connected to your Nextcloud — files, contacts, calendar synchronized, with no dependency on Google. A credible alternative to proprietary MDMs to control your devices end to end.</p>
        <a href="/en/etudes-de-cas/flotte-mobile" class="flag-link">See the mobile fleet case study →</a>
      </div>
      <div class="flag grav">
        <span class="flag-tag">stack: grav cms</span>
        <h3>Reproducible websites with Grav CMS</h3>
        <p>A technical base split into three repositories — application image, deployment role, site instance — to deploy a new Grav site without starting from scratch, with a one-command rollback.</p>
        <a href="/en/etudes-de-cas/grav" class="flag-link">See the Grav CMS case study →</a>
      </div>
      <div class="flag-note">// Matrix and mobile fleet combine naturally: an organization that adopts Matrix for its communication often follows up, shortly after, with a fleet of sovereign devices to carry it everywhere.</div>
    </div>
  </div>
</section>

<section id="souverainete">
  <div class="wrap">
    <div class="section-head">
      <span class="num">// architecture principle</span>
      <h2>Digital sovereignty as an architecture principle</h2>
      <p>Digital sovereignty doesn't just mean replacing proprietary software with open source software. An organization is only truly in control of its infrastructure if it can understand how it works, know where its data lives, back it up, rebuild it, and evolve it without depending on a single vendor.</p>
    </div>

    <div class="enjeux">
      <div class="enjeu">
        <span class="k">01 · control</span>
        <p>Critical data and components stay under the organization's control.</p>
      </div>
      <div class="enjeu">
        <span class="k">02 · reversibility</span>
        <p>Infrastructure must be rebuildable, migratable or replaceable without artificial dependency on a provider.</p>
      </div>
      <div class="enjeu">
        <span class="k">03 · reproducibility</span>
        <p>Important configuration shouldn't depend on manual steps that can't be reproduced.</p>
      </div>
      <div class="enjeu">
        <span class="k">04 · maintainability</span>
        <p>The infrastructure must remain operable by someone other than the person who built it.</p>
      </div>
    </div>

    <div class="result-banner" style="margin-top:32px;">
      <p>“Open source is a means. Control of the system is the goal.”</p>
    </div>
  </div>
</section>

<section>
  <div class="wrap">
    <div class="section-head">
      <h2>Other work</h2>
      <p>The same rigor, applied to other kinds of projects.</p>
    </div>
    <div class="others">
      <a href="/en/realisations/facturation" class="other-card"><span class="name">Electronic invoicing application</span><span class="arrow">→</span></a>
    </div>
  </div>
</section>

<section id="notes-techniques">
  <div class="wrap">
    <div class="section-head">
      <h2>Technical notes</h2>
    </div>
    <!-- notes-techniques:latest-articles -->
  </div>
</section>

<section id="methode">
  <div class="wrap">
    <div class="section-head">
      <h2>How I work</h2>
    </div>
    <div class="method">
      <div class="method-item">
        <span class="key">principle.01</span>
        <h4>Understand before automating</h4>
        <p>I identify the components, their responsibilities, their dependencies and their lifecycles. Automation comes after — never before.</p>
      </div>
      <div class="method-item">
        <span class="key">principle.02</span>
        <h4>Nothing is done the same way twice</h4>
        <p>Every deployment is automated and replayable identically — on a new server, after an outage, or to duplicate an installation.</p>
      </div>
      <div class="method-item">
        <span class="key">principle.03</span>
        <h4>Separate code, configuration, secrets and data</h4>
        <p>These elements don't share the same function, the same lifecycle, or the same security requirements. No secret ever sits in plain text.</p>
      </div>
      <div class="method-item">
        <span class="key">principle.04</span>
        <h4>Design for operations</h4>
        <p>A system doesn't stop at the first <code>docker compose up</code>. Updates, rollback, backups, monitoring and diagnostics are designed in from the start.</p>
      </div>
    </div>
    <div class="flag-note">// Document to hand off: infrastructure that only its author understands is a liability. Documentation is part of the technical product delivered.</div>
  </div>
</section>

<section>
  <div class="wrap proof">
    <p><strong style="color:var(--paper)">See the work, don't just hear about it.</strong><br>Everything I deliver is documented and, whenever possible, published as open source.</p>
    <a href="https://github.com/sepp67" target="_blank" rel="noopener" class="btn btn-ghost">See my projects on GitHub →</a>
  </div>
</section>
