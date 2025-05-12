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
function checkInstallers() {
    if ! command -v yay &>/dev/null; then
        echo -e "\033[0;31m'yay' is required. Please install yay to continue.\033[0m"
        exit 1
    fi
    if ! command -v pacman &>/dev/null; then
        echo -e "\033[0;31m'pacman' not found. Are you using Arch? Exiting.\033[0m"
        exit 1
    fi
}

function checkNetwork() {
#    echo -e "\033[0;36mChecking internet connection...\033[0m"
#    if ping -q -c 1 -W 2 archlinux.org &>/dev/null; then
#        echo -e "\033[0;32mNetwork connection: OK\033[0m"
#    else
#        echo -e "\033[0;31mNo internet connection. Please check your network.\033[0m"
#        exit 1
#    fi
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

PS3="\033[38;2;173;216;230mChoose a browser to install: \033[0m"
browsersChoices=("Firefox" "Chromium" "Brave" "Opera" "Onion Browser" "Information About The Browsers" "Back")

while true; do
    select browser in "${browsersChoices[@]}"; do
        case $browser in
            "Firefox")
            if checkStorage 500; then
                    sudo pacman -S --noconfirm firefox
                    sudo pacman -S --noconfirm firefox-ublock-origin
                fi
                break
                ;;
            "Chromium")
                if checkStorage 600; then
                    sudo pacman -S --noconfirm chromium
                fi
                break
                ;;
            "Brave")
                if checkStorage 550; then
                    yay -S --noconfirm opera
                fi
                break
                ;;
            "Opera")
                if checkStorage 550; then
                    yay -S --noconfirm opera
                fi
                break
                ;;
            "Onion Browser")
                if checkStorage 800; then
                    yay -S --noconfirm torbrowser-launcher
                fi
                break
                ;;
            "Information About The Browsers")
                echo -e "\033[38;2;173;216;230mBrowser Information:\033[0m"
                echo
                echo -e "\033[38;2;173;216;230m1. Firefox\033[0m\nStable and in the official repo. Installed via pacman.\n"
                echo -e "\033[38;2;173;216;230m2. Chromium\033[0m\nIn official repos. Installed via pacman.\n"
                echo -e "\033[38;2;173;216;230m3. Brave\033[0m\nAUR-only. Installed via yay (brave-bin).\n"
                echo -e "\033[38;2;173;216;230m4. Opera\033[0m\nBetter maintained in AUR. Installed via yay.\n"
                echo -e "\033[38;2;173;216;230m5. Onion Browser\033[0m\nAUR preferred. Installed via yay (torbrowser-launcher).\n"
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
