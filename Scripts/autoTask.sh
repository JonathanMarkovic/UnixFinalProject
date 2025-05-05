#!/bin/bash

function checkForYay() {
    if ! command -v yay &> /dev/null; then
        echo "We ask that you please install Yay in order to continue."
        exit 1
    fi
}

function setUpdateFrequency() {
    if [ ! -f "$HOME/.update_frequency" ]; then
        echo "Please select how often you want to be prompted for updates:"
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
                *) echo "Invalid option. Please try again." ;;
            esac
        done
    fi
}

function promptForUpdate() {
    local FREQUENCY=$(cat "$HOME/.update_frequency")
    local LAST_PROMPT_FILE="$HOME/.last_update_prompt"
    local CURRENT_TIME=$(date +%s)

    if [ ! -f "$LAST_PROMPT_FILE" ]; then
        return 0  # Prompt if the file doesn't exist
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

function createSystemdService() {
    local SERVICE_FILE="/etc/systemd/system/update-check.service"
    
    if [ ! -f "$SERVICE_FILE" ]; then
        echo "Creating systemd service for update check..."
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
        echo "Systemd service created and enabled."
    else
        echo "Systemd service already exists."
    fi
}

checkForYay

setUpdateFrequency

createSystemdService

if promptForUpdate; then
    if [ "$(checkupdates | wc -l)" -gt 0 ]; then
        echo "Updates are available. Do you want to proceed with the update? (y/n)"
        read -r response
        if [[ "$response" == "y" ]]; then
            sudo pacman -Syu
            echo "Updates completed."
        else
            echo "Update canceled."
        fi
    else
        echo "No updates available."
    fi
    echo "$(date +%s)" > "$HOME/.last_update_prompt"
fi
