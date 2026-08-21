---
title: Reproduzierbare Websites mit Grav CMS
template: etude-cas-grav
metadata:
  description: "Statt einer einmaligen Website eine technische Basis, aufgeteilt in drei Repositories — Anwendungs-Image, Deployment-Rolle, Site-Instanz — konzipiert für die Wiederverwendung bei jedem neuen Projekt."
---

<header class="case-header">
  <div class="wrap">
    <span class="flag-tag">fallstudie — stack: grav cms</span>
    <h1>Eine wiederverwendbare Basis, um eine Grav-Website mit Zuversicht bereitzustellen</h1>
    <p class="case-sub">Statt einer einmaligen Website eine technische Basis, aufgeteilt in drei Repositories — Anwendungs-Image, Deployment-Rolle, Site-Instanz — konzipiert für die Wiederverwendung bei jedem neuen Projekt, ohne bei null zu beginnen.</p>

    <div class="meta-row">
      <div class="meta-item"><span class="k">Art des Projekts</span><span class="v">Wiederverwendbare Basis, 3 Repositories</span></div>
      <div class="meta-item"><span class="k">Erste Nutzung</span><span class="v">Vorstellungswebsite für Ferienunterkünfte</span></div>
      <div class="meta-item"><span class="k">Zentrale Vorgabe</span><span class="v">Rollback mit einem Befehl</span></div>
      <div class="meta-item"><span class="k">Stack</span><span class="v">Docker · Ansible · Grav</span></div>
    </div>
  </div>
</header>

<section>
  <div class="wrap">
    <div class="section-head">
      <span class="num">// kontext</span>
      <h2>Das Problem</h2>
    </div>
    <div class="prose">
      <p>Die erste bereitzustellende Website war eine Vorstellungswebsite für Ferienunterkünfte — ein einfacher Bedarf, ein knappes Budget, kein Grund, mit einem schweren CMS samt zu wartender Datenbank aufzufahren. Grav, auf Basis von Flat Files, passte gut zu diesem Lastenheft.</p>
      <p><strong>Die eigentliche Herausforderung lag nicht in dieser ersten Website selbst</strong>, sondern darin zu verhindern, dass ein Grav-Deployment ein isolierter, von Hand eingerichteter Einzelfall bleibt. Das Ziel von Anfang an: eine wiederverwendbare Basis aufbauen, die jede neue Grav-Website aufnehmen kann, ohne jedes Mal bei null zu beginnen.</p>
    </div>
  </div>
</section>

<section>
  <div class="wrap">
    <div class="section-head">
      <span class="num">// anforderungen</span>
      <h2>Was in Einklang zu bringen war</h2>
    </div>
    <div class="enjeux">
      <div class="enjeu"><span class="k">Leichtigkeit</span><p>Ein Flat-File-CMS, ohne zu sichernde oder dauerhaft zu wartende Datenbank.</p></div>
      <div class="enjeu"><span class="k">Wiederverwendbarkeit</span><p>Eine allen künftigen Websites gemeinsame technische Basis, keine für einen einzigen Zweck gedachte Wegwerf-Website.</p></div>
      <div class="enjeu"><span class="k">Sicherheit</span><p>Kein Geheimnis im Klartext, selbst für eine Vorstellungswebsite mit scheinbar geringem Risiko.</p></div>
      <div class="enjeu"><span class="k">Reversibilität</span><p>Eine Website mit einem einzigen Befehl auf die vorherige Version zurücksetzen können, ohne Stress.</p></div>
    </div>
  </div>
</section>

<section>
  <div class="wrap">
    <div class="section-head">
      <span class="num">// architektur</span>
      <h2>Drei Repositories, drei Zuständigkeiten</h2>
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
          <text x="440" y="63" text-anchor="middle">anwendungs-image</text>
          <rect x="380" y="164" width="120" height="30" rx="2" fill="var(--moss-wash)" stroke="var(--moss)"/>
          <text x="440" y="183" text-anchor="middle" fill="var(--moss)">ansible-role-grav-site</text>

          <rect x="600" y="44" width="160" height="30" rx="2" fill="none" stroke="var(--line-strong)"/>
          <text x="680" y="63" text-anchor="middle">deployment-rolle</text>

          <rect x="800" y="24" width="150" height="30" rx="2" fill="var(--moss-wash)" stroke="var(--moss)"/>
          <text x="875" y="43" text-anchor="middle" fill="var(--moss)">projet-gites</text>
          <rect x="800" y="84" width="150" height="30" rx="2" fill="none" stroke="var(--paper)" stroke-dasharray="3 3"/>
          <text x="875" y="103" text-anchor="middle" fill="var(--paper)">projet-lavalle (in Vorbereitung)</text>
        </g>
      </svg>
      <div class="diagram-caption">// grav-runtime (Basis) → ansible-role-grav-site (Deployment) → jede Website (Instanz) — eine einzige Basis, mehrere identisch bereitgestellte Websites</div>
    </div>

    <div class="choice-list">
      <div class="choice">
        <span class="label">Runtime von der Website getrennt</span>
        <p><code>grav-runtime</code> stellt das Basis-Anwendungs-Image bereit (PHP, Grav, Abhängigkeiten) — eine Website muss sich nie um diese technische Ebene kümmern.</p>
      </div>
      <div class="choice">
        <span class="label">Eine Rolle, alle Websites</span>
        <p><code>ansible-role-grav-site</code> stellt jede Grav-Website identisch bereit — die Deployment-Logik wird nur ein einziges Mal geschrieben.</p>
      </div>
      <div class="choice">
        <span class="label">Jede Website bleibt reiner Inhalt</span>
        <p><code>projet-gites</code> — und bald <code>projet-lavalle</code> — enthält nur den Inhalt und die Konfiguration der jeweiligen Website, nichts von der Deployment-Mechanik.</p>
      </div>
      <div class="choice">
        <span class="label">Rollback wie ein Deployment behandelt</span>
        <p>Das Zurücksetzen einer Website auf ihre vorherige Version nutzt genau denselben Mechanismus wie ein normales Deployment — kein separates Notfallverfahren.</p>
      </div>
    </div>
  </div>
</section>

<section>
  <div class="wrap">
    <div class="section-head">
      <span class="num">// umsetzung</span>
      <h2>Was gemacht wurde</h2>
    </div>
    <div class="steps">
      <div class="step"><span class="step-num">01</span><div><h4>Aufbau der Basis-Runtime</h4><p>Verpacktes und versioniertes Grav-Anwendungs-Image, unabhängig von einer bestimmten Website.</p></div></div>
      <div class="step"><span class="step-num">02</span><div><h4>Schreiben der generischen Deployment-Rolle</h4><p>Eine Ansible-Rolle, die jede auf dieser Runtime basierende Website bereitstellen, aktualisieren und zurücksetzen kann.</p></div></div>
      <div class="step"><span class="step-num">03</span><div><h4>Erste Website unter Realbedingungen: projet-gites</h4><p>Validierung der gesamten Kette an einem konkreten Fall — Inhalt, Konfiguration, Inbetriebnahme.</p></div></div>
      <div class="step"><span class="step-num">04</span><div><h4>Härtung und Dokumentation</h4><p>Verwaltung der Secrets, dokumentiertes Rollback-Verfahren, Ende-zu-Ende-Tests, bevor die Basis als wiederverwendbar gilt.</p></div></div>
    </div>
  </div>
</section>

<section>
  <div class="wrap">
    <div class="section-head">
      <span class="num">// ergebnis</span>
      <h2>Was sich dadurch ändert</h2>
    </div>
    <div class="result-banner">
      <p>Die erste Website ermöglichte es, eine vollständige technische Basis zu validieren — nicht nur eine gelieferte Website. Jedes neue Grav-Projekt startet nun mit dem Wesentlichen bereits gelöst: Anwendungs-Image, Deployment, Rollback, Secrets.</p>
      <div class="result-stats">
        <div class="stat"><span class="num-big">3</span><span class="lbl">Repositories, jedes mit einer einzigen Zuständigkeit</span></div>
        <div class="stat"><span class="num-big">1</span><span class="lbl">Befehl zum Bereitstellen oder Zurücksetzen</span></div>
        <div class="stat"><span class="num-big">0</span><span class="lbl">zu sichernde oder zu wartende Datenbank</span></div>
      </div>
    </div>
  </div>
</section>

<section>
  <div class="wrap">
    <div class="section-head">
      <span class="num">// nächster schritt</span>
      <h2>Die Basis wird bereits wiederverwendet</h2>
    </div>
    <div class="roadmap-box">
      <span class="icon">→</span>
      <div>
        <h4>projet-lavalle <span class="status-pill">in Vorbereitung</span></h4>
        <p>Eine neue Grav-Website wird auf dieser selben Basis bereitgestellt — genau jene, die Sie gerade betrachten. Der beste Beweis, dass eine wiederverwendbare Basis ihr Versprechen hält, ist, sie selbst zu nutzen.</p>
      </div>
    </div>
  </div>
</section>

<section>
  <div class="wrap">
    <div class="section-head">
      <span class="num">// grenzen</span>
      <h2>Was außerhalb des Umfangs bleibt</h2>
    </div>
    <div class="limites-list">
      <div class="limite"><span class="marker">—</span><p>Die Inhaltserstellung und das redaktionelle Design jeder Website bleiben eine eigenständige Arbeit, nicht von der technischen Basis abgedeckt.</p></div>
      <div class="limite"><span class="marker">—</span><p>Die Deployment-Rolle verwaltet weder den Domainnamen noch den Reverse Proxy noch die TLS-Zertifikate — wie beim Matrix-Stack bleiben diese Schichten in der gemeinsamen Infrastruktur.</p></div>
      <div class="limite"><span class="marker">—</span><p>Websites mit hohem Traffic oder fortgeschrittenen dynamischen Funktionen (E-Commerce, komplexe Nutzerkonten) liegen außerhalb des natürlichen Anwendungsbereichs von Grav — hier wäre ein schwereres CMS sinnvoller.</p></div>
    </div>
  </div>
</section>

<section>
  <div class="wrap">
    <div class="section-head">
      <span class="num">// die repositories</span>
      <h2>Die Basis, in drei Repositories</h2>
    </div>
    <div class="repo-grid">
      <div class="repo-row">
        <div>
          <div class="repo-name">grav-runtime</div>
          <div class="repo-desc">Das Basis-Anwendungs-Image — unabhängig von einer bestimmten Website.</div>
        </div>
        <a href="https://github.com/sepp67/grav-runtime" target="_blank" rel="noopener" class="btn">Auf GitHub ansehen →</a>
      </div>
      <div class="repo-row">
        <div>
          <div class="repo-name">ansible-role-grav-site</div>
          <div class="repo-desc">Die generische Deployment-Rolle — von jeder Website wiederverwendet.</div>
        </div>
        <a href="https://github.com/sepp67/ansible-role-grav-site" target="_blank" rel="noopener" class="btn">Auf GitHub ansehen →</a>
      </div>
      <div class="repo-row">
        <div>
          <div class="repo-name">projet-gites</div>
          <div class="repo-desc">Die erste auf dieser Basis bereitgestellte Website — ein realer Anwendungsfall.</div>
        </div>
        <a href="https://github.com/sepp67/projet-gites" target="_blank" rel="noopener" class="btn">Auf GitHub ansehen →</a>
      </div>
    </div>
  </div>
</section>

<section class="final-cta">
  <div class="wrap">
    <h2>Eine Website bereitzustellen, ohne von einem proprietären Hoster abhängig zu sein?</h2>
    <p>Ob erste Website oder Relaunch — lassen Sie uns über Ihre Rahmenbedingungen sprechen, bevor wir über eine Lösung sprechen.</p>
    <a href="/de/#contact" class="btn btn-primary">Kontakt aufnehmen →</a>
  </div>
</section>
