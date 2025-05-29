#!/bin/bash
# Installation Script for Admin Dashboard.
# Not compulsory to run, but this sets up few things.

# Check for root privileges
if [ "$(id -u)" -ne 0 ]; then
    echo "This script must be run as root" >&2
    exit 1
fi

# Create log directory
mkdir -p /var/log/admin_dashboard
chmod 755 /var/log/admin_dashboard

# Create backup directory
mkdir -p /var/backups/admin_dashboard
chmod 700 /var/backups/admin_dashboard

# Install dependencies
if command -v apt-get >/dev/null; then
    apt-get update
    apt-get install -y jq sysstat lm-sensors
elif command -v yum >/dev/null; then
    yum install -y jq sysstat lm_sensors
fi

echo "Installation completed successfully!"
