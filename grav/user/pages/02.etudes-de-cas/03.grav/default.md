---
title: Un socle réutilisable pour déployer et maintenir plusieurs sites Grav
template: etude-cas-grav
metadata:
  description: "Plutôt que d'automatiser l'installation d'un site unique, une architecture séparant runtime, applications, données persistantes et mécanisme de déploiement — pensée pour maîtriser le cycle de vie de plusieurs sites Grav sans dupliquer leur exploitation."
---

<header class="case-header">
  <div class="wrap">
    <span class="flag-tag">étude de cas — stack: grav cms</span>
    <h1>Un socle réutilisable pour déployer et maintenir plusieurs sites Grav</h1>
    <p class="case-sub">Plutôt que d'automatiser l'installation d'un site unique, une architecture séparant runtime, applications, données persistantes et mécanisme de déploiement — pensée pour maîtriser le cycle de vie de plusieurs sites Grav sans dupliquer leur exploitation.</p>

    <div class="meta-row">
      <div class="meta-item"><span class="k">Type de projet</span><span class="v">Socle de déploiement réutilisable</span></div>
      <div class="meta-item"><span class="k">Point de départ</span><span class="v">Documentation interne sous Grav</span></div>
      <div class="meta-item"><span class="k">Contrainte initiale</span><span class="v">Préserver le contenu lors des redéploiements</span></div>
      <div class="meta-item"><span class="k">Stack</span><span class="v">Linux · Ansible · Docker · Grav · Git</span></div>
    </div>
  </div>
</header>

<section>
  <div class="wrap">
    <div class="section-head">
      <span class="num">// contexte</span>
      <h2>Le problème a commencé par la persistance</h2>
    </div>
    <div class="prose">
      <p>Le premier besoin était relativement simple : automatiser le déploiement d'un site Grav utilisé comme documentation interne.</p>
      <p>Mais ce site devait continuer à évoluer après son déploiement. Des pages seraient modifiées depuis l'interface d'administration, des images ajoutées, des comptes créés.</p>
      <p>Un redéploiement de l'application ne devait donc jamais remettre le site dans son état initial et détruire les données produites en exploitation.</p>
      <p>Une première frontière est apparue :</p>
      <blockquote><strong>L'application doit pouvoir être remplacée. Les données utilisateur doivent survivre.</strong></blockquote>
      <p>Le contenu persistant a donc été séparé du cycle de vie du conteneur.</p>
      <p>Puis d'autres projets ont eu besoin de sites Grav. La question n'était alors plus : <em>Comment déployer ce site ?</em> mais :</p>
      <blockquote><strong>Comment disposer d'un mécanisme permettant de déployer et maintenir plusieurs sites Grav sans dupliquer la logique d'exploitation ?</strong></blockquote>
      <p>C'est à ce moment qu'un problème de déploiement est devenu un problème d'architecture.</p>
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
      <div class="enjeu"><span class="k">Persistance</span><p>Le contenu créé en exploitation doit survivre au remplacement d'un conteneur, à un redéploiement et à un changement de version.</p></div>
      <div class="enjeu"><span class="k">Réutilisabilité</span><p>La mécanique commune ne doit pas être copiée et adaptée pour chaque nouveau projet.</p></div>
      <div class="enjeu"><span class="k">Maintenabilité</span><p>Runtime, application, données et déploiement n'évoluent ni au même rythme ni pour les mêmes raisons. Leur séparation doit refléter ces cycles de vie.</p></div>
      <div class="enjeu"><span class="k">Réversibilité</span><p>Revenir à une version précédente doit utiliser autant que possible le même mécanisme qu'un déploiement normal.</p></div>
      <div class="enjeu"><span class="k">Sécurité</span><p>Les secrets et configurations sensibles restent hors des images applicatives et du code versionné.</p></div>
    </div>
  </div>
</section>

<section>
  <div class="wrap">
    <div class="section-head">
      <span class="num">// architecture</span>
      <h2>Des cycles de vie différents, des responsabilités séparées</h2>
    </div>
    <div class="prose">
      <p>L'analyse du premier déploiement puis l'arrivée de nouveaux projets ont fait apparaître quatre domaines distincts : <strong>runtime</strong>, <strong>application / site</strong>, <strong>données persistantes</strong> et <strong>mécanisme de déploiement</strong>. Les regrouper simplement parce qu'ils participent au même site aurait créé un couplage inutile. L'architecture cherche donc à rendre ces frontières explicites.</p>
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
          <text x="500" y="311" text-anchor="middle">instances Grav</text>

          <rect x="400" y="380" width="200" height="32" rx="2" fill="none" stroke="var(--muted)" stroke-dasharray="3 3"/>
          <text x="500" y="401" text-anchor="middle" fill="var(--muted)">données persistantes</text>
        </g>
      </svg>
      <div class="diagram-caption">// grav-runtime (base commune) → applications indépendantes → ansible-role-grav-site (déploiement mutualisé) → instances → données découplées du conteneur</div>
    </div>

    <div class="choice-list">
      <div class="choice">
        <span class="label">Un runtime commun</span>
        <p><code>grav-runtime</code> fournit la fondation technique commune : Grav, PHP, Nginx et le contrat attendu par les applications. Il ne connaît aucun projet métier particulier.</p>
      </div>
      <div class="choice">
        <span class="label">Des applications indépendantes</span>
        <p><code>projet-gites</code>, <code>projet-lavallee-website</code> et les futurs sites ajoutent uniquement ce qui leur est propre : thème, plugins, configuration applicative et contenu initial. Chaque application reste versionnée indépendamment.</p>
      </div>
      <div class="choice">
        <span class="label">Un mécanisme de déploiement mutualisé</span>
        <p><code>ansible-role-grav-site</code> centralise la mécanique commune : préparation de l'instance, volumes persistants, configuration, secrets, démarrage, contrôles de santé, mise à jour et rollback. Le rôle reste orienté vers une instance par invocation.</p>
      </div>
      <div class="choice">
        <span class="label">Des données hors du cycle de vie du conteneur</span>
        <p>Pages, images, comptes et autres données persistantes vivent indépendamment de l'image applicative. Une nouvelle version peut donc remplacer l'application sans réinitialiser automatiquement son état de production.</p>
      </div>
    </div>
  </div>
</section>

<section>
  <div class="wrap">
    <div class="section-head">
      <span class="num">// mise en œuvre</span>
      <h2>De l'installation au cycle de vie</h2>
    </div>
    <div class="steps">
      <div class="step"><span class="step-num">01</span><div><h4>Premier besoin : rendre les données persistantes</h4><p>Le premier déploiement a permis de formaliser une règle fondamentale : les éléments reconstruisibles appartiennent à l'application ; les données produites en exploitation doivent vivre en dehors du conteneur.</p></div></div>
      <div class="step"><span class="step-num">02</span><div><h4>Extraction d'un runtime commun</h4><p>Grav, PHP, Nginx et les dépendances communes ont été isolés dans <code>grav-runtime</code>. Les projets applicatifs n'ont ainsi plus à reconstruire cette couche technique.</p></div></div>
      <div class="step"><span class="step-num">03</span><div><h4>Centralisation du déploiement</h4><p>La mécanique d'exploitation a été regroupée dans <code>ansible-role-grav-site</code> : volumes, secrets, configuration, healthchecks, version déployée, update et rollback.</p></div></div>
      <div class="step"><span class="step-num">04</span><div><h4>Passage à plusieurs applications</h4><p><code>projet-gites</code>, puis <code>lavallee.tech</code>, ont permis de confronter le modèle à plusieurs applications réelles. Le deuxième site a notamment exposé les hypothèses encore liées au premier projet — noms, chemins ou propriétés d'instance — et déclenché leur généralisation.</p></div></div>
    </div>
  </div>
</section>

<section>
  <div class="wrap">
    <div class="section-head">
      <span class="num">// cycle de vie</span>
      <h2>Installer n'est que la première opération</h2>
    </div>
    <div class="prose">
      <p>Une application n'est installée qu'une fois. Elle doit ensuite pouvoir être exploitée pendant des années. Le modèle recherché n'est donc plus :</p>
      <pre><code>install</code></pre>
      <p>mais :</p>
      <pre><code>deploy → update → rollback → migrate</code></pre>
      <p>Cette différence structure l'architecture. Le runtime est versionné. Chaque application est versionnée. Les données persistent indépendamment. Le mécanisme de déploiement applique l'état souhaité.</p>
    </div>
  </div>
</section>

<section>
  <div class="wrap">
    <div class="section-head">
      <span class="num">// rollback</span>
      <h2>Le rollback reste un déploiement</h2>
    </div>
    <div class="prose">
      <p>Le rollback n'est pas conçu comme une procédure d'urgence indépendante. Si une nouvelle version pose problème, une version précédente connue comme stable redevient simplement la version souhaitée.</p>
      <pre><code>version 1.3.2
      │
      ▼
 deploy 1.4.0
      │
   problème
      │
      ▼
 target = 1.3.2
      │
      ▼
même mécanisme de déploiement</code></pre>
      <p>Cela limite les procédures spéciales précisément au moment où elles seraient les plus risquées : pendant un incident.</p>
    </div>
  </div>
</section>

<section>
  <div class="wrap">
    <div class="section-head">
      <span class="num">// résultat</span>
      <h2>Ce que cette architecture change</h2>
    </div>
    <div class="result-banner">
      <p>La logique de déploiement est centralisée au lieu d'être recopiée dans chaque projet. Chaque site conserve son propre contenu, sa configuration et son cycle de versionnement — et le remplacement d'une application n'implique jamais le remplacement de son état persistant.</p>
      <div class="result-stats">
        <div class="stat"><span class="num-big">1</span><span class="lbl">runtime commun, construit et maintenu indépendamment des sites</span></div>
        <div class="stat"><span class="num-big">1</span><span class="lbl">mécanisme de déploiement, au lieu d'être recopié par projet</span></div>
        <div class="stat"><span class="num-big">2</span><span class="lbl">applications indépendantes déployées sur le même socle</span></div>
      </div>
    </div>
    <div class="prose" style="margin-top:24px;">
      <p><strong>Le premier site a résolu un besoin. Le deuxième a commencé à tester l'architecture.</strong> Les suivants doivent pouvoir réutiliser le même socle sans multiplier la logique d'exploitation.</p>
    </div>
  </div>
</section>

<section>
  <div class="wrap">
    <div class="section-head">
      <span class="num">// preuve</span>
      <h2>Le deuxième site est le véritable test</h2>
    </div>
    <div class="prose">
      <p>Il est facile de qualifier une architecture de « réutilisable » lorsqu'elle ne sert encore qu'un seul projet. Le deuxième consommateur révèle les hypothèses qui étaient en réalité spécifiques au premier.</p>
      <p><code>lavallee.tech</code> est désormais lui-même déployé sur cette architecture. Son arrivée a permis d'identifier les derniers paramètres d'instance qui doivent être généralisés pour que le rôle de déploiement reste un composant atomique et réutilisable.</p>
      <p>La prochaine étape consiste à utiliser ce même mécanisme pour un nouveau site de documentation technique. La réutilisabilité n'est donc pas considérée comme une propriété déclarative.</p>
      <blockquote><strong>Elle doit être vérifiée par de nouveaux consommateurs.</strong></blockquote>
    </div>

    <div class="roadmap-box" style="margin-top:28px;">
      <span class="icon">→</span>
      <div>
        <h4>Nouveau site de documentation technique <span class="status-pill">en préparation</span></h4>
        <p>Le même socle — grav-runtime + ansible-role-grav-site — sera réutilisé sans modification pour ce nouveau consommateur, seule véritable preuve qu'une architecture est réutilisable.</p>
      </div>
    </div>
  </div>
</section>

<section>
  <div class="wrap">
    <div class="section-head">
      <span class="num">// souveraineté</span>
      <h2>Pourquoi cette architecture participe aussi à la maîtrise du système</h2>
    </div>
    <div class="prose">
      <p>L'utilisation de logiciels open source n'est qu'une partie du problème. Une infrastructure reste difficile à maîtriser si son déploiement dépend de manipulations manuelles, si ses données sont mélangées à l'application ou si personne ne sait précisément quelle version est en production.</p>
      <p>Cette architecture cherche donc à rendre explicites :</p>
      <ul>
        <li>les composants utilisés ;</li>
        <li>les versions déployées ;</li>
        <li>les données à préserver ;</li>
        <li>les responsabilités de chaque couche ;</li>
        <li>le mécanisme permettant de reconstruire une instance.</li>
      </ul>
      <blockquote><strong>L'open source est un moyen. La maîtrise du système est l'objectif.</strong></blockquote>
    </div>
  </div>
</section>

<section>
  <div class="wrap">
    <div class="section-head">
      <span class="num">// limites</span>
      <h2>Ce que le socle ne cherche pas à faire</h2>
    </div>
    <div class="limites-list">
      <div class="limite"><span class="marker">—</span><p>La création de contenu et le design éditorial restent propres à chaque application.</p></div>
      <div class="limite"><span class="marker">—</span><p>Le rôle de déploiement ne gère ni DNS, ni reverse proxy, ni certificats TLS. Ces responsabilités appartiennent à l'infrastructure partagée.</p></div>
      <div class="limite"><span class="marker">—</span><p>La sauvegarde reste nécessaire. Grav évite d'exploiter un service de base de données supplémentaire, mais les fichiers persistants constituent des données de production et doivent être sauvegardés.</p></div>
      <div class="limite"><span class="marker">—</span><p>Le rôle de déploiement gère une instance par invocation. L'orchestration de plusieurs sites est volontairement traitée au niveau supérieur.</p></div>
      <div class="limite"><span class="marker">—</span><p>Les applications nécessitant des fonctionnalités métier complexes, un trafic important ou des modèles de données avancés peuvent sortir du périmètre naturel d'un CMS flat-file comme Grav.</p></div>
    </div>
  </div>
</section>

<section>
  <div class="wrap">
    <div class="section-head">
      <span class="num">// composants</span>
      <h2>Le socle et ses applications</h2>
    </div>
    <div class="repo-grid">
      <div class="repo-row">
        <div>
          <div class="repo-name">grav-runtime</div>
          <div class="repo-desc"><strong style="color:var(--paper)">Runtime partagé.</strong> Image de base versionnée fournissant Grav, PHP, Nginx et le contrat runtime commun.</div>
        </div>
        <a href="https://github.com/sepp67/grav-runtime" target="_blank" rel="noopener" class="btn">Voir sur GitHub →</a>
      </div>
      <div class="repo-row">
        <div>
          <div class="repo-name">ansible-role-grav-site</div>
          <div class="repo-desc"><strong style="color:var(--paper)">Mécanisme de déploiement.</strong> Rôle Ansible responsable du cycle de vie d'une instance Grav compatible.</div>
        </div>
        <a href="https://github.com/sepp67/ansible-role-grav-site" target="_blank" rel="noopener" class="btn">Voir sur GitHub →</a>
      </div>
      <div class="repo-row">
        <div>
          <div class="repo-name">projet-gites</div>
          <div class="repo-desc"><strong style="color:var(--paper)">Application.</strong> Premier site métier utilisant le socle partagé.</div>
        </div>
        <a href="https://github.com/sepp67/projet-gites" target="_blank" rel="noopener" class="btn">Voir sur GitHub →</a>
      </div>
      <div class="repo-row">
        <div>
          <div class="repo-name">projet-lavallee-website</div>
          <div class="repo-desc"><strong style="color:var(--paper)">Application.</strong> Deuxième site réel utilisant la même architecture — celui que vous consultez actuellement.</div>
        </div>
        <a href="https://github.com/sepp67/projet-lavallee-website" target="_blank" rel="noopener" class="btn">Voir sur GitHub →</a>
      </div>
    </div>
  </div>
</section>

<section>
  <div class="wrap">
    <div class="section-head">
      <span class="num">// aller plus loin</span>
      <h2>Pourquoi cette architecture ?</h2>
    </div>
    <div class="prose">
      <p>Cette séparation n'est pas née d'un design théorique. Elle résulte de l'évolution d'un besoin concret : préserver les données d'un premier site, puis comprendre comment maintenir plusieurs applications sans dupliquer leur infrastructure.</p>
    </div>
    <a href="/fr/articles/grav-plateforme-de-deploiement-reutilisable" class="flag-link" style="color:var(--moss);">Lire l'article : Du déploiement d'un site web à la conception d'une plateforme de déploiement réutilisable →</a>
  </div>
</section>

<section class="final-cta">
  <div class="wrap">
    <h2>Un service Linux à rendre reproductible et maintenable ?</h2>
    <p>Un déploiement automatisé n'est qu'une partie du problème. La vraie question est de savoir comment le système sera mis à jour, diagnostiqué, sauvegardé, restauré et transmis dans la durée.</p>
    <a href="/fr/#contact" class="btn btn-primary">Parlons d'abord de vos contraintes →</a>
  </div>
</section>
