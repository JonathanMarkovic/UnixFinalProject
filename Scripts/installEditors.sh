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
    if ! ping -q -c 1 -W 2 archlinux.org &>/dev/null; then
        echo -e "\033[0;31mNo internet connection. Please check your network.\033[0m"
        exit 1
    fi
}

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

checkNetwork
checkInstallers

PS3="\033[38;2;173;216;230mChoose an editor to install: \033[0m"
editorChoices=("NeoVim" "Visual Studio Code" "Nano" "Sublime Text" "Atom" "Information About The Text Editors" "Back")

while true; do
    select editor in "${editorChoices[@]}"; do
        case $editor in
            "NeoVim")
                if checkStorage 200; then
                    sudo pacman -S --noconfirm neovim
                fi
                break
                ;;
            "Visual Studio Code")
                if checkStorage 400; then
                    yay -S --noconfirm visual-studio-code-bin
                fi
                break
                ;;
            "Nano")
                if checkStorage 50; then
                    sudo pacman -S --noconfirm nano
                fi
                break
                ;;
            "Sublime Text")
                if checkStorage 350; then
                    yay -S --noconfirm sublime-text-4
                fi
                break
                ;;
            "Atom")
                if checkStorage 450; then
                    yay -S --noconfirm atom
                fi
                break
                ;;
                "Information About The Text Editors")
                echo -e "\033[38;2;173;216;230mText Editor Information:\033[0m"
                echo
                echo -e "\033[38;2;173;216;230m1. Neovim\033[0m: A highly extensible and customizable text editor that is a fork of Vim."
                echo -e "\033[38;2;173;216;230m2. Visual Studio Code\033[0m: A free, powerful, and lightweight source code editor from Microsoft."
                echo -e "\033[38;2;173;216;230m3. Nano\033[0m: A versatile and user-friendly text editor that provides essential editing capabilities."
                echo -e "\033[38;2;173;216;230m4. Sublime Text\033[0m: A sophisticated text and source code editor known for its speed, versatility, and ease of use."
                echo -e "\033[38;2;173;216;230m5. Atom\033[0m: A free, open-source, cross-platform text editor developed by GitHub."
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
