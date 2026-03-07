#!/usr/bin/env bash
#
# Folders to link into the host .config directory
link_to_config=(
    "git"
    "starship.toml"
)
link_to_home=(
    ".bashrc"
    ".gitconfig"
)

for link in "${link_to_config[@]}"; do
    config_path="$HOME/dotfiles/$link"
    target_path="$HOME/.config/$link"
    ln -s "$config_path" "$target_path"
done

for link in "${link_to_home[@]}"; do
    config_path="$HOME/dotfiles/$link"
    target_path="$HOME/$link"
    ln -s "$config_path" "$target_path"
done
