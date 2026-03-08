#!/usr/bin/env bash
#
# Folders to link into the host .config directory
link_to_config=(
    "git"
    "starship.toml"
    "fastfetch"
)
link_to_home=(
    ".bashrc"
    ".gitconfig"
)
directories=(
    "~/source"
)

for dir in "${directories[@]}"; do
    if [ -e "$dir" ] || [ -L "$dir" ]; then
        echo "  Skipping $dir (already exists)"
    else
        mkdir -p "$dir"
        echo "  Created $dir"
    fi
done


for link in "${link_to_config[@]}"; do
    config_path="$HOME/dotfiles/$link"
    target_path="$HOME/.config/$link"
    if [ -e "$target_path" ] || [ -L "$target_path" ]; then
        echo "  Skipping $target_path (already exists)"
    else
        ln -sf "$config_path" "$target_path"
    fi
done

for link in "${link_to_home[@]}"; do
    config_path="$HOME/dotfiles/$link"
    target_path="$HOME/$link"
    if [ -e "$target_path" ] || [ -L "$target_path" ]; then
        echo "  Skipping $target_path (already exists)"
    else
        ln -sf "$config_path" "$target_path"
    fi
done
