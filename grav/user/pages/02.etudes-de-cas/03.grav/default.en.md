---
title: Reproducible websites with Grav CMS
template: etude-cas-grav
metadata:
  description: "Rather than a one-off website, a technical base split into three repositories — application image, deployment role, site instance — designed to be reused for every new project."
---

<header class="case-header">
  <div class="wrap">
    <span class="flag-tag">case study — stack: grav cms</span>
    <h1>A reusable base to deploy a Grav site with confidence</h1>
    <p class="case-sub">Rather than a one-off website, a technical base split into three repositories — application image, deployment role, site instance — designed to be reused for every new project, without starting from scratch.</p>

    <div class="meta-row">
      <div class="meta-item"><span class="k">Type of project</span><span class="v">Reusable base, 3 repositories</span></div>
      <div class="meta-item"><span class="k">First use</span><span class="v">Vacation rental showcase site</span></div>
      <div class="meta-item"><span class="k">Key constraint</span><span class="v">One-command rollback</span></div>
      <div class="meta-item"><span class="k">Stack</span><span class="v">Docker · Ansible · Grav</span></div>
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
      <p>The first site to deploy was a showcase site for vacation rentals — a simple need, a tight budget, no reason to bring out the heavy artillery of a full CMS with a database to maintain. Grav, running on flat files, fit that brief well.</p>
      <p><strong>The real challenge wasn't this first site in particular</strong>, but making sure a Grav deployment didn't stay a one-off, hand-tuned case. The goal from the start: build a reusable base able to host any new Grav site without starting from scratch each time.</p>
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
      <div class="enjeu"><span class="k">Lightness</span><p>A flat-file CMS, with no database to back up or maintain over time.</p></div>
      <div class="enjeu"><span class="k">Reusability</span><p>A technical base shared by every future site, not a disposable site built for a single use.</p></div>
      <div class="enjeu"><span class="k">Security</span><p>No secret in plain text, even for a showcase site with seemingly low stakes.</p></div>
      <div class="enjeu"><span class="k">Reversibility</span><p>Being able to roll a site back to its previous version with a single command, without stress.</p></div>
    </div>
  </div>
</section>

<section>
  <div class="wrap">
    <div class="section-head">
      <span class="num">// architecture</span>
      <h2>Three repositories, three responsibilities</h2>
    </div>

    <div class="diagram-box">
      <svg viewBox="0 0 1000 240" fill="none" xmlns="http://www.w3.org/2000/svg" aria-hidden="true">
        <g stroke="var(--line-strong)" stroke-width="1">
          <line x1="170" y1="120" x2="380" y2="60"/>
          <line x1="170" y1="120" x2="380" y2="180"/>
          <line x1="500" y1="60" x2="680" y2="60"/>
          <line x1="500" y1="180" x2="680" y2="60"/>
          <line x1="680" y1="60" x2="880" y2="40"/>
          <line x1="680" y1="60" x2="880" y2="100"/>
        </g>
        <g font-family="JetBrains Mono, monospace" font-size="11" fill="var(--paper-dim)">
          <rect x="60" y="104" width="120" height="32" rx="2" fill="var(--moss-wash)" stroke="var(--moss)"/>
          <text x="120" y="125" text-anchor="middle" fill="var(--moss)">grav-runtime</text>

          <rect x="380" y="44" width="120" height="30" rx="2" fill="none" stroke="var(--line-strong)"/>
          <text x="440" y="63" text-anchor="middle">application image</text>
          <rect x="380" y="164" width="120" height="30" rx="2" fill="var(--moss-wash)" stroke="var(--moss)"/>
          <text x="440" y="183" text-anchor="middle" fill="var(--moss)">ansible-role-grav-site</text>

          <rect x="600" y="44" width="160" height="30" rx="2" fill="none" stroke="var(--line-strong)"/>
          <text x="680" y="63" text-anchor="middle">deployment role</text>

          <rect x="800" y="24" width="150" height="30" rx="2" fill="var(--moss-wash)" stroke="var(--moss)"/>
          <text x="875" y="43" text-anchor="middle" fill="var(--moss)">projet-gites</text>
          <rect x="800" y="84" width="150" height="30" rx="2" fill="none" stroke="var(--paper)" stroke-dasharray="3 3"/>
          <text x="875" y="103" text-anchor="middle" fill="var(--paper)">projet-lavalle (coming up)</text>
        </g>
      </svg>
      <div class="diagram-caption">// grav-runtime (base) → ansible-role-grav-site (deployment) → each site (instance) — one base, several sites deployed identically</div>
    </div>

    <div class="choice-list">
      <div class="choice">
        <span class="label">Runtime separated from the site</span>
        <p><code>grav-runtime</code> provides the base application image (PHP, Grav, dependencies) — a site never has to worry about this technical layer.</p>
      </div>
      <div class="choice">
        <span class="label">One role, every site</span>
        <p><code>ansible-role-grav-site</code> deploys any Grav site identically — the deployment logic is written only once.</p>
      </div>
      <div class="choice">
        <span class="label">Each site stays plain content</span>
        <p><code>projet-gites</code> — and soon <code>projet-lavalle</code> — contains only the content and configuration specific to the site, none of the deployment mechanics.</p>
      </div>
      <div class="choice">
        <span class="label">Rollback treated as a deployment</span>
        <p>Rolling a site back to its previous version uses exactly the same mechanism as a normal deployment — not a separate emergency procedure.</p>
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
      <div class="step"><span class="step-num">01</span><div><h4>Building the base runtime</h4><p>Packaged and versioned Grav application image, independent of any particular site.</p></div></div>
      <div class="step"><span class="step-num">02</span><div><h4>Writing the generic deployment role</h4><p>An Ansible role able to deploy, update and roll back any site built on this runtime.</p></div></div>
      <div class="step"><span class="step-num">03</span><div><h4>First site under real conditions: projet-gites</h4><p>Validating the full chain on a concrete case — content, configuration, going live.</p></div></div>
      <div class="step"><span class="step-num">04</span><div><h4>Hardening and documentation</h4><p>Secrets management, documented rollback procedure, end-to-end tests before considering the base reusable.</p></div></div>
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
      <p>The first site validated a complete technical base — not just a delivered site. Every new Grav project now starts with the essentials already solved: application image, deployment, rollback, secrets.</p>
      <div class="result-stats">
        <div class="stat"><span class="num-big">3</span><span class="lbl">repositories, each with a single responsibility</span></div>
        <div class="stat"><span class="num-big">1</span><span class="lbl">command to deploy or roll back</span></div>
        <div class="stat"><span class="num-big">0</span><span class="lbl">database to back up or maintain</span></div>
      </div>
    </div>
  </div>
</section>

<section>
  <div class="wrap">
    <div class="section-head">
      <span class="num">// next step</span>
      <h2>The base is already being reused</h2>
    </div>
    <div class="roadmap-box">
      <span class="icon">→</span>
      <div>
        <h4>projet-lavalle <span class="status-pill">in progress</span></h4>
        <p>A new Grav site is being deployed on this same base — the very one you're looking at right now. The best proof that a reusable base delivers on its promise is to use it yourself.</p>
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
      <div class="limite"><span class="marker">—</span><p>Content creation and the editorial design of each site remain a separate job, not covered by the technical base.</p></div>
      <div class="limite"><span class="marker">—</span><p>The deployment role doesn't manage the domain name, the reverse proxy, or TLS certificates — as with the Matrix stack, those layers stay in the shared infrastructure.</p></div>
      <div class="limite"><span class="marker">—</span><p>High-traffic sites or those requiring advanced dynamic features (e-commerce, complex user accounts) fall outside Grav's natural scope — a heavier CMS would then be more relevant.</p></div>
    </div>
  </div>
</section>

<section>
  <div class="wrap">
    <div class="section-head">
      <span class="num">// the repositories</span>
      <h2>The base, in three repositories</h2>
    </div>
    <div class="repo-grid">
      <div class="repo-row">
        <div>
          <div class="repo-name">grav-runtime</div>
          <div class="repo-desc">The base application image — independent of any particular site.</div>
        </div>
        <a href="https://github.com/sepp67/grav-runtime" target="_blank" rel="noopener" class="btn">View on GitHub →</a>
      </div>
      <div class="repo-row">
        <div>
          <div class="repo-name">ansible-role-grav-site</div>
          <div class="repo-desc">The generic deployment role — reused by every site.</div>
        </div>
        <a href="https://github.com/sepp67/ansible-role-grav-site" target="_blank" rel="noopener" class="btn">View on GitHub →</a>
      </div>
      <div class="repo-row">
        <div>
          <div class="repo-name">projet-gites</div>
          <div class="repo-desc">The first site deployed on this base — a real use case.</div>
        </div>
        <a href="https://github.com/sepp67/projet-gites" target="_blank" rel="noopener" class="btn">View on GitHub →</a>
      </div>
    </div>
  </div>
</section>

<section class="final-cta">
  <div class="wrap">
    <h2>A site to deploy without depending on a proprietary host?</h2>
    <p>Whether it's a first site or a redesign, let's talk about your constraints before talking about a solution.</p>
    <a href="/en/#contact" class="btn btn-primary">Get in touch →</a>
  </div>
</section>
