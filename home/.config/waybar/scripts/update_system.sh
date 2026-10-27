#!/bin/bash
# Script per aggiornare i mirror, il sistema (Pacman + AUR + Devel/Git), aggiornare GRUB e pulire il sistema.

# Abilita l'interruzione dello script in caso di errori imprevisti
set -e

# Gestore degli errori: evita la chiusura improvvisa della finestra del terminale
error_handler() {
    local exit_code=$?
    local line_no=$1
    echo -e "\n\e[1;31m========================================================\e[0m"
    echo -e "\e[1;31m[ERRORE] Aggiornamento interrotto alla riga $line_no (codice di uscita: $exit_code).\e[0m"
    echo -e "\e[1;33mEsamina l'output qui sopra per capire quale pacchetto o comando ha causato l'errore.\e[0m"
    if [ -f /var/lib/pacman/db.lck ]; then
        echo -e "\e[1;33mNota: se è presente /var/lib/pacman/db.lck da un crash precedente, potrebbe bloccare pacman.\e[0m"
    fi
    echo -e "\e[1;31m========================================================\e[0m"
    echo -e "\nPremi un tasto qualsiasi per chiudere questa finestra..."
    read -n 1 -s -r
    exit $exit_code
}
trap 'error_handler $LINENO' ERR

# Controllo preventivo del file db.lck
if [ -f /var/lib/pacman/db.lck ]; then
    echo -e "\e[1;33m[ATTENZIONE] Trovato /var/lib/pacman/db.lck. Assicurati che non ci siano altri pacman/yay attivi.\e[0m\n"
fi

echo -e "\e[1;34m=== 1. AGGIORNAMENTO MIRRORLIST (rate-mirrors) ===\e[0m"
if command -v rate-mirrors &>/dev/null; then
    echo "Aggiornamento mirrorlist per Italia, Svizzera, Germania e Francia con rate-mirrors..."
    sudo rate-mirrors \
        --entry-country IT \
        --country-neighbors-per-country 3 \
        --allow-root \
        --disable-comments-in-file \
        --save /etc/pacman.d/mirrorlist \
        arch || echo "Attenzione: aggiornamento mirrorlist fallito, proseguo con i mirror attuali."
elif command -v reflector &>/dev/null; then
    echo "rate-mirrors non presente. Uso reflector per Italia, Svizzera, Germania e Francia..."
    sudo reflector \
        --country Italy,Switzerland,Germany,France \
        --age 12 \
        --protocol https \
        --sort score \
        --fastest 20 \
        --number 20 \
        --save /etc/pacman.d/mirrorlist || echo "Attenzione: aggiornamento mirrorlist con reflector fallito."
else
    echo "Nessun gestore di mirror trovato. Salto l'aggiornamento dei mirror."
fi

echo -e "\n\e[1;34m=== 2. AGGIORNAMENTO DI SISTEMA (Official + AUR + Devel/Git) ===\e[0m"
# yay si occupa sia dei repository ufficiali sia di AUR (inclusi i pacchetti devel/git)
yay -Syu --devel

echo -e "\n\e[1;34m=== 3. AGGIORNAMENTO CONFIGURAZIONE GRUB ===\e[0m"
sudo grub-mkconfig -o /boot/grub/grub.cfg || echo "Attenzione: aggiornamento di GRUB non riuscito."

echo -e "\n\e[1;34m=== 4. PULIZIA DEL SISTEMA ===\e[0m"

# Rimozione degli orfani
echo "Verifica pacchetti orfani..."
orphans=$(pacman -Qtdq 2>/dev/null || true)
if [ -n "$orphans" ]; then
    echo "Rimozione orfani trovati: $orphans"
    sudo pacman -Rns $orphans --noconfirm || echo "Attenzione: rimozione di alcuni pacchetti orfani fallita."
else
    echo "Nessun pacchetto orfano trovato."
fi

# Pulizia cache pacchetti scaricati
echo "Pulizia cache pacchetti (mantenendo solo le ultime 2 versioni)..."
sudo paccache -r -k 2 2>/dev/null || true
# Pulisce la cache di yay/AUR
yay -Sc --noconfirm || true

echo -e "\n\e[1;32m=== 5. AGGIORNAMENTO STATO WAYBAR ===\e[0m"
pkill -SIGRTMIN+8 waybar || true

echo -e "\n\e[1;32mAggiornamento e pulizia completati con successo!\e[0m"
echo "Premi un tasto qualsiasi per chiudere questa finestra..."
read -n 1 -s -r


