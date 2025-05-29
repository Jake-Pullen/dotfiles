#!/bin/bash

# Get current user
USER=$(whoami)

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
    "zsh"
    "zsh-completions"
    "ttf-font-awesome"
    "nerd-fonts"
    )

# Create a string of packages
package_string=$(IFS=' ' ; echo "${package_list[@]}")

# Install all packages from the string
echo "Attempting to install packages: $package_string"
sudo pacman -S --needed --noconfirm $package_string

## UV for Python Dev
curl -LsSf https://astral.sh/uv/install.sh | sh

## Linutil by CTT
# curl -fsSL https://christitus.com/linux | sh

## make zsh the default shell
chsh /usr/bin/zsh

