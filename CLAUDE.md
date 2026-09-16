# Instructions locales — projet-lavallee

Lire d’abord le fichier `../CLAUDE.md`.

Ce dépôt produit l’image applicative du site lavallee.tech.

Il hérite de `grav-runtime` et constitue une application distincte de `projet-gites`.

Conserver dans ce dépôt :

- thème `lavallee-theme` ;
- plugin de contact spécifique au site ;
- contenu multilingue en français, anglais et allemand ;
- pages seed ;
- configuration publique ;
- modèles et logique métier ;
- tests applicatifs et de persistance.

Ne jamais intégrer :

- comptes réels ;
- secrets SMTP ou autres secrets de production ;
- volumes et données persistantes d’une instance ;
- logique générique de `grav-runtime` ;
- logique de déploiement Ansible.

Avant toute modification, consulter :

- `README.md` ;
- `docs/architecture.md` ;
- `Dockerfile` ;
- `compose.dev.yml` ;
- les tests dans `tests/`.

Toute évolution commune avec `projet-gites` doit préserver l’indépendance des deux applications et maintenir les responsabilités partagées dans `grav-runtime` ou `ansible-role-grav-site`.
