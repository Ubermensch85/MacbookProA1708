# Scheda Audio Cirrus CS8409 / CS4208 (MacBook Pro A1708)

## 📌 Panoramica Hardware
Il MacBookPro14,1 (13 pollici, Due porte Thunderbolt 3, 2017) utilizza un codec audio personalizzato Cirrus Logic CS8409 combinato con amplificatori CS4208.
Nel kernel Linux generico i driver Intel HD Audio standard (`snd-hda-intel`) non riconoscono correttamente la matrice di routing degli altoparlanti interni, del microfono e del jack per le cuffie, provocando assenza totale di audio o audio gracchiante.

---

## 🛠️ Soluzione Adottata
1. **Driver DKMS personalizzato**:
   Utilizzo del repository `snd_hda_macbookpro` (di davidjo), integrato nel sistema tramite modulo DKMS per compilarsi in automatico ad ogni aggiornamento kernel.
2. **Opzioni Modprobe (`/etc/modprobe.d/alsa-base.conf`)**:
   ```ini
   options snd-hda-intel model=cs8409
   ```
   Questa direttiva forza il sottosistema ALSA a caricare la tavola dei pin corretta per il chip Cirrus CS8409.
3. **Prevenzione Click/Pop da Risparmio Energetico (`/etc/tlp.conf`)**:
   Per evitare che la scheda audio entri in deep sleep su batteria producendo fastidiosi "click" o ritardi nella riproduzione sonora:
   ```ini
   SOUND_POWER_SAVE_ON_AC=0
   SOUND_POWER_SAVE_ON_BAT=0
   ```

---

## 🚀 Script di Installazione e Ripristino Rapido
Incluso nel repository:
```bash
./schedaaudio.sh
```
Lo script clona e ricompila il driver su misura per il kernel corrente eseguendo:
```bash
git clone https://github.com/davidjo/snd_hda_macbookpro.git
cd snd_hda_macbookpro
sudo ./install.cirrus.driver.sh
```
