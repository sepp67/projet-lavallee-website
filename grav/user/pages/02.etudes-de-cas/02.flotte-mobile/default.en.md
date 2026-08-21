---
title: Sovereign mobile fleet /e/OS + Nextcloud
template: etude-cas-flotte-mobile
metadata:
  description: "Rolling out an enrollment process for a fleet of refurbished smartphones running /e/OS, connected to a self-hosted Nextcloud — no Google account, no proprietary MDM."
---

<header class="case-header">
  <div class="wrap">
    <span class="flag-tag">case study — stack: /e/os + nextcloud</span>
    <h1>Equipping a mobile team without depending on Google</h1>
    <p class="case-sub">Rolling out an enrollment process for a fleet of refurbished smartphones running /e/OS, connected to a self-hosted Nextcloud — files, contacts and calendar synchronized, with no Google account and no proprietary MDM subscription.</p>

    <div class="meta-row">
      <div class="meta-item"><span class="k">Type of organization</span><span class="v">Cooperative, 15 field workers</span></div>
      <div class="meta-item"><span class="k">Trigger</span><span class="v">Leaving Google Workspace</span></div>
      <div class="meta-item"><span class="k">Key constraint</span><span class="v">Refurbished devices</span></div>
      <div class="meta-item"><span class="k">Stack</span><span class="v">/e/OS · Nextcloud · DAVx5</span></div>
    </div>
  </div>
</header>

<section>
  <div class="wrap">
    <div class="section-head">
      <span class="num">// context</span>
      <h2>The problem</h2>
    </div>
    <div class="prose">
      <p>The cooperative's field technicians used to travel with personal phones or Android devices tied to a Google Workspace account billed per user. As the renewal approached, the organization wanted to leave that dependency behind — without falling back on an equally costly, equally closed proprietary MDM (Intune, Jamf).</p>
      <p><strong>The budget constraint steered the choice towards refurbished hardware</strong>: rather than buying new, equip the fleet with refurbished phones flashed with /e/OS — provided the installation and connection process to the existing Nextcloud was reliable and reproducible, not hand-tinkered device by device.</p>
    </div>
  </div>
</section>

<section>
  <div class="wrap">
    <div class="section-head">
      <span class="num">// stakes</span>
      <h2>What had to be reconciled</h2>
    </div>
    <div class="enjeux">
      <div class="enjeu"><span class="k">Cost</span><p>Refurbished devices rather than new, no recurring MDM subscription per device.</p></div>
      <div class="enjeu"><span class="k">Autonomy</span><p>No dependency on a Google account — files, contacts and calendar hosted by the cooperative.</p></div>
      <div class="enjeu"><span class="k">Reproducibility</span><p>The same enrollment process applied identically to every new device.</p></div>
      <div class="enjeu"><span class="k">Lifecycle</span><p>Being able to reassign or wipe a device cleanly when someone leaves or a device is replaced.</p></div>
    </div>
  </div>
</section>

<section>
  <div class="wrap">
    <div class="section-head">
      <span class="num">// architecture</span>
      <h2>The choices that shape the process</h2>
    </div>

    <div class="diagram-box">
      <svg viewBox="0 0 1000 260" fill="none" xmlns="http://www.w3.org/2000/svg" aria-hidden="true">
        <g stroke="var(--line-strong)" stroke-width="1">
          <line x1="120" y1="130" x2="300" y2="60"/>
          <line x1="120" y1="130" x2="300" y2="130"/>
          <line x1="120" y1="130" x2="300" y2="200"/>
          <line x1="420" y1="60" x2="600" y2="130"/>
          <line x1="420" y1="130" x2="600" y2="130"/>
          <line x1="420" y1="200" x2="600" y2="130"/>
          <line x1="720" y1="130" x2="880" y2="60"/>
          <line x1="720" y1="130" x2="880" y2="130"/>
          <line x1="720" y1="130" x2="880" y2="200"/>
        </g>
        <g font-family="JetBrains Mono, monospace" font-size="11" fill="var(--paper-dim)">
          <rect x="20" y="114" width="120" height="32" rx="2" fill="none" stroke="var(--muted)"/>
          <text x="80" y="135" text-anchor="middle">refurbished stock</text>

          <rect x="300" y="44" width="120" height="30" rx="2" fill="var(--blue-wash)" stroke="var(--blue)"/>
          <text x="360" y="63" text-anchor="middle" fill="var(--blue)">flash /e/OS</text>
          <rect x="300" y="114" width="120" height="30" rx="2" fill="var(--blue-wash)" stroke="var(--blue)"/>
          <text x="360" y="133" text-anchor="middle" fill="var(--blue)">enrollment profile</text>
          <rect x="300" y="184" width="120" height="30" rx="2" fill="var(--blue-wash)" stroke="var(--blue)"/>
          <text x="360" y="203" text-anchor="middle" fill="var(--blue)">Nextcloud account</text>

          <rect x="600" y="114" width="120" height="32" rx="2" fill="none" stroke="var(--line-strong)"/>
          <text x="660" y="135" text-anchor="middle">DAVx5 (sync)</text>

          <rect x="820" y="44" width="120" height="30" rx="2" fill="none" stroke="var(--paper)"/>
          <text x="880" y="63" text-anchor="middle" fill="var(--paper)">files</text>
          <rect x="820" y="114" width="120" height="30" rx="2" fill="none" stroke="var(--paper)"/>
          <text x="880" y="133" text-anchor="middle" fill="var(--paper)">contacts</text>
          <rect x="820" y="184" width="120" height="30" rx="2" fill="none" stroke="var(--paper)"/>
          <text x="880" y="203" text-anchor="middle" fill="var(--paper)">calendar</text>
        </g>
      </svg>
      <div class="diagram-caption">// from refurbished stock to a working device — three reproducible steps, then continuous sync via DAVx5</div>
    </div>

    <div class="choice-list">
      <div class="choice">
        <span class="label">A profile, not manual configuration</span>
        <p>Every device receives the same enrollment profile (accounts, restrictions, base apps) — no settings redone by hand from scratch on each device.</p>
      </div>
      <div class="choice">
        <span class="label">DAVx5 rather than a proprietary app</span>
        <p>Files/contacts/calendar sync goes through a standard CardDAV/CalDAV connector — replaceable, with no vendor lock-in.</p>
      </div>
      <div class="choice">
        <span class="label">Inventory kept separate from assignment</span>
        <p>Tracking who uses which device stays independent from the technical enrollment process — the cooperative keeps control without depending on my tooling.</p>
      </div>
      <div class="choice">
        <span class="label">Wiping planned from the start</span>
        <p>The reset procedure between two users is documented to the same standard as the initial enrollment — not bolted on afterwards.</p>
      </div>
    </div>
  </div>
</section>

<section>
  <div class="wrap">
    <div class="section-head">
      <span class="num">// implementation</span>
      <h2>What was done</h2>
    </div>
    <div class="steps">
      <div class="step"><span class="step-num">01</span><div><h4>Selecting and checking the refurbished stock</h4><p>Checking /e/OS compatibility and the physical condition of each model before installation.</p></div></div>
      <div class="step"><span class="step-num">02</span><div><h4>Flashing /e/OS and baseline hardening</h4><p>Installing the system, removing residual Google services, configuring automatic updates.</p></div></div>
      <div class="step"><span class="step-num">03</span><div><h4>Applying the enrollment profile</h4><p>Accounts, restrictions and base apps applied identically on every device.</p></div></div>
      <div class="step"><span class="step-num">04</span><div><h4>Connecting to Nextcloud via DAVx5</h4><p>Syncing the technician's files, contacts and calendar, tested before handing over the device.</p></div></div>
      <div class="step"><span class="step-num">05</span><div><h4>Handover and user documentation</h4><p>A short sheet explaining the basic usage, with a contact for the first week in case of issues.</p></div></div>
    </div>
  </div>
</section>

<section>
  <div class="wrap">
    <div class="section-head">
      <span class="num">// result</span>
      <h2>What it changes</h2>
    </div>
    <div class="result-banner">
      <p>The cooperative equipped its mobile team without opening a single Google account, without a recurring MDM subscription, and with refurbished rather than new devices — all while keeping files, contacts and calendars hosted in-house.</p>
      <div class="result-stats">
        <div class="stat"><span class="num-big">€0</span><span class="lbl">MDM subscription or per-device license</span></div>
        <div class="stat"><span class="num-big">15</span><span class="lbl">refurbished devices enrolled identically</span></div>
        <div class="stat"><span class="num-big">1</span><span class="lbl">documented process, replayable at each renewal</span></div>
      </div>
    </div>
  </div>
</section>

<section>
  <div class="wrap">
    <div class="section-head">
      <span class="num">// limits</span>
      <h2>What stays out of scope</h2>
    </div>
    <div class="limites-list">
      <div class="limite"><span class="marker">—</span><p>Quality control of the refurbished hardware (battery, screen condition) depends on the supplier chosen by the organization — this process doesn't include hardware expertise.</p></div>
      <div class="limite"><span class="marker">—</span><p>Some banking or administrative apps refuse to run without Google services — worth checking case by case before a team fully switches over.</p></div>
      <div class="limite"><span class="marker">—</span><p>Advanced MDM-style remote management (locking, real-time geolocation) isn't covered — this process stays deliberately simpler than a full MDM solution.</p></div>
      <div class="limite"><span class="marker">—</span><p>Strong authentication on Nextcloud accounts wasn't included in this initial deployment — a separate project, to be handled with the same care as with Matrix.</p></div>
    </div>
  </div>
</section>

<section>
  <div class="wrap">
    <div class="repo-box">
      <div>
        <div class="repo-name">/e/OS + Nextcloud enrollment methodology</div>
        <div class="repo-desc">Process documented from this deployment — the reference repository is being prepared for publication.</div>
      </div>
      <a href="/en/#contact" class="btn">Request the methodology →</a>
    </div>
  </div>
</section>

<section class="final-cta">
  <div class="wrap">
    <h2>A fleet of devices to take off Google or a proprietary MDM?</h2>
    <p>Every organization has its own usage patterns and constraints — let's talk about yours before talking about a solution.</p>
    <a href="/en/#contact" class="btn btn-primary">Get in touch →</a>
  </div>
</section>
