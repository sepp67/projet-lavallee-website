---
title: Communication souveraine avec Matrix
template: etude-cas-matrix
metadata:
  description: "Déploiement d'une infrastructure Matrix/Synapse complète — deux serveurs dédiés, ponts vers WhatsApp et Telegram — pour sortir de Slack sans perdre le contrôle de sa communication."
---

<header class="case-header">
  <div class="wrap">
    <span class="flag-tag">étude de cas — stack: matrix</span>
    <h1>Sortir de Slack sans perdre le contrôle de sa communication</h1>
    <p class="case-sub">Déploiement d'une infrastructure Matrix/Synapse complète — deux serveurs dédiés, ponts vers WhatsApp et Telegram, base de données mutualisée — pour une structure qui voulait garder ses échanges chez elle, sans sacrifier le confort d'usage.</p>

    <div class="meta-row">
      <div class="meta-item"><span class="k">Type de structure</span><span class="v">Association, 40 salariés</span></div>
      <div class="meta-item"><span class="k">Déclencheur</span><span class="v">Fin de contrat Slack</span></div>
      <div class="meta-item"><span class="k">Contrainte clé</span><span class="v">Aucune donnée hors UE</span></div>
      <div class="meta-item"><span class="k">Stack</span><span class="v">Debian · Docker · Ansible</span></div>
    </div>
  </div>
</header>

<section>
  <div class="wrap">
    <div class="section-head">
      <span class="num">// contexte</span>
      <h2>Le problème</h2>
    </div>
    <div class="prose">
      <p>La structure utilisait Slack depuis plusieurs années. À l'approche du renouvellement du contrat, la direction a voulu évaluer une alternative hébergée en Europe — sans renoncer à ce que les salariés utilisent déjà au quotidien : discussions par équipe, messages directs, et surtout les groupes WhatsApp utilisés avec des partenaires externes qui, eux, ne changeraient pas d'outil.</p>
      <p><strong>Le vrai enjeu n'était donc pas seulement de remplacer Slack</strong>, mais de le faire sans imposer une rupture aux interlocuteurs externes — ce qui a orienté le choix vers Matrix avec des ponts applicatifs plutôt qu'une simple migration.</p>
    </div>
  </div>
</section>

<section>
  <div class="wrap">
    <div class="section-head">
      <span class="num">// enjeux</span>
      <h2>Ce qu'il fallait concilier</h2>
    </div>
    <div class="enjeux">
      <div class="enjeu"><span class="k">Souveraineté</span><p>Aucune donnée hébergée hors Union européenne, hébergeur choisi et audité par la structure elle-même.</p></div>
      <div class="enjeu"><span class="k">Continuité</span><p>Les contacts externes sur WhatsApp et Telegram ne devaient rien changer à leurs habitudes.</p></div>
      <div class="enjeu"><span class="k">Sécurité</span><p>Séparation stricte entre les comptes internes et les ponts vers des services tiers.</p></div>
      <div class="enjeu"><span class="k">Évolutivité</span><p>Pouvoir ajouter un futur pont (Signal, Discord) sans remettre l'architecture à plat.</p></div>
    </div>
  </div>
</section>

<section>
  <div class="wrap">
    <div class="section-head">
      <span class="num">// architecture</span>
      <h2>Les choix qui structurent le déploiement</h2>
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
          <text x="855" y="234" text-anchor="middle" fill="var(--muted)">futur pont…</text>
        </g>
      </svg>
      <div class="diagram-caption">// 4 VM dédiées — base de données, homeserver utilisateurs, homeserver + ponts, infrastructure partagée (hors périmètre du rôle)</div>
    </div>

    <div class="choice-list">
      <div class="choice">
        <span class="label">Séparer users / bridges</span>
        <p>Le homeserver utilisé au quotidien par les salariés tourne isolé du homeserver qui porte les ponts — une panne ou une mise à jour d'un pont WhatsApp ne peut jamais affecter la messagerie interne.</p>
      </div>
      <div class="choice">
        <span class="label">Base de données mutualisée</span>
        <p>Une seule VM PostgreSQL, une base par composant, ajout d'un futur composant en une entrée de variable — sans nouvelle tâche Ansible ni redémarrage de serveur.</p>
      </div>
      <div class="choice">
        <span class="label">Proxy hors périmètre</span>
        <p>Le rôle ne gère jamais le reverse proxy, le DNS ou les certificats TLS — ces responsabilités restent dans l'infrastructure partagée de la structure, pour rester réutilisable ailleurs.</p>
      </div>
      <div class="choice">
        <span class="label">Tokens jamais régénérés</span>
        <p>Les jetons d'authentification des ponts sont générés une fois et conservés — un rejeu du déploiement ne casse jamais une connexion déjà active.</p>
      </div>
    </div>
  </div>
</section>

<section>
  <div class="wrap">
    <div class="section-head">
      <span class="num">// mise en œuvre</span>
      <h2>Ce qui a été fait</h2>
    </div>
    <div class="steps">
      <div class="step"><span class="step-num">01</span><div><h4>Provisionnement des 4 VM</h4><p>Base de données, homeserver utilisateurs, homeserver + ponts, infrastructure partagée — chacune avec un rôle unique et documenté.</p></div></div>
      <div class="step"><span class="step-num">02</span><div><h4>Déploiement Synapse en double instance</h4><p>Un homeserver pour les comptes internes, un second dédié aux ponts — jamais mélangés, jamais sur la même base applicative.</p></div></div>
      <div class="step"><span class="step-num">03</span><div><h4>Connexion des ponts WhatsApp et Telegram</h4><p>Chaque pont dans son propre conteneur, sa propre base, son propre fichier d'enregistrement — ajout du prochain pont sans toucher aux existants.</p></div></div>
      <div class="step"><span class="step-num">04</span><div><h4>Validation en conditions réelles</h4><p>Vérification que chaque bot répond, que les messages passent dans les deux sens, avant toute bascule des équipes.</p></div></div>
      <div class="step"><span class="step-num">05</span><div><h4>Bascule progressive des équipes</h4><p>Migration par service, avec Slack maintenu en lecture seule le temps que chacun prenne ses marques sur Element.</p></div></div>
    </div>
  </div>
</section>

<section>
  <div class="wrap">
    <div class="section-head">
      <span class="num">// résultat</span>
      <h2>Ce que ça change</h2>
    </div>
    <div class="result-banner">
      <p>Toutes les données de messagerie restent hébergées en Europe, sur une infrastructure dont la structure garde la clé — sans que les contacts externes sur WhatsApp ou Telegram n'aient rien remarqué du changement.</p>
      <div class="result-stats">
        <div class="stat"><span class="num-big">0</span><span class="lbl">interruption ressentie par les contacts externes</span></div>
        <div class="stat"><span class="num-big">4</span><span class="lbl">VM déployées de façon reproductible et documentée</span></div>
        <div class="stat"><span class="num-big">1</span><span class="lbl">commande pour ajouter un futur pont</span></div>
      </div>
    </div>
  </div>
</section>

<section>
  <div class="wrap">
    <div class="section-head">
      <span class="num">// limites</span>
      <h2>Ce qui reste hors périmètre</h2>
    </div>
    <div class="limites-list">
      <div class="limite"><span class="marker">—</span><p>La configuration métier de chaque pont (connexion WhatsApp par QR code, liaison Telegram) reste une étape manuelle, propre à chaque compte — non automatisable côté infrastructure.</p></div>
      <div class="limite"><span class="marker">—</span><p>Le reverse proxy, le DNS et les certificats TLS ne sont pas gérés par ce déploiement — ils appartiennent à l'infrastructure partagée existante de la structure.</p></div>
      <div class="limite"><span class="marker">—</span><p>L'authentification forte (SSO/MFA) n'est pas encore intégrée sur cette installation — un chantier possible avec un fournisseur d'identité que la structure aura elle-même validé.</p></div>
      <div class="limite"><span class="marker">—</span><p>La sauvegarde des messages est déléguée à la politique de sauvegarde déjà en place chez l'hébergeur — ce déploiement ne réinvente pas ce qui existe déjà correctement.</p></div>
    </div>
  </div>
</section>

<section>
  <div class="wrap">
    <div class="repo-box">
      <div>
        <div class="repo-name">ansible-role-matrix-stack</div>
        <div class="repo-desc">Le rôle Ansible complet, documenté et open source, utilisé pour ce déploiement.</div>
      </div>
      <a href="https://github.com/sepp67/ansible-role-matrix-stack" target="_blank" rel="noopener" class="btn">Voir le code sur GitHub →</a>
    </div>
  </div>
</section>

<section class="final-cta">
  <div class="wrap">
    <h2>Un besoin de communication souveraine similaire ?</h2>
    <p>Chaque structure a ses propres contraintes — parlons de la vôtre avant de parler de solution.</p>
    <a href="/fr/#contact" class="btn btn-primary">Me contacter →</a>
  </div>
</section>
