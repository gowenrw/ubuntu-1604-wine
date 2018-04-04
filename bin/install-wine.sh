#!/usr/bin/env bash

### Exit script on error
set -e

echo "Install WINE !!!"
# Allow 32bit
echo "# Allow 32bit"
echo "**** dpkg --add-architecture i386"
dpkg --add-architecture i386

# Need to add this package to add repositories
echo "# Need to add this package to add repositories"
echo "**** apt-get install -y software-properties-common"
apt-get install -y software-properties-common

# Need to add this packge to use https repositories
echo "# Need to add this packge to use https repositories"
echo "**** apt-get install -y apt-transport-https"
apt-get install -y apt-transport-https

# Add the wine repo
echo "# Add the wine repo"
echo "**** wget -nc https://dl.winehq.org/wine-builds/Release.key"
wget -nc -nv https://dl.winehq.org/wine-builds/Release.key
echo "**** apt-key add Release.key"
apt-key add Release.key
echo "**** apt-add-repository https://dl.winehq.org/wine-builds/ubuntu/"
apt-add-repository https://dl.winehq.org/wine-builds/ubuntu/
echo "**** apt-get update -y"
apt-get update -y

# Install wine-stable
echo "# Install wine-stable"
echo "**** apt-get install -y wine-stable winehq-stable"
apt-get install -y wine-stable winehq-stable
# In a real desktop I would run this: WINEARCH=win32 winecfg to install gecko and mono
# with a GUI launch that allows other configuration as well... instead we will:
# Install gecko and mono via wget and msiexec
echo "# Install gecko and mono via wget and msiexec"
mkdir $HOME/.cache/wine
cd $HOME/.cache/wine
echo "**** wget -nv http://dl.winehq.org/wine/wine-mono/4.7.1/wine-mono-4.7.1.msi"
wget -nv http://dl.winehq.org/wine/wine-mono/4.7.1/wine-mono-4.7.1.msi
echo "**** wget -nv http://dl.winehq.org/wine/wine-gecko/2.47/wine_gecko-2.47-x86.msi"
wget -nv http://dl.winehq.org/wine/wine-gecko/2.47/wine_gecko-2.47-x86.msi
echo "**** WINEARCH=win32 msiexec /i wine-mono-4.7.1.msi /q /l* wine-mono-4.7.1.log"
WINEARCH=win32 msiexec /i wine-mono-4.7.1.msi /q /l* wine-mono-4.7.1.log
echo "**** WINEARCH=win32 msiexec /i wine_gecko-2.47-x86.msi /q /l* wine_gecko-2.47-x86.log"
WINEARCH=win32 msiexec /i wine_gecko-2.47-x86.msi /q /l* wine_gecko-2.47-x86.log
cd $HOME


# Install dotnet tools with winetricks
echo "# Install dotnet tools with winetricks"
echo "**** apt-get install -y winetricks"
apt-get install -y winetricks


