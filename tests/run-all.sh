#!/bin/sh
# Exécute la suite de tests dans l'ordre, s'arrête au premier échec.
set -eu

DIR="$(cd "$(dirname "$0")" && pwd)"

for script in test-build.sh test-startup.sh test-app-presence.sh test-persistence.sh; do
  echo "=================================================================="
  echo "== $script"
  echo "=================================================================="
  sh "$DIR/$script"
done

echo "=================================================================="
echo "Tous les tests ont réussi."
echo "=================================================================="
