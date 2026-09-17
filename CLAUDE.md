# Instructions locales — projet-lavallee-website

Avant toute action, lire le fichier `../CLAUDE.md`.

Ce dépôt produit l'image applicative du site `lavallee.tech` à partir de
`grav-runtime`. Il constitue une application indépendante de `projet-gites`.

## Invariants locaux

- maintenir le thème `lavallee-theme` ;
- maintenir le plugin de contact propre au site ;
- préserver le contenu multilingue en français, anglais et allemand ;
- conserver dans l'image les pages initiales, les modèles, la logique métier et
  la configuration publique ;
- préserver la séparation entre image applicative et contenu persistant de
  production ;
- tester les comportements applicatifs et la persistance.

Toute évolution commune avec `projet-gites` doit préserver l'indépendance des
deux applications. Une fonction réellement générique doit être placée dans
`grav-runtime` ou `ansible-role-grav-site`, selon sa responsabilité.

## Avant une modification

Consulter au minimum :

- `README.md` ;
- `docs/architecture.md` ;
- `Dockerfile` ;
- `compose.dev.yml` ;
- `tests/`.

## Contrôles spécifiques

- construction de l'image applicative ;
- validation des variantes française, anglaise et allemande ;
- tests du thème et du plugin de contact ;
- tests de persistance ;
- vérification qu'aucun compte réel, secret SMTP ou donnée de production
  n'entre dans l'image.
