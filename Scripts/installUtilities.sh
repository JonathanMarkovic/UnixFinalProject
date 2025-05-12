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

PS3="\033[38;2;173;216;230mChoose a utility to install: \033[0m"
utilityChoices=("NetworkManager" "xdg-utils" "fontconfig" "xorg-server" "Install All At Once" "Information About The Utilities" "Back")

while true; do
    select utility in "${utilityChoices[@]}"; do
        case $utility in
            "NetworkManager")
                if checkStorage 150; then
                    sudo pacman -S --noconfirm networkmanager
                    sudo systemctl enable --now NetworkManager
                fi
                break
                ;;
            "xdg-utils")
                if checkStorage 50; then
                    sudo pacman -S --noconfirm xdg-utils
                fi
                break
                ;;
            "fontconfig")
                if checkStorage 100; then
                    sudo pacman -S --noconfirm fontconfig
                fi
                break
                ;;
            "xorg-server")
                if checkStorage 300; then
                    sudo pacman -S --noconfirm xorg-server
                fi
                break
                ;;
            "Install All At Once")
                if checkStorage 600; then
                    sudo pacman -S --noconfirm networkmanager xdg-utils fontconfig xorg-server
                    sudo systemctl enable --now NetworkManager
                fi
                break
                ;;
            "Information About The Utilities")
                echo -e "\033[38;2;173;216;230mUtilities Information:\033[0m"
                echo
                echo -e "\033[38;2;173;216;230m1. NetworkManager\033[0m: A tool for managing network connections."
                echo -e "\033[38;2;173;216;230m2. xdg-utils\033[0m: A set of tools that provide a standard way to interact with the desktop environment."
                echo -e "\033[38;2;173;216;230m3. fontconfig\033[0m: A library for configuring and customizing font access."
                echo -e "\033[38;2;173;216;230m4. xorg-server\033[0m: The X.Org X server, which provides the graphical environment."
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
