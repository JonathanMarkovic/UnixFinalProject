#!/bin/bash

function checkForYay() {
    if ! command -v yay &> /dev/null; then
        echo -e "\033[0;31mWe ask that you please install Yay in order to continue.\033[0m"
        exit 1
    fi
}

checkForYay

PS3="\033[38;2;173;216;230mChoose a file manager to install: \033[0m"
fileManagerChoices=("Thunar" "PCManFM" "XFE" "Nemo" "SpaceFM" "Information About The File Managers" "Back")

while true; do
    select fileManager in "${fileManagerChoices[@]}"; do
        case $fileManager in
            "Thunar")
                yay -S --noconfirm thunar
                break
                ;;
            "PCManFM")
                yay -S --noconfirm pcmanfm
                break
                ;;
            "XFE")
                yay -S --noconfirm xfe
                break
                ;;
            "Nemo")
                yay -S --noconfirm nemo
                break
                ;;
            "SpaceFM")
                yay -S --noconfirm spacefm
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
