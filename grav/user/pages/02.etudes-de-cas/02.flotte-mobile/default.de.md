---
title: Souveräne mobile Flotte /e/OS + Nextcloud
template: etude-cas-flotte-mobile
metadata:
  description: "Einführung eines Einrollungsprozesses für eine Flotte generalüberholter Smartphones unter /e/OS, verbunden mit einer selbstgehosteten Nextcloud — ohne Google-Konto und ohne proprietäres MDM."
---

<header class="case-header">
  <div class="wrap">
    <span class="flag-tag">fallstudie — stack: /e/os + nextcloud</span>
    <h1>Ein reisendes Team ausstatten, ohne von Google abhängig zu sein</h1>
    <p class="case-sub">Einführung eines Einrollungsprozesses für eine Flotte generalüberholter Smartphones unter /e/OS, verbunden mit einer selbstgehosteten Nextcloud — Dateien, Kontakte und Kalender synchronisiert, ohne Google-Konto und ohne proprietäres MDM-Abonnement.</p>

    <div class="meta-row">
      <div class="meta-item"><span class="k">Art der Organisation</span><span class="v">Genossenschaft, 15 Außendienstler</span></div>
      <div class="meta-item"><span class="k">Auslöser</span><span class="v">Ausstieg aus Google Workspace</span></div>
      <div class="meta-item"><span class="k">Zentrale Vorgabe</span><span class="v">Generalüberholte Endgeräte</span></div>
      <div class="meta-item"><span class="k">Stack</span><span class="v">/e/OS · Nextcloud · DAVx5</span></div>
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
      <p>Die Außendiensttechniker der Genossenschaft waren bislang mit privaten Telefonen oder Android-Geräten unterwegs, die an ein pro Nutzer abgerechnetes Google-Workspace-Konto gebunden waren. Vor der Vertragsverlängerung wollte die Organisation diese Abhängigkeit beenden — ohne auf ein ebenso teures wie geschlossenes proprietäres MDM (Intune, Jamf) zurückzugreifen.</p>
      <p><strong>Die Budgetvorgabe lenkte die Wahl auf generalüberholte Geräte</strong>: statt Neugeräte zu kaufen, die Flotte mit generalüberholten, mit /e/OS geflashten Telefonen auszustatten — vorausgesetzt, der Installations- und Anbindungsprozess an die bestehende Nextcloud war zuverlässig und reproduzierbar, nicht Gerät für Gerät handgestrickt.</p>
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
      <div class="enjeu"><span class="k">Kosten</span><p>Generalüberholte statt neue Endgeräte, kein wiederkehrendes MDM-Abonnement pro Gerät.</p></div>
      <div class="enjeu"><span class="k">Autonomie</span><p>Keine Abhängigkeit von einem Google-Konto — Dateien, Kontakte und Kalender bei der Genossenschaft gehostet.</p></div>
      <div class="enjeu"><span class="k">Reproduzierbarkeit</span><p>Derselbe Einrollungsprozess, identisch auf jedes neue Endgerät angewendet.</p></div>
      <div class="enjeu"><span class="k">Lebenszyklus</span><p>Ein Endgerät bei einem Abgang oder Austausch sauber neu zuweisen oder löschen können.</p></div>
    </div>
  </div>
</section>

<section>
  <div class="wrap">
    <div class="section-head">
      <span class="num">// architektur</span>
      <h2>Die Entscheidungen, die den Prozess prägen</h2>
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
          <text x="80" y="135" text-anchor="middle">generalüberholter bestand</text>

          <rect x="300" y="44" width="120" height="30" rx="2" fill="var(--blue-wash)" stroke="var(--blue)"/>
          <text x="360" y="63" text-anchor="middle" fill="var(--blue)">flash /e/OS</text>
          <rect x="300" y="114" width="120" height="30" rx="2" fill="var(--blue-wash)" stroke="var(--blue)"/>
          <text x="360" y="133" text-anchor="middle" fill="var(--blue)">einrollungsprofil</text>
          <rect x="300" y="184" width="120" height="30" rx="2" fill="var(--blue-wash)" stroke="var(--blue)"/>
          <text x="360" y="203" text-anchor="middle" fill="var(--blue)">Nextcloud-Konto</text>

          <rect x="600" y="114" width="120" height="32" rx="2" fill="none" stroke="var(--line-strong)"/>
          <text x="660" y="135" text-anchor="middle">DAVx5 (Sync)</text>

          <rect x="820" y="44" width="120" height="30" rx="2" fill="none" stroke="var(--paper)"/>
          <text x="880" y="63" text-anchor="middle" fill="var(--paper)">Dateien</text>
          <rect x="820" y="114" width="120" height="30" rx="2" fill="none" stroke="var(--paper)"/>
          <text x="880" y="133" text-anchor="middle" fill="var(--paper)">Kontakte</text>
          <rect x="820" y="184" width="120" height="30" rx="2" fill="none" stroke="var(--paper)"/>
          <text x="880" y="203" text-anchor="middle" fill="var(--paper)">Kalender</text>
        </g>
      </svg>
      <div class="diagram-caption">// vom generalüberholten Bestand zum einsatzbereiten Endgerät — drei reproduzierbare Schritte, danach fortlaufende Synchronisierung via DAVx5</div>
    </div>

    <div class="choice-list">
      <div class="choice">
        <span class="label">Ein Profil statt manueller Konfiguration</span>
        <p>Jedes Endgerät erhält dasselbe Einrollungsprofil (Konten, Einschränkungen, Basisanwendungen) — keine von Hand neu vorgenommenen Einstellungen auf jedem Gerät.</p>
      </div>
      <div class="choice">
        <span class="label">DAVx5 statt einer proprietären App</span>
        <p>Die Synchronisierung von Dateien/Kontakten/Kalender läuft über einen Standard-CardDAV/CalDAV-Connector — austauschbar, ohne Anbieterbindung.</p>
      </div>
      <div class="choice">
        <span class="label">Inventar getrennt von der Zuweisung</span>
        <p>Die Nachverfolgung, wer welches Endgerät nutzt, bleibt unabhängig vom technischen Einrollungsprozess — die Genossenschaft behält die Kontrolle, ohne von meinem Tooling abhängig zu sein.</p>
      </div>
      <div class="choice">
        <span class="label">Löschung von Anfang an mitgedacht</span>
        <p>Das Zurücksetzungsverfahren zwischen zwei Nutzern ist auf demselben Niveau dokumentiert wie die anfängliche Einrollung — nicht nachträglich hinzugefügt.</p>
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
      <div class="step"><span class="step-num">01</span><div><h4>Auswahl und Prüfung des generalüberholten Bestands</h4><p>Prüfung der /e/OS-Kompatibilität und des physischen Zustands jedes Modells vor der Installation.</p></div></div>
      <div class="step"><span class="step-num">02</span><div><h4>Flashen von /e/OS und Grundhärtung</h4><p>Installation des Systems, Entfernen verbliebener Google-Dienste, Konfiguration automatischer Updates.</p></div></div>
      <div class="step"><span class="step-num">03</span><div><h4>Anwendung des Einrollungsprofils</h4><p>Konten, Einschränkungen und Basisanwendungen identisch auf jedem Endgerät angewendet.</p></div></div>
      <div class="step"><span class="step-num">04</span><div><h4>Anbindung an Nextcloud via DAVx5</h4><p>Synchronisierung der Dateien, Kontakte und des Kalenders des Technikers, getestet vor Übergabe des Endgeräts.</p></div></div>
      <div class="step"><span class="step-num">05</span><div><h4>Übergabe und Nutzerdokumentation</h4><p>Ein kurzes Merkblatt zur Basisnutzung, mit einer Kontaktmöglichkeit für die erste Woche bei Problemen.</p></div></div>
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
      <p>Die Genossenschaft hat ihr reisendes Team ausgestattet, ohne ein einziges Google-Konto zu eröffnen, ohne wiederkehrendes MDM-Abonnement, und mit generalüberholten statt neuen Endgeräten — bei gleichzeitig im eigenen Haus gehosteten Dateien, Kontakten und Kalendern.</p>
      <div class="result-stats">
        <div class="stat"><span class="num-big">0 €</span><span class="lbl">MDM-Abonnement oder Lizenz pro Endgerät</span></div>
        <div class="stat"><span class="num-big">15</span><span class="lbl">identisch eingerollte generalüberholte Endgeräte</span></div>
        <div class="stat"><span class="num-big">1</span><span class="lbl">dokumentierter, bei jeder Erneuerung wiederholbarer Prozess</span></div>
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
      <div class="limite"><span class="marker">—</span><p>Die Qualitätskontrolle der generalüberholten Hardware (Akku- und Bildschirmzustand) hängt vom durch die Organisation gewählten Lieferanten ab — dieser Prozess umfasst keine Hardware-Expertise.</p></div>
      <div class="limite"><span class="marker">—</span><p>Manche Bank- oder Verwaltungs-Apps funktionieren ohne Google-Dienste nicht — im Einzelfall vor der vollständigen Umstellung eines Teams zu prüfen.</p></div>
      <div class="limite"><span class="marker">—</span><p>Fortgeschrittene MDM-artige Fernverwaltung (Sperrung, Echtzeit-Geolokalisierung) wird nicht abgedeckt — dieser Prozess bleibt bewusst einfacher als eine vollständige MDM-Lösung.</p></div>
      <div class="limite"><span class="marker">—</span><p>Starke Authentifizierung für Nextcloud-Konten war in diesem ersten Deployment nicht enthalten — ein separates Projekt, mit derselben Sorgfalt anzugehen wie bei Matrix.</p></div>
    </div>
  </div>
</section>

<section>
  <div class="wrap">
    <div class="repo-box">
      <div>
        <div class="repo-name">Einrollungsmethodik /e/OS + Nextcloud</div>
        <div class="repo-desc">Aus diesem Deployment dokumentierter Prozess — das Referenz-Repository wird für die Veröffentlichung vorbereitet.</div>
      </div>
      <a href="/de/#contact" class="btn">Methodik anfragen →</a>
    </div>
  </div>
</section>

<section class="final-cta">
  <div class="wrap">
    <h2>Eine Flotte von Endgeräten, die von Google oder einem proprietären MDM befreit werden soll?</h2>
    <p>Jede Organisation hat ihre eigenen Abläufe und Rahmenbedingungen — lassen Sie uns über Ihre sprechen, bevor wir über eine Lösung sprechen.</p>
    <a href="/de/#contact" class="btn btn-primary">Kontakt aufnehmen →</a>
  </div>
</section>
