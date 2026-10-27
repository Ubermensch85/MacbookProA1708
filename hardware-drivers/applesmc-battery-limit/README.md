# AppleSMC con Supporto Soglia di Ricarica Batteria (MacBook Pro A1708)

## 📌 Panoramica
Sui MacBook con architettura Intel (in particolare MacBookPro14,1 / A1708), la gestione della batteria e delle ventole è affidata all'**Apple System Management Controller (SMC)**.
Nei kernel Linux moderni (6.x e 7.x), i vecchi hook ACPI della batteria per `applesmc` generavano errori o impedivano l'impostazione di una soglia massima di carica (es. 80%) per preservare la salute della batteria durante l'alimentazione continua via caricatore USB-C.

In questo repository è presente la patch sviluppata su misura per `applesmc-next`:
1. Rimuove la dipendenza problematica da `acpi_battery_hook`.
2. Espone direttamente il nodo sysfs `/sys/devices/platform/applesmc.768/charge_limit`.
3. Integra le chiamate native SMC `CHARGE_END_KEY` per leggere e scrivere la percentuale limite di carica.

---

## 🛠️ File Inclusi
- `applesmc.c.modified`: Sorgente C patchato e compatibile con i kernel recenti (testato con Linux 6.18 e 7.2+).
- `applesmc.patch`: Diff unificato da applicare ai sorgenti di `applesmc-next`.
- `applesmc_Makefile.patch`: Correzione per il Makefile del modulo DKMS.
- `applesmc-next-clean.patch`: Pulizia dei warning del compilatore per i nuovi kernel.
- `dkms.patch`: Configurazione DKMS per l'automazione ad ogni aggiornamento kernel.
- `PKGBUILD`: Script di pacchettizzazione Arch Linux / AUR pronto all'uso con `makepkg -si`.

---

## 🚀 Come Compilare e Installare con DKMS
Se si reinstalla il sistema o si aggiorna il pacchetto:

```bash
cd hardware-drivers/applesmc-battery-limit
makepkg -si
```

Verifica che il modulo sia correttamente registrato in DKMS:
```bash
dkms status | grep applesmc
```

---

## 🔋 Come Funziona il Limite di Carica
1. **Configurazione TLP (`/etc/tlp.conf`)**:
   ```ini
   START_CHARGE_THRESH_BAT0=70
   STOP_CHARGE_THRESH_BAT0=80
   ```
2. **Servizio Systemd (`macbook-charge-limit.service`)**:
   All'avvio del sistema, legge `STOP_CHARGE_THRESH_BAT0` da TLP e scrive `80` su:
   ```bash
   /sys/devices/platform/applesmc.768/charge_limit
   ```
3. **Regola Udev (`99-macbook-charge-limit.rules`)**:
   Ogni volta che l'alimentatore USB-C viene collegato o scollegato, la regola udev riesegue `/home/ubermensch/scripts/set-charge-limit.sh` per garantire che la soglia dell'80% rimanga sempre attiva nel controller hardware.
