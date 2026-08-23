---
title: Startseite
template: homepage
metadata:
  description: "Ich konzipiere, betreibe und pflege reproduzierbare Linux-Infrastrukturen auf Basis von Open-Source-Technologien, mit digitaler Souveränität als Gestaltungsprinzip."
---

<section class="hero">
  <div class="wrap">
    <div class="eyebrow">berater für open-source-infrastruktur</div>
    <h1>Digitale Souveränität, mit Methode umgesetzt.</h1>
    <p class="hero-sub">Ich konzipiere, betreibe und pflege reproduzierbare Linux-Infrastrukturen — Kommunikation, Dateien, mobile Endgeräte — für Organisationen, die wieder die Kontrolle über ihre digitalen Werkzeuge übernehmen wollen, ohne von einem einzigen Anbieter abhängig zu sein.</p>
    <div class="cta-row">
      <a href="#flagships" class="btn btn-primary btn-lg">Meine Leuchtturmprojekte ansehen →</a>
      <a href="#contact" class="btn btn-ghost btn-lg">Kontakt aufnehmen</a>
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
          <text x="60" y="204" text-anchor="middle">nutzer</text>

          <circle cx="200" cy="180" r="5" fill="var(--blue)"/>
          <text x="200" y="204" text-anchor="middle" fill="var(--blue)">/e/OS</text>

          <circle cx="380" cy="60" r="6" fill="var(--amber)"/>
          <text x="380" y="40" text-anchor="middle" fill="var(--amber)">matrix-synapse</text>

          <circle cx="380" cy="180" r="5" fill="var(--blue)"/>
          <text x="380" y="204" text-anchor="middle" fill="var(--blue)">nextcloud</text>

          <circle cx="660" cy="150" r="5" fill="var(--muted)"/>
          <text x="660" y="174" text-anchor="middle">reverse proxy</text>

          <circle cx="980" cy="70" r="6" fill="var(--paper)"/>
          <text x="980" y="50" text-anchor="middle" fill="var(--paper)">beherrschte infra</text>
        </g>
      </svg>
      <div class="diagram-caption">// Trennung der Zuständigkeiten — jede Komponente bleibt unabhängig austauschbar</div>
    </div>
  </div>
</section>

<section class="problem">
  <div class="wrap">
    <div class="section-head">
      <h2>Das Problem</h2>
    </div>
    <p>Der Ausstieg aus proprietären Plattformen ist zu einem konkreten Thema geworden — DSGVO, strategische Abhängigkeit, steigende Kosten. Aber Slack, Teams oder ein MDM durch eine Open-Source-Alternative zu ersetzen, reicht nicht, wenn diese <strong>handgestrickt</strong>, schlecht abgesichert oder auf Dauer nicht wartbar ist.</p>
    <p>Ich leiste die Arbeit, die aus einem vielversprechenden Open-Source-Werkzeug eine <strong>zuverlässige Infrastruktur</strong> macht: automatisiert, reproduzierbar, dokumentiert und auch nach meinem Weggang wartbar.</p>
  </div>
</section>

<section id="ce-que-je-fais">
  <div class="wrap">
    <div class="section-head">
      <span class="num">// was ich mache</span>
      <h2>Der vollständige Lebenszyklus eines Dienstes</h2>
      <p>Ich decke die gesamte Kette ab: Architektur, Deployment, Automatisierung, Updates, Monitoring und Störungsbehebung.</p>
    </div>

    <div class="skills-grid">
      <div class="skill-item">
        <span class="key">expertise.01</span>
        <h4>Linux-Administration</h4>
        <p>Installation, Konfiguration, Betrieb, Updates, Diagnose und Störungsbehebung in Produktion. Das Ziel: eine Infrastruktur, die dauerhaft beobachtbar, dokumentiert und betreibbar bleibt.</p>
        <div class="pill-tags"><span>Debian</span><span>Ubuntu</span><span>Netzwerk</span><span>Systemdienste</span><span>Troubleshooting</span></div>
      </div>

      <div class="skill-item">
        <span class="key">expertise.02</span>
        <h4>Automatisierung & Deployment</h4>
        <div class="flow">deploy → update → rollback → migrate</div>
        <p>Ansible beschreibt den erwarteten Zustand der Maschinen, Docker kontrolliert die Anwendungsumgebung, Git macht nachvollziehbar, was genau bereitgestellt ist.</p>
        <div class="pill-tags"><span>Ansible</span><span>Docker</span><span>Docker Compose</span><span>Git</span><span>CI/CD</span></div>
      </div>

      <div class="skill-item">
        <span class="key">expertise.03</span>
        <h4>Infrastruktur-Architektur</h4>
        <p>Zuständigkeiten trennen statt monolithische Systeme bauen: Runtime, Anwendung, persistente Daten, Secrets, Reverse Proxy und Deployment folgen nicht demselben Lebenszyklus.</p>
        <div class="pill-tags"><span>Architektur</span><span>Reproduzierbarkeit</span><span>Idempotenz</span><span>Lifecycle-Management</span></div>
      </div>

      <div class="skill-item">
        <span class="key">expertise.04</span>
        <h4>Identität & Sicherheit</h4>
        <p>Umgebungen mit MFA, RADIUS, LDAP/Active Directory und Identitätsföderation. Secrets-Management, Rechtebeschränkung, Trennung der Zuständigkeiten.</p>
        <div class="pill-tags"><span>IAM</span><span>MFA</span><span>privacyIDEA</span><span>RADIUS</span><span>LDAP/AD</span><span>Keycloak</span><span>OIDC</span><span>SAML</span></div>
      </div>
    </div>
  </div>
</section>

<section id="flagships">
  <div class="wrap">
    <div class="section-head">
      <h2>Meine Kompetenzbereiche</h2>
      <p>Drei Stacks, eine Methode — und eine mögliche Kombination für Organisationen, die ihre digitale Souveränität konsequent zu Ende denken wollen.</p>
    </div>

    <div class="flagships">
      <div class="flag matrix">
        <span class="flag-tag">stack: matrix</span>
        <h3>Souveräne Kommunikation mit Matrix</h3>
        <p>Vollständige Matrix/Synapse-Infrastruktur — verschlüsselte Nachrichten, Brücken zu WhatsApp, Telegram, Signal — um Slack oder Teams zu verlassen, ohne den Kontakt zu Ihren Gesprächspartnern zu verlieren. Multi-Server-Architektur, strikte Trennung der Zuständigkeiten, bereit für starke Authentifizierung.</p>
        <a href="/de/etudes-de-cas/matrix" class="flag-link">Fallstudie Matrix ansehen →</a>
      </div>
      <div class="flag mobile">
        <span class="flag-tag">stack: /e/os + nextcloud</span>
        <h3>Souveräne mobile Flotte</h3>
        <p>Einrollungsprozess für generalüberholte Smartphones unter /e/OS, verbunden mit Ihrer Nextcloud — Dateien, Kontakte, Kalender synchronisiert, ohne Abhängigkeit von Google. Eine glaubwürdige Alternative zu proprietären MDM-Lösungen, um Ihre Endgeräte vollständig zu beherrschen.</p>
        <a href="/de/etudes-de-cas/flotte-mobile" class="flag-link">Fallstudie mobile Flotte ansehen →</a>
      </div>
      <div class="flag grav">
        <span class="flag-tag">stack: grav cms</span>
        <h3>Reproduzierbare Websites mit Grav CMS</h3>
        <p>Eine technische Basis, aufgeteilt in drei Repositories — Anwendungs-Image, Deployment-Rolle, Site-Instanz —, um eine neue Grav-Website bereitzustellen, ohne bei null zu beginnen, mit Rollback per einzigem Befehl.</p>
        <a href="/de/etudes-de-cas/grav" class="flag-link">Fallstudie Grav CMS ansehen →</a>
      </div>
      <div class="flag-note">// Matrix und mobile Flotte lassen sich natürlich kombinieren: eine Organisation, die Matrix für ihre Kommunikation einführt, folgt oft kurz darauf mit einer Flotte souveräner Endgeräte, um sie überallhin mitzunehmen.</div>
    </div>
  </div>
</section>

<section id="souverainete">
  <div class="wrap">
    <div class="section-head">
      <span class="num">// architekturprinzip</span>
      <h2>Digitale Souveränität als Architekturprinzip</h2>
      <p>Digitale Souveränität bedeutet nicht einfach, proprietäre Software durch Open-Source-Software zu ersetzen. Eine Organisation beherrscht ihre Infrastruktur nur dann wirklich, wenn sie verstehen kann, wie diese funktioniert, weiß, wo ihre Daten liegen, sie sichern, wiederherstellen und weiterentwickeln kann, ohne von einem einzigen Anbieter abhängig zu sein.</p>
    </div>

    <div class="enjeux">
      <div class="enjeu">
        <span class="k">01 · Beherrschung</span>
        <p>Kritische Daten und Komponenten bleiben unter der Kontrolle der Organisation.</p>
      </div>
      <div class="enjeu">
        <span class="k">02 · Reversibilität</span>
        <p>Eine Infrastruktur muss sich ohne künstliche Abhängigkeit von einem Anbieter wiederherstellen, migrieren oder ersetzen lassen.</p>
      </div>
      <div class="enjeu">
        <span class="k">03 · Reproduzierbarkeit</span>
        <p>Eine wichtige Konfiguration sollte nicht von manuellen, nicht wiederholbaren Eingriffen abhängen.</p>
      </div>
      <div class="enjeu">
        <span class="k">04 · Wartbarkeit</span>
        <p>Die Infrastruktur muss auch von jemand anderem als ihrem Erbauer betrieben werden können.</p>
      </div>
    </div>

    <div class="result-banner" style="margin-top:32px;">
      <p>„Open Source ist ein Mittel. Die Beherrschung des Systems ist das Ziel.“</p>
    </div>
  </div>
</section>

<section>
  <div class="wrap">
    <div class="section-head">
      <h2>Weitere Arbeiten</h2>
      <p>Dieselbe Sorgfalt, angewendet auf andere Arten von Projekten.</p>
    </div>
    <div class="others">
      <a href="/de/realisations/facturation" class="other-card"><span class="name">Anwendung für elektronische Rechnungsstellung</span><span class="arrow">→</span></a>
    </div>
  </div>
</section>

<section id="notes-techniques">
  <div class="wrap">
    <div class="section-head">
      <h2>Technische Notizen</h2>
    </div>
    <!-- notes-techniques:latest-articles -->
  </div>
</section>

<section id="methode">
  <div class="wrap">
    <div class="section-head">
      <h2>Wie ich arbeite</h2>
    </div>
    <div class="method">
      <div class="method-item">
        <span class="key">prinzip.01</span>
        <h4>Verstehen, bevor automatisiert wird</h4>
        <p>Ich identifiziere die Komponenten, ihre Zuständigkeiten, ihre Abhängigkeiten und ihre Lebenszyklen. Die Automatisierung kommt danach — nie davor.</p>
      </div>
      <div class="method-item">
        <span class="key">prinzip.02</span>
        <h4>Nichts wird zweimal auf dieselbe Weise gemacht</h4>
        <p>Jedes Deployment ist automatisiert und identisch wiederholbar — auf einem neuen Server, im Störungsfall oder um eine Installation zu duplizieren.</p>
      </div>
      <div class="method-item">
        <span class="key">prinzip.03</span>
        <h4>Code, Konfiguration, Secrets und Daten trennen</h4>
        <p>Diese Elemente haben weder dieselbe Funktion noch denselben Lebenszyklus noch dieselben Sicherheitsanforderungen. Kein Geheimnis liegt jemals im Klartext.</p>
      </div>
      <div class="method-item">
        <span class="key">prinzip.04</span>
        <h4>Für den Betrieb konzipieren</h4>
        <p>Ein System endet nicht beim ersten <code>docker compose up</code>. Updates, Rollback, Backups, Monitoring und Diagnose werden von Anfang an mitgedacht.</p>
      </div>
    </div>
    <div class="flag-note">// Dokumentieren, um weiterzugeben: eine Infrastruktur, die nur ihr Autor versteht, ist eine Abhängigkeit. Dokumentation ist Teil des gelieferten technischen Produkts.</div>
  </div>
</section>

<section>
  <div class="wrap proof">
    <p><strong style="color:var(--paper)">Die Arbeit sehen, nicht nur davon hören.</strong><br>Alles, was ich liefere, ist dokumentiert und, wann immer möglich, als Open Source veröffentlicht.</p>
    <a href="https://github.com/sepp67" target="_blank" rel="noopener" class="btn btn-ghost">Meine Projekte auf GitHub ansehen →</a>
  </div>
</section>
