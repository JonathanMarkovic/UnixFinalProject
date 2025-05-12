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

## How To Install

---

## Baseline Arch Installation Overview
## How To Install on VirtualBox (Arch Linux)

### Pre-Installation

1. Download the latest [Arch Linux ISO](https://archlinux.org/download/)
2. Create a new VM in VirtualBox:
   - Type: Linux  
   - Version: Arch Linux (64-bit)  
   - Memory: 2048MB or more  
   - Storage: Create a virtual disk (e.g., 20GB)  
3. Mount the ISO and boot the VM

---

### Inside the Arch ISO (Live Environment)
```bash
# Set keyboard layout (optional, default is 'us')
loadkeys us

### Verify UEFI mode
cat /sys/firmware/efi/fw_platform_size

### Enable Networking
ping archlinux.org

### Set Up Keys and Install Git
pacman-key --init
pacman-key --populate
pacman -Sy git

### Clone and Run the Setup Script
git clone https://github.com/JonathanMarkovic/UnixFinalProject
cd UnixFinalProject
chmod +x installScript.sh
./installScript.sh

### Partition the Disk
Create EFI partition: at least 512MB (type: EFI System)
Create root partition: rest of the disk (type: Linux File System)
Write and quit the partition tool
The script will handle formatting and mounting

### Reboot and Finish Setup
Reboot the system when prompted
Boot into the installed Arch system

### Final Setup (After Reboot)
pacman -Sy git
git clone https://github.com/JonathanMarkovic/UnixFinalProject
cd UnixFinalProject
chmod +x install.sh
./install.sh

### Select Your Applications
Choose your preferred applications and desktop environment from the menu system.
The script will handle all installations and configurations.
Enjoy your fully-functional Arch Linux desktop!

