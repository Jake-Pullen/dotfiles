#!/usr/bin/env bash

# ------------------------------------------------------------
# Ubuntu System Set Up Script
# ------------------------------------------------------------

# ============================================================
# PACKAGE LISTING
# ============================================================
# List all packages we want from apt
package_list=(
	"kitty"
	"fastfetch"
	"zsh"
	"btop"
	"steam"
	"code"
	"just"
)

# List all the flatpaks we want to install
flatpacks_to_install=(
	"com.discordapp.Discord"
	"com.spotify.Client"
	"app.zen_browser.zen"
)

# List all the folders we want to link from our dotfiles folder to our .config folder
folders_to_link=(
	# "alacritty"
	"git"
	"zsh"
	"kitty"
	"starship.toml"
	)

# ============================================================
# SCRIPT SETUP
# ============================================================
set -euo pipefail          # safer shell behaviour
shopt -s expand_aliases    # if you use aliases inside the script

# ============================================================
# SYSTEM UPDATE
# ============================================================
echo "==> Updating Ubuntu base packages..."

sudo apt update && sudo apt upgrade -y

# ============================================================
# REPOSITORY SETUP
# ============================================================
echo "==> Enabling RPM-Fusion repositories..."
# For Ubuntu, we'll skip RPM-Fusion since it's Fedora-specific

# Prep for vs-code install # TODO: needs testing / tewaking
curl -fsSL https://packages.microsoft.com/keys/microsoft.asc | sudo gpg --dearmor -o /usr/share/keyrings/microsoft-archive-keyring.gpg
echo "deb [arch=amd64 signed-by=/usr/share/keyrings/microsoft-archive-keyring.gpg] https://packages.microsoft.com/repos/vscode stable main" | sudo tee /etc/apt/sources.list.d/vscode.list > /dev/null

# ============================================================
# PACKAGE INSTALLATION
# ============================================================

# Create a string of packages
package_string=$(IFS=' ' ; echo "${package_list[@]}")

# Install packages listed
echo "==> Installing apt Packages..."
sudo apt install $package_string -y --no-install-recommends

# ============================================================
# FLATPAK SETUP
# ============================================================

# 5. Install Flatpak (if not present) and set up Flathub
if ! command -v flatpak &>/dev/null; then
    echo "==> Installing Flatpak..."
    sudo apt install flatpak -y
fi

echo "==> Adding Flathub repository..."
sudo flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

flatpack_string=$(IFS=' ' ; echo "${flatpacks_to_install[@]}")
echo "==> Installing flatpaks..."
flatpak install -y flathub $flatpack_string

# ============================================================
# WEB INSTALLATION
# ============================================================

# UV for Python Dev
curl -LsSf https://astral.sh/uv/install.sh | sh

# Rust, because we all love rust
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

# Bazecore for the Dygma Keyboard 
./bazecore_grab.sh

# Starship because command line glory
curl -sS https://starship.rs/install.sh | sh

# ============================================================
# SYMBOLIC LINKING
# ============================================================

for folder in "${folders_to_link[@]}"; do
	config_path="$HOME/dotfiles/$folder"
	target_path="$HOME/.config/$folder"
	ln -s "$config_path" "$target_path"
done

# Sym link other bits. 
ln -s $HOME/dotfiles/git/gitconfig $HOME/.gitconfig
ln -s $HOME/dotfiles/.justfile $HOME/.justfile

# slightly tested zshrc sym link
sudo rm -f /etc/zshrc
sudo ln -s /etc/zshrc $HOME/dotfiles/zsh/.zshrc

# ============================================================
# NVIM SETUP
# ============================================================
# Untested nvim kickstart clone
git clone https://github.com/Jake-Pullen/kickstart.nvim.git $HOME/.config/nvim

# ============================================================
# SHELL SETUP
# ============================================================
chsh -s /bin/zsh

# ============================================================
# CLEANUP
# ============================================================
echo "==> Cleaning up package cache..."
sudo apt clean

echo "===================================================="
echo "All done! Give the system a reboot!"