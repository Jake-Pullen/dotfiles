#!/bin/bash

# Get current user
USER=$(whoami)

# Define paths
SSH_DIR="/home/$USER/.ssh"
KEY_FILE="$SSH_DIR/id_rsa.pub"

# Create .ssh directory if it doesn't exist
if [ ! -d "$SSH_DIR" ]; then
    mkdir -p "$SSH_DIR"
    echo "Created .ssh directory for user $USER"
fi

# Check if the public key file exists
if [ -f "$KEY_FILE" ]; then
    echo "Public key already exists at $KEY_FILE"
else
    # Generate SSH key with a comment based on user, hostname, and timestamp
    ssh-keygen -C "$USER@$(uname -n)-$(date -I)" -f "$SSH_DIR/id_rsa"
    echo "SSH key generated successfully at $KEY_FILE"
fi

# Optionally, display the public key if it was generated
if [ -f "$KEY_FILE" ]; then
    echo "Public key content:"
    cat "$KEY_FILE"
fi


package_list=(
    "alacritty"
    "diff-so-fancy"
    "discord"
    "fastfetch"
    "firefox"
    "spotify-launcher"
    "ollama"
    "waybar"
    "flameshot"
    )

# Create a string of packages
package_string=$(IFS=' ' ; echo "${package_list[@]}")

# Install all packages from the string
echo "Attempting to install packages: $package_string"
sudo pacman -S --needed --noconfirm $package_string

## UV for Python Dev
curl -LsSf https://astral.sh/uv/install.sh | sh

## Linutil by CTT
curl -fsSL https://christitus.com/linux | sh
