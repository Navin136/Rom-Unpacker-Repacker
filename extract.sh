#!/bin/bash
printf "	${ORANGE}What's Your Rom zip location\n"
printf "	${ORANGE}For Example: /home/navin/stock/UL-ASUS.zip\n"
read -p "Enter Here: " ZIPLOC
clear
printf "${BLUE} Unzipping rom ...."
unzip ${ZIPLOC} -d root/ > /dev/null 2>&1 
cd root/
printf "${CYAN} Decompiling System Image With Brotli ...."
printf "${BLUE} This Might take 1 or 2 Minute(s)"
brotli -d system.new.dat.br
printf "${CYAN} Decompiling Vendor Image With Brotli ...."
printf "${BLUE} This Might take 1 or 2 Minute(s)"
brotli -d vendor.new.dat.br
rm -rf META-INF
rm -rf *.zip
rm system.new.dat.br
rm vendor.new.dat.br
printf "${ORANGE} Setting up Permissions for sdat2img ...."
chmod +x sdat2img.py
sleep 1
clear 
printf "${DRED} Converting sdat to img"
printf "${DORANGE} Wait for 5 Minutes"
./$W_DIR/sdat2img.py system.transfer.list system.new.dat system.img > /dev/null 2>&1
./$W_DIR/sdat2img.py vendor.transfer.list vendor.new.dat vendor.img > /dev/null 2>&1
rm vendor.transfer.list
rm system.transfer.list
rm system.new.dat
rm vendor.new.dat
rm system.patch.dat
rm vendor.patch.dat
clear
printf "${DPURPLE} Extracted Successfully ..." 
printf "${GREEN} Mounting system and vendor"
mkdir system vendor
sudo mount -rw system.img system/
sudo chown ${USER} system/.
sudo chown ${USER} vendor/.
sudo chmod -R 777 system/.
sudo chmod -R 777 vendor/.
clear
printf "${DGREEN} Images Mounted Succesfully ...."
printf "${DCYAN} ============================================================="
figlet -cf small THANK YOU!!
printf "${DCYAN} ============================================================="
