#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)"
SCRIPT_DIR="${SCRIPT_DIR%/}"

echo "📄 Directory dello script: $SCRIPT_DIR"

PROJECT_DIR="$SCRIPT_DIR/../.."

echo "📁 Vado alla directory del progetto..."
cd "$PROJECT_DIR" || { echo "❌ Directory non trovata: $PROJECT_DIR"; exit 1; }

echo "⚠️ Scarto tutte le modifiche locali..."
git reset --hard 	#  ripristina tutti i file al loro stato originale (HEAD)
git clean -fd 		#  rimuove file non tracciati e directory (-f = forza, -d = directory)

echo "🔄 Eseguo git pull..."
git pull 			# recupera e unisce gli ultimi cambiamenti dal ramo remoto

if [ $? -eq 0 ]; then
  echo "✅ Progetto aggiornato correttamente"
else
  echo "❌ Errore durante il pull"
  exit 1
fi