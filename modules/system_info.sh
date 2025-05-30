#!/bin/bash
# System Information Module

system_info_menu() {
    while true; do
        clear
        echo -e "${HEADER_COLOR}=== System Information ===${RESET_COLOR}"
        echo -e "1. Overview"
        echo -e "2. CPU Information"
        echo -e "3. Memory Usage"
        echo -e "4. Disk Usage"
        echo -e "5. Temperature"
        echo -e "6. Load Averages"
        echo -e "0. Back to Main Menu"
        echo -e "=========================="
        
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
    echo -e "${HEADER_COLOR}=== System Overview ===${RESET_COLOR}"
    echo -e "Hostname: $(hostname)"
    echo -e "Operating System: $(source /etc/os-release; echo "$PRETTY_NAME")"
    echo -e "Kernel Version: $(uname -r)"
    echo -e "Architecture: $(uname -m)"
    echo -e "Uptime: $(uptime -p)"
    echo -e "========================"
    read -p "Press [Enter] to continue..."
}

show_cpu_info() {
    clear
    echo -e "${HEADER_COLOR}=== CPU Information ===${RESET_COLOR}"
    echo -e "Model: $(grep 'model name' /proc/cpuinfo | head -1 | cut -d ':' -f2 | sed 's/^ //')"
    echo -e "Cores: $(grep -c '^processor' /proc/cpuinfo)"
    echo -e "CPU MHz: $(grep 'cpu MHz' /proc/cpuinfo | head -1 | cut -d ':' -f2 | sed 's/^ //') MHz"
    echo -e "Cache Size: $(grep 'cache size' /proc/cpuinfo | head -1 | cut -d ':' -f2 | sed 's/^ //')"
    echo -e "======================="
    read -p "Press [Enter] to continue..."
}

show_memory_info() {
    clear
    echo -e "${HEADER_COLOR}=== Memory Usage ===${RESET_COLOR}"
    free -h
    echo -e "====================="
    read -p "Press [Enter] to continue..."
}

show_disk_info() {
    clear
    echo -e "${HEADER_COLOR}=== Disk Usage ===${RESET_COLOR}"
    df -h --total | grep '^/dev/'
    echo -e "==================="
    read -p "Press [Enter] to continue..."
}

show_temperature() {
    clear
    echo -e "${HEADER_COLOR}=== Temperature ===${RESET_COLOR}"
    if command -v sensors &>/dev/null; then
        sensors
    else
        echo "The 'sensors' command is not installed or no temperature sensors detected."
        echo "Try installing 'lm-sensors' package."
    fi
    echo -e "==================="
    read -p "Press [Enter] to continue..."
}

show_load_averages() {
    clear
    echo -e "${HEADER_COLOR}=== Load Averages ===${RESET_COLOR}"
    uptime | awk -F'load average:' '{ print "Load averages:" $2 }'
    echo -e "===================="
    read -p "Press [Enter] to continue..."
}
    