---
title: Accueil
template: homepage
metadata:
  description: "Je conçois, déploie et maintiens des infrastructures Linux reproductibles basées sur des technologies open source, avec la souveraineté numérique comme principe de conception."
---

<section class="hero">
  <div class="wrap">
    <div class="eyebrow">consultant infrastructure open source</div>
    <h1>La souveraineté numérique, déployée avec méthode.</h1>
    <p class="hero-sub">Je conçois, déploie et maintiens des infrastructures Linux reproductibles — communication, fichiers, terminaux mobiles — pour les organisations qui veulent reprendre la main sur leurs outils numériques, sans dépendre d'un fournisseur unique.</p>
    <div class="cta-row">
      <a href="#flagships" class="btn btn-primary btn-lg">Voir mes projets phares →</a>
      <a href="#contact" class="btn btn-ghost btn-lg">Me contacter</a>
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
          <text x="60" y="204" text-anchor="middle">utilisateur</text>

          <circle cx="200" cy="180" r="5" fill="var(--blue)"/>
          <text x="200" y="204" text-anchor="middle" fill="var(--blue)">/e/OS</text>

          <circle cx="380" cy="60" r="6" fill="var(--amber)"/>
          <text x="380" y="40" text-anchor="middle" fill="var(--amber)">matrix-synapse</text>

          <circle cx="380" cy="180" r="5" fill="var(--blue)"/>
          <text x="380" y="204" text-anchor="middle" fill="var(--blue)">nextcloud</text>

          <circle cx="660" cy="150" r="5" fill="var(--muted)"/>
          <text x="660" y="174" text-anchor="middle">reverse proxy</text>

          <circle cx="980" cy="70" r="6" fill="var(--paper)"/>
          <text x="980" y="50" text-anchor="middle" fill="var(--paper)">infra maîtrisée</text>
        </g>
      </svg>
      <div class="diagram-caption">// séparation des responsabilités — chaque brique reste remplaçable indépendamment</div>
    </div>
  </div>
</section>

<section class="problem">
  <div class="wrap">
    <div class="section-head">
      <h2>Le problème</h2>
    </div>
    <p>Sortir des plateformes propriétaires est devenu un enjeu concret — RGPD, dépendance stratégique, coûts qui grimpent. Mais remplacer Slack, Teams ou un MDM par une alternative open source ne suffit pas si elle est <strong>bricolée à la main</strong>, mal sécurisée, ou impossible à maintenir dans la durée.</p>
    <p>Je fais le travail qui transforme un outil open source prometteur en <strong>infrastructure fiable</strong> : automatisée, reproductible, documentée, et qui reste maintenable après mon départ.</p>
  </div>
</section>

<section id="ce-que-je-fais">
  <div class="wrap">
    <div class="section-head">
      <span class="num">// ce que je fais</span>
      <h2>Le cycle de vie complet d'un service</h2>
      <p>J'interviens sur l'ensemble de la chaîne : architecture, déploiement, automatisation, mise à jour, supervision et résolution d'incidents.</p>
    </div>

    <div class="skills-grid">
      <div class="skill-item">
        <span class="key">expertise.01</span>
        <h4>Administration Linux</h4>
        <p>Installation, configuration, exploitation, mises à jour, diagnostic et résolution d'incidents en production. L'objectif : une infrastructure observable, documentée et exploitable dans la durée.</p>
        <div class="pill-tags"><span>Debian</span><span>Ubuntu</span><span>Réseau</span><span>Services système</span><span>Troubleshooting</span></div>
      </div>

      <div class="skill-item">
        <span class="key">expertise.02</span>
        <h4>Automatisation & déploiement</h4>
        <div class="flow">deploy → update → rollback → migrate</div>
        <p>Ansible décrit l'état attendu des machines, Docker maîtrise l'environnement applicatif, Git permet de savoir précisément ce qui est déployé.</p>
        <div class="pill-tags"><span>Ansible</span><span>Docker</span><span>Docker Compose</span><span>Git</span><span>CI/CD</span></div>
      </div>

      <div class="skill-item">
        <span class="key">expertise.03</span>
        <h4>Architecture d'infrastructure</h4>
        <p>Séparer les responsabilités plutôt que construire des systèmes monolithiques : runtime, application, données persistantes, secrets, reverse proxy et déploiement n'ont pas le même cycle de vie.</p>
        <div class="pill-tags"><span>Architecture</span><span>Reproductibilité</span><span>Idempotence</span><span>Lifecycle management</span></div>
      </div>

      <div class="skill-item">
        <span class="key">expertise.04</span>
        <h4>Identité & sécurité</h4>
        <p>Environnements combinant MFA, RADIUS, LDAP/Active Directory et fédération d'identité. Gestion des secrets, limitation des privilèges, segmentation des responsabilités.</p>
        <div class="pill-tags"><span>IAM</span><span>MFA</span><span>privacyIDEA</span><span>RADIUS</span><span>LDAP/AD</span><span>Keycloak</span><span>OIDC</span><span>SAML</span></div>
      </div>
    </div>
  </div>
</section>

<section id="flagships">
  <div class="wrap">
    <div class="section-head">
      <h2>Mes domaines d'expertise</h2>
      <p>Trois stacks, une même méthode — et une combinaison possible pour les organisations qui veulent aller jusqu'au bout de leur souveraineté numérique.</p>
    </div>

    <div class="flagships">
      <div class="flag matrix">
        <span class="flag-tag">stack: matrix</span>
        <h3>Communication souveraine avec Matrix</h3>
        <p>Infrastructure Matrix/Synapse complète — messagerie chiffrée, ponts vers WhatsApp, Telegram, Signal — pour sortir de Slack ou Teams sans perdre le contact avec vos interlocuteurs. Architecture multi-serveurs, séparation stricte des responsabilités, prête pour l'authentification forte.</p>
        <a href="/fr/etudes-de-cas/matrix" class="flag-link">Voir l'étude de cas Matrix →</a>
      </div>
      <div class="flag mobile">
        <span class="flag-tag">stack: /e/os + nextcloud</span>
        <h3>Flotte mobile souveraine</h3>
        <p>Process d'enrôlement de smartphones reconditionnés sous /e/OS, connectés à votre Nextcloud — fichiers, contacts, agenda synchronisés, sans dépendance à Google. Une alternative crédible aux MDM propriétaires pour maîtriser vos terminaux de bout en bout.</p>
        <a href="/fr/etudes-de-cas/flotte-mobile" class="flag-link">Voir l'étude de cas flotte mobile →</a>
      </div>
      <div class="flag grav">
        <span class="flag-tag">stack: grav cms</span>
        <h3>Sites web reproductibles avec Grav CMS</h3>
        <p>Un socle technique découpé en trois dépôts — image applicative, rôle de déploiement, instance de site — pour déployer un nouveau site Grav sans repartir de zéro, avec rollback en une seule commande.</p>
        <a href="/fr/etudes-de-cas/grav" class="flag-link">Voir l'étude de cas Grav CMS →</a>
      </div>
      <div class="flag-note">// Matrix et flotte mobile se combinent naturellement : une organisation qui adopte Matrix pour sa communication adopte souvent, dans la foulée, une flotte de terminaux souverains pour la porter partout.</div>
    </div>
  </div>
</section>

<section id="souverainete">
  <div class="wrap">
    <div class="section-head">
      <span class="num">// principe d'architecture</span>
      <h2>La souveraineté numérique comme principe d'architecture</h2>
      <p>La souveraineté numérique ne signifie pas simplement remplacer un logiciel propriétaire par un logiciel open source. Une organisation n'est réellement maîtresse de son infrastructure que si elle peut comprendre comment elle fonctionne, savoir où résident ses données, la sauvegarder, la reconstruire et la faire évoluer sans dépendre d'un fournisseur unique.</p>
    </div>

    <div class="enjeux">
      <div class="enjeu">
        <span class="k">01 · maîtrise</span>
        <p>Les données et les composants critiques restent sous le contrôle de l'organisation.</p>
      </div>
      <div class="enjeu">
        <span class="k">02 · réversibilité</span>
        <p>Une infrastructure doit pouvoir être reconstruite, migrée ou remplacée sans dépendance artificielle à un prestataire.</p>
      </div>
      <div class="enjeu">
        <span class="k">03 · reproductibilité</span>
        <p>Une configuration importante ne devrait pas dépendre de manipulations manuelles impossibles à reproduire.</p>
      </div>
      <div class="enjeu">
        <span class="k">04 · maintenabilité</span>
        <p>L'infrastructure doit pouvoir continuer à être exploitée par une autre personne que celle qui l'a construite.</p>
      </div>
    </div>

    <div class="result-banner" style="margin-top:32px;">
      <p>« L'open source est un moyen. La maîtrise du système est l'objectif. »</p>
    </div>
  </div>
</section>

<section>
  <div class="wrap">
    <div class="section-head">
      <h2>Autres réalisations</h2>
      <p>La même rigueur, appliquée à d'autres types de projets.</p>
    </div>
    <div class="others">
      <a href="/fr/realisations/facturation" class="other-card"><span class="name">Application de facturation électronique</span><span class="arrow">→</span></a>
    </div>
  </div>
</section>

<section id="notes-techniques">
  <div class="wrap">
    <div class="section-head">
      <h2>Notes techniques</h2>
    </div>
    <!-- notes-techniques:latest-articles -->
  </div>
</section>

<section id="methode">
  <div class="wrap">
    <div class="section-head">
      <h2>Comment je travaille</h2>
    </div>
    <div class="method">
      <div class="method-item">
        <span class="key">principe.01</span>
        <h4>Comprendre avant d'automatiser</h4>
        <p>J'identifie les composants, leurs responsabilités, leurs dépendances et leurs cycles de vie. L'automatisation vient ensuite — jamais avant.</p>
      </div>
      <div class="method-item">
        <span class="key">principe.02</span>
        <h4>Rien n'est fait deux fois de la même manière</h4>
        <p>Chaque déploiement est automatisé et rejouable à l'identique — sur un nouveau serveur, en cas de panne, ou pour dupliquer une installation.</p>
      </div>
      <div class="method-item">
        <span class="key">principe.03</span>
        <h4>Séparer code, configuration, secrets et données</h4>
        <p>Ces éléments n'ont ni la même fonction, ni le même cycle de vie, ni les mêmes exigences de sécurité. Aucun secret ne traîne en clair.</p>
      </div>
      <div class="method-item">
        <span class="key">principe.04</span>
        <h4>Concevoir pour l'exploitation</h4>
        <p>Un système ne s'arrête pas au premier <code>docker compose up</code>. Mises à jour, rollback, sauvegardes, supervision et diagnostic sont pensés dès la conception.</p>
      </div>
    </div>
    <div class="flag-note">// Documenter pour transmettre : une infrastructure que seule son auteur comprend constitue une dépendance. La documentation fait partie du produit technique livré.</div>
  </div>
</section>

<section>
  <div class="wrap proof">
    <p><strong style="color:var(--paper)">Voir le travail, pas juste en entendre parler.</strong><br>Tout ce que je livre est documenté et, quand c'est possible, publié en open source.</p>
    <a href="https://github.com/sepp67" target="_blank" rel="noopener" class="btn btn-ghost">Voir mes projets sur GitHub →</a>
  </div>
</section>
