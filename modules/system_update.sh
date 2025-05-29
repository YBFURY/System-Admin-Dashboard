#!/bin/bash
# System Update Module - Complete Implementation

check_updates() {
    clear
    echo -e "${HEADER_COLOR}=== Available Updates ==="
    
    if command -v apt-get &>/dev/null; then
        sudo apt update >/dev/null
        updates=$(apt list --upgradable 2>/dev/null | grep -v "^Listing...")
        if [ -z "$updates" ]; then
            echo -e "${MENU_COLOR}No updates available${RESET_COLOR}"
        else
            echo "$updates"
        fi
    elif command -v dnf &>/dev/null; then
        sudo dnf check-update
    elif command -v yum &>/dev/null; then
        sudo yum check-update
    else
        echo -e "${ERROR_COLOR}Unsupported package manager!${RESET_COLOR}"
    fi
    
    echo -e "==========================${RESET_COLOR}"
    read -p "Press [Enter] to continue..."
}

install_updates() {
    clear
    echo -e "${HEADER_COLOR}=== Install Updates ==="
    
    if command -v apt-get &>/dev/null; then
        sudo apt upgrade -y
    elif command -v dnf &>/dev/null; then
        sudo dnf upgrade -y
    elif command -v yum &>/dev/null; then
        sudo yum update -y
    else
        echo -e "${ERROR_COLOR}Unsupported package manager!${RESET_COLOR}"
        sleep 1
        return
    fi
    
    if [ $? -eq 0 ]; then
        echo -e "${MENU_COLOR}Updates installed successfully!${RESET_COLOR}"
    else
        echo -e "${ERROR_COLOR}Update failed!${RESET_COLOR}"
    fi
    sleep 1
}

update_history() {
    clear
    echo -e "${HEADER_COLOR}=== Update History ==="
    
    if command -v journalctl &>/dev/null; then
        sudo journalctl -u packagekit --no-pager | grep -i 'upgrade\|install'
    elif [ -f "/var/log/dnf.log" ]; then
        sudo tail -n 20 /var/log/dnf.log
    elif [ -f "/var/log/yum.log" ]; then
        sudo tail -n 20 /var/log/yum.log
    elif [ -f "/var/log/apt/history.log" ]; then
        sudo tail -n 20 /var/log/apt/history.log
    else
        echo -e "${ERROR_COLOR}No update history found!${RESET_COLOR}"
    fi
    
    echo -e "==========================${RESET_COLOR}"
    read -p "Press [Enter] to continue..."
}

enable_autoupdates() {
    clear
    echo -e "${HEADER_COLOR}=== Enable Auto-updates ==="
    
    if command -v dpkg-reconfigure &>/dev/null; then
        sudo dpkg-reconfigure --priority=low unattended-upgrades
    elif command -v dnf &>/dev/null; then
        sudo dnf install -y dnf-automatic
        sudo systemctl enable --now dnf-automatic.timer
    else
        echo -e "${ERROR_COLOR}Auto-updates not supported!${RESET_COLOR}"
        sleep 1
        return
    fi
    
    echo -e "${MENU_COLOR}Auto-updates enabled!${RESET_COLOR}"
    sleep 1
}

disable_autoupdates() {
    clear
    echo -e "${HEADER_COLOR}=== Disable Auto-updates ==="
    
    if command -v dpkg-reconfigure &>/dev/null; then
        sudo dpkg-reconfigure --priority=low unattended-upgrades
    elif command -v dnf &>/dev/null; then
        sudo systemctl disable --now dnf-automatic.timer
    else
        echo -e "${ERROR_COLOR}Auto-updates not supported!${RESET_COLOR}"
        sleep 1
        return
    fi
    
    echo -e "${MENU_COLOR}Auto-updates disabled!${RESET_COLOR}"
    sleep 1
}

system_update_menu() {
    while true; do
        clear
        echo -e "${HEADER_COLOR}=== System Updates ==="
        echo -e "1. Check for Updates"
        echo -e "2. Install Updates"
        echo -e "3. Update History"
        echo -e "4. Enable Auto-updates"
        echo -e "5. Disable Auto-updates"
        echo -e "0. Back to Main Menu"
        echo -e "======================${RESET_COLOR}"
        
        read -p "Select an option [0-5]: " choice
        
        case $choice in
            1) check_updates ;;
            2) install_updates ;;
            3) update_history ;;
            4) enable_autoupdates ;;
            5) disable_autoupdates ;;
            0) break ;;
            *) echo -e "${ERROR_COLOR}Invalid option!${RESET_COLOR}"; sleep 1 ;;
        esac
    done
}
