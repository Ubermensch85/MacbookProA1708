#!/bin/bash

# Percorso della batteria (potrebbe essere BAT0 o BAT1)
BATTERY="/sys/class/power_supply/BAT0"

# Controlla se la directory della batteria esiste
if [ ! -d "$BATTERY" ]; then
    echo "Errore: Batteria non trovata in $BATTERY"
    exit 1
fi

# Leggi i valori
if [ -f "$BATTERY/charge_full" ] && [ -f "$BATTERY/charge_full_design" ]; then
    CHARGE_FULL=$(cat "$BATTERY/charge_full")
    CHARGE_FULL_DESIGN=$(cat "$BATTERY/charge_full_design")
    # Calcola la capacità residua in percentuale
    CAPACITY_PERCENT=$(echo "scale=2; ($CHARGE_FULL * 100) / $CHARGE_FULL_DESIGN" | bc)
else
    CAPACITY_PERCENT="N/D"
fi

# Leggi il numero di cicli
if [ -f "$BATTERY/cycle_count" ]; then
    CYCLE_COUNT=$(cat "$BATTERY/cycle_count")
else
    CYCLE_COUNT="N/D"
fi

# Stampa i risultati
echo "Salute della batteria:"
echo "Capacità residua: $CAPACITY_PERCENT%"
echo "Cicli di carica: $CYCLE_COUNT"
