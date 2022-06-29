#!/bin/bash

W_DIR=($(pwd))

RED='\033[0;31m'
GREEN='\033[0;32m'
ORANGE='\033[0;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
DRED='\033[1;31m'
DGREEN='\033[1;32m'
DORANGE='\033[1;33m'
DBLUE='\033[1;34m'
DPURPLE='\033[1;35m'
DCYAN='\033[1;36m'


if [ -f "/usr/bin/apt-get" ]; then
DISTRO="debian"
printf "${DGREEN} Your machine is installed with Debian/Ubuntu Linux\n"
fi
if [ -f "/usr/bin/pacman" ]; then
DISTRO="arch"
printf "${DGREEN} Your machine is installed with Arch Linux\n"
fi
printf "${ORANGE}"
if [ $DISTRO == debian ];then
	sudo apt-get update && sudo apt-get install git brotli python cmake zip unzip figlet rar unrar -y
else
	sudo pacman -Syy && sudo pacman -S android-tools cmake git python brotli zip unzip rar figlet unrar --noconfirm
fi
clear
bash extract.sh
