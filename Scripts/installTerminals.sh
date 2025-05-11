#!/bin/bash

function checkForYay() {
    if ! command -v yay &> /dev/null; then
        echo -e "\033[0;31mWe ask that you please install Yay in order to continue.\033[0m"
        exit 1
    fi
}

checkForYay

PS3="\033[38;2;173;216;230mChoose a terminal emulator to install: \033[0m"
terminalChoices=("Alacritty" "Kitty" "Foot" "URxvt" "Termite" "Information About The Terminal Emulators" "Back")

while true; do
    select terminal in "${terminalChoices[@]}"; do
        case $terminal in
            "Alacritty")
                yay -S --noconfirm alacritty
                break
                ;;
            "Kitty")
                yay -S --noconfirm kitty
                break
                ;;
            "Foot")
                yay -S --noconfirm foot
                break
                ;;
            "URxvt")
                yay -S --noconfirm rxvt-unicode
                break
                ;;
            "Termite")
                yay -S --noconfirm termite
                break
                ;;
            "Information About The Terminal Emulators")
                echo -e "\033[38;2;173;216;230mTerminal Emulator Information:\033[0m"
                echo
                echo -e "\033[38;2;173;216;230m1. Alacritty\033[0m: A fast, GPU-accelerated terminal emulator."
                echo -e "\033[38;2;173;216;230m2. Kitty\033[0m: A feature-rich terminal emulator that supports graphics and ligatures."
                echo -e "\033[38;2;173;216;230m3. Foot\033[0m: A simple and lightweight Wayland terminal emulator."
                echo -e "\033[38;2;173;216;230m4. URxvt\033[0m: A highly customizable terminal emulator for X11."
                echo -e "\033[38;2;173;216;230m5. Termite\033[0m: A simple terminal emulator based on GTK+ 3."
                echo
                break
                ;;
            "Back")
                bash UnixProject.sh
                exit 0
                ;;
            *)
                echo -e "\033[0;31m\033[1mInvalid choice. Please try again.\033[0m"
                ;;
        esac
    done
done
