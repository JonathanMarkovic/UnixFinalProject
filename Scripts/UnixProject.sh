#!/bin/bash

displayIntroScreen() {
    clear
    echo -e "\033[38;2;23;147;209m
                   ▄
                  ▟█▙
                 ▟███▙
                ▟█████▙
               ▟███████▙
              ▂▔▀▜██████▙
             ▟██▅▂▝▜█████▙
            ▟█████████████▙
           ▟███████████████▙
          ▟█████████████████▙
         ▟███████████████████▙
        ▟█████████▛▀▀▜████████▙
       ▟████████▛      ▜███████▙
      ▟█████████        ████████▙
     ▟██████████        █████▆▅▄▃▂
    ▟██████████▛        ▜█████████▙
   ▟██████▀▀▀              ▀▀██████▙
  ▟███▀▘                       ▝▀███▙
 ▟▛▀                               ▀▜▙
\033[0m"

    tput cup 2 40
    echo -e "\033[38;2;173;216;230mWelcome to Arch Made Easy - Your Friend That Simplifies Your Arch Linux Setup! \033[0m"
    tput cup 4 40
    echo -e "\033[38;2;173;216;230mMade by Matthew Pietracupa, Jonathan Markovic & Iulia Apintilioaie\e[0m"
    tput cup 6 40
    echo -e "\033[38;2;173;216;230mPlease press any key to proceed...\033[0m"
    read -n 1 -s
    clear
    displayMainMenu
}

mainMenu() {
    displayIntroScreen
    displayCategories
    mainMenuOption
}

displayCategories() {
    clear
    tput cup 2 40
    echo -e "\033[38;2;173;216;230mPlease choose a category to install: \033[0m"
    echo -e "\033[38;2;173;216;230m1. Code Editors   \033[0m"
    echo -e "\033[38;2;173;216;230m2. Browsers    \033[0m"
    echo -e "\033[38;2;173;216;230m3. File Managers  \033[0m"
    echo -e "\033[38;2;173;216;230m4. Terminal Emulators  \033[0m"
    echo -e "\033[38;2;173;216;230m5. Desktop Environment    \033[0m"
    echo -e "\033[38;2;173;216;230m6. System Utilities    \033[0m"
    echo -e "\033[38;2;173;216;230m7. Quit \033[0m"
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

