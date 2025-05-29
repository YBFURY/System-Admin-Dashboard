#!/bin/bash
# Process Management Module - Complete Implementation

list_processes() {
    clear
    echo -e "${HEADER_COLOR}=== Running Processes (Sorted by CPU) ==="
    echo -e "PID\tUSER\t%CPU\t%MEM\tCOMMAND"
    ps -eo pid,user,%cpu,%mem,cmd --sort=-%cpu | head -n 20
    echo -e "======================================${RESET_COLOR}"
    read -p "Press [Enter] to continue..."
}

process_details() {
    clear
    read -p "Enter PID to view details: " pid
    
    if ! [[ "$pid" =~ ^[0-9]+$ ]]; then
        echo -e "${ERROR_COLOR}Invalid PID format!${RESET_COLOR}"
        sleep 1
        return
    fi
    
    if ps -p "$pid" > /dev/null; then
        echo -e "${HEADER_COLOR}=== Process Details (PID: $pid) ==="
        ps -p "$pid" -o pid,user,%cpu,%mem,vsz,rss,tty,stat,start,time,cmd
        echo -e "======================================${RESET_COLOR}"
    else
        echo -e "${ERROR_COLOR}No process found with PID $pid!${RESET_COLOR}"
    fi
    read -p "Press [Enter] to continue..."
}

search_processes() {
    clear
    read -p "Enter process name to search: " pname
    
    if [ -z "$pname" ]; then
        echo -e "${ERROR_COLOR}Process name cannot be empty!${RESET_COLOR}"
        sleep 1
        return
    fi
    
    echo -e "${HEADER_COLOR}=== Matching Processes ==="
    pgrep -l "$pname" | while read -r pid name; do
        ps -p "$pid" -o pid,user,%cpu,%mem,cmd --no-headers
    done
    echo -e "======================================${RESET_COLOR}"
    read -p "Press [Enter] to continue..."
}

kill_process_menu() {
    clear
    echo -e "${HEADER_COLOR}=== Kill Process Options ==="
    echo -e "1. Kill by PID"
    echo -e "2. Kill by Name"
    echo -e "0. Back to Process Menu"
    echo -e "==========================${RESET_COLOR}"
    
    read -p "Select kill method [0-2]: " method
    
    case $method in
        1) kill_by_pid ;;
        2) kill_by_name ;;
        0) return ;;
        *) echo -e "${ERROR_COLOR}Invalid option!${RESET_COLOR}"; sleep 1 ;;
    esac
}

kill_by_pid() {
    read -p "Enter PID to kill: " pid
    
    if ! [[ "$pid" =~ ^[0-9]+$ ]]; then
        echo -e "${ERROR_COLOR}Invalid PID format!${RESET_COLOR}"
        sleep 1
        return
    fi
    
    if ! ps -p "$pid" > /dev/null; then
        echo -e "${ERROR_COLOR}No process found with PID $pid!${RESET_COLOR}"
        sleep 1
        return
    fi
    
    echo -e "${WARNING_COLOR}Select signal to send:"
    echo -e "1. TERM (15) - Graceful termination"
    echo -e "2. KILL (9) - Forceful termination"
    echo -e "3. HUP (1) - Hangup"
    echo -e "4. INT (2) - Interrupt${RESET_COLOR}"
    
    read -p "Signal choice [1-4]: " sig_choice
    
    case $sig_choice in
        1) signal="TERM"; sig=15 ;;
        2) signal="KILL"; sig=9 ;;
        3) signal="HUP"; sig=1 ;;
        4) signal="INT"; sig=2 ;;
        *) echo -e "${ERROR_COLOR}Invalid choice! Using TERM.${RESET_COLOR}"; signal="TERM"; sig=15 ;;
    esac
    
    if kill -"$sig" "$pid"; then
        echo -e "${MENU_COLOR}Successfully sent $signal to process $pid${RESET_COLOR}"
    else
        echo -e "${ERROR_COLOR}Failed to kill process $pid!${RESET_COLOR}"
    fi
    sleep 1
}

kill_by_name() {
    read -p "Enter process name to kill: " pname
    
    if [ -z "$pname" ]; then
        echo -e "${ERROR_COLOR}Process name cannot be empty!${RESET_COLOR}"
        sleep 1
        return
    fi
    
    pids=$(pgrep "$pname")
    
    if [ -z "$pids" ]; then
        echo -e "${ERROR_COLOR}No processes found matching '$pname'!${RESET_COLOR}"
        sleep 1
        return
    fi
    
    echo -e "${WARNING_COLOR}Found processes:"
    ps -p "$pids" -o pid,user,cmd
    echo -e "${RESET_COLOR}"
    
    read -p "Kill all matching processes? [y/N]: " confirm
    if [[ "$confirm" =~ ^[yY] ]]; then
        kill -9 $pids
        echo -e "${MENU_COLOR}Killed all processes matching '$pname'${RESET_COLOR}"
    else
        echo -e "${MENU_COLOR}Aborted process kill${RESET_COLOR}"
    fi
    sleep 1
}

process_monitor() {
    clear
    echo -e "${HEADER_COLOR}=== Real-time Process Monitor (q to quit) ==="
    echo -e "Press q to return to menu"
    echo -e "==========================${RESET_COLOR}"
    top -d 1
}

process_tree() {
    clear
    read -p "Enter PID to show tree (leave empty for full tree): " pid
    
    echo -e "${HEADER_COLOR}=== Process Tree ==="
    if [ -z "$pid" ]; then
        pstree -p
    else
        if ! [[ "$pid" =~ ^[0-9]+$ ]]; then
            echo -e "${ERROR_COLOR}Invalid PID format!${RESET_COLOR}"
        elif ps -p "$pid" > /dev/null; then
            pstree -p "$pid"
        else
            echo -e "${ERROR_COLOR}No process found with PID $pid!${RESET_COLOR}"
        fi
    fi
    echo -e "==========================${RESET_COLOR}"
    read -p "Press [Enter] to continue..."
}

process_management_menu() {
    while true; do
        clear
        echo -e "${HEADER_COLOR}=== Process Management ==="
        echo -e "1. List Running Processes"
        echo -e "2. Process Details by PID"
        echo -e "3. Search Processes by Name"
        echo -e "4. Kill Process"
        echo -e "5. Real-time Process Monitor"
        echo -e "6. Process Tree View"
        echo -e "0. Back to Main Menu"
        echo -e "==========================${RESET_COLOR}"
        
        read -p "Select an option [0-6]: " choice
        
        case $choice in
            1) list_processes ;;
            2) process_details ;;
            3) search_processes ;;
            4) kill_process_menu ;;
            5) process_monitor ;;
            6) process_tree ;;
            0) break ;;
            *) echo -e "${ERROR_COLOR}Invalid option!${RESET_COLOR}"; sleep 1 ;;
        esac
    done
}
