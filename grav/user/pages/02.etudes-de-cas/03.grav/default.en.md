---
title: A reusable base to deploy and maintain multiple Grav sites
template: etude-cas-grav
metadata:
  description: "Rather than automating the installation of a single site, an architecture separating runtime, applications, persistent data and deployment mechanism — designed to control the lifecycle of multiple Grav sites without duplicating their operations."
---

<header class="case-header">
  <div class="wrap">
    <span class="flag-tag">case study — stack: grav cms</span>
    <h1>A reusable base to deploy and maintain multiple Grav sites</h1>
    <p class="case-sub">Rather than automating the installation of a single site, an architecture separating runtime, applications, persistent data and deployment mechanism — designed to control the lifecycle of multiple Grav sites without duplicating their operations.</p>

    <div class="meta-row">
      <div class="meta-item"><span class="k">Type of project</span><span class="v">Reusable deployment base</span></div>
      <div class="meta-item"><span class="k">Starting point</span><span class="v">Internal documentation site running Grav</span></div>
      <div class="meta-item"><span class="k">Initial constraint</span><span class="v">Preserve content across redeployments</span></div>
      <div class="meta-item"><span class="k">Stack</span><span class="v">Linux · Ansible · Docker · Grav · Git</span></div>
    </div>
  </div>
</header>

<section>
  <div class="wrap">
    <div class="section-head">
      <span class="num">// context</span>
      <h2>The problem started with persistence</h2>
    </div>
    <div class="prose">
      <p>The first need was fairly simple: automate the deployment of a Grav site used as internal documentation.</p>
      <p>But this site had to keep evolving after deployment. Pages would be edited from the admin interface, images added, accounts created.</p>
      <p>Redeploying the application could therefore never reset the site to its initial state and destroy data produced in operation.</p>
      <p>A first boundary appeared:</p>
      <blockquote><strong>The application must be replaceable. User data must survive.</strong></blockquote>
      <p>Persistent content was therefore separated from the container's lifecycle.</p>
      <p>Then other projects needed Grav sites. The question was no longer: <em>How do I deploy this site?</em> but:</p>
      <blockquote><strong>How do I have a mechanism to deploy and maintain multiple Grav sites without duplicating the operational logic?</strong></blockquote>
      <p>That's the moment a deployment problem became an architecture problem.</p>
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
      <div class="enjeu"><span class="k">Persistence</span><p>Content created in operation must survive a container being replaced, a redeployment, and a version change.</p></div>
      <div class="enjeu"><span class="k">Reusability</span><p>The shared mechanics must not be copied and adapted for every new project.</p></div>
      <div class="enjeu"><span class="k">Maintainability</span><p>Runtime, application, data and deployment don't evolve at the same pace or for the same reasons. Their separation should reflect these lifecycles.</p></div>
      <div class="enjeu"><span class="k">Reversibility</span><p>Rolling back to a previous version should use, as much as possible, the same mechanism as a normal deployment.</p></div>
      <div class="enjeu"><span class="k">Security</span><p>Secrets and sensitive configuration stay out of application images and versioned code.</p></div>
    </div>
  </div>
</section>

<section>
  <div class="wrap">
    <div class="section-head">
      <span class="num">// architecture</span>
      <h2>Different lifecycles, separated responsibilities</h2>
    </div>
    <div class="prose">
      <p>Analyzing the first deployment, then the arrival of new projects, brought out four distinct domains: <strong>runtime</strong>, <strong>application / site</strong>, <strong>persistent data</strong> and <strong>deployment mechanism</strong>. Grouping them together just because they serve the same site would have created unnecessary coupling. The architecture therefore aims to make these boundaries explicit.</p>
    </div>

    <div class="diagram-box">
      <svg viewBox="0 0 1000 440" fill="none" xmlns="http://www.w3.org/2000/svg" aria-hidden="true">
        <g stroke="var(--line-strong)" stroke-width="1">
          <path d="M500,52 L290,110"/>
          <path d="M500,52 L730,110"/>
          <path d="M290,142 L500,200"/>
          <path d="M730,142 L500,200"/>
          <line x1="500" y1="232" x2="500" y2="290"/>
          <line x1="500" y1="322" x2="500" y2="380"/>
        </g>
        <g font-family="JetBrains Mono, monospace" font-size="12" fill="var(--paper-dim)">
          <rect x="430" y="20" width="140" height="32" rx="2" fill="var(--moss-wash)" stroke="var(--moss)"/>
          <text x="500" y="41" text-anchor="middle" fill="var(--moss)">grav-runtime</text>

          <rect x="200" y="110" width="180" height="32" rx="2" fill="var(--moss-wash)" stroke="var(--moss)"/>
          <text x="290" y="131" text-anchor="middle" fill="var(--moss)">projet-gites</text>

          <rect x="620" y="110" width="220" height="32" rx="2" fill="var(--moss-wash)" stroke="var(--moss)"/>
          <text x="730" y="131" text-anchor="middle" fill="var(--moss)" font-size="11">projet-lavallee-website</text>

          <rect x="380" y="200" width="240" height="32" rx="2" fill="var(--moss-wash)" stroke="var(--moss)"/>
          <text x="500" y="221" text-anchor="middle" fill="var(--moss)" font-size="11">ansible-role-grav-site</text>

          <rect x="420" y="290" width="160" height="32" rx="2" fill="none" stroke="var(--line-strong)"/>
          <text x="500" y="311" text-anchor="middle">Grav instances</text>

          <rect x="400" y="380" width="200" height="32" rx="2" fill="none" stroke="var(--muted)" stroke-dasharray="3 3"/>
          <text x="500" y="401" text-anchor="middle" fill="var(--muted)">persistent data</text>
        </g>
      </svg>
      <div class="diagram-caption">// grav-runtime (shared base) → independent applications → ansible-role-grav-site (shared deployment) → instances → data decoupled from the container</div>
    </div>

    <div class="choice-list">
      <div class="choice">
        <span class="label">A shared runtime</span>
        <p><code>grav-runtime</code> provides the shared technical foundation: Grav, PHP, Nginx and the contract expected by applications. It knows nothing about any particular business project.</p>
      </div>
      <div class="choice">
        <span class="label">Independent applications</span>
        <p><code>projet-gites</code>, <code>projet-lavallee-website</code> and future sites add only what's specific to them: theme, plugins, application configuration and initial content. Each application stays independently versioned.</p>
      </div>
      <div class="choice">
        <span class="label">A shared deployment mechanism</span>
        <p><code>ansible-role-grav-site</code> centralizes the shared mechanics: preparing the instance, persistent volumes, configuration, secrets, startup, health checks, updates and rollback. The role stays focused on one instance per invocation.</p>
      </div>
      <div class="choice">
        <span class="label">Data outside the container's lifecycle</span>
        <p>Pages, images, accounts and other persistent data live independently of the application image. A new version can therefore replace the application without automatically resetting its production state.</p>
      </div>
    </div>
  </div>
</section>

<section>
  <div class="wrap">
    <div class="section-head">
      <span class="num">// implementation</span>
      <h2>From installation to lifecycle</h2>
    </div>
    <div class="steps">
      <div class="step"><span class="step-num">01</span><div><h4>First need: making data persistent</h4><p>The first deployment made it possible to formalize a fundamental rule: rebuildable elements belong to the application; data produced in operation must live outside the container.</p></div></div>
      <div class="step"><span class="step-num">02</span><div><h4>Extracting a shared runtime</h4><p>Grav, PHP, Nginx and the shared dependencies were isolated into <code>grav-runtime</code>. Application projects no longer have to rebuild this technical layer.</p></div></div>
      <div class="step"><span class="step-num">03</span><div><h4>Centralizing deployment</h4><p>The operational mechanics were grouped into <code>ansible-role-grav-site</code>: volumes, secrets, configuration, health checks, deployed version, update and rollback.</p></div></div>
      <div class="step"><span class="step-num">04</span><div><h4>Moving to multiple applications</h4><p><code>projet-gites</code>, then <code>lavallee.tech</code>, made it possible to test the model against several real applications. The second site in particular exposed assumptions still tied to the first project — names, paths or instance properties — and triggered their generalization.</p></div></div>
    </div>
  </div>
</section>

<section>
  <div class="wrap">
    <div class="section-head">
      <span class="num">// lifecycle</span>
      <h2>Installing is only the first step</h2>
    </div>
    <div class="prose">
      <p>An application is only installed once. It then has to be operable for years. The model being sought is therefore no longer:</p>
      <pre><code>install</code></pre>
      <p>but:</p>
      <pre><code>deploy → update → rollback → migrate</code></pre>
      <p>This difference shapes the architecture. The runtime is versioned. Each application is versioned. Data persists independently. The deployment mechanism applies the desired state.</p>
    </div>
  </div>
</section>

<section>
  <div class="wrap">
    <div class="section-head">
      <span class="num">// rollback</span>
      <h2>Rollback stays a deployment</h2>
    </div>
    <div class="prose">
      <p>Rollback isn't designed as a separate emergency procedure. If a new version causes a problem, a previously known-stable version simply becomes the desired version again.</p>
      <pre><code>version 1.3.2
      │
      ▼
 deploy 1.4.0
      │
    issue
      │
      ▼
 target = 1.3.2
      │
      ▼
same deployment mechanism</code></pre>
      <p>This keeps special procedures confined to exactly the moment they'd be riskiest: during an incident.</p>
    </div>
  </div>
</section>

<section>
  <div class="wrap">
    <div class="section-head">
      <span class="num">// result</span>
      <h2>What this architecture changes</h2>
    </div>
    <div class="result-banner">
      <p>Deployment logic is centralized instead of being copied into every project. Each site keeps its own content, configuration and versioning cycle — and replacing an application never means replacing its persistent state.</p>
      <div class="result-stats">
        <div class="stat"><span class="num-big">1</span><span class="lbl">shared runtime, built and maintained independently of the sites</span></div>
        <div class="stat"><span class="num-big">1</span><span class="lbl">deployment mechanism, instead of being copied per project</span></div>
        <div class="stat"><span class="num-big">2</span><span class="lbl">independent applications deployed on the same base</span></div>
      </div>
    </div>
    <div class="prose" style="margin-top:24px;">
      <p><strong>The first site solved a need. The second started testing the architecture.</strong> The next ones must be able to reuse the same base without multiplying the operational logic.</p>
    </div>
  </div>
</section>

<section>
  <div class="wrap">
    <div class="section-head">
      <span class="num">// proof</span>
      <h2>The second site is the real test</h2>
    </div>
    <div class="prose">
      <p>It's easy to call an architecture "reusable" while it still serves only one project. The second consumer reveals the assumptions that were actually specific to the first.</p>
      <p><code>lavallee.tech</code> is now itself deployed on this architecture. Its arrival made it possible to identify the last instance parameters that needed generalizing for the deployment role to stay an atomic, reusable component.</p>
      <p>The next step is to use this same mechanism for a new technical documentation site. Reusability is therefore not treated as a declared property.</p>
      <blockquote><strong>It has to be verified by new consumers.</strong></blockquote>
    </div>

    <div class="roadmap-box" style="margin-top:28px;">
      <span class="icon">→</span>
      <div>
        <h4>New technical documentation site <span class="status-pill">in progress</span></h4>
        <p>The same base — grav-runtime + ansible-role-grav-site — will be reused without modification for this new consumer, the only real proof that an architecture is reusable.</p>
      </div>
    </div>
  </div>
</section>

<section>
  <div class="wrap">
    <div class="section-head">
      <span class="num">// sovereignty</span>
      <h2>Why this architecture also supports control of the system</h2>
    </div>
    <div class="prose">
      <p>Using open source software is only part of the problem. Infrastructure remains hard to control if its deployment depends on manual steps, if its data is mixed in with the application, or if nobody knows precisely which version is in production.</p>
      <p>This architecture therefore aims to make explicit:</p>
      <ul>
        <li>the components in use;</li>
        <li>the versions deployed;</li>
        <li>the data to preserve;</li>
        <li>the responsibilities of each layer;</li>
        <li>the mechanism to rebuild an instance.</li>
      </ul>
      <blockquote><strong>Open source is a means. Control of the system is the goal.</strong></blockquote>
    </div>
  </div>
</section>

<section>
  <div class="wrap">
    <div class="section-head">
      <span class="num">// limits</span>
      <h2>What the base isn't trying to do</h2>
    </div>
    <div class="limites-list">
      <div class="limite"><span class="marker">—</span><p>Content creation and editorial design stay specific to each application.</p></div>
      <div class="limite"><span class="marker">—</span><p>The deployment role doesn't manage DNS, reverse proxy, or TLS certificates. Those responsibilities belong to the shared infrastructure.</p></div>
      <div class="limite"><span class="marker">—</span><p>Backups are still necessary. Grav avoids running an extra database service, but the persistent files are production data and must be backed up.</p></div>
      <div class="limite"><span class="marker">—</span><p>The deployment role manages one instance per invocation. Orchestrating multiple sites is deliberately handled at a higher level.</p></div>
      <div class="limite"><span class="marker">—</span><p>Applications requiring complex business features, heavy traffic, or advanced data models may fall outside the natural scope of a flat-file CMS like Grav.</p></div>
    </div>
  </div>
</section>

<section>
  <div class="wrap">
    <div class="section-head">
      <span class="num">// components</span>
      <h2>The base and its applications</h2>
    </div>
    <div class="repo-grid">
      <div class="repo-row">
        <div>
          <div class="repo-name">grav-runtime</div>
          <div class="repo-desc"><strong style="color:var(--paper)">Shared runtime.</strong> Versioned base image providing Grav, PHP, Nginx and the shared runtime contract.</div>
        </div>
        <a href="https://github.com/sepp67/grav-runtime" target="_blank" rel="noopener" class="btn">View on GitHub →</a>
      </div>
      <div class="repo-row">
        <div>
          <div class="repo-name">ansible-role-grav-site</div>
          <div class="repo-desc"><strong style="color:var(--paper)">Deployment mechanism.</strong> Ansible role responsible for the lifecycle of a compatible Grav instance.</div>
        </div>
        <a href="https://github.com/sepp67/ansible-role-grav-site" target="_blank" rel="noopener" class="btn">View on GitHub →</a>
      </div>
      <div class="repo-row">
        <div>
          <div class="repo-name">projet-gites</div>
          <div class="repo-desc"><strong style="color:var(--paper)">Application.</strong> First business site using the shared base.</div>
        </div>
        <a href="https://github.com/sepp67/projet-gites" target="_blank" rel="noopener" class="btn">View on GitHub →</a>
      </div>
      <div class="repo-row">
        <div>
          <div class="repo-name">projet-lavallee-website</div>
          <div class="repo-desc"><strong style="color:var(--paper)">Application.</strong> Second real site using the same architecture — the one you're currently looking at.</div>
        </div>
        <a href="https://github.com/sepp67/projet-lavallee-website" target="_blank" rel="noopener" class="btn">View on GitHub →</a>
      </div>
    </div>
  </div>
</section>

<section>
  <div class="wrap">
    <div class="section-head">
      <span class="num">// go further</span>
      <h2>Why this architecture?</h2>
    </div>
    <div class="prose">
      <p>This separation wasn't born from a theoretical design. It results from the evolution of a concrete need: preserving the data of a first site, then understanding how to maintain multiple applications without duplicating their infrastructure.</p>
    </div>
    <a href="/en/articles/grav-plateforme-de-deploiement-reutilisable" class="flag-link" style="color:var(--moss);">Read the article: From Deploying One Website to Designing a Reusable Deployment Platform →</a>
  </div>
</section>

<section class="final-cta">
  <div class="wrap">
    <h2>A Linux service to make reproducible and maintainable?</h2>
    <p>Automated deployment is only part of the problem. The real question is how the system will be updated, diagnosed, backed up, restored, and handed off over time.</p>
    <a href="/en/#contact" class="btn btn-primary">Let's talk about your constraints first →</a>
  </div>
</section>
