#!/bin/bash 

function checkForYay() {
    if ! command -v yay &> /dev/null; then
        echo -e "\033[0;31mWe ask that you please install Yay in order to continue.\033[0m"
        exit 1
    fi
}

checkForYay

PS3="\033[38;2;173;216;230mChoose an editor to install: \033[0m"
editorChoices=("NeoVim" "Visual Studio Code" "Nano" "Sublime Text" "Atom" "Information About The Text Editors" "Back")

while true; do
    select editor in "${editorChoices[@]}"; do
        case $editor in
            "NeoVim")
                sudo pacman -S neovim
                break
                ;;
            "Visual Studio Code")
                yay -S visual-studio-code-bin
                break
                ;;
            "Nano")
                sudo pacman -S nano
                break
                ;;
            "Sublime Text")
                yay -S sublime-text-4
                break
                ;;
            "Atom")
                yay -S atom
                break
                ;;
            "Information About The Text Editors")
                echo -e "\033[38;2;173;216;230mText Editor Information:\033[0m"

                echo -e "\033[38;2;173;216;230m1. Neovim\033[0m\n"
                echo -e "Neovim is a highly extensible and customizable text editor that is a fork of vim.\n"

                echo -e "\033[38;2;173;216;230m2. Visual Studio Code\033[0m\n"
                echo -e "Visual Studio Code is a free, powerful, and lightweight source code editor from Microsoft.\n"

                echo -e "\033[38;2;173;216;230m3. Nano\033[0m\n"
                echo -e "Nano is a versatile and user-friendly text editor that provides essential editing capabilities.\n"

                echo -e "\033[38;2;173;216;230m4. Sublime Text\033[0m\n"
                echo -e "Sublime Text is a sophisticated text and source code editor known for its speed, versatility, and ease of use.\n"

                echo -e "\033[38;2;173;216;230m5. Atom\033[0m\n"
                echo -e "Atom is a free, open-source, cross-platform text editor developed by GitHub.\n"
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
