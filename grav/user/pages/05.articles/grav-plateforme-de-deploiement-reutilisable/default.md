---
title: "Du déploiement d'un site web à la conception d'une plateforme de déploiement réutilisable."
subtitle: "Ce qu'un simple déploiement de Grav CMS m'a appris sur la persistance, les cycles de vie et la conception d'architectures maintenables."
published_label: 23 août 2026
template: article
date: '23-08-2026 12:00'
---

Beaucoup d'architectures techniques ne naissent pas sur un tableau blanc.

Elles commencent par un problème concret.

Dans mon cas, le besoin initial était relativement simple : déployer automatiquement sur une machine virtuelle un site Grav CMS servant de documentation interne.

Docker pour l'environnement d'exécution, Ansible pour le déploiement — à première vue, rien de particulièrement complexe.

La véritable question d'architecture est apparue un peu plus tard :

> **Comment redéployer l'application à tout moment sans mettre en danger les données produites par les utilisateurs ?**

À partir de cette contrainte initialement simple s'est progressivement construite une architecture de déploiement réutilisable.

---

## Le premier problème : l'application est remplaçable, ses données ne le sont pas

Grav est un CMS *flat-file*. Les contenus ne sont donc pas principalement stockés dans une base de données traditionnelle, mais sous forme de fichiers.

Cela rend Grav particulièrement intéressant pour de petits sites web ou des systèmes de documentation : la stack technique reste légère et aucune base de données supplémentaire ne doit être exploitée et maintenue.

Mais cette simplicité fait apparaître une frontière importante pour le déploiement.

L'application peut être reconstruite à tout moment à partir d'un artefact défini.

Les contenus, eux, évoluent pendant l'exploitation.

Un utilisateur modifie une page.

Un administrateur ajoute une image.

Des comptes sont créés.

Des configurations évoluent.

Dès la première utilisation en production, le système possède donc un état qui ne peut plus nécessairement être reconstruit à partir du repository Git.

La première décision d'architecture a donc été :

> **Un déploiement peut remplacer l'application, mais il ne doit jamais remplacer ses données persistantes.**

Les données concernées ont donc été séparées du cycle de vie du conteneur.

Un conteneur peut être supprimé et recréé. Les contenus restent en place.

Le problème initial était résolu.

Mais seulement pour un site.

---

## Puis est arrivé le deuxième site

De nouveaux projets ont ensuite fait apparaître d'autres besoins en sites Grav.

À ce stade, j'aurais pu simplement copier l'architecture existante.

Un nouveau fichier Docker Compose.

Un code Ansible adapté.

Quelques nouvelles variables.

Et le déploiement aurait fonctionné.

Avec deux projets, cela aurait probablement même été la solution la plus rapide.

Mais chaque nouveau projet aurait alors obtenu sa propre variante de la même logique de déploiement.

À la prochaine mise à jour de Grav, de nouvelles questions seraient apparues :

Quels projets doivent être adaptés ?

Quelle version utilise quel environnement PHP ?

Où la logique de déploiement a-t-elle déjà été mise à jour ?

Quelle variante prend en charge le rollback ?

Le petit gain de temps obtenu sur le deuxième projet se serait progressivement transformé en coût de maintenance.

La question a donc changé.

Il ne s'agissait plus de demander :

> *Comment déployer ce site Grav ?*

Mais :

> **Comment construire un mécanisme permettant de déployer et de maintenir de la même manière différents sites Grav ?**

C'est à ce moment qu'une problématique de déploiement est devenue une problématique d'architecture.

---

## Ce n'est pas le code qui définit les frontières, mais le cycle de vie

L'analyse a montré que ce qui semblait être un seul système était en réalité composé de plusieurs éléments ayant des cycles de vie différents :

```text
Runtime
    ≠
Site / application
    ≠
Données utilisateurs
    ≠
Mécanisme de déploiement
```

Le **runtime** évolue par exemple lorsqu'une version de Grav, de PHP ou d'une dépendance système est mise à jour.

Le **site** évolue lorsque des templates, des plugins ou des fonctionnalités spécifiques au projet sont développés.

Les **données utilisateurs** évoluent indépendamment de ces deux éléments pendant l'exploitation.

Et le **mécanisme de déploiement** évolue pour d'autres raisons encore — par exemple lorsque les health checks, la gestion des secrets ou les procédures de rollback sont améliorés.

Gérer tous ces éléments dans un seul projet uniquement parce qu'ils participent ensemble au fonctionnement d'un site aurait artificiellement couplé des cycles de vie différents.

C'est précisément ce couplage que je voulais éviter.

---

## Trois repositories, trois responsabilités

Cette réflexion a conduit à une architecture composée de trois éléments techniques clairement séparés.

### `grav-runtime` — l'environnement d'exécution commun

Le runtime fournit la base technique :

* Grav ;
* PHP ;
* les composants système nécessaires ;
* la configuration commune de l'environnement d'exécution.

Il ne sait rien des gîtes, d'un site de documentation ou de tout autre contenu métier.

Sa responsabilité est exclusivement :

> **Fournir un environnement d'exécution Grav reproductible.**

---

### Le repository du site — le projet concret

Un repository comme `projet-gites` contient au contraire ce qui caractérise un site particulier :

* la configuration propre au projet ;
* les templates ;
* les plugins ;
* le design ;
* les contenus initiaux.

Le projet n'a pas à déterminer lui-même comment préparer un serveur ou réaliser son déploiement.

Il décrit le site.

Pas la plateforme de déploiement.

---

### `ansible-role-grav-site` — le mécanisme de déploiement

Le troisième composant automatise le déploiement.

Le rôle Ansible se charge notamment de préparer l'environnement nécessaire, de mettre à disposition les répertoires persistants, d'intégrer la configuration et les secrets, de démarrer la version souhaitée de l'image puis de vérifier l'état de l'application.

Un principe est essentiel :

> **Le rôle ne doit pas avoir besoin de savoir quel site il déploie.**

Il reçoit une application versionnée ainsi que la configuration nécessaire.

La logique de déploiement reste ainsi indépendante du projet concret.

---

## Les données persistantes constituent une quatrième frontière

Les trois repositories Git ne représentent cependant qu'une partie de l'architecture.

À côté d'eux existe un quatrième domaine :

**l'état persistant de l'instance en fonctionnement.**

```text
                 grav-runtime
                      │
                      ▼
               Artefact du site
                      │
                      ▼
            ansible-role-grav-site
                      │
                      ▼
                Instance Grav
                      │
             ┌────────┴────────┐
             ▼                 ▼
        Application       Données persistantes
        remplaçable       à préserver
```

Cette distinction entraîne une conséquence importante.

Git, l'image du conteneur et le code de déploiement peuvent être reproduits.

Les données utilisateurs en production doivent au contraire être conservées, sauvegardées et, lors de certains changements de version, éventuellement migrées.

Le terme « déploiement » prend alors une signification plus précise.

---

## L'installation n'est que le début

Dans un projet serveur unique, beaucoup d'attention est souvent consacrée à l'installation initiale.

Sur l'ensemble du cycle de vie, c'est pourtant probablement l'opération la moins intéressante.

Un site est installé une fois.

Il peut ensuite fonctionner pendant plusieurs années.

Les questions réellement importantes deviennent donc :

**Comment est-il mis à jour ?**

**Comment revenir en arrière si une version pose problème ?**

**Comment protéger les données persistantes ?**

**Comment migrer vers une nouvelle version du runtime ?**

On passe donc de :

> **install**

à :

> **deploy → update → rollback → migrate**

La perspective change.

L'objectif n'est plus simplement de réussir à installer un logiciel sur un serveur.

L'objectif devient de **rendre contrôlable l'ensemble de son cycle de vie technique**.

---

## Le rollback n'est pas une procédure d'urgence

Le rollback en est un bon exemple.

On pourrait développer un script de restauration spécifique et espérer qu'il fonctionne le jour où il devient nécessaire.

J'ai préféré une autre approche.

Un rollback doit autant que possible être la même opération qu'un déploiement normal — mais avec une autre version.

Si, par exemple, la version `1.4.0` pose problème, la version précédemment connue comme stable, `1.3.2`, redevient simplement l'état souhaité.

Le mécanisme de déploiement reste le même.

Cela réduit la logique spécifique exactement là où elle est la moins souhaitable : pendant un incident.

---

## La deuxième instance est le véritable test de l'architecture

Il est facile de qualifier une architecture de « réutilisable » tant qu'un seul projet l'utilise.

Les choses deviennent intéressantes avec le deuxième.

C'est à ce moment que l'on découvre quelles hypothèses étaient réellement génériques et lesquelles dépendaient inconsciemment du premier projet.

Quels noms étaient codés en dur ?

Quels répertoires étaient spécifiques au projet ?

Quels ports étaient considérés comme acquis ?

Quelle configuration appartient à la plateforme et laquelle appartient à l'application ?

La deuxième instance n'est donc pas simplement un nouvel utilisateur de la plateforme.

Elle constitue un test d'architecture.

Chaque hypothèse spécifique au premier projet qui apparaît à ce moment permet de définir plus précisément la frontière entre plateforme et application.

---

## Ce que je retiens de ce projet

Techniquement, cette solution repose sur des outils bien connus.

Grav.

Docker.

Ansible.

Git.

Aucun d'entre eux n'est particulièrement exceptionnel pris isolément.

Pour moi, la partie intéressante ne réside donc pas dans le choix des outils.

Elle réside dans la définition de leurs responsabilités.

À partir d'un problème concret — assurer le fonctionnement persistant d'un site de documentation interne — est d'abord né un déploiement automatisé.

L'arrivée de nouveaux projets a ensuite montré que le déploiement lui-même n'était pas le véritable problème.

Le véritable problème était **la maintenabilité sur plusieurs projets et sur plusieurs années**.

La principale leçon que j'en retiens est la suivante :

> **Les frontières d'une architecture ne devraient pas être définies uniquement en fonction de ce que font les composants, mais également en fonction de la manière et des raisons pour lesquelles ils évoluent.**

Si le runtime, l'application, les données utilisateurs et le mécanisme de déploiement suivent des cycles de vie différents, ces frontières doivent également être visibles dans l'architecture.

Le résultat n'est pas une plateforme spectaculairement complexe.

Au contraire.

L'objectif est de construire une plateforme grâce à laquelle le projet suivant devient plus simple que le premier — et où le dixième projet ne nécessite pas dix fois plus de logique de déploiement.

C'est précisément là que réside, à mes yeux, la valeur d'une architecture réutilisable.
