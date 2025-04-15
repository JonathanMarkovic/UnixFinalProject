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
select editor in "${editors[@]}"; do
case $editorChoices in
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
echo
;;
"Back")
break
;;
*)
echo -e "\033[0;31m\033[1mInvalid choice. Please try again.\033[0;31m\033[0m"
;;
esac
done
done
