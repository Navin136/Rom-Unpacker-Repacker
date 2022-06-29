#!/bin/bash
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
rm -rf META-INF
rm -rf *.zip
rm system.new.dat.br
rm vendor.new.dat.br

printf "${ORANGE} Setting up Permissions for sdat2img ....\n"
chmod +x ../sdat2img.py
sleep 1
clear 

printf "${DRED} Converting sdat to img\n"

printf "${DORANGE} Wait for 5 Minutes\n"

./../sdat2img.py system.transfer.list system.new.dat system.img > /dev/null 2>&1
./../sdat2img.py vendor.transfer.list vendor.new.dat vendor.img > /dev/null 2>&1
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
printf "${CYAN} Removing useless files ....\n"
rm -rf system.img
rm -rf vendor.img
rm -rf s
rm -rf v
clear

printf "${DGREEN} Images Mounted Succesfully ....\n"

printf "${DCYAN} =============================================================\n"
figlet -cf small THANK YOU!!
printf "${DCYAN} =============================================================\n"
