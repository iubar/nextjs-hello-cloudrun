#!/bin/bash

#if [ $# -eq 0 ]; then
echo ""
echo "💡 USAGE : $0 [scripts_path] [batch_mode]"
echo ""
echo "\t scripts_path: the path to the folder containing the scripts (even the subfolders are processed). The default is the current folder"
echo "\t batch_mode: true to disable script interactivity. Default value is false."
echo ""
exit 1
#fi

# Cartella di partenza, puoi modificarla o passarla come parametro
TARGET_PATH="${1:-.}" # Usa la cartella passata come parametro, altrimenti la cartella corrente

if [ $# -ge 1 ]; then
    if [ ! -e "$TARGET_PATH" ]; then
        echo "❌ Il path ${TARGET_PATH} non esiste !"
        exit 1
    fi
fi

BATCH_MODE=0
if [ $# -eq 2 ]; then
    if [ "$2" == "true" ] || [ "$2" == "1" ]; then
        BATCH_MODE=1
    fi
fi

######################################### FUNCTIONS
runChmod()
{
    # Applica chmod +x su tutti i file .sh
    find "${TARGET_PATH}" -type f -name "*.sh" -exec chmod +x {} \;
    echo "✅ Permessi 'chmod +x' applicati su tutti i file .sh."
}
#########################################

echo "🔍 Imposto chmod +x su tutti i file .sh in ${TARGET_PATH} e sottocartelle..."
echo "Verranno applicati i permessi di esecuzione su tutti i file con estensione .sh."
echo ""

# Trova tutti i file .sh nella cartella e sottocartelle
sh_files=$(find "${TARGET_PATH}" -type f -name "*.sh")

if [ -z "$sh_files" ]; then
    echo "⚠️ Nessun file .sh trovato in ${TARGET_PATH} e nelle sue sottocartelle."
    exit 0
fi

# Visualizza i file che verranno modificati
echo "I seguenti file riceveranno il permesso di esecuzione:"
echo ""
echo "${sh_files}"
echo ""

if [ "$BATCH_MODE" == "1" ]; then
    runChmod
else
    # Chiede conferma prima di procedere
    read -p "Continuare ? (s/n): " answer

    echo ""
    if [[ "$answer" =~ ^[Ss]$ ]]; then
        runChmod
    else
        echo "❌ Operazione annullata."
    fi
fi
