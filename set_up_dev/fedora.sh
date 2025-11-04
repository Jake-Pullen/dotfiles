#!/usr/bin/env bash

# ------------------------------------------------------------
# Fedora package bootstrap script
# Author: Jake Pullen
# Date  : 2025-08-15
#
# Usage:
#   chmod +x fedora-setup.sh
#   sudo ./fedora-setup.sh
# ------------------------------------------------------------

set -euo pipefail          # safer shell behaviour
shopt -s expand_aliases    # if you use aliases inside the script

# 1. Update system first
echo "==> Updating Fedora base packages..."
sudo dnf upgrade --refresh -y

# 2. Install RPM‑Fusion repos (free & non‑free)
echo "==> Enabling RPM-Fusion repositories..."
sudo dnf install \
    https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm \
    https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm \
    -y

# list all packages we want from dnf
package_list=(
	"kitty"
	"fastfetch"
	"zsh"
	"btop"
	"steam"
	"code"
	"just"
	)

# Create a string of packages
package_string=$(IFS=' ' ; echo "${package_list[@]}")

# 3. Install packages listed
echo "==> Installing dnf Packages..."
sudo dnf install $package_string -y --skip-unavailable

# 5. Install Flatpak (if not present) and set up Flathub
if ! command -v flatpak &>/dev/null; then
    echo "==> Installing Flatpak..."
    sudo dnf install flatpak -y
fi

echo "==> Adding Flathub repository..."
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

# 6. Install Flatpak Apps
echo "==> Installing Discord..."
flatpak install -y flathub com.discordapp.Discord
flatpak install -y flathub com.spotify.Client
flatpak install -y flathub app.zen_browser.zen

# 7. Install stuff from around the web that we want
# UV for Python Dev
curl -LsSf https://astral.sh/uv/install.sh | sh

# Rust, because we all love rust
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

# Bazecore for the Dygma Keyboard 
./bazecore_grab.sh

# Starship because command line 
curl -sS https://starship.rs/install.sh | sh

# sim link config
folders_to_link=(
	# "alacritty"
	"git"
	"zsh"
	"kitty"
	"starship.toml" # not a folder, but should still work
	)
for folder in "${folders_to_link[@]}"; do
	config_path="$HOME/dotfiles/$folder"
	target_path="$HOME/.config/$folder"
	ln -s "$config_path" "$target_path"
done

# sym link other bits. 
ln -s $HOME/dotfiles/git/gitconfig $HOME/.gitconfig
ln -s $HOME/dotfiles/.justfile $HOME/.justfile

# untested zshrc sym link
sudo rm /etc/zshrc
sudo ln -s /etc/zshrc $HOME/dotfiles/zsh/.zshrc

# nvim set up likely needs work
# git clone https://github.com/Jake-Pullen/kickstart.nvim.git $HOME/.config/nvim

# 9. Clean up (optional)
echo "==> Cleaning up package cache..."
sudo dnf clean all

echo "===================================================="
echo "All done! Your Fedora system is now ready to go."
echo "You can run 'flatpak list' to see Flatpak apps or 'dnf list installed' for rpm packages."

