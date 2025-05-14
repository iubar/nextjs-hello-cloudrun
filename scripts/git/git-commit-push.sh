#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)"
SCRIPT_DIR="${SCRIPT_DIR%/}"

echo "📄 Directory dello script: $SCRIPT_DIR"

PROJECT_DIR="$SCRIPT_DIR/../.."
DEF_COMMIT_MESSAGE="Aggiornamenti automatici"

echo "📍 Directory iniziale: $(pwd)"

# Cambio cartella
cd $PROJECT_DIR || { echo "❌ Impossibile accedere a $PROJECT_DIR"; exit 1; }

echo "📂 Sei ora in: $(pwd)"

# Verifica se siamo in una directory Git
if [ ! -d ".git" ]; then
  echo "❌ Non è una directory Git valida."
  exit 1
fi

# Aggiungi tutti i file modificati e nuovi
git add -A

# Chiedi il messaggio di commit all'utente
read -p "Inserisci il messaggio di commit [default: '${DEF_COMMIT_MESSAGE}']: " commit_message

# Se l'input è vuoto, usa un messaggio predefinito
if [ -z "$commit_message" ]; then
  commit_message="${DEF_COMMIT_MESSAGE}"
fi

# Esegui il commit
git commit -m "$commit_message"

# Esegui il push
git push

# Verifica se il push è riuscito
if [ $? -eq 0 ]; then
  echo "✅ Modifiche inviate con successo."
else
  echo "❌ Errore durante il push."
  exit 1
fi
