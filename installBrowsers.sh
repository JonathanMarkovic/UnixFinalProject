#!/bin/bash 
function checkForYay() {
if ! command -v yay &> /dev/null; then
echo "We ask that you please install Yay in order to continue."
exit 1
fi
}

checkForYay

PS3="Choose a browser to install: "
browsersChoices=("Firefox" "Chromium" "Brave" "Opera" "Onion Browser" "Information About The Browsers" "Back")

while true; do
select browser in "${browsersChoice[@]}"; do
case $browser in
"Firefox")
yay -S --noconfirm firefox
yay -S --noconfirm firefox-ublock-origin
break
;;
"Chromium")
yay -S --noconfirm chromium
break
;;
"Brave")
yay -S --noconfirm brave-bin
break
;;
"Opera")
yay -S --noconfirm opera
break
;;
"Onion Browser")
yay -S --noconfirm torbrowser-launcher
break
;;
"Information About The Browsers")
echo -e "\eBrowser Information:"
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
