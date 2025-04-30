#!/bin/bash

displayIntroScreen() {
clear
echo -e "\e[1;4;100mWelcome to Arch Made Easy - Your Friend That Simplifies Your Arch Linux Setup! \e[0m"
echo -e "\e[1;4;100mMade by Matthew Pietracupa, Jonathan Markovic & Iulia Apintilioaie\e[0m"
echo
echo -e "\e[0mPlease press any key to proceed with the application...\e[0m"
read -n 1 -s
}

mainMenu() {
displayIntroScreen
displayCategories
mainMenuOption
}

displayCategories() {
clear
echo -e "\033[1;36m\033[4mPlease choose a category to install: \033[0m"
echo -e "\033[1m1. Code Editors   \033[0m"
echo -e "\033[1m2. Browsers    \033[0m"
echo -e "\033[1m3. File Managers  \033[0m"
echo -e "\033[1m4. Terminal Emulators  \033[0m"
echo -e "\033[1m5. Desktop Environment    \033[0m"
echo -e "\033[1m6. System Utilities    \033[0m"
echo -e "\033[0;31m\033[1m7. Quit \033[0;31m\033[0m"
}

mainMenuOption() {
    while true; do
        echo
        read -p "Please select a choice from 1-7: " choice
        case $choice in
        1)
            loadingAnimation
            bash installEditors.sh
            ;;
        2)
            loadingAnimation
            bash installBrowsers.sh
            ;;
        3)
            loadingAnimation
            bash installFileManagers.sh
            ;;
        4)
            loadingAnimation
            bash installTerminals.sh
            ;;
        5)
            loadingAnimation
            bash installDesktop.sh
            ;;
        6)
            loadingAnimation
            bash installUtilities.sh
            ;;
        7)
            echo -e "\033[1mThank you for using our Arch Made Easy program!\033[0m"
            sleep 2
            clear
            exit
            ;;
        *)
            echo -e "\033[0;31m\033[1mInvalid choice. Please try again.\033[0;31m\033[0m"
            sleep 1
            ;;
        esac
    done
}

loadingAnimation() {
echo -e "\033[1mLoading...\033[0m"
sleep 1
}
mainMenu
