#!/bin/bash
# Service Management Module - Complete Implementation

list_services() {
    clear
    echo -e "${HEADER_COLOR}=== System Services ==="
    
    if command -v systemctl &>/dev/null; then
        systemctl list-units --type=service --no-pager --no-legend | head -n 20 | awk '{print $1, $4}'
    elif command -v service &>/dev/null; then
        service --status-all | head -n 20
    else
        echo -e "${ERROR_COLOR}No supported service manager found!${RESET_COLOR}"
    fi
    
    echo -e "==========================${RESET_COLOR}"
    read -p "Press [Enter] to continue..."
}

start_service() {
    clear
    read -p "Enter service name to start: " service
    
    if command -v systemctl &>/dev/null; then
        sudo systemctl start "$service"
    elif command -v service &>/dev/null; then
        sudo service "$service" start
    else
        echo -e "${ERROR_COLOR}No supported service manager found!${RESET_COLOR}"
        sleep 1
        return
    fi
    
    if [ $? -eq 0 ]; then
        echo -e "${MENU_COLOR}Service $service started successfully${RESET_COLOR}"
    else
        echo -e "${ERROR_COLOR}Failed to start $service${RESET_COLOR}"
    fi
    sleep 1
}

stop_service() {
    clear
    read -p "Enter service name to stop: " service
    
    if command -v systemctl &>/dev/null; then
        sudo systemctl stop "$service"
    elif command -v service &>/dev/null; then
        sudo service "$service" stop
    else
        echo -e "${ERROR_COLOR}No supported service manager found!${RESET_COLOR}"
        sleep 1
        return
    fi
    
    if [ $? -eq 0 ]; then
        echo -e "${MENU_COLOR}Service $service stopped successfully${RESET_COLOR}"
    else
        echo -e "${ERROR_COLOR}Failed to stop $service${RESET_COLOR}"
    fi
    sleep 1
}

restart_service() {
    clear
    read -p "Enter service name to restart: " service
    
    if command -v systemctl &>/dev/null; then
        sudo systemctl restart "$service"
    elif command -v service &>/dev/null; then
        sudo service "$service" restart
    else
        echo -e "${ERROR_COLOR}No supported service manager found!${RESET_COLOR}"
        sleep 1
        return
    fi
    
    if [ $? -eq 0 ]; then
        echo -e "${MENU_COLOR}Service $service restarted successfully${RESET_COLOR}"
    else
        echo -e "${ERROR_COLOR}Failed to restart $service${RESET_COLOR}"
    fi
    sleep 1
}

service_status() {
    clear
    read -p "Enter service name to check: " service
    
    echo -e "${HEADER_COLOR}=== Status of $service ==="
    
    if command -v systemctl &>/dev/null; then
        systemctl status "$service" --no-pager
    elif command -v service &>/dev/null; then
        service "$service" status
    else
        echo -e "${ERROR_COLOR}No supported service manager found!${RESET_COLOR}"
    fi
    
    echo -e "==========================${RESET_COLOR}"
    read -p "Press [Enter] to continue..."
}

toggle_boot_service() {
    clear
    echo -e "${HEADER_COLOR}=== Enable/Disable at Boot ==="
    read -p "Enter service name: " service
    
    echo -e "\n1. Enable at boot"
    echo -e "2. Disable at boot"
    read -p "Select action [1-2]: " action
    
    if command -v systemctl &>/dev/null; then
        case $action in
            1) sudo systemctl enable "$service" ;;
            2) sudo systemctl disable "$service" ;;
            *) echo -e "${ERROR_COLOR}Invalid choice!${RESET_COLOR}"; return ;;
        esac
    else
        echo -e "${ERROR_COLOR}Auto-start management requires systemd!${RESET_COLOR}"
        sleep 1
        return
    fi
    
    if [ $? -eq 0 ]; then
        echo -e "${MENU_COLOR}Operation completed successfully${RESET_COLOR}"
    else
        echo -e "${ERROR_COLOR}Operation failed!${RESET_COLOR}"
    fi
    sleep 1
}

service_management_menu() {
    while true; do
        clear
        echo -e "${HEADER_COLOR}=== Service Management ==="
        echo -e "1. List All Services"
        echo -e "2. Start Service"
        echo -e "3. Stop Service"
        echo -e "4. Restart Service"
        echo -e "5. Service Status"
        echo -e "6. Enable/Disable at Boot"
        echo -e "0. Back to Main Menu"
        echo -e "========================${RESET_COLOR}"
        
        read -p "Select an option [0-6]: " choice
        
        case $choice in
            1) list_services ;;
            2) start_service ;;
            3) stop_service ;;
            4) restart_service ;;
            5) service_status ;;
            6) toggle_boot_service ;;
            0) break ;;
            *) echo -e "${ERROR_COLOR}Invalid option!${RESET_COLOR}"; sleep 1 ;;
        esac
    done
}
