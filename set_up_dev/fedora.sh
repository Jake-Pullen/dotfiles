#!/usr/bin/env bash

# ------------------------------------------------------------
# Fedora System Set Up Script
# ------------------------------------------------------------

# ============================================================
# PACKAGE LISTING
# ============================================================
# List all packages we want from dnf
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
echo "==> Updating Fedora base packages..."

sudo dnf upgrade --refresh -y

# ============================================================
# REPOSITORY SETUP
# ============================================================
echo "==> Enabling RPM-Fusion repositories..."
sudo dnf install \
    https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm \
    https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm \
    -y

# Prep for vs-code install
sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\nautorefresh=1\ntype=rpm-md\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" | sudo tee /etc/yum.repos.d/vscode.repo > /dev/null

# ============================================================
# PACKAGE INSTALLATION
# ============================================================

# Create a string of packages
package_string=$(IFS=' ' ; echo "${package_list[@]}")

# Install packages listed
echo "==> Installing dnf Packages..."
sudo dnf install $package_string -y --skip-unavailable

# ============================================================
# FLATPAK SETUP
# ============================================================

# 5. Install Flatpak (if not present) and set up Flathub
if ! command -v flatpak &>/dev/null; then
    echo "==> Installing Flatpak..."
    sudo dnf install flatpak -y
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
sudo ln -s $HOME/dotfiles/zsh/.zshrc /etc/zshrc

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
sudo dnf clean all

echo "===================================================="
echo "All done! Give the system a reboot!"