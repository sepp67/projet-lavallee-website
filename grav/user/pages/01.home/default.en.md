---
title: Home
template: homepage
metadata:
  description: "I design and industrialize open source infrastructure — communication, files, mobile devices — for companies, associations and public bodies who want to take back control of their digital tools."
---

<section class="hero">
  <div class="wrap">
    <div class="eyebrow">open source infrastructure consultant</div>
    <h1>Digital sovereignty, deployed with method.</h1>
    <p class="hero-sub">I design and industrialize open source infrastructure — communication, files, mobile devices — for companies, associations and public bodies who want to take back control of their digital tools, without depending on Google, Microsoft or Slack.</p>
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
        <h4>Each building block does one thing</h4>
        <p>I always separate the application role, the deployment, and the shared infrastructure. I can replace one component without breaking the rest.</p>
      </div>
      <div class="method-item">
        <span class="key">principle.02</span>
        <h4>Nothing is done the same way twice</h4>
        <p>Every deployment is automated and replayable identically — on a new server, after an outage, or to duplicate an installation.</p>
      </div>
      <div class="method-item">
        <span class="key">principle.03</span>
        <h4>No secret ever sits in plain text</h4>
        <p>Passwords, tokens, certificates: always encrypted, never committed to a code repository in plain text.</p>
      </div>
      <div class="method-item">
        <span class="key">principle.04</span>
        <h4>I only sell what I actually master</h4>
        <p>If a piece falls outside my real scope, I say so clearly — rather than improvising as an expert on a subject I don't fully master.</p>
      </div>
    </div>
  </div>
</section>

<section>
  <div class="wrap proof">
    <p><strong style="color:var(--paper)">See the work, don't just hear about it.</strong><br>Everything I deliver is documented and, whenever possible, published as open source.</p>
    <a href="https://github.com/sepp67" target="_blank" rel="noopener" class="btn btn-ghost">See my projects on GitHub →</a>
  </div>
</section>
