#!/bin/bash
# Log Analysis Module - Complete Implementation

view_system_logs() {
    clear
    echo -e "${HEADER_COLOR}=== System Logs (Last 50 Lines) ==="
    echo -e "${MENU_COLOR}1. Kernel Log"
    echo -e "2. System Log"
    echo -e "3. Auth Log"
    echo -e "4. All Logs${RESET_COLOR}"
    
    read -p "Select log type [1-4]: " log_type
    
    case $log_type in
        1) sudo journalctl -k -n 50 --no-pager ;;
        2) sudo journalctl -n 50 --no-pager ;;
        3) sudo tail -n 50 /var/log/auth.log ;;
        4) sudo journalctl -n 50 --no-pager -b ;;
        *) echo -e "${ERROR_COLOR}Invalid option!${RESET_COLOR}"; return ;;
    esac
    
    echo -e "==================================${RESET_COLOR}"
    read -p "Press [Enter] to continue..."
}

filter_logs_service() {
    clear
    read -p "Enter service name to filter: " service
    
    if [ -z "$service" ]; then
        echo -e "${ERROR_COLOR}Service name cannot be empty!${RESET_COLOR}"
        sleep 1
        return
    fi
    
    echo -e "${HEADER_COLOR}=== Logs for $service ==="
    sudo journalctl -u "$service" -n 50 --no-pager
    echo -e "==================================${RESET_COLOR}"
    read -p "Press [Enter] to continue..."
}

search_logs_keyword() {
    clear
    read -p "Enter keyword to search: " keyword
    
    if [ -z "$keyword" ]; then
        echo -e "${ERROR_COLOR}Keyword cannot be empty!${RESET_COLOR}"
        sleep 1
        return
    fi
    
    echo -e "${HEADER_COLOR}=== Log Entries Containing '$keyword' ==="
    sudo journalctl --no-pager -g "$keyword" -n 50
    echo -e "==================================${RESET_COLOR}"
    read -p "Press [Enter] to continue..."
}

export_logs() {
    clear
    echo -e "${HEADER_COLOR}=== Export Logs ==="
    read -p "Enter time range (e.g., '1 hour ago'): " time_range
    read -p "Enter output file path: " out_file
    
    if [ -z "$time_range" ] || [ -z "$out_file" ]; then
        echo -e "${ERROR_COLOR}Both fields are required!${RESET_COLOR}"
        sleep 1
        return
    fi
    
    if sudo journalctl --since "$time_range" > "$out_file"; then
        echo -e "${MENU_COLOR}Logs exported to $out_file${RESET_COLOR}"
    else
        echo -e "${ERROR_COLOR}Export failed!${RESET_COLOR}"
    fi
    sleep 1
}

monitor_logs_realtime() {
    clear
    echo -e "${HEADER_COLOR}=== Real-time Log Monitoring (Ctrl+C to stop) ==="
    echo -e "Monitoring system logs..."
    echo -e "==========================${RESET_COLOR}"
    sudo tail -f /var/log/syslog
}

show_error_stats() {
    clear
    echo -e "${HEADER_COLOR}=== Error Statistics (Last 24 Hours) ==="
    echo -e "Count\tService\t\tMessage"
    echo -e "----------------------------------"
    sudo journalctl --since "24 hours ago" -p err --no-pager | \
        awk '{if ($5) services[$5]++; else services["Unknown"]++} 
             END {for (s in services) print services[s] "\t" s}' | \
        sort -nr
    echo -e "==========================${RESET_COLOR}"
    read -p "Press [Enter] to continue..."
}

log_analysis_menu() {
    while true; do
        clear
        echo -e "${HEADER_COLOR}=== Log Analysis ==="
        echo -e "1. View System Logs"
        echo -e "2. Filter by Service"
        echo -e "3. Search by Keyword"
        echo -e "4. Export Logs"
        echo -e "5. Real-time Monitoring"
        echo -e "6. Error Statistics"
        echo -e "0. Back to Main Menu"
        echo -e "======================${RESET_COLOR}"
        
        read -p "Select an option [0-6]: " choice
        
        case $choice in
            1) view_system_logs ;;
            2) filter_logs_service ;;
            3) search_logs_keyword ;;
            4) export_logs ;;
            5) monitor_logs_realtime ;;
            6) show_error_stats ;;
            0) break ;;
            *) echo -e "${ERROR_COLOR}Invalid option!${RESET_COLOR}"; sleep 1 ;;
        esac
    done
}
