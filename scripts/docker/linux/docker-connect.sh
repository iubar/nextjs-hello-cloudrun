#!/bin/bash

# Ottieni la directory dello script
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Rimuove lo slash finale se presente
SCRIPT_DIR="${SCRIPT_DIR%/}"

echo "🛠️ ⚙️ Questo script si trova in: $SCRIPT_DIR"

# Includi config.sh se esiste
source "$SCRIPT_DIR/config.sh"

# Controlla se è stato passato un nome
# if [ -z "$1" ]; then
  # echo "Usage: $0 <container_name>"
  # exit 1
# fi

docker exec -it $CONTAINER_NAME /bin/bash  
