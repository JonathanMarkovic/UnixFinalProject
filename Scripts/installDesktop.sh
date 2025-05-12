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

function checkNetwork() {
#    echo -e "\033[0;36mChecking internet connection...\033[0m"
#    if ! ping -q -c 1 -W 2 archlinux.org &>/dev/null; then
#        echo -e "\033[0;31mNo internet connection. Please check your network.\033[0m"
#        exit 1
#    fi
}

function checkInstallers() {
    if ! command -v yay &>/dev/null; then
        echo -e "\033[0;31mWe ask that you please install Yay in order to continue.\033[0m"
        exit 1
    fi
    if ! command -v pacman &>/dev/null; then
        echo -e "\033[0;31mPacman not found. Are you on Arch?\033[0m"
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
checkNetwork
checkInstallers

PS3="\033[38;2;173;216;230mChoose a desktop environment to install: \033[0m"
desktopEnvironmentChoices=("Sway" "GNOME" "Plasma" "Cinnamon" "Budgie" "Information About The Desktop Environments" "Back")

while true; do
    select desktopenv in "${desktopEnvironmentChoices[@]}"; do
        case $desktopenv in
            "Sway")
                if checkStorage 800; then
                    sudo pacman -S --noconfirm sway
                fi
                break
                ;;
            "GNOME")
                if checkStorage 2000; then
                    sudo pacman -S --noconfirm gnome
                fi
                break
                ;;
            "Plasma")
                if checkStorage 2500; then
                    sudo pacman -S --noconfirm plasma-meta
                fi
                break
                ;;
            "Cinnamon")
                if checkStorage 1800; then
                    yay -S --noconfirm cinnamon
                fi
                break
                ;;
            "Budgie")
                if checkStorage 1700; then
                    yay -S --noconfirm budgie-desktop
                fi
                break
                ;;
            "Information About The Desktop Environments")
                echo -e "\033[38;2;173;216;230mDesktop Environment Information:\033[0m"
                echo
                echo -e "\033[38;2;173;216;230m1. Sway\033[0m: A tiling window manager that is designed for Wayland."
                echo -e "\033[38;2;173;216;230m2. GNOME\033[0m: A user-friendly desktop environment that is known for its simplicity and ease of use."
                echo -e "\033[38;2;173;216;230m3. Plasma\033[0m: A highly customizable desktop environment that is part of the KDE project."
                echo -e "\033[38;2;173;216;230m4. Cinnamon\033[0m: A modern desktop environment that is designed to be easy to use and highly customizable."
                echo -e "\033[38;2;173;216;230m5. Budgie\033[0m: A simple and elegant desktop environment that is designed to be easy to use."
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
