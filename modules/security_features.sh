#!/bin/bash
# Security Features Module - Complete Implementation

run_security_audit() {
    clear
    echo -e "${HEADER_COLOR}=== Security Audit Report ==="
    
    # User accounts check
    echo -e "\n${MENU_COLOR}1. User Accounts:${RESET_COLOR}"
    echo "Root users: $(grep ':0:' /etc/passwd | wc -l)"
    echo "Users with no password: $(awk -F: '($2 == "") {print $1}' /etc/shadow | wc -l)"
    
    # SSH security
    echo -e "\n${MENU_COLOR}2. SSH Configuration:${RESET_COLOR}"
    grep -i '^PermitRootLogin\|^PasswordAuthentication\|^AllowUsers' /etc/ssh/sshd_config
    
    # Firewall status
    echo -e "\n${MENU_COLOR}3. Firewall Status:${RESET_COLOR}"
    if command -v ufw &>/dev/null; then
        sudo ufw status verbose
    elif command -v firewall-cmd &>/dev/null; then
        sudo firewall-cmd --state
    else
        echo "No firewall manager detected"
    fi
    
    # SUID files
    echo -e "\n${MENU_COLOR}4. SUID Files:${RESET_COLOR}"
    find / -type f -perm -4000 2>/dev/null | head -n 10
    
    echo -e "==================================${RESET_COLOR}"
    read -p "Press [Enter] to continue..."
}

check_open_ports() {
    clear
    echo -e "${HEADER_COLOR}=== Open Ports ==="
    
    if command -v ss &>/dev/null; then
        sudo ss -tulnp
    elif command -v netstat &>/dev/null; then
        sudo netstat -tulnp
    else
        echo -e "${ERROR_COLOR}No network tools available!${RESET_COLOR}"
    fi
    
    echo -e "==========================${RESET_COLOR}"
    read -p "Press [Enter] to continue..."
}

show_login_history() {
    clear
    echo -e "${HEADER_COLOR}=== User Login History ==="
    echo -e "Recent logins:"
    last -n 10
    echo -e "\nFailed logins:"
    lastb -n 5
    echo -e "==========================${RESET_COLOR}"
    read -p "Press [Enter] to continue..."
}

show_failed_logins() {
    clear
    echo -e "${HEADER_COLOR}=== Failed Login Attempts ==="
    echo -e "Count\tIP Address\t\tUser"
    echo -e "----------------------------------"
    sudo lastb | awk '{print $3}' | sort | uniq -c | sort -nr | head -n 10
    echo -e "==========================${RESET_COLOR}"
    read -p "Press [Enter] to continue..."
}

file_integrity_check() {
    clear
    read -p "Enter directory to check: " check_dir
    
    if [ ! -d "$check_dir" ]; then
        echo -e "${ERROR_COLOR}Directory does not exist!${RESET_COLOR}"
        sleep 1
        return
    fi
    
    echo -e "${HEADER_COLOR}=== File Integrity Check for $check_dir ==="
    echo -e "Checking for suspicious files..."
    
    # Find world-writable files
    echo -e "\n${WARNING_COLOR}World-writable files:${RESET_COLOR}"
    find "$check_dir" -type f -perm -o+w -ls 2>/dev/null | head -n 10
    
    # Find files with no owner
    echo -e "\n${WARNING_COLOR}Files with no owner:${RESET_COLOR}"
    find "$check_dir" -nouser -ls 2>/dev/null | head -n 10
    
    echo -e "==========================${RESET_COLOR}"
    read -p "Press [Enter] to continue..."
}

firewall_status() {
    clear
    echo -e "${HEADER_COLOR}=== Firewall Status ==="
    
    if command -v ufw &>/dev/null; then
        sudo ufw status verbose
    elif command -v firewall-cmd &>/dev/null; then
        sudo firewall-cmd --state
        sudo firewall-cmd --list-all
    elif command -v iptables &>/dev/null; then
        sudo iptables -L -n -v
    else
        echo -e "${ERROR_COLOR}No firewall manager detected!${RESET_COLOR}"
    fi
    
    echo -e "==========================${RESET_COLOR}"
    read -p "Press [Enter] to continue..."
}

security_center_menu() {
    while true; do
        clear
        echo -e "${HEADER_COLOR}=== Security Center ==="
        echo -e "1. System Audit"
        echo -e "2. Check Open Ports"
        echo -e "3. User Login History"
        echo -e "4. Failed Login Attempts"
        echo -e "5. File Integrity Check"
        echo -e "6. Firewall Status"
        echo -e "0. Back to Main Menu"
        echo -e "=======================${RESET_COLOR}"
        
        read -p "Select an option [0-6]: " choice
        
        case $choice in
            1) run_security_audit ;;
            2) check_open_ports ;;
            3) show_login_history ;;
            4) show_failed_logins ;;
            5) file_integrity_check ;;
            6) firewall_status ;;
            0) break ;;
            *) echo -e "${ERROR_COLOR}Invalid option!${RESET_COLOR}"; sleep 1 ;;
        esac
    done
}
