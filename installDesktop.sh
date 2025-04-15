#!/bin/bash
function checkForYay() {
if ! command -v yay &> /dev/null; then
echo "We ask that you please install Yay in order to continue."
exit 1
fi
}

checkForYay

PS3="Choose a desktop environment to install: "
desktopEnvironmentChoices=("Sway" "GNOME" "Plasma" "Cinnamon" "Budgie" "Information About The Desktop Environments" "Back")

while true; do
select desktopenv in "${desktopEnvironmentChoices[@]}"; do
case $desktopenv in
"Sway")
yay -S --noconfirm sway
break
;;
"GNOME")
yay -S --noconfirm gnome
break
;;
"Plasma")
yay -S --noconfirm plasma-meta
break
;;
"Cinnamon")
yay -S --noconfirm cinnamon
break
;;
"Budgie")
yay -S --noconfirm budgie-desktop
break
;;
"Information About The Desktop Environments")
echo -e "\eDesktop Environment Information:"
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

