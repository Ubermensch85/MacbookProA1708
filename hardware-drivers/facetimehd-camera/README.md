# Fotocamera FaceTime HD PCIe (MacBook Pro A1708)

## 📌 Panoramica Hardware
A differenza dei normali laptop dove la webcam è collegata via bus USB (UVC), sui MacBook Pro 2016-2017 la videocamera FaceTime HD è un dispositivo PCIe dedicato Broadcom (`BCM15700A2`).
Linux non include il driver proprietario nell'albero mainline del kernel, né i file di calibrazione del sensore (ISP).

---

## 🛠️ Pacchetti e Moduli Richiesti
- `facetimehd-dkms-git`: Driver kernel PCIe compilato con DKMS.
- `facetimehd-firmware`: Firmware estratto dal driver OSX o scaricato dal repository AUR.

---

## 🎨 Calibrazione Automatica Immagine (`/etc/udev/rules.d/99-facetimehd.rules`)
Di fabbrica, il driver espone un'immagine sovraesposta, con colori slavati o dominante violacea.
Per risolvere il problema, è stata configurata la seguente regola udev che applica automaticamente i parametri corretti tramite `v4l2-ctl` all'accensione della periferica:

```udev
ACTION=="add", SUBSYSTEM=="video4linux", ATTR{name}=="FaceTime HD Camera", RUN+="/usr/bin/v4l2-ctl -d $devnode --set-ctrl=white_balance_automatic=0 --set-ctrl=brightness=160 --set-ctrl=contrast=145 --set-ctrl=saturation=140"
```

Valori impostati:
- `white_balance_automatic=0`: Disabilita il bilanciamento del bianco instabile
- `brightness=160`: Luminosità bilanciata
- `contrast=145`: Contrasto ottimale per le lenti del MacBook
- `saturation=140`: Resa cromatica naturale dell'incarnato
