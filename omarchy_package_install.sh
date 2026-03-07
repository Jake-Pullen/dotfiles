#!/usr/bin/env bash
#
pacman_to_add=(
    "tree"
    "ttf-fira-code"
    "cronie"
)

aur_to_add=(
    "bazecor"
    "lmstudio-bin"
)

package_str=(IFS=' ' ; echo "${pacman_to_add[@]}")
aur_str=(IFS=' ' ; echo "${aur_to_add[@]}")


omarchy-pkg-add $package_str
omarchy-pkg-aur-add $aur_str
