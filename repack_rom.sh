#!/bin/bash

# Colours
RED='\e[31m'
GREEN='\e[32m'
ORANGE='\e[33m'
BLUE='\e[34m'
PURPLE='\e[35m'
CYAN='\e[36m'
GREY='\e[37m'

if [ -f "/usr/bin/apt-get" ]; then
DISTRO="debian"
printf "${GREEN} Your machine is installed with Debian/Ubuntu Linux\n"
fi
if [ -f "/usr/bin/pacman" ]; then
DISTRO="arch"
printf "${GREEN} Your machine is installed with Arch Linux\n"
fi
printf "${ORANGE}"
if [ $DISTRO == debian ];then
        sudo apt-get update && sudo apt-get install git brotli python cmake zip unzip figlet rar unrar -y
else
        sudo pacman -Syy && sudo pacman -S android-tools cmake git python brotli zip unzip rar figlet unrar --noconfirm
fi
clear


printf "${CYAN} Refer info.txt for Block Count and Block Size\n"
printf "${CYAN} Enter Block Count of System Image : \n"
read BCS
printf "${CYAN} Enter Block Size of System Image : \n"
read BSS
printf "${ORANGE} Enter Block Count of Vendor Image : \n"
read BCV
printf "${ORANGE} Enter Block Size of Vendor Image : \n"  
read BSV

LEN_SYS=$((BCS * BSS))
LEN_VEN=$((BCV * BSV))

printf "${GREEN} Enter Directory Which has system and vendor folder: \n"
read SYSVENDIR

clear
printf "${ORANGE} Making Images.......\n\n"
./tools/make_ext4fs -a system -s -l ${LEN_SYS} system.img ${SYSVENDIR}/system/
./tools/make_ext4fs -a vendor -s -l ${LEN_VEN} vendor.img ${SYSVENDIR}/vendor/

printf "${BLUE} Converting image to sdat .....\n"
./tools/img2sdat.py -v 4 system.img -p system
./tools/img2sdat.py -v 4 vendor.img -p vendor

#brotli system.new.dat
#brotli vendor.new.dat

printf "${CYAN} Removing System and Vendor Images\n"
rm system.img vendor.img
mkdir port
cp -r root/META-INF root/boot.img root/firmware* *.new.dat *.patch.dat *.transfer.list port/
cd port
printf "${GREEN} Do You Want to Zip the Rom? (Y/N)\n"
read OPTION
if [ $OPTION == Y ] || [ $OPTION == y ];then
	zip -r ported.zip boot.img vendor.* system.* META-INF firmware-update
else
	printf "${ORANGE} Okay! Thank You! Have a Nice Day!"
fi
