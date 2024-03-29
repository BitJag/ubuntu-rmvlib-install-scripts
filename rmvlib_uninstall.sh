#!/bin/bash
 
RED='\033[0;31m'
NC='\033[0m' # No Color
INSTALLDIRECTORYNAME='Jaguar'
INSTALLPATH="/home/$USER/$INSTALLDIRECTORYNAME"

echo "\n${RED}Removing Jaguar Folder in Home Directory${NC}\n"

sudo rm -r $INSTALLPATH

echo "\n${RED}Removing JAGPATH Environoment Variable${NC}\n"

sudo sed -i '/Jaguar/d' /etc/environment

# old method of insatll cross compiler tools
echo "\n${RED}Removing Cross Tools and PPA From source.list${NC}\n"

sudo apt-get remove -y --purge cross-mint-essential
sudo apt-get remove -y --purge gcc-m68k-atari-mint
sudo add-apt-repository -y --remove ppa:vriviere/ppa
sudo apt-get update -y

echo "\n${RED}Removing Symbolic Links to JAGPTAH/bin Executables${NC}\n"

sudo rm -v /usr/bin/bigpemu
sudo rm -v /usr/bin/jag-image-converter
sudo rm -v /usr/bin/jcp
sudo rm -v /usr/bin/lz77

echo "\n${RED}Removing JCP rules file${NC}\n"

sudo rm -v /etc/udev/rules.d/64-skunk.rules

echo "\n${RED}Uninstall Finished${NC}\n"

