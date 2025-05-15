#!/bin/bash

# Alternativa solo Bash : SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
echo "Lo script si trova in: ${SCRIPT_DIR}"

cd $SCRIPT_DIR/../..
echo "📁📍 Cartella corrente: $(pwd)"

# Verifica se siamo in una directory Git
if [ ! -d ".git" ]; then
  echo "❌ Non è una directory Git valida."
  exit 1
fi

PROJECT_ROOT=$(pwd)
echo "📁 Project root path is: ${PROJECT_ROOT}"

#########################################

echo 
echo "📦 Preparazione al push del progetto Git..."
echo 
echo "🔍 Aggiunta SOLO dei file già tracciati (modificati o cancellati)."
echo 

# Aggiunge solo file già tracciati modificati o cancellati
git add -u

# Aggiungi tutti i file modificati e nuovi
# git add -A

# Verifica se ci sono modifiche da committare
if git diff --cached --quiet; then
    echo "⚠️ Nessuna modifica da pushare. Tutto aggiornato!"
    exit 0
fi

# Messaggio di commit di default
DEFAULT_MSG="Aggiornamento del $(date +'%Y-%m-%d %H:%M')"

# Chiedi all’utente un messaggio di commit
read -p "✏️  Inserisci un messaggio di commit [${DEFAULT_MSG}]: " COMMIT_MSG

# Usa messaggio di default se l’utente non scrive nulla
COMMIT_MSG="${COMMIT_MSG:-$DEFAULT_MSG}"

# Esegui il commit
git commit -m "$COMMIT_MSG"

# Esegui il push
git push

# Verifica se il push è riuscito
if [ $? -eq 0 ]; then
  echo "✅ Modifiche inviate con successo."
else
  echo "❌ Errore durante il push."
  exit 1
fi