#!/usr/bin/env bash
#
# source ~/.local/share/omarchy/bin/omarchy-pkg-add
# source ~/.local/share/omarchy/bin/omarchy-pkg-aur-add

pacman_to_add=(
    "tree"
    "ttf-fira-code"
    "cronie"
    "cmake"
    "gamemode"
)

aur_to_add=(
    "bazecor"
    "lmstudio-bin"
    # "yubico-authenticator" # partially borked?
)

package_str=$(IFS=' ' ; echo "${pacman_to_add[@]}")
aur_str=$(IFS=' ' ; echo "${aur_to_add[@]}")


omarchy-pkg-add $package_str
omarchy-pkg-aur-add $aur_str
