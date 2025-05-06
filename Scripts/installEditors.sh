#!/bin/bash 
function checkForYay() {
if ! command -v yay &> /dev/null; then
echo "We ask that you please install Yay in order to continue."
exit 1
fi
}

checkForYay
PS3="Choose an editor to install: "
editorChoices=("NeoVim" "Visual Studio Code" "Nano" "Sublime Text" "Atom" "Information About The Text Editors" "Back")

while true; do
select editor in "${editorChoices[@]}"; do
case $editor in
"NeoVim")
sudo pacman -S neovim
;;
"Visual Studio Code")
yay -S visual-studio-code-bin
;;
"Nano")
sudo pacman -S nano
;;
"Sublime Text")
yay -S sublime-text-4
;;
"Atom")
yay -S atom
;;
"Information About The Text Editors")
echo -e "\eText Editor Information:"

echo -e "1. Neovim\n"
echo -e "Neovim is a highly extensible and customizable text editor that is a fork of vim."

echo -e "2. Visual Studio Code\n"
echo -e "Visual Studio Code is a free, powerful, and lightweight source code editor from Microsoft."

echo -e "3. Nano\n"
echo -e "Nano is a veratile and user-friendly text editor that provides essential editing capabilities."

echo -e "4. Sublime Text\n"
echo -e "Sublime Text is a sophisticated test and source code editor known for its speed, versatility, and ease of use."

echo -e "5. Atom\n"
echo -e "Atom is a free, open-source, cross-platform text editor developed by Github."
;;
"Back")
#bash UnixProject.sh
exit 0
break
;;
*)
echo -e "\033[0;31m\033[1mInvalid choice. Please try again.\033[0;31m\033[0m"
;;
esac
done
done
