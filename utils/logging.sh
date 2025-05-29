#!/bin/bash
# Logging Utilities

log() {
    local level="$1"
    local message="$2"
    local timestamp=$(date +"%Y-%m-%d %T")
    
    # Check if log level is enabled
    case "$LOG_LEVEL" in
        "DEBUG") ;;
        "INFO") [[ "$level" == "DEBUG" ]] && return ;;
        "WARN") [[ "$level" == "DEBUG" || "$level" == "INFO" ]] && return ;;
        "ERROR") [[ "$level" != "ERROR" ]] && return ;;
        *) return ;;
    esac
    
    # Rotate log if needed
    if [ -f "$LOG_FILE" ] && [ $(stat -c%s "$LOG_FILE") -gt $MAX_LOG_SIZE ]; then
        mv "$LOG_FILE" "${LOG_FILE}.1"
    fi
    
    # Write to log
    echo "[$timestamp] [$level] $message" >> "$LOG_FILE"
}

log_action() {
    local action="$1"
    local status="$2"
    local message="$3"
    
    log "INFO" "ACTION: $action STATUS: $status MESSAGE: $message"
    [ "$status" != "SUCCESS" ] && log "ERROR" "Failed action: $action - $message"
}
