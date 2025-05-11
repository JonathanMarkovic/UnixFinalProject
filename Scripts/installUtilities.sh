#!/bin/bash

function checkForYay() {
    if ! command -v yay &> /dev/null; then
        echo -e "\033[0;31mWe ask that you please install Yay in order to continue.\033[0m"
        exit 1
    fi
}

checkForYay

PS3="\033[38;2;173;216;230mChoose a utility to install: \033[0m"
utilityChoices=("NetworkManager" "xdg-utils" "fontconfig" "xorg-server" "Install All At Once" "Information About The Utilities" "Back")

while true; do
    select utility in "${utilityChoices[@]}"; do
        case $utility in
            "NetworkManager")
                yay -S --noconfirm networkmanager
                sudo systemctl enable --now NetworkManager
                break
                ;;
            "xdg-utils")
                yay -S --noconfirm xdg-utils
                break
                ;;
            "fontconfig")
                yay -S --noconfirm fontconfig
                break
                ;;
            "xorg-server")
                yay -S --noconfirm xorg-server
                break
                ;;
            "Install All At Once")
                yay -S --noconfirm networkmanager xdg-utils fontconfig xorg-server
                sudo systemctl enable --now NetworkManager
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
