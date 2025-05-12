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
checkNetwork
checkInstallers

PS3="\033[38;2;173;216;230mChoose a file manager to install: \033[0m"
fileManagerChoices=("Thunar" "PCManFM" "XFE" "Nemo" "SpaceFM" "Information About The File Managers" "Back")

while true; do
    select fileManager in "${fileManagerChoices[@]}"; do
        case $fileManager in
            "Thunar")
                if checkStorage 200; then
                    yay -S --noconfirm thunar
                fi
                break
                ;;
            "PCManFM")
                if checkStorage 150; then
                    yay -S --noconfirm pcmanfm
                fi
                break
                ;;
            "XFE")
                if checkStorage 150; then
                    yay -S --noconfirm xfe
                fi
                break
                ;;
            "Nemo")
                if checkStorage 300; then
                    yay -S --noconfirm nemo
                fi
                break
                ;;
            "SpaceFM")
                if checkStorage 250; then
                    yay -S --noconfirm spacefm
                fi
                break
                ;;
            "Information About The File Managers")
                echo -e "\033[38;2;173;216;230mFile Manager Information:\033[0m"
                echo
                echo -e "\033[38;2;173;216;230m1. Thunar\033[0m: A lightweight file manager for the Xfce desktop environment."
                echo -e "\033[38;2;173;216;230m2. PCManFM\033[0m: A fast and lightweight file manager with a simple interface."
                echo -e "\033[38;2;173;216;230m3. XFE\033[0m: A lightweight file manager that is designed to be fast and easy to use."
                echo -e "\033[38;2;173;216;230m4. Nemo\033[0m: The default file manager for the Cinnamon desktop environment, known for its ease of use."
                echo -e "\033[38;2;173;216;230m5. SpaceFM\033[0m: A multi-panel tabbed file manager that is highly customizable."
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
