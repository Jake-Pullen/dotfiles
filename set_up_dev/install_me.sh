#!/bin/bash

# echo 'test'
$ ssh-keygen -C "$(whoami)@$(uname -n)-$(date -I) git key"
cat /home/$(whoami)/.ssh/id_rsa.pub

curl -fsSL https://christitus.com/linux | sh

package_list=(
    "alacritty"
    "diff-so-fancy"
    "discord"
    "fastfetch"
    "firefox"
    "git"
    "spotify (Launcher)"
    )

for package in "${package_list[@]}"
do
    echo $package
done
# sudo pacman -S --noconfirm
