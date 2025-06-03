#!/bin/bash

# Ottieni la directory dello script
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Rimuove lo slash finale se presente
SCRIPT_DIR="${SCRIPT_DIR%/}"

echo ""
echo "💡 USAGE : $0 [batch_mode]"
echo ""
echo "\t batch_mode: true to disable script interactivity. Default value is false."
echo ""

BATCH_MODE=0
if [ "$1" == "true" ] || [ "$1" == "1" ]; then
    BATCH_MODE=1
fi

echo "🛠️ ⚙️ Questo script si trova in: ${SCRIPT_DIR}"

source ${SCRIPT_DIR}/stop-and-remove-container.sh ${BATCH_MODE}

source ${SCRIPT_DIR}/build-image.sh ${BATCH_MODE}

source ${SCRIPT_DIR}/run-container.sh ${BATCH_MODE}
