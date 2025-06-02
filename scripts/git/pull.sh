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

echo ""
echo "🔁 Aggiornamento del repository Git..."
echo ""
echo "⚠️ Scarto tutte le modifiche locali ai file già tracciati."
echo ""
echo "📄 I nuovi file non tracciati verranno mantenuti ma ignorati."

# Scarta modifiche a file già esistenti
git reset --hard #  ripristina tutti i file al loro stato originale (HEAD)
# Pulisce solo i file *tracciati* cancellati o modificati
# Ma NON tocca file non tracciati
# git clean -dfx -e '!*' -e '!*/' --dry-run > /dev/null

if [ $? -ne 0 ]; then
    echo "❌ Errore durante il reset"
    exit 1
fi

# git clean è usato per rimuovere file non tracciati (file che non sono stati aggiunti al repository con git add). Può rimuovere sia file non tracciati che cartelle vuote.
git clean -df --dry-run
#  -d: rimuove anche le directory non tracciate
#  -f: Senza questo argomento, il comando git non farà nulla (per motivi di sicurezza)
#  ...ma non tocca i file ignorati, come quelli elencati in .gitignore

# TODO: valutare se aggiungere al comando sopra: > /dev/null

# Chiede conferma prima di procedere
echo ""
read -p "⚠️ Confermi ? (s/n): " answer
echo ""
if [[ "$answer" =~ ^[Ss]$ ]]; then
	git clean -df
    if [ $? -ne 0 ]; then
        echo "❌ Errore durante il clean"
        exit 1
    fi    
    echo "✅🔄 Ho effettuato il clean del repository !"
else
    echo "❌ Non ho effettuato il clean del repository !"
fi   

echo ""

# Pull dal remoto
# git pull --rebase
git pull
if [ $? -ne 0 ]; then
  echo "❌ Errore durante il pull"
  exit 1
fi
echo ""
echo "✅🔄 Pull completato!"

echo ""

echo "Ora rendo eseguibili tutti gli script sh del progetto..."	
echo ""
chmod +x $SCRIPT_DIR/chmod_all_sh_with_confirmation.sh
$SCRIPT_DIR/chmod_all_sh_with_confirmation.sh ${PROJECT_ROOT}/scripts
echo ""	 
echo "... ✅ fatto!"
