# first remove the old lm studio (keeping one old version copy)
echo Removing old backup
rm -f ~/AppImages/LM-Studio.AppImage.old

echo Making new backup
mv ~/AppImages/LM-Studio.AppImage ~/AppImages/LM-Studio.AppImage.old

echo Bringing in new App
mv ~/Downloads/LM-Studio*.AppImage ~/AppImages/LM-Studio.AppImage

echo Making it executable
chmod +x ~/AppImages/LM-Studio.AppImage