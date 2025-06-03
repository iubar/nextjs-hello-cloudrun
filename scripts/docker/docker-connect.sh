#!/bin/bash

# Ottieni la directory dello script
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Rimuove lo slash finale se presente
SCRIPT_DIR="${SCRIPT_DIR%/}"

echo "🛠️ ⚙️ Questo script si trova in: ${SCRIPT_DIR}"

# Includi config.sh se esiste
source "${SCRIPT_DIR}/config.sh"

# Controlla se è stato passato un argomento e in tal caso effettuo l'override dall configurazione
# if [ -z "$1" ]; then
# CONTAINER_NAME=$1
# fi

docker exec -it ${CONTAINER_NAME} /bin/bash

if [ $? -ne 0 ]; then
    echo "❌ Il comando exec è fallito!"
    exit 1
fi
