# Guida di Ripristino e Reinstallazione Completa da Zero

Questa guida descrive la procedura passo-passo per installare Arch Linux su un Apple MacBook Pro 13" A1708 (Metà 2017) e ripristinare integralmente l'ambiente configurato in questo repository.

---

## 1. Preparazione dell'Hardware e Live USB
1. Scarica la ISO più recente di Arch Linux o EndeavourOS e scrivila su una chiavetta USB con `dd` o Rufus.
2. Inserisci la chiavetta USB nel MacBook spento.
3. Tieni premuto il tasto `Option / Alt` e accendi il laptop. Seleziona l'avvio da `EFI Boot`.

---

## 2. Partizionamento e Parametri di Boot
1. Partiziona l'unità NVMe:
   - Partizione 1: EFI (`/boot`, dimensione 512M - 1GB, formato vfat / FAT32)
   - Partizione 2: Root (`/`, ext4 o btrfs)
2. Parametri del bootloader (GRUB o systemd-boot):
   Aggiungi alla riga del kernel:
   ```text
   i915.enable_guc=2 i915.enable_psr=0 i915.enable_fbc=1 pcie_aspm=off quiet
   ```

---

## 3. Installazione Pacchetti
Dalla cartella `packages/`:

### Pacchetti Ufficiali
```bash
sudo pacman -S --needed - < packages/pkglist-native.txt
```

### Pacchetti AUR (con yay o paru)
```bash
yay -S --needed - < packages/pkglist-aur.txt
```

---

## 4. Installazione Driver Hardware Essenziali

### Audio Cirrus CS8409
```bash
cd hardware-drivers/audio-cirrus-cs8409
chmod +x schedaaudio.sh
./schedaaudio.sh
```

### Batteria AppleSMC (Limite Carica 80%)
```bash
cd hardware-drivers/applesmc-battery-limit
makepkg -si
```

### Wi-Fi Broadcom BCM4350
Assicurati che `bcm4350-firmware` e `broadcom-bt-firmware` siano installati da AUR e che la regola udev per il powersave sia attiva.

---

## 5. Ripristino Dotfiles e Configurazioni di Sistema
Esegui lo script automatico `install.sh` presente nella radice del repository:
```bash
chmod +x install.sh
./install.sh
```

Lo script effettua:
1. Copia/aggiornamento delle regole in `/etc/` (`modprobe.d`, `udev`, `systemd`, `tlp.conf`, `environment`, `grub`).
2. Abilitazione dei servizi di sistema (`tlp`, `keyd`, `macbook-charge-limit.service`).
3. Installazione dei file in `~/.config`, `~/.local` e `~/scripts`.
4. Ricarica di udev e di hwdb.
