# UnixFinalProject
# Easy Arch: A Beginner-Friendly Arch Linux Setup Tool

---

## Project Description & Goals

We aim to provide an easier alternative to using the Arch Linux distribution by simplifying the installation process and desktop configuration. Our main goal is to make installing packages and managing a desktop environment more intuitive. The final product will feature an easy-to-navigate desktop environment equipped with essential apps, tailored for beginner computer science students or users new to Linux.

---

## Platform of Choice

- **Platform:** Desktop
- **Operating System:** Arch Linux (fresh install)
- **Demo Method:** Virtual Machine (VM)

---

## Demonstration Plan

We will use a virtual machine to demonstrate the project. Starting from a fresh Arch installation, we’ll showcase how our script automates and simplifies the setup process, including package installation, configuration, and desktop customization.

---

## Requirements

To achieve our goal, the project will include the following components:

- [x] Package Manager ('pacman')
- [x] Desktop Environment
- [x] Code/Text Editor
- [x] Browser
- [x] File Manager
- [x] Terminal Emulator
- [x] Network Manager
- [x] Utility Tool
- [x] Font Manager
- [x] Window Manager
- [x] System Update Check using `systemd`
- [x] Any needed dependencies for the above tools

---

## Team Composition

- Matthew Pietracupa  
- Jonathan Markovic  
- Iulia Apintilioaie

---

## Baseline Arch Installation Overview
Arch Linux installation is known to be difficult for newcomers. A helpful guide:  
https://gist.github.com/mjkstra/96ce7a5689d753e7a6bdd92cdc169bae

**Common Difficulties With Arch:**
- No graphical installer  
- Manual Wi-Fi setup  
- Risk of command errors during disk configuration  
- Lack of immediate help or automation

Our script automates these tedious steps to remove complexity from the Arch experience.

---

## Repository Structure

```plaintext
├── install.sh           # Main Bash script
├── Scripts/             # Additional scripts
├── README.md            # This file
└── assets/              # Screenshots or support files
```
---

## Arch Linux Full Installation Guide (UEFI, Virtual Machine-Friendly)

---

## Step 1: Download the ISO and Set Up the Virtual Machine
Download the ISO: https://archlinux.org/download
Download the latest archlinux-x86_64.iso from a mirror near you.

## Set up VirtualBox:
Install VirtualBox: https://www.virtualbox.org/wiki/Downloads

## Create a new VM:
Name: ArchLinux
Type: Linux
Version: Arch Linux (64-bit)
Memory: 2048–4096 MB
Create a virtual hard disk (VDI, at least 15 GB)
Go to Settings > System > Motherboard:
Enable EFI (check “Enable EFI (special OSes only)”)
Go to Settings > Storage:
Load the Arch ISO under "Controller: IDE"
Start the VM

---

## Step 2: Boot ISO and Prepare
Set keyboard layout:
loadkeys us

## Check UEFI mode:
cat /sys/firmware/efi/fw_platform_size

## Test internet connection:
ping -c 5 archlinux.org

## Enable NTP and set timezone:
timedatectl set-ntp true

timedatectl set-timezone Canada/Eastern

---

## Step 3: Partition the Disk
## List disks:
lsblk

Run fdisk on the target disk (e.g., /dev/sda):

fdisk /dev/sda

## Inside fdisk, type:

g

n

ENTER

ENTER

+512M

t

1

n

ENTER

ENTER

ENTER

p

w

---

## Step 4: Format the Partitions
mkfs.fat -F 32 /dev/sda1
mkfs.btrfs /dev/sda2

---

## Step 5: Mount and Create Subvolumes
mount /dev/sda2 /mnt

btrfs subvolume create /mnt/@
btrfs subvolume create /mnt/@home

umount /mnt

mount -o compress=zstd,subvol=@ /dev/sda2 /mnt
mkdir -p /mnt/home
mount -o compress=zstd,subvol=@home /dev/sda2 /mnt/home

mkdir -p /mnt/efi
mount /dev/sda1 /mnt/efi

---

## Step 6: Install Base Packages
pacstrap /mnt base base-devel linux linux-firmware \
git btrfs-progs grub efibootmgr grub-btrfs inotify-tools timeshift \
vim networkmanager pipewire pipewire-alsa pipewire-pulse pipewire-jack \
wireplumber reflector zsh zsh-completions zsh-autosuggestions \
openssh man sudo

---

## Step 7: Generate fstab
genfstab -U /mnt >> /mnt/etc/fstab
cat /mnt/etc/fstab

---

## Step 8: Enter the New System
arch-chroot /mnt

---

## Step 9: System Configuration
## Time & Clock:
ln -sf /usr/share/zoneinfo/Canada/Eastern /etc/localtime
hwclock --systohc

---

## Locale:
nano /etc/locale.gen
# Uncomment: en_CA.UTF-8
locale-gen

echo "LANG=en_CA.UTF-8" > /etc/locale.conf
echo "KEYMAP=us" > /etc/vconsole.conf

## Hostname:
echo "arch" > /etc/hostname

## Hosts file:
cat > /etc/hosts <<EOF
127.0.0.1 localhost
::1       localhost
127.0.1.1 arch
EOF

## Step 10: Add User and Passwords
## Set root password:
passwd

---

## Create a new user (replace jon with your preferred username):
useradd -mG wheel jon
passwd jon

---

## Enable sudo:
EDITOR=vim visudo
# Uncomment: %wheel ALL=(ALL:ALL) ALL

---

## Step 11: Install Bootloader
grub-install --target=x86_64-efi --efi-directory=/efi --bootloader-id=GRUB
grub-mkconfig -o /boot/grub/grub.cfg

---

## Step 12: Finalize Installation
Enable networking:
systemctl enable NetworkManager

---

## Exit chroot and reboot:
exit
umount -R /mnt
reboot

---

## Step 13: Post-Install
Login with your new user. To enable NTP time sync (if needed):
timedatectl set-ntp true

---

## Guide that inspired this installation:
https://gist.github.com/mjkstra/96ce7a5689d753e7a6bdd92cdc169bae#preliminary-steps
