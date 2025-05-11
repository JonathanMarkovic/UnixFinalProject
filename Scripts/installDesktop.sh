#!/bin/bash

function checkForYay() {
    if ! command -v yay &> /dev/null; then
        echo -e "\033[0;31mWe ask that you please install Yay in order to continue.\033[0m"
        exit 1
    fi
}

checkForYay

function installWithDependencies() {
    local package=$1
    local dependencies=$(pactree -u "$package" | tail -n +2 | awk '{print $1}')
    
    for dep in $dependencies; do
        if ! pacman -Qi "$dep" &> /dev/null; then
            echo -e "\033[38;2;173;216;230mInstalling missing dependency: $dep\033[0m"
            yay -S --noconfirm "$dep"
        fi
    done
    
    echo -e "\033[38;2;173;216;230mInstalling $package...\033[0m"
    yay -S --noconfirm "$package"
}

PS3="\033[38;2;173;216;230mChoose a desktop environment to install: \033[0m"
desktopEnvironmentChoices=("Sway" "GNOME" "Plasma" "Cinnamon" "Budgie" "Information About The Desktop Environments" "Back")

while true; do
    select desktopenv in "${desktopEnvironmentChoices[@]}"; do
        case $desktopenv in
            "Sway")
                installWithDependencies sway
                break
                ;;
            "GNOME")
                installWithDependencies gnome
                break
                ;;
            "Plasma")
                installWithDependencies plasma-meta
                break
                ;;
            "Cinnamon")
                installWithDependencies cinnamon
                break
                ;;
            "Budgie")
                installWithDependencies budgie-desktop
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
