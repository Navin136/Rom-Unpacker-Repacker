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

printf "	${ORANGE}What's Your Rom zip location\n"
printf "	${ORANGE}For Example: /home/navin/stock/UL-ASUS.zip\n"
read -p "Enter Here: " ZIPLOC
clear
printf "${BLUE} Unzipping rom ....\n"
unzip ${ZIPLOC} -d root/ || { echo "${RED} Failed to Unzip !" && exit 1; }
cd root/

printf "${DGREEN} Decompiling System Image With Brotli ....\n"

printf "${BLUE} This Might take 1 or 2 Minute(s)\n"

brotli -d system.new.dat.br

printf "${DGREEN} Decompiling Vendor Image With Brotli ....\n"

printf "${BLUE} This Might take 1 or 2 Minute(s)\n"

brotli -d vendor.new.dat.br
#rm -rf META-INF
rm system.new.dat.br
rm vendor.new.dat.br
sleep 1
clear 

printf "${DRED} Converting sdat to img\n"

printf "${DORANGE} Wait for 5 Minutes\n"

./../tools/sdat2img.py system.transfer.list system.new.dat system.img > /dev/null 2>&1
./../tools/sdat2img.py vendor.transfer.list vendor.new.dat vendor.img > /dev/null 2>&1
rm vendor.transfer.list
rm system.transfer.list
rm system.new.dat
rm vendor.new.dat
rm system.patch.dat
rm vendor.patch.dat
clear

printf "${DPURPLE} Extracted Successfully ...\n" 

printf "${GREEN} Mounting system and vendor\n"
mkdir system vendor s v
sudo mount -rw system.img s/
sudo mount -rw vendor.img v/
sudo chown ${USER} s/.
sudo chown ${USER} v/.
sudo chmod -R 777 s/.
sudo chmod -R 777 v/.
printf "${BLUE} Copying Files to System and Vendor Folder .... \n"
cp -r v/* vendor/
cp -r s/* system/
sudo umount -f v
sudo umount -f s
tune2fs -l system.img | grep "Block count\|Block size" > info.txt
tune2fs -l vendor.img | grep "Block count\|Block size" >> info.txt
printf "${CYAN} Removing useless files ....\n"
rm -rf system.img
rm -rf vendor.img
rm -rf s
rm -rf v
clear

printf "${DGREEN} Rom Extracted Succesfully ....\n"

printf "${DCYAN} ======================================================================\n"
figlet -cf small THANK YOU!!
printf "${DCYAN} ======================================================================\n"

printf "${DBLUE}Check info.txt for Block info"
