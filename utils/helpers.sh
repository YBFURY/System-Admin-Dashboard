#!/bin/bash
# Helper Functions

check_root() {
    if [ "$(id -u)" -ne 0 ]; then
        echo -e "${ERROR_COLOR}This operation requires root privileges.${RESET_COLOR}"
        return 1
    fi
    return 0
}

validate_username() {
    local username="$1"
    if [[ ! "$username" =~ ^[a-z_][a-z0-9_-]*$ ]]; then
        echo -e "${ERROR_COLOR}Invalid username format!${RESET_COLOR}"
        return 1
    fi
    return 0
}

confirm_action() {
    local message="$1"
    read -p "$message [y/N]: " response
    case "$response" in
        [yY][eE][sS]|[yY]) return 0 ;;
        *) return 1 ;;
    esac
}
