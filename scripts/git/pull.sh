#!/bin/bash

# Alternativa solo Bash : SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
echo "Lo script si trova in: ${SCRIPT_DIR}"

cd $SCRIPT_DIR/../..
echo "📁📍 Cartella corrente: $(pwd)"

# Verifica se siamo in una directory Git
if [ ! -d ".git" ]; then
  echo "❌ Non sei nella cartella radice di un progetto git."
  exit 1
fi

PROJECT_ROOT=$(pwd)
echo "📁 Project root path is: ${PROJECT_ROOT}"

echo ""
echo "💡 USAGE : $0 [batch_mode]"
echo ""
echo "\t batch_mode: true to disable script interactivity. Default value is false."
echo ""

BATCH_MODE=0
if [ $# -eq 1 ]; then
if [ "$1" == "true" ] || [ "$1" == "1" ]; then
    BATCH_MODE=1
  fi
fi

######################################### FUNCTIONS
gitClean() {
    git clean -df
    if [ $? -ne 0 ]; then        
        echo ""
        echo "❌ Errore durante il clean"
        exit 1
    else
        echo ""        
        echo "✅🔄 Ho effettuato il clean del repository !"
    fi   
}
#########################################  

echo ""
echo "🔁 Aggiornamento del repository Git..."
echo ""
echo "⚠️ Scarto tutte le modifiche locali ai file già tracciati."
echo ""
echo "📄 I nuovi file non tracciati verranno mantenuti ma ignorati."
echo ""

# Scarta modifiche a file già esistenti
git reset --hard #  ripristina tutti i file al loro stato originale (HEAD)
# Pulisce solo i file *tracciati* cancellati o modificati
# Ma NON tocca file non tracciati
# git clean -dfx -e '!*' -e '!*/' --dry-run > /dev/null
if [ $? -ne 0 ]; then
    echo "❌ Errore durante il reset"
    exit 1
fi

if [ "$BATCH_MODE" == "1" ]; then
  gitClean
else
  # git clean è usato per rimuovere file non tracciati (file che non sono stati aggiunti al repository con git add). Può rimuovere sia file non tracciati che cartelle vuote.
  echo "🔁 Anteprima del comando git clean..."
  git clean -df --dry-run
  #  -d: rimuove anche le directory non tracciate
  #  -f: Senza questo argomento, il comando git non farà nulla (per motivi di sicurezza)
  #  ...ma non tocca i file ignorati, come quelli elencati in .gitignore
  # TODO: valutare se aggiungere al comando sopra: > /dev/null  
  echo ""
  read -p "⚠️ Confermi ? (s/n): " answer
  echo ""
  if [[ "$answer" =~ ^[Ss]$ ]]; then
    gitClean
  else
    echo ""
    echo "⚠️ Ok, non effettuo il clean del repository !"
  fi   
fi

echo ""

# Pull dal remoto
# git pull --rebase
git pull
if [ $? -ne 0 ]; then
  echo ""
  echo "❌ Errore durante il pull"
  exit 1
else  
  echo ""
  echo "✅🔄 Pull completato!"
fi

echo ""

# echo "Ora rendo eseguibili tutti gli script sh del progetto..."	
# echo ""
chmod +x $SCRIPT_DIR/chmod_all_sh_with_confirmation.sh
$SCRIPT_DIR/chmod_all_sh_with_confirmation.sh ${PROJECT_ROOT}/scripts $BATCH_MODE

echo ""	 
echo "... ✅ fatto!"
