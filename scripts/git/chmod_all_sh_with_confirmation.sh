#!/bin/bash

# Cartella di partenza, puoi modificarla o passarla come parametro
folder="${1:-.}"  # Usa la cartella passata come parametro, altrimenti la cartella corrente

echo "🔍 Impostazione chmod +x su tutti i file .sh in $folder e sottocartelle..."
echo "Verranno applicati i permessi di esecuzione su tutti i file con estensione .sh."
echo ""

# Trova tutti i file .sh nella cartella e sottocartelle
sh_files=$(find "$folder" -type f -name "*.sh")

if [ -z "$sh_files" ]; then
    echo "⚠️ Nessun file .sh trovato in $folder e nelle sue sottocartelle."
    exit 0
fi

# Visualizza i file che verranno modificati
echo "I seguenti file riceveranno il permesso di esecuzione:"
echo ""
echo "$sh_files"
echo ""

# Chiede conferma prima di procedere
read -p "Continuare ? (s/n): " answer

echo ""
if [[ "$answer" =~ ^[Ss]$ ]]; then
    # Applica chmod +x su tutti i file .sh
    find "$folder" -type f -name "*.sh" -exec chmod +x {} \;
    echo "✅ Permessi 'chmod +x' applicati su tutti i file .sh."
else
    echo "❌ Operazione annullata."
fi