#!/bin/bash
# User Management Module - Complete Implementation

list_users() {
    clear
    echo -e "${HEADER_COLOR}=== User List ==="
    printf "%-15s %-10s %-15s %-20s %-15s\n" "Username" "UID" "Group" "Home" "Shell"
    echo "------------------------------------------------------------------"
    
    while IFS=: read -r username _ uid gid _ home shell; do
        groupname=$(getent group "$gid" | cut -d: -f1)
        printf "%-15s %-10s %-15s %-20s %-15s\n" "$username" "$uid" "$groupname" "$home" "$shell"
    done < /etc/passwd
    
    echo -e "==========================================================${RESET_COLOR}"
    read -p "Press [Enter] to continue..."
}

add_user() {
    clear
    echo -e "${HEADER_COLOR}=== Add New User ==="
    read -p "Enter username: " username
    
    if ! [[ "$username" =~ ^[a-z_][a-z0-9_-]*$ ]]; then
        echo -e "${ERROR_COLOR}Invalid username! Must start with letter/underscore${RESET_COLOR}"
        sleep 1
        return
    fi
    
    if id "$username" &>/dev/null; then
        echo -e "${ERROR_COLOR}User $username already exists!${RESET_COLOR}"
        sleep 1
        return
    fi
    
    read -p "Create home directory? [Y/n]: " create_home
    read -p "Set password for $username? [Y/n]: " set_pass
    
    home_opts=""
    [[ "$create_home" =~ ^[nN] ]] || home_opts="-m"
    
    if useradd $home_opts "$username"; then
        echo -e "${MENU_COLOR}User $username created successfully${RESET_COLOR}"
        
        if [[ "$set_pass" =~ ^[nN] ]]; then
            echo -e "${WARNING_COLOR}No password set for $username${RESET_COLOR}"
        else
            passwd "$username"
        fi
    else
        echo -e "${ERROR_COLOR}Failed to create user $username${RESET_COLOR}"
    fi
    sleep 1
}

delete_user() {
    clear
    echo -e "${HEADER_COLOR}=== Delete User ==="
    read -p "Enter username to delete: " username
    
    if ! id "$username" &>/dev/null; then
        echo -e "${ERROR_COLOR}User $username does not exist!${RESET_COLOR}"
        sleep 1
        return
    fi
    
    read -p "Remove home directory? [y/N]: " remove_home
    read -p "Force delete if user is logged in? [y/N]: " force
    
    del_opts=""
    [[ "$remove_home" =~ ^[yY] ]] && del_opts="-r"
    [[ "$force" =~ ^[yY] ]] && del_opts+=" -f"
    
    if userdel $del_opts "$username"; then
        echo -e "${MENU_COLOR}User $username deleted successfully${RESET_COLOR}"
    else
        echo -e "${ERROR_COLOR}Failed to delete user $username${RESET_COLOR}"
    fi
    sleep 1
}

modify_user() {
    clear
    echo -e "${HEADER_COLOR}=== Modify User ==="
    read -p "Enter username to modify: " username
    
    if ! id "$username" &>/dev/null; then
        echo -e "${ERROR_COLOR}User $username does not exist!${RESET_COLOR}"
        sleep 1
        return
    fi
    
    echo -e "\n${MENU_COLOR}1. Change password"
    echo -e "2. Change shell"
    echo -e "3. Change home directory"
    echo -e "4. Add to group"
    echo -e "5. Remove from group"
    echo -e "6. Lock account"
    echo -e "7. Unlock account${RESET_COLOR}"
    
    read -p "Select modification [1-7]: " mod_choice
    
    case $mod_choice in
        1) passwd "$username" ;;
        2) 
            read -p "Enter new shell path: " new_shell
            chsh -s "$new_shell" "$username" 
            ;;
        3)
            read -p "Enter new home directory: " new_home
            usermod -d "$new_home" "$username"
            ;;
        4)
            read -p "Enter group to add to: " group
            usermod -aG "$group" "$username"
            ;;
        5)
            read -p "Enter group to remove from: " group
            gpasswd -d "$username" "$group"
            ;;
        6) usermod -L "$username" ;;
        7) usermod -U "$username" ;;
        *) echo -e "${ERROR_COLOR}Invalid choice!${RESET_COLOR}" ;;
    esac
    sleep 1
}

user_details() {
    clear
    read -p "Enter username: " username
    
    if ! id "$username" &>/dev/null; then
        echo -e "${ERROR_COLOR}User $username does not exist!${RESET_COLOR}"
        sleep 1
        return
    fi
    
    echo -e "${HEADER_COLOR}=== User Details: $username ==="
    echo -e "${MENU_COLOR}Account Information:${RESET_COLOR}"
    finger "$username" 2>/dev/null || grep "^$username:" /etc/passwd
    
    echo -e "\n${MENU_COLOR}Group Memberships:${RESET_COLOR}"
    groups "$username"
    
    echo -e "\n${MENU_COLOR}Password Status:${RESET_COLOR}"
    passwd -S "$username"
    
    echo -e "\n${MENU_COLOR}Recent Logins:${RESET_COLOR}"
    lastlog -u "$username"
    echo -e "====================================${RESET_COLOR}"
    read -p "Press [Enter] to continue..."
}

user_management_menu() {
    while true; do
        clear
        echo -e "${HEADER_COLOR}=== User Management ==="
        echo -e "1. List All Users"
        echo -e "2. Add User"
        echo -e "3. Delete User"
        echo -e "4. Modify User"
        echo -e "5. User Details"
        echo -e "0. Back to Main Menu"
        echo -e "======================${RESET_COLOR}"
        
        read -p "Select an option [0-5]: " choice
        
        case $choice in
            1) list_users ;;
            2) add_user ;;
            3) delete_user ;;
            4) modify_user ;;
            5) user_details ;;
            0) break ;;
            *) echo -e "${ERROR_COLOR}Invalid option!${RESET_COLOR}"; sleep 1 ;;
        esac
    done
}
