---
title: Sovereign communication with Matrix
template: etude-cas-matrix
metadata:
  description: "Deployment of a complete Matrix/Synapse infrastructure — two dedicated servers, bridges to WhatsApp and Telegram — to leave Slack without losing control of your communication."
---

<header class="case-header">
  <div class="wrap">
    <span class="flag-tag">case study — stack: matrix</span>
    <h1>Leaving Slack without losing control of your communication</h1>
    <p class="case-sub">Deployment of a complete Matrix/Synapse infrastructure — two dedicated servers, bridges to WhatsApp and Telegram, a shared database — for an organization that wanted to keep its conversations in-house, without sacrificing ease of use.</p>

    <div class="meta-row">
      <div class="meta-item"><span class="k">Type of organization</span><span class="v">Non-profit, 40 employees</span></div>
      <div class="meta-item"><span class="k">Trigger</span><span class="v">Slack contract ending</span></div>
      <div class="meta-item"><span class="k">Key constraint</span><span class="v">No data outside the EU</span></div>
      <div class="meta-item"><span class="k">Stack</span><span class="v">Debian · Docker · Ansible</span></div>
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
      <p>The organization had been using Slack for several years. As the contract renewal approached, management wanted to evaluate an alternative hosted in Europe — without giving up what employees already used daily: team discussions, direct messages, and above all the WhatsApp groups used with external partners who, themselves, would not switch tools.</p>
      <p><strong>The real challenge wasn't just replacing Slack</strong>, but doing so without forcing a break on external contacts — which steered the choice towards Matrix with application bridges rather than a simple migration.</p>
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
      <div class="enjeu"><span class="k">Sovereignty</span><p>No data hosted outside the European Union, hosting provider chosen and audited by the organization itself.</p></div>
      <div class="enjeu"><span class="k">Continuity</span><p>External contacts on WhatsApp and Telegram shouldn't have to change anything about their habits.</p></div>
      <div class="enjeu"><span class="k">Security</span><p>Strict separation between internal accounts and bridges to third-party services.</p></div>
      <div class="enjeu"><span class="k">Scalability</span><p>Being able to add a future bridge (Signal, Discord) without reworking the whole architecture.</p></div>
    </div>
  </div>
</section>

<section>
  <div class="wrap">
    <div class="section-head">
      <span class="num">// architecture</span>
      <h2>The choices that shape the deployment</h2>
    </div>

    <div class="diagram-box">
      <svg viewBox="0 0 1000 320" fill="none" xmlns="http://www.w3.org/2000/svg" aria-hidden="true">
        <g stroke="var(--line-strong)" stroke-width="1">
          <line x1="150" y1="260" x2="150" y2="120"/>
          <line x1="150" y1="120" x2="400" y2="120"/>
          <line x1="150" y1="120" x2="400" y2="60"/>
          <line x1="150" y1="120" x2="400" y2="180"/>
          <line x1="620" y1="60" x2="850" y2="60"/>
          <line x1="620" y1="180" x2="850" y2="130"/>
          <line x1="620" y1="180" x2="850" y2="180"/>
          <line x1="620" y1="180" x2="850" y2="230"/>
        </g>
        <g font-family="JetBrains Mono, monospace" font-size="11" fill="var(--paper-dim)">
          <rect x="90" y="248" width="120" height="28" rx="2" fill="none" stroke="var(--muted)"/>
          <text x="150" y="266" text-anchor="middle">Vault (secrets)</text>

          <rect x="90" y="106" width="120" height="28" rx="2" fill="var(--amber-wash)" stroke="var(--amber-dim)"/>
          <text x="150" y="124" text-anchor="middle" fill="var(--amber)">Ansible control</text>

          <rect x="340" y="46" width="120" height="28" rx="2" fill="none" stroke="var(--line-strong)"/>
          <text x="400" y="64" text-anchor="middle">vm-postgresql</text>

          <rect x="340" y="106" width="120" height="28" rx="2" fill="none" stroke="var(--line-strong)"/>
          <text x="400" y="124" text-anchor="middle">vm-matrix-users</text>

          <rect x="340" y="166" width="120" height="28" rx="2" fill="var(--amber-wash)" stroke="var(--amber)"/>
          <text x="400" y="184" text-anchor="middle" fill="var(--amber)">vm-matrix-bridges</text>

          <rect x="560" y="46" width="130" height="28" rx="2" fill="none" stroke="var(--line-strong)"/>
          <text x="625" y="64" text-anchor="middle">reverse proxy</text>

          <rect x="560" y="166" width="130" height="28" rx="2" fill="none" stroke="var(--line-strong)"/>
          <text x="625" y="184" text-anchor="middle">docker-compose</text>

          <rect x="790" y="46" width="130" height="28" rx="2" fill="none" stroke="var(--blue)"/>
          <text x="855" y="64" text-anchor="middle" fill="var(--blue)">Element (web)</text>

          <rect x="790" y="116" width="130" height="28" rx="2" fill="none" stroke="var(--blue)"/>
          <text x="855" y="134" text-anchor="middle" fill="var(--blue)">mautrix-whatsapp</text>

          <rect x="790" y="166" width="130" height="28" rx="2" fill="none" stroke="var(--blue)"/>
          <text x="855" y="184" text-anchor="middle" fill="var(--blue)">mautrix-telegram</text>

          <rect x="790" y="216" width="130" height="28" rx="2" fill="none" stroke="var(--muted)" stroke-dasharray="3 3"/>
          <text x="855" y="234" text-anchor="middle" fill="var(--muted)">future bridge…</text>
        </g>
      </svg>
      <div class="diagram-caption">// 4 dedicated VMs — database, user homeserver, homeserver + bridges, shared infrastructure (outside the role's scope)</div>
    </div>

    <div class="choice-list">
      <div class="choice">
        <span class="label">Separating users / bridges</span>
        <p>The homeserver used daily by employees runs isolated from the homeserver that carries the bridges — an outage or update of a WhatsApp bridge can never affect internal messaging.</p>
      </div>
      <div class="choice">
        <span class="label">Shared database</span>
        <p>A single PostgreSQL VM, one database per component, adding a future component is a single variable entry away — no new Ansible task, no server restart.</p>
      </div>
      <div class="choice">
        <span class="label">Proxy stays out of scope</span>
        <p>The role never manages the reverse proxy, DNS, or TLS certificates — those responsibilities stay within the organization's shared infrastructure, keeping the role reusable elsewhere.</p>
      </div>
      <div class="choice">
        <span class="label">Tokens never regenerated</span>
        <p>Bridge authentication tokens are generated once and kept — replaying the deployment never breaks an already active connection.</p>
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
      <div class="step"><span class="step-num">01</span><div><h4>Provisioning the 4 VMs</h4><p>Database, user homeserver, homeserver + bridges, shared infrastructure — each with a single, documented role.</p></div></div>
      <div class="step"><span class="step-num">02</span><div><h4>Deploying Synapse as two instances</h4><p>One homeserver for internal accounts, a second dedicated to the bridges — never mixed, never on the same application base.</p></div></div>
      <div class="step"><span class="step-num">03</span><div><h4>Connecting the WhatsApp and Telegram bridges</h4><p>Each bridge in its own container, its own database, its own registration file — adding the next bridge without touching the existing ones.</p></div></div>
      <div class="step"><span class="step-num">04</span><div><h4>Validation under real conditions</h4><p>Checking that every bot responds and that messages flow both ways, before any team switches over.</p></div></div>
      <div class="step"><span class="step-num">05</span><div><h4>Gradual rollout across teams</h4><p>Migration team by team, with Slack kept in read-only mode while everyone got comfortable with Element.</p></div></div>
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
      <p>All messaging data stays hosted in Europe, on infrastructure the organization keeps the key to — while external contacts on WhatsApp or Telegram noticed nothing about the change.</p>
      <div class="result-stats">
        <div class="stat"><span class="num-big">0</span><span class="lbl">disruption felt by external contacts</span></div>
        <div class="stat"><span class="num-big">4</span><span class="lbl">VMs deployed reproducibly and documented</span></div>
        <div class="stat"><span class="num-big">1</span><span class="lbl">command to add a future bridge</span></div>
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
      <div class="limite"><span class="marker">—</span><p>The business-level configuration of each bridge (WhatsApp QR-code pairing, Telegram linking) remains a manual step specific to each account — not automatable on the infrastructure side.</p></div>
      <div class="limite"><span class="marker">—</span><p>The reverse proxy, DNS, and TLS certificates aren't managed by this deployment — they belong to the organization's existing shared infrastructure.</p></div>
      <div class="limite"><span class="marker">—</span><p>Strong authentication (SSO/MFA) isn't integrated on this installation yet — a possible follow-up project with an identity provider the organization would validate itself.</p></div>
      <div class="limite"><span class="marker">—</span><p>Message backups are delegated to the hosting provider's existing backup policy — this deployment doesn't reinvent what's already handled correctly.</p></div>
    </div>
  </div>
</section>

<section>
  <div class="wrap">
    <div class="repo-box">
      <div>
        <div class="repo-name">ansible-role-matrix-stack</div>
        <div class="repo-desc">The complete Ansible role, documented and open source, used for this deployment.</div>
      </div>
      <a href="https://github.com/sepp67/ansible-role-matrix-stack" target="_blank" rel="noopener" class="btn">View the code on GitHub →</a>
    </div>
  </div>
</section>

<section class="final-cta">
  <div class="wrap">
    <h2>A similar need for sovereign communication?</h2>
    <p>Every organization has its own constraints — let's talk about yours before talking about a solution.</p>
    <a href="/en/#contact" class="btn btn-primary">Get in touch →</a>
  </div>
</section>
