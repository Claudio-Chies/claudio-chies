#!/bin/bash

# Script to add SSH host key checking bypass for 10.41.1.1
# This is useful for development with Auterion Skynode

SSH_CONFIG_FILE="/etc/ssh/ssh_config"
HOST_IP="10.41.1.1"

# Check if running as root
if [ "$(id -u)" -ne 0 ]; then
   echo "This script must be run as root (use sudo)"
   exit 1
fi

# Check if the entry already exists
if grep -q "Host $HOST_IP" "$SSH_CONFIG_FILE"; then
    echo "SSH configuration for $HOST_IP already exists in $SSH_CONFIG_FILE"
    echo "Current entry:"
    grep -A2 "Host $HOST_IP" "$SSH_CONFIG_FILE"
    exit 0
fi

# Backup the original file
cp "$SSH_CONFIG_FILE" "${SSH_CONFIG_FILE}.backup.$(date +%Y%m%d_%H%M%S)"
echo "Created backup: ${SSH_CONFIG_FILE}.backup.$(date +%Y%m%d_%H%M%S)"

# Add the SSH configuration entry
echo "" >> "$SSH_CONFIG_FILE"
echo "Host $HOST_IP" >> "$SSH_CONFIG_FILE"
echo "    StrictHostKeyChecking no" >> "$SSH_CONFIG_FILE"
echo "    UserKnownHostsFile=/dev/null" >> "$SSH_CONFIG_FILE"

echo "Successfully added SSH configuration for $HOST_IP to $SSH_CONFIG_FILE"
echo ""
echo "Added entry:"
echo "Host $HOST_IP"
echo "    StrictHostKeyChecking no"
echo "    UserKnownHostsFile=/dev/null"
echo ""
echo "This configuration will skip host key verification for connections to $HOST_IP"
echo "WARNING: This reduces security and should only be used in development environments!"
