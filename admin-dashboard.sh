#!/bin/bash

# ================================
# System Admin Dashboard
# Group 6
# Members:
# --------------------------------
# Okakwu Israel - 2024/12955
# Olaleye Samuel - 2024/13108
# Celestine Udichukwu - 2024/13254
# $Fadipe Oluwatomisona - 2024/13089
# Peters Moyosoreoluwa - 2024/12925
# ---------------------------------
# ================================


# Load config files
CONFIG_FILE="$(dirname "$0")/config/dashboard.conf"
[ -f "$CONFIG_FILE" ] && source "$CONFIG_FILE" || {
    echo "Error: Configuration file not found!"
    exit 1
}

# Load modules
source "$(dirname "$0")/utils/helpers.sh"
source "$(dirname "$0")/utils/logging.sh"
source "$(dirname "$0")/utils/validation.sh"

# Import all modules
for module in "$(dirname "$0")"/modules/*.sh; do
    source "$module"
done

# Main menu function
main_menu() {
    clear
    echo -e "${HEADER_COLOR}=== System Administration Dashboard ==="
    echo -e "Host: $(hostname)\t\tUser: $(whoami)"
    echo -e "============================================${RESET_COLOR}"
    
    echo -e "\n${MENU_COLOR}1. System Information${RESET_COLOR}"
    echo -e "${MENU_COLOR}2. User Management${RESET_COLOR}"
    echo -e "${MENU_COLOR}3. Process Management${RESET_COLOR}"
    echo -e "${MENU_COLOR}4. Service Management${RESET_COLOR}"
    echo -e "${MENU_COLOR}5. Network Information${RESET_COLOR}"
    echo -e "${MENU_COLOR}6. Log Analysis${RESET_COLOR}"
    echo -e "${MENU_COLOR}7. Backup Utility${RESET_COLOR}"
    echo -e "${MENU_COLOR}8. System Updates${RESET_COLOR}"
    echo -e "${MENU_COLOR}9. Security Center${RESET_COLOR}"
    echo -e "${MENU_COLOR}0. Exit${RESET_COLOR}"
    
    read -p "Select an option [0-9]: " choice
    
    case $choice in
        1) system_info_menu ;;
        2) user_management_menu ;;
        3) process_management_menu ;;
        4) service_management_menu ;;
        5) network_info_menu ;;
        6) log_analysis_menu ;;
        7) backup_utility_menu ;;
        8) system_update_menu ;;
        9) security_center_menu ;;
        0) exit 0 ;;
        *) echo -e "${ERROR_COLOR}Invalid option!${RESET_COLOR}"; sleep 1 ;;
    esac
}

# Main execution
while true; do
    main_menu
done
