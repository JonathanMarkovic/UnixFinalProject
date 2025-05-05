#!/bin/bash
function checkForYay() {
if ! command -v yay &> /dev/null; then
echo "We ask that you please install Yay in order to continue."
exit 1
fi
}

checkForYay

PS3="Choose a utility to install: "
utilityChoices=("NetworkManager" "xdg-utils" "fontconfig" "xorg-server" "Install All At Once" "Information About The Utilities" "Back")

while true; do
select utility in "${utilityChoices[@]}"; do
case $utility in
"NetworkManager")
yay -S --noconfirm networkManager
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
"Install All")
yay -S --noconfirm networkManager xdg-utils fontconfig xorg-server
sudo systemctl enable --now NetworkManager
break
;;
"Information About The Utilities")
echo -e "\eUTilities Information:"
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

