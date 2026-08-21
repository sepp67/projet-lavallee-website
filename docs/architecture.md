# Architecture

Ce document donne la vue d'ensemble des couches qui composent (à terme) le
déploiement du site de Sébastien Lavallée, sur le même modèle que
`3-projet-gites` (voir `docs/architecture.md` de ce dépôt pour la version de
référence, plus détaillée).

## Les trois couches

```text
grav-runtime (ghcr.io/sepp67/grav-runtime)
    │  socle technique générique — même image pour n'importe quel site Grav
    │
    └── projet-lavallee (ce dépôt, ghcr.io/sepp67/projet-lavallee à terme)
            │  code et contenu propres au site : thème lavallee-theme, pages,
            │  configuration versionnée
            │
            └── ansible-role-grav-site
                    déploiement — génère le Compose de production, gère les
                    volumes, les secrets, le healthcheck, la version déployée
                    (pas encore branché sur ce dépôt à ce stade)
```

| Couche | Possède | Ne possède jamais |
|---|---|---|
| `grav-runtime` | PHP-FPM, Nginx, Grav Core + Admin, entrypoint, healthcheck, bootstrap admin, mécanisme de seed | Rien de propre à un site |
| `projet-lavallee` (ce dépôt) | Thème `lavallee-theme` (autonome, n'hérite pas de quark2), pages, configuration versionnée du site | PHP, Nginx, Grav Core, l'entrypoint, le healthcheck, la logique de déploiement, tout secret réel |
| `ansible-role-grav-site` | Compose de production, répertoires persistants sur l'hôte, montage des secrets, attente du healthcheck | Toute connaissance du contenu métier |

## Différence notable avec `projet-gites`

`gites-theme` hérite du thème par défaut de Grav (`quark2`, fourni par
`grav-runtime`) via chaînage de flux, et ne redéfinit que quelques templates.
`lavallee-theme` est au contraire **entièrement autonome** : la maquette
d'origine (`exemple/*.html`) est un design "terminal" fait sur mesure, sans
rapport avec la mise en page par défaut de Grav — chaîner vers `quark2`
n'aurait donc apporté aucune réutilisation utile. Tout le rendu (head, statusbar,
sections, footer) vit dans `lavallee-theme/templates/partials/base.html.twig`
et `lavallee-theme/css/custom.css`.

## Ce que ce dépôt ne fait jamais

Reprendre PHP, Nginx, Grav Core, l'entrypoint, le healthcheck natif ou le
bootstrap admin (tout cela appartient à `grav-runtime`) ; générer ou committer
un Compose de production, ou dupliquer une tâche de déploiement (tout cela
appartiendra à `ansible-role-grav-site`) ; gérer un reverse proxy, TLS, DNS ou
un pare-feu (infrastructure externe).
