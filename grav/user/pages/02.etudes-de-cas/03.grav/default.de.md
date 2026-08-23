---
title: Eine wiederverwendbare Basis, um mehrere Grav-Websites bereitzustellen und zu betreiben
template: etude-cas-grav
metadata:
  description: "Statt die Installation einer einzelnen Website zu automatisieren, eine Architektur, die Runtime, Anwendungen, persistente Daten und Deployment-Mechanismus trennt — konzipiert, um den Lebenszyklus mehrerer Grav-Websites zu beherrschen, ohne deren Betrieb zu duplizieren."
---

<header class="case-header">
  <div class="wrap">
    <span class="flag-tag">fallstudie — stack: grav cms</span>
    <h1>Eine wiederverwendbare Basis, um mehrere Grav-Websites bereitzustellen und zu betreiben</h1>
    <p class="case-sub">Statt die Installation einer einzelnen Website zu automatisieren, eine Architektur, die Runtime, Anwendungen, persistente Daten und Deployment-Mechanismus trennt — konzipiert, um den Lebenszyklus mehrerer Grav-Websites zu beherrschen, ohne deren Betrieb zu duplizieren.</p>

    <div class="meta-row">
      <div class="meta-item"><span class="k">Art des Projekts</span><span class="v">Wiederverwendbare Deployment-Basis</span></div>
      <div class="meta-item"><span class="k">Ausgangspunkt</span><span class="v">Interne Dokumentationswebsite auf Grav-Basis</span></div>
      <div class="meta-item"><span class="k">Anfängliche Vorgabe</span><span class="v">Inhalte bei Redeployments erhalten</span></div>
      <div class="meta-item"><span class="k">Stack</span><span class="v">Linux · Ansible · Docker · Grav · Git</span></div>
    </div>
  </div>
</header>

<section>
  <div class="wrap">
    <div class="section-head">
      <span class="num">// kontext</span>
      <h2>Das Problem begann bei der Persistenz</h2>
    </div>
    <div class="prose">
      <p>Der erste Bedarf war recht einfach: das Deployment einer als interne Dokumentation genutzten Grav-Website automatisieren.</p>
      <p>Doch diese Website sollte sich nach dem Deployment weiterentwickeln. Seiten würden über die Admin-Oberfläche bearbeitet, Bilder hinzugefügt, Konten angelegt.</p>
      <p>Ein erneutes Deployment der Anwendung durfte die Website deshalb niemals in ihren Ausgangszustand zurückversetzen und die im Betrieb erzeugten Daten zerstören.</p>
      <p>Eine erste Grenze wurde sichtbar:</p>
      <blockquote><strong>Die Anwendung muss ersetzbar sein. Die Nutzerdaten müssen überleben.</strong></blockquote>
      <p>Die persistenten Inhalte wurden daher vom Lebenszyklus des Containers getrennt.</p>
      <p>Dann brauchten weitere Projekte Grav-Websites. Die Frage lautete nicht mehr: <em>Wie stelle ich diese Website bereit?</em> sondern:</p>
      <blockquote><strong>Wie lässt sich ein Mechanismus schaffen, mit dem sich mehrere Grav-Websites bereitstellen und betreiben lassen, ohne die Betriebslogik zu duplizieren?</strong></blockquote>
      <p>In diesem Moment wurde aus einem Deployment-Problem ein Architekturproblem.</p>
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
      <div class="enjeu"><span class="k">Persistenz</span><p>Im Betrieb erzeugte Inhalte müssen das Ersetzen eines Containers, ein Redeployment und einen Versionswechsel überstehen.</p></div>
      <div class="enjeu"><span class="k">Wiederverwendbarkeit</span><p>Die gemeinsame Mechanik darf nicht für jedes neue Projekt kopiert und angepasst werden.</p></div>
      <div class="enjeu"><span class="k">Wartbarkeit</span><p>Runtime, Anwendung, Daten und Deployment entwickeln sich weder im gleichen Takt noch aus denselben Gründen. Ihre Trennung sollte diese Lebenszyklen widerspiegeln.</p></div>
      <div class="enjeu"><span class="k">Reversibilität</span><p>Die Rückkehr zu einer vorherigen Version sollte so weit wie möglich denselben Mechanismus nutzen wie ein normales Deployment.</p></div>
      <div class="enjeu"><span class="k">Sicherheit</span><p>Secrets und sensible Konfiguration bleiben außerhalb der Anwendungs-Images und des versionierten Codes.</p></div>
    </div>
  </div>
</section>

<section>
  <div class="wrap">
    <div class="section-head">
      <span class="num">// architektur</span>
      <h2>Unterschiedliche Lebenszyklen, getrennte Zuständigkeiten</h2>
    </div>
    <div class="prose">
      <p>Die Analyse des ersten Deployments und die Ankunft neuer Projekte machten vier unterschiedliche Bereiche sichtbar: <strong>Runtime</strong>, <strong>Anwendung / Website</strong>, <strong>persistente Daten</strong> und <strong>Deployment-Mechanismus</strong>. Sie nur deshalb zusammenzufassen, weil sie derselben Website dienen, hätte eine unnötige Kopplung geschaffen. Die Architektur zielt daher darauf ab, diese Grenzen explizit zu machen.</p>
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
          <text x="500" y="311" text-anchor="middle">Grav-Instanzen</text>

          <rect x="400" y="380" width="200" height="32" rx="2" fill="none" stroke="var(--muted)" stroke-dasharray="3 3"/>
          <text x="500" y="401" text-anchor="middle" fill="var(--muted)">persistente Daten</text>
        </g>
      </svg>
      <div class="diagram-caption">// grav-runtime (gemeinsame Basis) → unabhängige Anwendungen → ansible-role-grav-site (gemeinsames Deployment) → Instanzen → vom Container entkoppelte Daten</div>
    </div>

    <div class="choice-list">
      <div class="choice">
        <span class="label">Eine gemeinsame Runtime</span>
        <p><code>grav-runtime</code> stellt das gemeinsame technische Fundament bereit: Grav, PHP, Nginx und den von den Anwendungen erwarteten Vertrag. Sie kennt kein einzelnes Fachprojekt.</p>
      </div>
      <div class="choice">
        <span class="label">Unabhängige Anwendungen</span>
        <p><code>projet-gites</code>, <code>projet-lavallee-website</code> und künftige Websites fügen nur das hinzu, was ihnen eigen ist: Theme, Plugins, Anwendungskonfiguration und Ausgangsinhalte. Jede Anwendung bleibt unabhängig versioniert.</p>
      </div>
      <div class="choice">
        <span class="label">Ein gemeinsamer Deployment-Mechanismus</span>
        <p><code>ansible-role-grav-site</code> zentralisiert die gemeinsame Mechanik: Vorbereitung der Instanz, persistente Volumes, Konfiguration, Secrets, Start, Health-Checks, Updates und Rollback. Die Rolle bleibt auf eine Instanz pro Aufruf ausgerichtet.</p>
      </div>
      <div class="choice">
        <span class="label">Daten außerhalb des Container-Lebenszyklus</span>
        <p>Seiten, Bilder, Konten und andere persistente Daten leben unabhängig vom Anwendungs-Image. Eine neue Version kann die Anwendung daher ersetzen, ohne automatisch ihren Produktionszustand zurückzusetzen.</p>
      </div>
    </div>
  </div>
</section>

<section>
  <div class="wrap">
    <div class="section-head">
      <span class="num">// umsetzung</span>
      <h2>Von der Installation zum Lebenszyklus</h2>
    </div>
    <div class="steps">
      <div class="step"><span class="step-num">01</span><div><h4>Erster Bedarf: Daten persistent machen</h4><p>Das erste Deployment ermöglichte es, eine grundlegende Regel zu formalisieren: rekonstruierbare Elemente gehören zur Anwendung; im Betrieb erzeugte Daten müssen außerhalb des Containers leben.</p></div></div>
      <div class="step"><span class="step-num">02</span><div><h4>Extraktion einer gemeinsamen Runtime</h4><p>Grav, PHP, Nginx und die gemeinsamen Abhängigkeiten wurden in <code>grav-runtime</code> isoliert. Anwendungsprojekte müssen diese technische Schicht dadurch nicht mehr selbst aufbauen.</p></div></div>
      <div class="step"><span class="step-num">03</span><div><h4>Zentralisierung des Deployments</h4><p>Die Betriebsmechanik wurde in <code>ansible-role-grav-site</code> zusammengefasst: Volumes, Secrets, Konfiguration, Health-Checks, bereitgestellte Version, Update und Rollback.</p></div></div>
      <div class="step"><span class="step-num">04</span><div><h4>Übergang zu mehreren Anwendungen</h4><p><code>projet-gites</code>, dann <code>lavallee.tech</code>, ermöglichten es, das Modell an mehreren realen Anwendungen zu prüfen. Die zweite Website deckte insbesondere Annahmen auf, die noch an das erste Projekt gebunden waren — Namen, Pfade oder Instanzeigenschaften — und löste deren Verallgemeinerung aus.</p></div></div>
    </div>
  </div>
</section>

<section>
  <div class="wrap">
    <div class="section-head">
      <span class="num">// lebenszyklus</span>
      <h2>Installation ist nur der erste Schritt</h2>
    </div>
    <div class="prose">
      <p>Eine Anwendung wird nur einmal installiert. Danach muss sie über Jahre betrieben werden können. Das gesuchte Modell lautet daher nicht mehr:</p>
      <pre><code>install</code></pre>
      <p>sondern:</p>
      <pre><code>deploy → update → rollback → migrate</code></pre>
      <p>Dieser Unterschied prägt die Architektur. Die Runtime ist versioniert. Jede Anwendung ist versioniert. Daten bestehen unabhängig fort. Der Deployment-Mechanismus setzt den gewünschten Zustand um.</p>
    </div>
  </div>
</section>

<section>
  <div class="wrap">
    <div class="section-head">
      <span class="num">// rollback</span>
      <h2>Rollback bleibt ein Deployment</h2>
    </div>
    <div class="prose">
      <p>Rollback ist nicht als eigenständiges Notfallverfahren konzipiert. Verursacht eine neue Version ein Problem, wird einfach eine zuvor als stabil bekannte Version wieder zur gewünschten Version.</p>
      <pre><code>version 1.3.2
      │
      ▼
 deploy 1.4.0
      │
  problem
      │
      ▼
 ziel = 1.3.2
      │
      ▼
derselbe deployment-mechanismus</code></pre>
      <p>Das begrenzt Sonderverfahren genau auf den Moment, in dem sie am riskantesten wären: während eines Vorfalls.</p>
    </div>
  </div>
</section>

<section>
  <div class="wrap">
    <div class="section-head">
      <span class="num">// ergebnis</span>
      <h2>Was diese Architektur verändert</h2>
    </div>
    <div class="result-banner">
      <p>Die Deployment-Logik ist zentralisiert, statt in jedes Projekt hineinkopiert zu werden. Jede Website behält ihre eigenen Inhalte, ihre Konfiguration und ihren Versionierungszyklus — und das Ersetzen einer Anwendung bedeutet nie das Ersetzen ihres persistenten Zustands.</p>
      <div class="result-stats">
        <div class="stat"><span class="num-big">1</span><span class="lbl">gemeinsame Runtime, unabhängig von den Websites gebaut und gepflegt</span></div>
        <div class="stat"><span class="num-big">1</span><span class="lbl">Deployment-Mechanismus, statt pro Projekt kopiert zu werden</span></div>
        <div class="stat"><span class="num-big">2</span><span class="lbl">unabhängige Anwendungen, auf derselben Basis bereitgestellt</span></div>
      </div>
    </div>
    <div class="prose" style="margin-top:24px;">
      <p><strong>Die erste Website hat einen Bedarf gelöst. Die zweite hat begonnen, die Architektur zu testen.</strong> Die nächsten müssen dieselbe Basis wiederverwenden können, ohne die Betriebslogik zu vervielfachen.</p>
    </div>
  </div>
</section>

<section>
  <div class="wrap">
    <div class="section-head">
      <span class="num">// beweis</span>
      <h2>Die zweite Website ist der eigentliche Test</h2>
    </div>
    <div class="prose">
      <p>Es ist leicht, eine Architektur als „wiederverwendbar“ zu bezeichnen, solange sie erst einem einzigen Projekt dient. Der zweite Nutzer deckt die Annahmen auf, die in Wirklichkeit spezifisch für das erste waren.</p>
      <p><code>lavallee.tech</code> ist inzwischen selbst auf dieser Architektur bereitgestellt. Ihre Ankunft ermöglichte es, die letzten Instanzparameter zu identifizieren, die verallgemeinert werden mussten, damit die Deployment-Rolle eine atomare, wiederverwendbare Komponente bleibt.</p>
      <p>Der nächste Schritt besteht darin, denselben Mechanismus für eine neue technische Dokumentationswebsite zu nutzen. Wiederverwendbarkeit wird daher nicht als deklarierte Eigenschaft betrachtet.</p>
      <blockquote><strong>Sie muss durch neue Nutzer bestätigt werden.</strong></blockquote>
    </div>

    <div class="roadmap-box" style="margin-top:28px;">
      <span class="icon">→</span>
      <div>
        <h4>Neue technische Dokumentationswebsite <span class="status-pill">in Vorbereitung</span></h4>
        <p>Dieselbe Basis — grav-runtime + ansible-role-grav-site — wird unverändert für diesen neuen Nutzer wiederverwendet, der einzig wirkliche Beweis dafür, dass eine Architektur wiederverwendbar ist.</p>
      </div>
    </div>
  </div>
</section>

<section>
  <div class="wrap">
    <div class="section-head">
      <span class="num">// souveränität</span>
      <h2>Warum diese Architektur auch zur Beherrschung des Systems beiträgt</h2>
    </div>
    <div class="prose">
      <p>Der Einsatz von Open-Source-Software ist nur ein Teil des Problems. Eine Infrastruktur bleibt schwer zu beherrschen, wenn ihr Deployment von manuellen Eingriffen abhängt, ihre Daten mit der Anwendung vermischt sind oder niemand genau weiß, welche Version in Produktion läuft.</p>
      <p>Diese Architektur zielt daher darauf ab, Folgendes explizit zu machen:</p>
      <ul>
        <li>die verwendeten Komponenten;</li>
        <li>die bereitgestellten Versionen;</li>
        <li>die zu erhaltenden Daten;</li>
        <li>die Zuständigkeiten jeder Schicht;</li>
        <li>den Mechanismus, um eine Instanz wiederherzustellen.</li>
      </ul>
      <blockquote><strong>Open Source ist ein Mittel. Die Beherrschung des Systems ist das Ziel.</strong></blockquote>
    </div>
  </div>
</section>

<section>
  <div class="wrap">
    <div class="section-head">
      <span class="num">// grenzen</span>
      <h2>Was die Basis nicht zu leisten versucht</h2>
    </div>
    <div class="limites-list">
      <div class="limite"><span class="marker">—</span><p>Inhaltserstellung und redaktionelles Design bleiben Sache jeder einzelnen Anwendung.</p></div>
      <div class="limite"><span class="marker">—</span><p>Die Deployment-Rolle verwaltet weder DNS noch Reverse Proxy noch TLS-Zertifikate. Diese Zuständigkeiten liegen bei der gemeinsamen Infrastruktur.</p></div>
      <div class="limite"><span class="marker">—</span><p>Backups bleiben notwendig. Grav vermeidet den Betrieb eines zusätzlichen Datenbankdienstes, aber die persistenten Dateien sind Produktionsdaten und müssen gesichert werden.</p></div>
      <div class="limite"><span class="marker">—</span><p>Die Deployment-Rolle verwaltet eine Instanz pro Aufruf. Die Orchestrierung mehrerer Websites wird bewusst auf einer höheren Ebene behandelt.</p></div>
      <div class="limite"><span class="marker">—</span><p>Anwendungen mit komplexen Fachfunktionen, hohem Traffic oder fortgeschrittenen Datenmodellen können außerhalb des natürlichen Anwendungsbereichs eines Flat-File-CMS wie Grav liegen.</p></div>
    </div>
  </div>
</section>

<section>
  <div class="wrap">
    <div class="section-head">
      <span class="num">// komponenten</span>
      <h2>Die Basis und ihre Anwendungen</h2>
    </div>
    <div class="repo-grid">
      <div class="repo-row">
        <div>
          <div class="repo-name">grav-runtime</div>
          <div class="repo-desc"><strong style="color:var(--paper)">Gemeinsame Runtime.</strong> Versioniertes Basis-Image, das Grav, PHP, Nginx und den gemeinsamen Runtime-Vertrag bereitstellt.</div>
        </div>
        <a href="https://github.com/sepp67/grav-runtime" target="_blank" rel="noopener" class="btn">Auf GitHub ansehen →</a>
      </div>
      <div class="repo-row">
        <div>
          <div class="repo-name">ansible-role-grav-site</div>
          <div class="repo-desc"><strong style="color:var(--paper)">Deployment-Mechanismus.</strong> Ansible-Rolle, zuständig für den Lebenszyklus einer kompatiblen Grav-Instanz.</div>
        </div>
        <a href="https://github.com/sepp67/ansible-role-grav-site" target="_blank" rel="noopener" class="btn">Auf GitHub ansehen →</a>
      </div>
      <div class="repo-row">
        <div>
          <div class="repo-name">projet-gites</div>
          <div class="repo-desc"><strong style="color:var(--paper)">Anwendung.</strong> Erste Fachwebsite, die die gemeinsame Basis nutzt.</div>
        </div>
        <a href="https://github.com/sepp67/projet-gites" target="_blank" rel="noopener" class="btn">Auf GitHub ansehen →</a>
      </div>
      <div class="repo-row">
        <div>
          <div class="repo-name">projet-lavallee-website</div>
          <div class="repo-desc"><strong style="color:var(--paper)">Anwendung.</strong> Zweite reale Website, die dieselbe Architektur nutzt — diejenige, die Sie gerade betrachten.</div>
        </div>
        <a href="https://github.com/sepp67/projet-lavallee-website" target="_blank" rel="noopener" class="btn">Auf GitHub ansehen →</a>
      </div>
    </div>
  </div>
</section>

<section>
  <div class="wrap">
    <div class="section-head">
      <span class="num">// weiterführend</span>
      <h2>Warum diese Architektur?</h2>
    </div>
    <div class="prose">
      <p>Diese Trennung entstand nicht aus einem theoretischen Entwurf. Sie ist das Ergebnis der Entwicklung eines konkreten Bedarfs: die Daten einer ersten Website zu erhalten und dann zu verstehen, wie mehrere Anwendungen betrieben werden können, ohne ihre Infrastruktur zu duplizieren.</p>
    </div>
    <a href="/de/articles/grav-plateforme-de-deploiement-reutilisable" class="flag-link" style="color:var(--moss);">Artikel lesen: Von der Bereitstellung einer Website zur wiederverwendbaren Deployment-Plattform →</a>
  </div>
</section>

<section class="final-cta">
  <div class="wrap">
    <h2>Ein Linux-Dienst, den es reproduzierbar und wartbar zu machen gilt?</h2>
    <p>Ein automatisiertes Deployment ist nur ein Teil des Problems. Die eigentliche Frage ist, wie das System aktualisiert, diagnostiziert, gesichert, wiederhergestellt und langfristig weitergegeben wird.</p>
    <a href="/de/#contact" class="btn btn-primary">Lassen Sie uns zuerst über Ihre Rahmenbedingungen sprechen →</a>
  </div>
</section>
