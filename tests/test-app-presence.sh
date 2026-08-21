#!/bin/sh
# Thème activé, contenu initial seedé, rendu réel de l'application, pages
# secondaires accessibles (pas seulement HTTP 200 sur "/").
. "$(dirname "$0")/lib.sh"

CONTAINER="projet-lavallee-test-presence"
PORT="18081"

cleanup() {
  docker rm -f "$CONTAINER" >/dev/null 2>&1 || true
}
trap cleanup EXIT

cleanup
log "démarrage d'un conteneur jetable (sans volumes) depuis $IMAGE"
docker run -d --name "$CONTAINER" -p "$PORT:80" \
  -e GRAV_ADMIN_USER=admin \
  -e GRAV_ADMIN_PASSWORD=ChangeMe123 \
  -e GRAV_ADMIN_EMAIL=admin@example.com \
  "$IMAGE" >/dev/null
wait_healthy "$CONTAINER" 30

log "thème actif déclaré (system.yaml)"
docker exec "$CONTAINER" grep -q "theme: lavallee-theme" /var/www/html/user/config/system.yaml \
  || fail "system.yaml ne déclare pas lavallee-theme comme thème actif"

log "thème lavallee-theme présent dans l'image"
docker exec "$CONTAINER" test -d /var/www/html/user/themes/lavallee-theme \
  || fail "user/themes/lavallee-theme absent"

log "plugin contact présent dans l'image"
docker exec "$CONTAINER" test -d /var/www/html/user/plugins/contact \
  || fail "user/plugins/contact absent"

log "contenu initial seedé dans le volume user/pages au premier démarrage"
docker exec "$CONTAINER" test -f /var/www/html/user/pages/01.home/default.md \
  || fail "seed non appliqué : user/pages/01.home/default.md absent"

log "rendu réel de la page d'accueil (fr)"
html="$(curl -s "http://localhost:$PORT/fr")"
echo "$html" | grep -q "souveraineté numérique" || fail "marqueur de contenu absent du rendu de la page d'accueil"

log "pages internes répondent (fr)"
for path in /etudes-de-cas/matrix /etudes-de-cas/flotte-mobile /etudes-de-cas/grav /realisations/facturation /mentions-legales /articles/mfa-keycloak-privacyidea /articles/nextcloud-role-deploiement-dedie /articles/proxmox-staging-production /contact /contact/confirmation; do
  status="$(http_status "http://localhost:$PORT/fr$path")"
  [ "$status" = "200" ] || fail "/fr$path : attendu 200, obtenu $status"
done

log "multilingue : accueil et pages internes répondent en en/de, contenu dans la bonne langue"
en_home="$(curl -s "http://localhost:$PORT/en")"
echo "$en_home" | grep -q "Digital sovereignty" || fail "marqueur de contenu anglais absent du rendu de /en"
de_home="$(curl -s "http://localhost:$PORT/de")"
echo "$de_home" | grep -q "Digitale Souveränität" || fail "marqueur de contenu allemand absent du rendu de /de"
for lang in en de; do
  for path in /etudes-de-cas/matrix /etudes-de-cas/flotte-mobile /etudes-de-cas/grav /realisations/facturation /mentions-legales /articles/mfa-keycloak-privacyidea /articles/nextcloud-role-deploiement-dedie /articles/proxmox-staging-production /contact /contact/confirmation; do
    status="$(http_status "http://localhost:$PORT/$lang$path")"
    [ "$status" = "200" ] || fail "/$lang$path : attendu 200, obtenu $status"
  done
done

log "sélecteur de langue présent et cohérent sur l'accueil"
echo "$html" | grep -q 'class="language-switch"' || fail "sélecteur de langue absent du rendu de l'accueil"
echo "$html" | grep -q 'href="/en/"' || fail "le sélecteur de langue ne pointe pas vers /en/ depuis l'accueil fr"
echo "$html" | grep -q 'href="/de/"' || fail "le sélecteur de langue ne pointe pas vers /de/ depuis l'accueil fr"

log "formulaire de contact présent sur l'accueil (fr)"
echo "$html" | grep -q 'name="data\[nom\]"' || fail "champ 'nom' du formulaire de contact absent du rendu de l'accueil"

log "asset du thème accessible (CSS)"
status="$(http_status "http://localhost:$PORT/user/themes/lavallee-theme/css/custom.css")"
[ "$status" = "200" ] || fail "custom.css : attendu 200, obtenu $status"

log "admin accessible"
status="$(http_status "http://localhost:$PORT/admin")"
[ "$status" = "200" ] || fail "/admin : attendu 200, obtenu $status"

log "présence applicative OK"
