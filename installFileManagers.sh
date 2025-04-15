#!/bin/bash
function checkForYay() {
if ! command -v yay &> /dev/null; then
echo "We ask that you please install Yay in order to continue."
exit 1
fi
}

checkForYay

PS3="Choose a file manager to install: "
fileManagerChoices=("Thunar" "PCManFM" "XFE" "Nemo" "SpaceFM" "Information About The Terminal Emulators" "Back")

while true; do
select fileManager in "${fileManagerChoices[@]}"; do
case $fileManager in
"Thundar")
yay -S --noconfirm thundar
break
;;
"PCMAnFM")
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
"Information About The File Manager")
echo -e "\eFile Manager Information:"
echo
break
;;
"Back")
exit 0
;;
*)
echo -e "\033[0;31m\033[1mInvalid choice. Please try again.\033[0;31m\033[0m"
;;
esac
done
done
