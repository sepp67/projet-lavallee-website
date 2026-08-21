# projet-lavallee

**Image applicative Grav pour le site vitrine de Sébastien Lavallée** (consultant infrastructure open source / souveraineté numérique).

Ce dépôt contient **uniquement** la couche métier :
- thème `lavallee-theme`
- pages (accueil, études de cas, réalisations, articles, mentions légales, contact), en français, anglais et allemand
- plugin métier `contact` (formulaire de contact)
- configuration non secrète

Il s'appuie sur le socle technique [`grav-runtime`](https://github.com/sepp67/grav-runtime) et sera déployé par le rôle [`ansible-role-grav-site`](https://github.com/sepp67/ansible-role-grav-site), sur le même modèle que [`projet-gites`](https://github.com/sepp67/projet-gites).

```text
ghcr.io/sepp67/grav-runtime   (socle technique générique)
        └── projet-lavallee    (ce dépôt : thème, pages, config)
                └── ansible-role-grav-site   (déploiement, hors de ce dépôt)
```

Voir [`docs/architecture.md`](docs/architecture.md) pour le détail de cette séparation.

## État actuel

Contenu de la maquette statique (`exemple/`) porté en Grav. Le formulaire de
contact est fonctionnel (plugin `contact`, sur le modèle de celui de
`projet-gites`) : en développement, sans secret SMTP réel, l'envoi échoue
proprement (message d'erreur affiché, pas de crash) — voir
`grav/user/config/plugins/email.yaml` et `docs/architecture.md`. Site
multilingue (FR/EN/DE, toutes les langues préfixées : `/fr/`, `/en/`, `/de/`
— voir `grav/user/config/system.yaml` et `grav/user/languages/`). Les slugs
d'URL ne sont pas traduits par langue (ex. `/en/etudes-de-cas/matrix`, pas
`/en/case-studies/matrix`) — simplification délibérée pour cette itération.
Pas encore de dépôt Git initialisé, pas de publication GHCR, pas de
déploiement réel — voir la fin de ce README.

## Prérequis

- Docker et Docker Compose (v2).

## Build local

```bash
docker build -t projet-lavallee:local .
```

## Développement local

```bash
docker compose -f compose.dev.yml up -d --build

docker compose -f compose.dev.yml down -v
```
- Site : http://localhost:8080
- Admin : http://localhost:8080/admin (identifiants de test définis dans `compose.dev.yml`, jetables — voir le fichier)

`compose.dev.yml` est réservé au développement local : il n'est jamais utilisé en
production, et n'est pas une seconde implémentation du déploiement.

## Tests locaux

```bash
sh tests/run-all.sh
```

- `test-build.sh` — l'image se construit.
- `test-startup.sh` — le conteneur démarre, passe `healthy`, la page d'accueil répond en 200.
- `test-app-presence.sh` — le thème et le plugin `contact` sont actifs, le contenu initial est seedé, toutes les pages internes répondent en français **et** en anglais/allemand (formulaire de contact compris), le sélecteur de langue est cohérent, l'admin est accessible.
- `test-persistence.sh` — le contenu écrit dans les volumes survit à un redémarrage du conteneur.

## Pour aller plus loin

| Document | Contenu |
|---|---|
| [`docs/architecture.md`](docs/architecture.md) | Vue d'ensemble des trois couches (runtime / image applicative / déploiement) |

## Ce qui n'est pas encore fait

- Secret SMTP réel pour l'envoi effectif des e-mails de contact (`grav/user/config/email-private.php`, jamais commité — voir `plugins.email.mailer.smtp.*`).
- `git init` du dépôt, publication GHCR, workflows CI/CD activés (`.github/workflows/` est scaffoldé mais inerte sans dépôt Git).
- Déploiement réel via `ansible-role-grav-site`.
- Documentation complète façon `projet-gites/docs/` (compatibility-policy, seed-lifecycle, secrets-and-config, release-and-rollback…), à étoffer si ce projet en a besoin.
