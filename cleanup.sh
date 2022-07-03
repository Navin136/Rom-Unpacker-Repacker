#!/bin/bash
printf "\e[32m CAUTION!!! All Files Will Be Deleted !!!\n"
printf "\e[33m Do You Want to Proceed ? (Y/N)\n"
read OPTION
if [ $OPTION == Y ] || [ $OPTION == y ];then
	rm -rf *
	git restore .
fi
