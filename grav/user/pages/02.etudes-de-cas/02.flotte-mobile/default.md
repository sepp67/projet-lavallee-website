---
title: Flotte mobile souveraine /e/OS + Nextcloud
template: etude-cas-flotte-mobile
metadata:
  description: "Mise en place d'un process d'enrôlement pour une flotte de smartphones reconditionnés sous /e/OS, connectés à un Nextcloud self-hosted — sans compte Google ni MDM propriétaire."
---

<header class="case-header">
  <div class="wrap">
    <span class="flag-tag">étude de cas — stack: /e/os + nextcloud</span>
    <h1>Équiper une équipe itinérante sans dépendre de Google</h1>
    <p class="case-sub">Mise en place d'un process d'enrôlement pour une flotte de smartphones reconditionnés sous /e/OS, connectés à un Nextcloud self-hosted — fichiers, contacts et agenda synchronisés, sans compte Google ni abonnement MDM propriétaire.</p>

    <div class="meta-row">
      <div class="meta-item"><span class="k">Type de structure</span><span class="v">Coopérative, 15 itinérants</span></div>
      <div class="meta-item"><span class="k">Déclencheur</span><span class="v">Sortie de Google Workspace</span></div>
      <div class="meta-item"><span class="k">Contrainte clé</span><span class="v">Terminaux reconditionnés</span></div>
      <div class="meta-item"><span class="k">Stack</span><span class="v">/e/OS · Nextcloud · DAVx5</span></div>
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
      <p>Les techniciens de la coopérative se déplaçaient avec des téléphones personnels ou des terminaux Android liés à un compte Google Workspace facturé par utilisateur. À l'approche du renouvellement, la structure a voulu sortir de cette dépendance — sans repasser par un MDM propriétaire (Intune, Jamf) tout aussi coûteux et tout aussi fermé.</p>
      <p><strong>La contrainte budgétaire a orienté le choix vers le reconditionné</strong> : plutôt que d'acheter du neuf, équiper la flotte avec des téléphones reconditionnés flashés sous /e/OS — à condition que le processus d'installation et de connexion au Nextcloud existant soit fiable et reproductible, pas bricolé appareil par appareil.</p>
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
      <div class="enjeu"><span class="k">Coût</span><p>Terminaux reconditionnés plutôt que neufs, aucun abonnement MDM récurrent par appareil.</p></div>
      <div class="enjeu"><span class="k">Autonomie</span><p>Aucune dépendance à un compte Google — fichiers, contacts et agenda hébergés chez la coopérative.</p></div>
      <div class="enjeu"><span class="k">Reproductibilité</span><p>Un même processus d'enrôlement, appliqué de façon identique à chaque nouveau terminal.</p></div>
      <div class="enjeu"><span class="k">Cycle de vie</span><p>Pouvoir réattribuer ou effacer un terminal proprement lors d'un départ ou d'un remplacement.</p></div>
    </div>
  </div>
</section>

<section>
  <div class="wrap">
    <div class="section-head">
      <span class="num">// architecture</span>
      <h2>Les choix qui structurent le processus</h2>
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
          <text x="80" y="135" text-anchor="middle">stock reconditionné</text>

          <rect x="300" y="44" width="120" height="30" rx="2" fill="var(--blue-wash)" stroke="var(--blue)"/>
          <text x="360" y="63" text-anchor="middle" fill="var(--blue)">flash /e/OS</text>
          <rect x="300" y="114" width="120" height="30" rx="2" fill="var(--blue-wash)" stroke="var(--blue)"/>
          <text x="360" y="133" text-anchor="middle" fill="var(--blue)">profil d'enrôlement</text>
          <rect x="300" y="184" width="120" height="30" rx="2" fill="var(--blue-wash)" stroke="var(--blue)"/>
          <text x="360" y="203" text-anchor="middle" fill="var(--blue)">compte Nextcloud</text>

          <rect x="600" y="114" width="120" height="32" rx="2" fill="none" stroke="var(--line-strong)"/>
          <text x="660" y="135" text-anchor="middle">DAVx5 (sync)</text>

          <rect x="820" y="44" width="120" height="30" rx="2" fill="none" stroke="var(--paper)"/>
          <text x="880" y="63" text-anchor="middle" fill="var(--paper)">fichiers</text>
          <rect x="820" y="114" width="120" height="30" rx="2" fill="none" stroke="var(--paper)"/>
          <text x="880" y="133" text-anchor="middle" fill="var(--paper)">contacts</text>
          <rect x="820" y="184" width="120" height="30" rx="2" fill="none" stroke="var(--paper)"/>
          <text x="880" y="203" text-anchor="middle" fill="var(--paper)">agenda</text>
        </g>
      </svg>
      <div class="diagram-caption">// du stock reconditionné au terminal opérationnel — trois étapes reproductibles, puis synchronisation continue via DAVx5</div>
    </div>

    <div class="choice-list">
      <div class="choice">
        <span class="label">Un profil, pas une config manuelle</span>
        <p>Chaque terminal reçoit le même profil d'enrôlement (comptes, restrictions, applications de base) — pas de réglage repris à zéro à la main sur chaque appareil.</p>
      </div>
      <div class="choice">
        <span class="label">DAVx5 plutôt qu'une app propriétaire</span>
        <p>La synchronisation fichiers/contacts/agenda passe par un connecteur CardDAV/CalDAV standard — remplaçable, sans verrouillage vers un fournisseur.</p>
      </div>
      <div class="choice">
        <span class="label">Inventaire séparé de l'attribution</span>
        <p>Le suivi de qui utilise quel terminal reste indépendant du processus d'enrôlement technique — la coopérative garde la main sans dépendre de mon outillage.</p>
      </div>
      <div class="choice">
        <span class="label">Effacement pensé dès le départ</span>
        <p>La procédure de remise à zéro entre deux utilisateurs est documentée au même niveau que l'enrôlement initial — pas ajoutée après coup.</p>
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
      <div class="step"><span class="step-num">01</span><div><h4>Sélection et contrôle du stock reconditionné</h4><p>Vérification de la compatibilité /e/OS et de l'état matériel de chaque modèle avant installation.</p></div></div>
      <div class="step"><span class="step-num">02</span><div><h4>Flash /e/OS et durcissement de base</h4><p>Installation du système, suppression des services Google résiduels, configuration des mises à jour automatiques.</p></div></div>
      <div class="step"><span class="step-num">03</span><div><h4>Application du profil d'enrôlement</h4><p>Comptes, restrictions et applications de base appliqués de façon identique sur chaque terminal.</p></div></div>
      <div class="step"><span class="step-num">04</span><div><h4>Connexion au Nextcloud via DAVx5</h4><p>Synchronisation des fichiers, contacts et agenda du technicien, testée avant remise du terminal.</p></div></div>
      <div class="step"><span class="step-num">05</span><div><h4>Remise et documentation utilisateur</h4><p>Fiche courte expliquant les usages de base, avec un contact en cas de blocage la première semaine.</p></div></div>
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
      <p>La coopérative a équipé son équipe itinérante sans ouvrir le moindre compte Google, sans abonnement MDM récurrent, et avec des terminaux reconditionnés plutôt que neufs — tout en gardant fichiers, contacts et agendas hébergés chez elle.</p>
      <div class="result-stats">
        <div class="stat"><span class="num-big">0€</span><span class="lbl">abonnement MDM ou licence par terminal</span></div>
        <div class="stat"><span class="num-big">15</span><span class="lbl">terminaux reconditionnés enrôlés à l'identique</span></div>
        <div class="stat"><span class="num-big">1</span><span class="lbl">processus documenté, rejouable pour chaque renouvellement</span></div>
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
      <div class="limite"><span class="marker">—</span><p>Le contrôle qualité du matériel reconditionné (état de la batterie, de l'écran) dépend du fournisseur choisi par la structure — ce processus n'inclut pas d'expertise matérielle.</p></div>
      <div class="limite"><span class="marker">—</span><p>Certaines applications bancaires ou administratives refusent de fonctionner sans les services Google — un point à vérifier au cas par cas avant la bascule complète d'une équipe.</p></div>
      <div class="limite"><span class="marker">—</span><p>La gestion à distance façon MDM avancé (verrouillage, géolocalisation en temps réel) n'est pas couverte — ce processus reste volontairement plus simple qu'une solution MDM complète.</p></div>
      <div class="limite"><span class="marker">—</span><p>L'authentification forte sur les comptes Nextcloud n'était pas incluse dans ce déploiement initial — un chantier à part, à mener avec la même prudence que pour Matrix.</p></div>
    </div>
  </div>
</section>

<section>
  <div class="wrap">
    <div class="repo-box">
      <div>
        <div class="repo-name">Méthodologie d'enrôlement /e/OS + Nextcloud</div>
        <div class="repo-desc">Processus documenté à partir de ce déploiement — publication du dépôt de référence en préparation.</div>
      </div>
      <a href="/fr/#contact" class="btn">Demander la méthodologie →</a>
    </div>
  </div>
</section>

<section class="final-cta">
  <div class="wrap">
    <h2>Une flotte de terminaux à sortir de Google ou d'un MDM propriétaire ?</h2>
    <p>Chaque structure a ses propres usages et contraintes — parlons de la vôtre avant de parler de solution.</p>
    <a href="/fr/#contact" class="btn btn-primary">Me contacter →</a>
  </div>
</section>
