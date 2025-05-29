#!/bin/bash
# Backup Utility Module - Complete Implementation

create_backup() {
    clear
    read -p "Enter directory to backup: " backup_path
    read -p "Enter backup name (optional): " backup_name
    
    if [ ! -d "$backup_path" ]; then
        echo -e "${ERROR_COLOR}Directory does not exist!${RESET_COLOR}"
        sleep 1
        return
    fi
    
    if [ -z "$backup_name" ]; then
        backup_name="backup_$(date +%Y%m%d_%H%M%S)"
    fi
    
    backup_file="${BACKUP_DIR}/${backup_name}.tar.gz"
    
    echo -e "${MENU_COLOR}Creating backup of $backup_path...${RESET_COLOR}"
    if tar -czf "$backup_file" -C "$(dirname "$backup_path")" "$(basename "$backup_path")"; then
        echo -e "${MENU_COLOR}Backup created: $backup_file${RESET_COLOR}"
        echo -e "Size: $(du -h "$backup_file" | cut -f1)"
    else
        echo -e "${ERROR_COLOR}Backup failed!${RESET_COLOR}"
    fi
    sleep 1
}

restore_backup() {
    clear
    echo -e "${HEADER_COLOR}=== Available Backups ==="
    ls -lh "$BACKUP_DIR" | grep -E '\.tar\.gz$'
    echo -e "==========================${RESET_COLOR}"
    
    read -p "Enter backup filename to restore: " backup_file
    read -p "Enter restore path: " restore_path
    
    full_path="${BACKUP_DIR}/${backup_file}"
    
    if [ ! -f "$full_path" ]; then
        echo -e "${ERROR_COLOR}Backup file not found!${RESET_COLOR}"
        sleep 1
        return
    fi
    
    if [ ! -d "$restore_path" ]; then
        echo -e "${WARNING_COLOR}Restore path doesn't exist. Creating...${RESET_COLOR}"
        mkdir -p "$restore_path"
    fi
    
    echo -e "${MENU_COLOR}Restoring $backup_file to $restore_path...${RESET_COLOR}"
    if tar -xzf "$full_path" -C "$restore_path"; then
        echo -e "${MENU_COLOR}Restore completed successfully${RESET_COLOR}"
    else
        echo -e "${ERROR_COLOR}Restore failed!${RESET_COLOR}"
    fi
    sleep 1
}

schedule_backup() {
    clear
    echo -e "${HEADER_COLOR}=== Schedule Backup ==="
    read -p "Enter directory to backup: " backup_path
    read -p "Enter cron schedule (e.g., '0 3 * * *' for daily at 3AM): " cron_schedule
    
    if [ ! -d "$backup_path" ]; then
        echo -e "${ERROR_COLOR}Directory does not exist!${RESET_COLOR}"
        sleep 1
        return
    fi
    
    script_path="/usr/local/bin/backup_$(basename "$backup_path")"
    
    cat > "$script_path" <<EOF
#!/bin/bash
# Auto-generated backup script
tar -czf "${BACKUP_DIR}/auto_\$(date +\%Y\%m\%d).tar.gz" -C "$(dirname "$backup_path")" "$(basename "$backup_path")"
EOF
    
    chmod +x "$script_path"
    (crontab -l 2>/dev/null; echo "$cron_schedule $script_path") | crontab -
    
    echo -e "${MENU_COLOR}Backup scheduled successfully!${RESET_COLOR}"
    echo -e "Next run: $(crontab -l | grep "$script_path")"
    sleep 1
}

list_backups() {
    clear
    echo -e "${HEADER_COLOR}=== Available Backups ==="
    echo -e "Date\t\tSize\tName"
    echo -e "----------------------------------"
    
    for backup in "$BACKUP_DIR"/*.tar.gz; do
        if [ -f "$backup" ]; then
            size=$(du -h "$backup" | cut -f1)
            date=$(stat -c %y "$backup" | cut -d' ' -f1)
            name=$(basename "$backup")
            echo -e "$date\t$size\t$name"
        fi
    done
    
    echo -e "==========================${RESET_COLOR}"
    read -p "Press [Enter] to continue..."
}

backup_settings() {
    clear
    echo -e "${HEADER_COLOR}=== Backup Settings ==="
    echo -e "1. Change Backup Directory (Current: $BACKUP_DIR)"
    echo -e "2. Set Maximum Backups (Current: $MAX_BACKUPS)"
    echo -e "0. Back to Backup Menu${RESET_COLOR}"
    
    read -p "Select option [0-2]: " setting
    
    case $setting in
        1)
            read -p "Enter new backup directory: " new_dir
            if [ -d "$new_dir" ]; then
                sed -i "s|BACKUP_DIR=.*|BACKUP_DIR=\"$new_dir\"|" "$CONFIG_FILE"
                echo -e "${MENU_COLOR}Backup directory updated!${RESET_COLOR}"
            else
                echo -e "${ERROR_COLOR}Directory does not exist!${RESET_COLOR}"
            fi
            ;;
        2)
            read -p "Enter maximum number of backups: " max_num
            if [[ "$max_num" =~ ^[0-9]+$ ]]; then
                sed -i "s/MAX_BACKUPS=.*/MAX_BACKUPS=$max_num/" "$CONFIG_FILE"
                echo -e "${MENU_COLOR}Maximum backups updated!${RESET_COLOR}"
            else
                echo -e "${ERROR_COLOR}Invalid number!${RESET_COLOR}"
            fi
            ;;
        0) return ;;
        *) echo -e "${ERROR_COLOR}Invalid option!${RESET_COLOR}" ;;
    esac
    sleep 1
}

backup_utility_menu() {
    while true; do
        clear
        echo -e "${HEADER_COLOR}=== Backup Utility ==="
        echo -e "1. Create Backup"
        echo -e "2. Restore Backup"
        echo -e "3. Schedule Backup"
        echo -e "4. List Backups"
        echo -e "5. Backup Settings"
        echo -e "0. Back to Main Menu"
        echo -e "======================${RESET_COLOR}"
        
        read -p "Select an option [0-5]: " choice
        
        case $choice in
            1) create_backup ;;
            2) restore_backup ;;
            3) schedule_backup ;;
            4) list_backups ;;
            5) backup_settings ;;
            0) break ;;
            *) echo -e "${ERROR_COLOR}Invalid option!${RESET_COLOR}"; sleep 1 ;;
        esac
    done
}
