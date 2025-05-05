#!/bin/bash
function checkForYay() {
if ! command -v yay &> /dev/null; then
echo "We ask that you please install Yay in order to continue."
exit 1
fi
}

checkForYay

PS3="Choose a terminal emulator to install: "
terminalChoices=("Alacritty" "Kitty" "Foot" "URxvt" "Termite" "Information About The Terminal Emulators" "Back")

while true; do
select terminal in "${terminalChoices[@]}"; do
case $terminal in
"Alacritty")
yay -S --noconfirm alacritty
break
;;
"Kitty")
yay -S --noconfirm kitty
break
;;
"Foot")
yay -S --noconfirm foot
break
;;
"URxvt")
yay -S --noconfirm rxvt-unico
break
;;
"Termite")
yay -S --noconfirm termite
break
;;

"Information About The Terminal Emulators")
echo -e "\eTerminal Emulator Information:"
echo
break
;;
"Back")
exit 0
;;
*)
echo -e "\033[0;31m\033[1mInvalid choice. Please try again.\033[0;31m\033[0m"
break
;;
esac
done
done
