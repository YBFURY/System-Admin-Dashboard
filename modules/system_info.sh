#!/bin/bash
# System Information Module

system_info_menu() {
    while true; do
        clear
        echo -e "${HEADER_COLOR}=== System Information ==="
        echo -e "1. Overview"
        echo -e "2. CPU Information"
        echo -e "3. Memory Usage"
        echo -e "4. Disk Usage"
        echo -e "5. Temperature"
        echo -e "6. Load Averages"
        echo -e "0. Back to Main Menu"
        echo -e "==========================${RESET_COLOR}"
        
        read -p "Select an option [0-6]: " choice
        
        case $choice in
            1) show_system_overview ;;
            2) show_cpu_info ;;
            3) show_memory_info ;;
            4) show_disk_info ;;
            5) show_temperature ;;
            6) show_load_averages ;;
            0) break ;;
            *) echo -e "${ERROR_COLOR}Invalid option!${RESET_COLOR}"; sleep 1 ;;
        esac
    done
}

show_system_overview() {
    clear
    echo -e "${HEADER_COLOR}=== System Overview ==="
    echo -e "Hostname: $(hostname)"
    echo -e "Operating System: $(source /etc/os-release; echo "$PRETTY_NAME")"
    echo -e "Kernel Version: $(uname -r)"
    echo -e "Architecture: $(uname -m)"
    echo -e "Uptime: $(uptime -p)"
    echo -e "========================${RESET_COLOR}"
    read -p "Press [Enter] to continue..."
}
