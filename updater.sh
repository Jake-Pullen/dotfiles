# !bin/bash
echo Doing some updates!
echo Checking for dnf updates...

sudo dnf update -y

echo Checking for flatpak updates...

sudo flatpak update -y 

echo Doing a quick clean up...

sudo dnf clean all

echo Checking if we need a restart...

sudo dnf needs-restarting

