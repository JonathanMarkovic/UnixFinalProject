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

- [x] Package Manager (`pacman`)
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
1. run: pacman-key --init
2. run: pacman-key --populate
3. run: pacman -Sy git
4. clone Repository: git clone https:github.com/JonathanMarkovic/UnixFinalProject
5. run: ./installScript.sh
6. In partition UI create an EFI parition of at least 512M(mb)
7. In partition UI create a Linux File System for the rest of your disk
8. In partition UI choose write option then quit
9. reboot after setup

10. Clone repository again: git clone https:github.com/JonathanMarkovic/UnixFinalProject
11. run: cd UnixFinalProject
12. run: install.sh
13. Choose preffered apps and enjoy
