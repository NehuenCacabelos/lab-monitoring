#!/usr/bin/env bash
set -e

TARGET_URL=${1:-"http://localhost:8080"}
CONCURRENCY=${2:-50}
REQUESTS=${3:-2000}

echo "=================================================="
echo "Iniciando prueba de carga contra Nginx Upstream"
echo "Target:      $TARGET_URL"
echo "Concurrencia: $CONCURRENCY"
echo "Total reqs:  $REQUESTS"
echo "=================================================="

# Detectar herramienta instalada
if command -v hey &> /dev/null; then
    hey -n "$REQUESTS" -c "$CONCURRENCY" "$TARGET_URL"
elif command -v ab &> /dev/null; then
    ab -n "$REQUESTS" -c "$CONCURRENCY" "$TARGET_URL/"
else
    echo "[!] Ni 'hey' ni 'ab' encontrados. Ejecutando ráfaga con curl en segundo plano..."
    for i in $(seq 1 "$REQUESTS"); do
        curl -s "$TARGET_URL" > /dev/null &
        if (( i % CONCURRENCY == 0 )); then
            wait
        fi
    done
    wait
    echo "[✓] Ráfaga completada."
fi
