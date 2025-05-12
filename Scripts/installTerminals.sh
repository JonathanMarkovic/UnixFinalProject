#!/bin/bash

function checkDependencies() {
    local missing=()
    local dependencies=("ping" "df" "awk")

    for dep in "${dependencies[@]}"; do
        if ! command -v "$dep" &>/dev/null; then
            missing+=("$dep")
        fi
    done

    if (( ${#missing[@]} > 0 )); then
        echo -e "\033[0;31mMissing required dependencies:\033[0m"
        for m in "${missing[@]}"; do
            echo -e " - $m"
        done
        echo -e "\n\033[0;31mPlease install the missing tools and try again.\033[0m"
        exit 1
    fi
}

#function checkNetwork() {
#    if ! ping -q -c 1 -W 2 archlinux.org &>/dev/null; then
#        echo -e "\033[0;31mNo internet connection. Please check your network.\033[0m"
#        exit 1
#    fi
#}

function checkInstallers() {
    if ! command -v yay &>/dev/null; then
        echo -e "\033[0;31mWe ask that you please install Yay in order to continue.\033[0m"
        exit 1
    fi
    if ! command -v pacman &>/dev/null; then
        echo -e "\033[0;31mPacman is required but not found. Are you on Arch?\033[0m"
        exit 1
    fi
}

function checkStorage() {
    requiredMB=$1
    availableKB=$(df / | awk 'NR==2 {print $4}')
    availableMB=$((availableKB / 1024))
    if (( availableMB < requiredMB )); then
        echo -e "\033[0;31mNot enough storage. Required: ${requiredMB}MB, Available: ${availableMB}MB.\033[0m"
        return 1
    fi
    return 0
}

checkDependencies
#checkNetwork
checkInstallers

PS3="Choose a terminal emulator to install: "
terminalChoices=("Alacritty" "Kitty" "Foot" "URxvt" "Termite" "Information About The Terminal Emulators" "Back")

while true; do
    select terminal in "${terminalChoices[@]}"; do
        case $terminal in
            "Alacritty")
                if checkStorage 200; then
                    sudo pacman -S --noconfirm alacritty
                fi
                break
                ;;
            "Kitty")
                if checkStorage 200; then
                    sudo pacman -S --noconfirm kitty
                fi
                break
                ;;
            "Foot")
                if checkStorage 150; then
                    sudo pacman -S --noconfirm foot
                fi
                break
                ;;
            "URxvt")
                if checkStorage 100; then
                    sudo pacman -S --noconfirm rxvt-unicode
                fi
                break
                ;;
            "Termite")
                if checkStorage 150; then
                    yay -S --noconfirm termite
                fi
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
