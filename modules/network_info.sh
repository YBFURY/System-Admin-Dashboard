#!/bin/bash
# Network Information Module - Complete Implementation

show_interfaces() {
    clear
    echo -e "${HEADER_COLOR}=== Network Interfaces ==="
    echo -e "${MENU_COLOR}Active Interfaces:${RESET_COLOR}"
    ip -br -c addr show | grep -v "DOWN"
    
    echo -e "\n${MENU_COLOR}All Interfaces:${RESET_COLOR}"
    ip -br -c link show
    
    echo -e "\n${MENU_COLOR}Routing Table:${RESET_COLOR}"
    ip -br -c route show
    
    echo -e "============================${RESET_COLOR}"
    read -p "Press [Enter] to continue..."
}

show_routing_table() {
    clear
    echo -e "${HEADER_COLOR}=== Routing Table ==="
    ip -br -c route show
    echo -e "\n${MENU_COLOR}ARP Table:${RESET_COLOR}"
    ip -br -c neigh show
    echo -e "============================${RESET_COLOR}"
    read -p "Press [Enter] to continue..."
}

show_open_ports() {
    clear
    echo -e "${HEADER_COLOR}=== Open Ports ==="
    
    if command -v ss &>/dev/null; then
        sudo ss -tulnp
    elif command -v netstat &>/dev/null; then
        sudo netstat -tulnp
    else
        echo -e "${ERROR_COLOR}No supported network tools found!${RESET_COLOR}"
    fi
    
    echo -e "============================${RESET_COLOR}"
    read -p "Press [Enter] to continue..."
}

show_connections() {
    clear
    echo -e "${HEADER_COLOR}=== Active Connections ==="
    
    if command -v ss &>/dev/null; then
        sudo ss -tup
    elif command -v netstat &>/dev/null; then
        sudo netstat -tup
    else
        echo -e "${ERROR_COLOR}No supported network tools found!${RESET_COLOR}"
    fi
    
    echo -e "============================${RESET_COLOR}"
    read -p "Press [Enter] to continue..."
}

run_ping_test() {
    clear
    read -p "Enter host to ping: " host
    
    if [ -z "$host" ]; then
        echo -e "${ERROR_COLOR}Host cannot be empty!${RESET_COLOR}"
        sleep 1
        return
    fi
    
    echo -e "${HEADER_COLOR}=== Ping Results: $host ==="
    ping -c 4 "$host"
    echo -e "============================${RESET_COLOR}"
    read -p "Press [Enter] to continue..."
}

show_dns_info() {
    clear
    echo -e "${HEADER_COLOR}=== DNS Information ==="
    echo -e "${MENU_COLOR}Resolv.conf:${RESET_COLOR}"
    cat /etc/resolv.conf
    
    echo -e "\n${MENU_COLOR}Current DNS:${RESET_COLOR}"
    if command -v nmcli &>/dev/null; then
        nmcli dev show | grep DNS
    else
        echo "No nmcli available"
    fi
    
    echo -e "\n${MENU_COLOR}Test DNS Resolution:${RESET_COLOR}"
    nslookup google.com
    
    echo -e "============================${RESET_COLOR}"
    read -p "Press [Enter] to continue..."
}

show_bandwidth() {
    clear
    echo -e "${HEADER_COLOR}=== Bandwidth Usage ==="
    
    if command -v iftop &>/dev/null; then
        echo "Running iftop for 10 seconds..."
        sudo iftop -t -s 10
    elif command -v nload &>/dev/null; then
        nload
    else
        echo -e "${ERROR_COLOR}No bandwidth monitoring tools installed!${RESET_COLOR}"
        echo "Install iftop or nload to use this feature"
    fi
    
    echo -e "============================${RESET_COLOR}"
    read -p "Press [Enter] to continue..."
}

network_info_menu() {
    while true; do
        clear
        echo -e "${HEADER_COLOR}=== Network Information ==="
        echo -e "1. Interface Configuration"
        echo -e "2. Routing Table"
        echo -e "3. Open Ports"
        echo -e "4. Network Connections"
        echo -e "5. Ping Test"
        echo -e "6. DNS Information"
        echo -e "7. Bandwidth Usage"
        echo -e "0. Back to Main Menu"
        echo -e "==========================${RESET_COLOR}"
        
        read -p "Select an option [0-7]: " choice
        
        case $choice in
            1) show_interfaces ;;
            2) show_routing_table ;;
            3) show_open_ports ;;
            4) show_connections ;;
            5) run_ping_test ;;
            6) show_dns_info ;;
            7) show_bandwidth ;;
            0) break ;;
            *) echo -e "${ERROR_COLOR}Invalid option!${RESET_COLOR}"; sleep 1 ;;
        esac
    done
}
