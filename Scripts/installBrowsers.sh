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
select browser in "${browsersChoices[@]}"; do
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

echo -e "1. Firefox\n"
echo -e "Firefox is an open-source browser from Mozilla that puts privacy and customization front and center. It blocks trackers and ads by default, and it’s easy to use with tons of extensions. Firefox makes a good choice if you like having customizing your browsing experience and care about privacy.\n"

echo -e "2. Chromium\n"
echo -e "Chromium is basically the open-source version of Google Chrome. It’s fast, lightweight, and supports all the same extensions, but it doesn’t come with Google’s features like account syncing or DRM support. Chromium is good if you want something that works like Chrome but with a bit more freedom and less tracking.\n"

echo -e "3. Brave\n"
echo -e "Brave is a browser focused on privacy—it blocks ads and trackers by default, and it even lets you earn cryptocurrency (BAT - Basic Attention Token) by watching privacy-respecting ads. Plus, it has built-in Tor integration for even more anonymity. If you’re all about privacy and want to block ads while still earning rewards, Brave’s a great option. It’s perfect for anyone who wants a browser that respects your data and privacy.\n"

echo -e "4. Opera\n"
echo -e "Opera is a feature-packed browser based on Chromium. It comes with built-in tools like a VPN, an ad blocker, and even social media messengers (like WhatsApp and Facebook Messenger) right in the sidebar it has. Opera also has a Turbo mode for slower networks and a battery saver for laptops. If you like having everything in one place and want some extra features like a built-in VPN, Opera’s definitely worth a try. It’s a good choice for anyone who wants a more all-around browser with a lot of convenient tools.\n"

echo -e "5. Onion Browser\n"
echo -e "The Onion Browser is all about remaining anonymous. It routes your internet traffic through the Tor network, keeping your identity and location hidden. It’s the go-to choice if you need extra privacy or plan to visit sketchy sites. Onion is good if staying completely anonymous online is your priority. Just keep in mind it can be slower than other browsers since your traffic is being encrypted and routed through multiple servers.\n"

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
