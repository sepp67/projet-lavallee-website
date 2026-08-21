---
title: Souveräne Kommunikation mit Matrix
template: etude-cas-matrix
metadata:
  description: "Bereitstellung einer vollständigen Matrix/Synapse-Infrastruktur — zwei dedizierte Server, Brücken zu WhatsApp und Telegram — um Slack zu verlassen, ohne die Kontrolle über die eigene Kommunikation zu verlieren."
---

<header class="case-header">
  <div class="wrap">
    <span class="flag-tag">fallstudie — stack: matrix</span>
    <h1>Slack verlassen, ohne die Kontrolle über die eigene Kommunikation zu verlieren</h1>
    <p class="case-sub">Bereitstellung einer vollständigen Matrix/Synapse-Infrastruktur — zwei dedizierte Server, Brücken zu WhatsApp und Telegram, eine gemeinsame Datenbank — für eine Organisation, die ihre Gespräche im eigenen Haus behalten wollte, ohne auf Bedienkomfort zu verzichten.</p>

    <div class="meta-row">
      <div class="meta-item"><span class="k">Art der Organisation</span><span class="v">Verein, 40 Mitarbeitende</span></div>
      <div class="meta-item"><span class="k">Auslöser</span><span class="v">Ende des Slack-Vertrags</span></div>
      <div class="meta-item"><span class="k">Zentrale Vorgabe</span><span class="v">Keine Daten außerhalb der EU</span></div>
      <div class="meta-item"><span class="k">Stack</span><span class="v">Debian · Docker · Ansible</span></div>
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
      <p>Die Organisation nutzte Slack seit mehreren Jahren. Vor der Vertragsverlängerung wollte die Leitung eine in Europa gehostete Alternative prüfen — ohne auf das zu verzichten, was die Mitarbeitenden bereits täglich nutzten: Teamdiskussionen, Direktnachrichten und vor allem die WhatsApp-Gruppen mit externen Partnern, die selbst nicht das Werkzeug wechseln würden.</p>
      <p><strong>Die eigentliche Herausforderung war nicht nur, Slack zu ersetzen</strong>, sondern dies zu tun, ohne den externen Gesprächspartnern einen Bruch aufzuzwingen — was die Wahl auf Matrix mit Anwendungsbrücken statt einer einfachen Migration lenkte.</p>
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
      <div class="enjeu"><span class="k">Souveränität</span><p>Keine Daten außerhalb der Europäischen Union gehostet, Hoster von der Organisation selbst gewählt und geprüft.</p></div>
      <div class="enjeu"><span class="k">Kontinuität</span><p>Externe Kontakte auf WhatsApp und Telegram sollten nichts an ihren Gewohnheiten ändern müssen.</p></div>
      <div class="enjeu"><span class="k">Sicherheit</span><p>Strikte Trennung zwischen internen Konten und Brücken zu Drittanbieterdiensten.</p></div>
      <div class="enjeu"><span class="k">Erweiterbarkeit</span><p>Eine künftige Brücke (Signal, Discord) hinzufügen können, ohne die Architektur neu aufzusetzen.</p></div>
    </div>
  </div>
</section>

<section>
  <div class="wrap">
    <div class="section-head">
      <span class="num">// architektur</span>
      <h2>Die Entscheidungen, die das Deployment prägen</h2>
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
          <text x="150" y="266" text-anchor="middle">Vault (Secrets)</text>

          <rect x="90" y="106" width="120" height="28" rx="2" fill="var(--amber-wash)" stroke="var(--amber-dim)"/>
          <text x="150" y="124" text-anchor="middle" fill="var(--amber)">Ansible Control</text>

          <rect x="340" y="46" width="120" height="28" rx="2" fill="none" stroke="var(--line-strong)"/>
          <text x="400" y="64" text-anchor="middle">vm-postgresql</text>

          <rect x="340" y="106" width="120" height="28" rx="2" fill="none" stroke="var(--line-strong)"/>
          <text x="400" y="124" text-anchor="middle">vm-matrix-users</text>

          <rect x="340" y="166" width="120" height="28" rx="2" fill="var(--amber-wash)" stroke="var(--amber)"/>
          <text x="400" y="184" text-anchor="middle" fill="var(--amber)">vm-matrix-bridges</text>

          <rect x="560" y="46" width="130" height="28" rx="2" fill="none" stroke="var(--line-strong)"/>
          <text x="625" y="64" text-anchor="middle">Reverse Proxy</text>

          <rect x="560" y="166" width="130" height="28" rx="2" fill="none" stroke="var(--line-strong)"/>
          <text x="625" y="184" text-anchor="middle">docker-compose</text>

          <rect x="790" y="46" width="130" height="28" rx="2" fill="none" stroke="var(--blue)"/>
          <text x="855" y="64" text-anchor="middle" fill="var(--blue)">Element (Web)</text>

          <rect x="790" y="116" width="130" height="28" rx="2" fill="none" stroke="var(--blue)"/>
          <text x="855" y="134" text-anchor="middle" fill="var(--blue)">mautrix-whatsapp</text>

          <rect x="790" y="166" width="130" height="28" rx="2" fill="none" stroke="var(--blue)"/>
          <text x="855" y="184" text-anchor="middle" fill="var(--blue)">mautrix-telegram</text>

          <rect x="790" y="216" width="130" height="28" rx="2" fill="none" stroke="var(--muted)" stroke-dasharray="3 3"/>
          <text x="855" y="234" text-anchor="middle" fill="var(--muted)">künftige Brücke…</text>
        </g>
      </svg>
      <div class="diagram-caption">// 4 dedizierte VMs — Datenbank, Homeserver für Nutzer, Homeserver + Brücken, gemeinsame Infrastruktur (außerhalb des Rollenumfangs)</div>
    </div>

    <div class="choice-list">
      <div class="choice">
        <span class="label">Trennung von Users / Bridges</span>
        <p>Der täglich von den Mitarbeitenden genutzte Homeserver läuft isoliert vom Homeserver, der die Brücken trägt — eine Störung oder ein Update einer WhatsApp-Brücke kann die interne Kommunikation nie beeinträchtigen.</p>
      </div>
      <div class="choice">
        <span class="label">Gemeinsame Datenbank</span>
        <p>Eine einzige PostgreSQL-VM, eine Datenbank pro Komponente, das Hinzufügen einer künftigen Komponente ist nur einen Variableneintrag entfernt — ohne neue Ansible-Aufgabe, ohne Serverneustart.</p>
      </div>
      <div class="choice">
        <span class="label">Proxy bleibt außen vor</span>
        <p>Die Rolle verwaltet nie den Reverse Proxy, DNS oder TLS-Zertifikate — diese Verantwortlichkeiten bleiben in der gemeinsamen Infrastruktur der Organisation, damit die Rolle andernorts wiederverwendbar bleibt.</p>
      </div>
      <div class="choice">
        <span class="label">Tokens werden nie neu generiert</span>
        <p>Die Authentifizierungs-Tokens der Brücken werden einmal erzeugt und aufbewahrt — ein erneuter Durchlauf des Deployments bricht nie eine bereits aktive Verbindung.</p>
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
      <div class="step"><span class="step-num">01</span><div><h4>Bereitstellung der 4 VMs</h4><p>Datenbank, Homeserver für Nutzer, Homeserver + Brücken, gemeinsame Infrastruktur — jede mit einer eindeutigen, dokumentierten Rolle.</p></div></div>
      <div class="step"><span class="step-num">02</span><div><h4>Bereitstellung von Synapse als zwei Instanzen</h4><p>Ein Homeserver für interne Konten, ein zweiter dediziert für die Brücken — nie vermischt, nie auf derselben Anwendungsbasis.</p></div></div>
      <div class="step"><span class="step-num">03</span><div><h4>Anbindung der WhatsApp- und Telegram-Brücken</h4><p>Jede Brücke in ihrem eigenen Container, ihrer eigenen Datenbank, ihrer eigenen Registrierungsdatei — Hinzufügen der nächsten Brücke, ohne die bestehenden anzufassen.</p></div></div>
      <div class="step"><span class="step-num">04</span><div><h4>Validierung unter Realbedingungen</h4><p>Prüfung, dass jeder Bot antwortet und Nachrichten in beide Richtungen fließen, bevor ein Team umgestellt wird.</p></div></div>
      <div class="step"><span class="step-num">05</span><div><h4>Schrittweise Umstellung der Teams</h4><p>Migration Team für Team, wobei Slack im Nur-Lese-Modus blieb, bis sich alle mit Element vertraut gemacht hatten.</p></div></div>
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
      <p>Alle Nachrichtendaten bleiben in Europa gehostet, auf einer Infrastruktur, deren Schlüssel die Organisation selbst behält — während externe Kontakte auf WhatsApp oder Telegram nichts von der Umstellung bemerkt haben.</p>
      <div class="result-stats">
        <div class="stat"><span class="num-big">0</span><span class="lbl">von externen Kontakten wahrgenommene Unterbrechung</span></div>
        <div class="stat"><span class="num-big">4</span><span class="lbl">reproduzierbar bereitgestellte und dokumentierte VMs</span></div>
        <div class="stat"><span class="num-big">1</span><span class="lbl">Befehl, um eine künftige Brücke hinzuzufügen</span></div>
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
      <div class="limite"><span class="marker">—</span><p>Die fachliche Konfiguration jeder Brücke (WhatsApp-QR-Code-Kopplung, Telegram-Verknüpfung) bleibt ein manueller, kontospezifischer Schritt — infrastrukturseitig nicht automatisierbar.</p></div>
      <div class="limite"><span class="marker">—</span><p>Reverse Proxy, DNS und TLS-Zertifikate werden von diesem Deployment nicht verwaltet — sie gehören zur bereits bestehenden gemeinsamen Infrastruktur der Organisation.</p></div>
      <div class="limite"><span class="marker">—</span><p>Starke Authentifizierung (SSO/MFA) ist auf dieser Installation noch nicht integriert — ein mögliches Folgeprojekt mit einem von der Organisation selbst validierten Identitätsanbieter.</p></div>
      <div class="limite"><span class="marker">—</span><p>Die Sicherung der Nachrichten wird der bereits bestehenden Backup-Richtlinie des Hosters überlassen — dieses Deployment erfindet nicht neu, was bereits korrekt funktioniert.</p></div>
    </div>
  </div>
</section>

<section>
  <div class="wrap">
    <div class="repo-box">
      <div>
        <div class="repo-name">ansible-role-matrix-stack</div>
        <div class="repo-desc">Die vollständige, dokumentierte und quelloffene Ansible-Rolle, die für dieses Deployment verwendet wurde.</div>
      </div>
      <a href="https://github.com/sepp67/ansible-role-matrix-stack" target="_blank" rel="noopener" class="btn">Code auf GitHub ansehen →</a>
    </div>
  </div>
</section>

<section class="final-cta">
  <div class="wrap">
    <h2>Ein ähnlicher Bedarf an souveräner Kommunikation?</h2>
    <p>Jede Organisation hat ihre eigenen Rahmenbedingungen — lassen Sie uns über Ihre sprechen, bevor wir über eine Lösung sprechen.</p>
    <a href="/de/#contact" class="btn btn-primary">Kontakt aufnehmen →</a>
  </div>
</section>
