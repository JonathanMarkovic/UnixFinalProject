#!/bin/bash

function checkForYay() {
    if ! command -v yay &> /dev/null; then
        echo -e "\033[0;31mWe ask that you please install Yay in order to continue.\033[0m"
        exit 1
    fi
}

function setUpdateFrequency() {
    if [ ! -f "$HOME/.update_frequency" ]; then
        echo -e "\033[38;2;173;216;230mPlease select how often you want to be prompted for updates:\033[0m"
        PS3="Choose an option: "
        options=("Daily" "Weekly" "Never")
        select opt in "${options[@]}"; do
            case $opt in
                "Daily")
                    echo "daily" > "$HOME/.update_frequency"
                    break
                    ;;
                "Weekly")
                    echo "weekly" > "$HOME/.update_frequency"
                    break
                    ;;
                "Never")
                    echo "never" > "$HOME/.update_frequency"
                    break
                    ;;
                *) echo -e "\033[0;31mInvalid option. Please try again.\033[0m" ;;
            esac
        done
    fi
}

function promptForUpdate() {
    local FREQUENCY=$(cat "$HOME/.update_frequency")
    local LAST_PROMPT_FILE="$HOME/.last_update_prompt"
    local CURRENT_TIME=$(date +%s)

    if [ ! -f "$LAST_PROMPT_FILE" ]; then
        return 0
    fi

    local LAST_PROMPT_TIME=$(cat "$LAST_PROMPT_FILE")

    case "$FREQUENCY" in
        daily)
            if (( CURRENT_TIME - LAST_PROMPT_TIME >= 86400 )); then
                return 0
            fi
            ;;
        weekly)
            if (( CURRENT_TIME - LAST_PROMPT_TIME >= 604800 )); then
                return 0
            fi
            ;;
        never)
            return 1 
            ;;
    esac

    return 1 
}

function createSystemdService() {
    local SERVICE_FILE="/etc/systemd/system/update-check.service"
    
    if [ ! -f "$SERVICE_FILE" ]; then
        echo -e "\033[38;2;173;216;230mCreating systemd service for update check...\033[0m"
        sudo bash -c "cat > $SERVICE_FILE" <<EOL
[Unit]
Description=Check for system updates

[Service]
ExecStart=/path/to/your/script.sh
Type=simple

[Install]
WantedBy=multi-user.target
EOL
        sudo systemctl enable update-check.service
        echo -e "\033[38;2;173;216;230mSystemd service created and enabled.\033[0m"
    else
        echo -e "\033[38;2;173;216;230mSystemd service already exists.\033[0m"
    fi
}

checkForYay

setUpdateFrequency

createSystemdService

if promptForUpdate; then
    if [ "$(checkupdates | wc -l)" -gt 0 ]; then
        echo -e "\033[38;2;173;216;230mUpdates are available. Do you want to proceed with the update? (y/n)\033[0m"
        read -r response
        if [[ "$response" == "y" ]]; then
            sudo pacman -Syu
            echo -e "\033[38;2;173;216;230mUpdates completed.\033[0m"
        else
            echo -e "\033[38;2;173;216;230mUpdate canceled.\033[0m"
        fi
    else
        echo -e "\033[38;2;173;216;230mNo updates available.\033[0m"
    fi
    echo "$(date +%s)" > "$HOME/.last_update_prompt"
fi

bash UnixProject.sh
