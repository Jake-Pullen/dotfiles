#!/usr/bin/env bash
#
# Setup script for QNAP NAS mount
# This script adds the NAS entry to /etc/fstab and creates credential file

set -e

NAS_SERVER="192.168.0.146"
NAS_PATH="Jake"
MOUNT_POINT="/mnt/nas"
FILESYSTEM_TYPE="cifs"

echo "Setting up QNAP NAS mount..."
echo "NAS: //$NAS_SERVER/$NAS_PATH"
echo "Mount point: $MOUNT_POINT"

# Create mount point if it doesn't exist
sudo mkdir -p "$MOUNT_POINT"

# Backup existing fstab
sudo cp /etc/fstab /etc/fstab.backup.$(date +%Y%m%d%H%M%S)

# Read credentials from environment or prompt user
CREDENTIALS_FILE="$HOME/.nas-credentials"

if [[ -n "$NAS_USERNAME" && -n "$NAS_PASSWORD" ]]; then
    username="$NAS_USERNAME"
    password="$NAS_PASSWORD"
    echo "username=$username" > "$CREDENTIALS_FILE"
    echo "password=$password" >> "$CREDENTIALS_FILE"
    chmod 600 "$CREDENTIALS_FILE"
elif [[ -f "$CREDENTIALS_FILE" ]]; then
    echo "Using existing credentials file: $CREDENTIALS_FILE"
    source "$CREDENTIALS_FILE"
    username="$username"
    password="$password"
else
    read -p "Enter NAS username: " username
    read -sp "Enter NAS password: " password
    echo
    echo "username=$username" > "$CREDENTIALS_FILE"
    echo "password=$password" >> "$CREDENTIALS_FILE"
    chmod 600 "$CREDENTIALS_FILE"
fi

# Check if entry already exists in fstab
MOUNT_ENTRY="//$NAS_SERVER/$NAS_PATH $MOUNT_POINT $FILESYSTEM_TYPE credentials=$CREDENTIALS_FILE,uid=1000,gid=1000,iocharset=utf8,cache=none,_netdev,x-systemd.device-timeout=10,x-systemd.requires-network.target 0 0"

if grep -q "$MOUNT_ENTRY" /etc/fstab; then
    echo "Mount entry already exists in /etc/fstab"
else
    # Add the NAS mount entry to fstab
    echo "$MOUNT_ENTRY" | sudo tee -a /etc/fstab
    echo
    echo "Mount added to /etc/fstab"
fi

# Try mounting to verify it works (ignoring failure if network not available)
echo "Attempting to mount (will fail if network not available)..."
systemctl daemon-reload
sudo mount -a 2>/dev/null || echo "Network unavailable, will mount on next boot"
