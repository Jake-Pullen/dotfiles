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
    "btop"
    "firefox"
    )

# Create a string of packages
package_string=$(IFS=' ' ; echo "${package_list[@]}")

# Install all packages from the string
echo "Attempting to install packages: $package_string"
sudo pacman -S --needed --noconfirm $package_string

## UV for Python Dev
curl -LsSf https://astral.sh/uv/install.sh | sh

## Rust, because we all love rust
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

## Linutil by CTT
# curl -fsSL https://christitus.com/linux | sh

## Bazecor for the Dygma Keyboard
yay bazecor
## ckb-next for the corsair mouse
yay ckb-next

## Symlink the config files to the right places
folders_to_link=(
	"alacritty"
	"git"
	"hypr"
	"waybar"
	"wofi"
	"zsh"
	"ckb-next"
	)

# Loop through the folder list
for folder in "${folders_to_link[@]}"; do
  # Construct the full path to the .config folder
  config_path="$HOME/dotfiles/$folder"

  # Construct the full path to the target folder
  target_path="$HOME/.config/$folder"

  # Check if the target folder exists
  if [ -d "$target_path" ]; then
    echo "Warning: Target directory '$target_path' already exists. Skipping link creation."
  else
    # Create a soft link
    ln -s "$config_path" "$target_path"
    if [ $? -eq 0 ]; then
      echo "Successfully created soft link: $target_path -> $config_path"
    else
      echo "Error: Failed to create soft link: $target_path"
    fi
  fi
done

if [ -f "$HOME/.gitconfig" ]; then
  echo gitconfig already linked, skipping
else
  ln -s $HOME/dotfiles/git/gitconfig $HOME/.gitconfig
  echo linked gitconfig 
fi

if [ -f "/etc/zsh/zshenv" ]; then
  echo zshenv already exists, skipping
else
  ln -s $HOME/dotfiles/zshenv /etc/zsh/zshenv
fi

echo Make sure you change shell with chsh 

