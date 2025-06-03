#!/bin/bash

# Ottieni la directory dello script
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Rimuove lo slash finale se presente
SCRIPT_DIR="${SCRIPT_DIR%/}"

echo "Questo script si trova in: $SCRIPT_DIR"

# Includi il file di configurazione (dove viene definito CONTAINER_NAME)
source "$SCRIPT_DIR/config.sh"

# Se vuoi chiedere all'utente di inserire manualmente un nome o ID del container:
# read -p "Inserisci il nome o ID del container da fermare ed eliminare: " CONTAINER_NAME

BATCH_MODE=0
   if [ "$1" == "true" ]; then
   BATCH_MODE=1
fi

ERROR_COUNT=0

# Ferma il container
echo " 🐳 Fermo il container: $CONTAINER_NAME..."
docker stop "$CONTAINER_NAME"

if [ $? -ne 0 ]; then
    echo "❌ Il comando \"stop\" è fallito!"
    echo "(🤔 Forse il container è già stato fermato via cli ? )"
    (( ERROR_COUNT++ ))
else
    echo "...OK ✅"
fi

# Elimina il container
echo "🐳 Elimino il container: ${CONTAINER_NAME}..."
docker rm "${CONTAINER_NAME}"

if [ $? -ne 0 ]; then
    echo "❌ Il comando \"rm\" è fallito!"
    echo "(🤔 Forse il container è già stato eliminato via cli ?)"
    (( ERROR_COUNT++ ))
else
    echo "...OK ✅"
fi

if [ "$ERROR_COUNT" -gt 0 ]; then
    echo "⚠️ ⚠️ ⚠️ Si sono verificati errori : ${ERROR_COUNT}"
    if [ "$BATCH_MODE" == "1" ]; then
            echo "❌ Operazione annullata."
            exit 1
    else    
        read -p "Vuoi continuare lo stesso ? (s/n): " answer    
        if [[ "$answer" =~ ^[Ss]$ ]]; then    
            echo "✅ Procedo..."
        else
            echo "❌ Operazione annullata."
            exit 1
        fi  
        else
    fi
fi

# Pausa opzionale (simile a PAUSE in batch)
# read -p "Premi invio per uscire..."
