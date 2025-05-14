#!/bin/bash

# Nome del progetto (modifica se necessario)
PROJECT_DIR="/percorso/del/tuo/progetto"
REPO_URL="https://github.com/tuo-utente/tuo-progetto.git"

# Vai alla directory del progetto
cd $PROJECT_DIR || { echo "Directory non trovata"; exit 1; }

# Fetch o clone dal repo (se non hai ancora clonato il repo, esegui questa riga)
# git pull origin main || git clone $REPO_URL $PROJECT_DIR
git pull origin main || echo "Progetto non trovato, clonando..." && git clone $REPO_URL $PROJECT_DIR

# Installa le dipendenze
echo "Installando le dipendenze..."
npm install || { echo "Errore nell'installazione delle dipendenze"; exit 1; }

# Compila il progetto
echo "Costruendo il progetto per la produzione..."
npm run build || { echo "Errore nella costruzione del progetto"; exit 1; }

# Avvia l'app in modalità produzione con pm2
echo "Avviando l'app con pm2..."
pm2 start npm --name "next-app" -- start || { echo "Errore nell'avvio dell'app"; exit 1; }

# Salva la configurazione di pm2
pm2 save || { echo "Errore nel salvataggio della configurazione di pm2"; exit 1; }

# Riavvia Nginx per assicurarsi che il reverse proxy sia attivo
echo "Riavviando Nginx..."
sudo systemctl restart nginx || { echo "Errore nel riavvio di Nginx"; exit 1; }

echo "Deploy completato con successo!"
