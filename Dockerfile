# syntax=docker/dockerfile:1
#
# Image applicative "projet-lavallee", construite sur le runtime générique
# grav-runtime. Ne réimplémente jamais PHP, Nginx, Grav Core/Admin,
# l'entrypoint, le healthcheck ou le bootstrap admin : tout cela appartient
# exclusivement à grav-runtime.
#
# Version épinglée explicitement — jamais "latest".
FROM ghcr.io/sepp67/grav-runtime:1.0.4

# Code applicatif immuable : thème, plugin métier (contact), traductions
# (chrome multilingue) et configuration versionnée.
COPY --chown=www-data:www-data grav/user/themes/     /var/www/html/user/themes/
COPY --chown=www-data:www-data grav/user/plugins/    /var/www/html/user/plugins/
COPY --chown=www-data:www-data grav/user/languages/  /var/www/html/user/languages/
COPY --chown=www-data:www-data grav/user/config/     /var/www/html/user/config/

# Contenu initial : copié dans le volume persistant par le mécanisme de seed
# de grav-runtime (/opt/grav-seed/), uniquement si le volume est vide au
# premier démarrage — jamais écrasé ensuite.
COPY --chown=www-data:www-data grav/user/pages/ /opt/grav-seed/pages/
