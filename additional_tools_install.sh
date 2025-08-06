#!/bin/bash

RED='\033[0;31m'
NC='\033[0m' # No Color
TMPDIRECTORY=/tmp
INSTALLDIRECTORYNAME='Jaguar'
INSTALLPATH="/home/$USER/$INSTALLDIRECTORYNAME"


echo "\n"
echo "${RED}Installer script for BigPEmu, Seb's Jaguar Image Converter, ray's lz77 Packer, and the latest version of Tursi's JCP.${NC}\nScript last updated January 1st, 2023\n"

echo "${RED}Installation requires access to the ubuntu repositories and an internet connection.${NC}\n"

echo "${RED}Sources are pulled from the following locations on the web:\n"

echo "${RED}BigPEmu${NC} - https://www.richwhitehouse.com/jaguar/index.php?content=download\n"
echo "${RED}JCP${NC} - http://www.harmlesslion.com/zips/SKUNKBOARD_FULL_RELEASE.zip\n"
echo "${RED}Seb's Jaguar Image Converter${NC} - http://removers.free.fr/softs/archives/converter-0.1.9.tar.gz\n"
echo "${RED}Ray's lz77 Packer${NC} - http://s390174849.online.de/ray.tscc.de/files/lz77_v13.zip\n${NC}"

echo "Consider supporting these developers and their effors with donations and feeback.\n"


#prerequisites
echo "\n"
echo "${RED}Adding necessary packages for binary building.${NC}\n"
echo "\n"

sudo apt-get install -y make  
sudo apt-get install -y git
sudo apt-get install -y libusb-dev
sudo apt-get install -y libusb-0.1-4
sudo apt-get install -y python3

#setup python3 to be the version of python with highest priority.  jconverter/jag-image-converter requires python3 or higher to execute.
sudo update-alternatives --install /usr/bin/python python /usr/bin/python3 99


echo "\n"
echo "${RED}Making directory structure for building and final binaries.${NC}\n"
echo "\n"

mkdir -v $TMPDIRECTORY/tmp_additional_jaguar_dev_binaries
cd $TMPDIRECTORY/tmp_additional_jaguar_dev_binaries
mkdir -v ./bin
mkdir -v ./src
mkdir -v ./src/other_binaries

#Download and unpack sources from web, and then remove archived files
echo "\n"
echo "${RED}Download and unpack sources from web, and then move archived source files.${NC}\n"
echo "\n"

#bigPEmu
wget https://www.richwhitehouse.com/jaguar/builds/BigPEmu_Linux64_v119.tar.gz
tar -xvf ./BigPEmu_Linux64_v119.tar.gz -d ./bigpemu
mv -v ./BigPEmu_Linux64_v119.tar.gz ./src/other_binaries

#jcp
wget http://www.harmlesslion.com/zips/SKUNKBOARD_FULL_RELEASE.zip
unzip ./SKUNKBOARD_FULL_RELEASE.zip
cp -r ./FULL_RELEASE/sources/jcp2/jcp ./
sudo rm -r ./SKUNKBOARD_FULL_RELEASE.zip
sudo rm -r ./FULL_RELEASE
tar -cvf jcp.tar ./jcp
mv -v ./jcp.tar ./src/other_binaries

#lz77
wget http://s390174849.online.de/ray.tscc.de/files/lz77_v13.zip
unzip lz77_v13.zip
mv -v ./lz77_v13.zip ./src/other_binaries

#jag-image-converter
git clone https://github.com/theRemovers/jconverter.git



#Build Binaries

echo "\n"
echo "${RED}Begin building binaries.${NC}\n"

#jcp
echo "\n"
echo "${RED}Building jcp.${NC}\n"
echo "\n"
sleep 1
cd ./jcp
make
sudo bash -c 'echo "SUBSYSTEM==\"usb\", ATTRS{idProduct}==\"7200\", ATTRS{idVendor}==\"04b4\", MODE=\"0666\"" >> /etc/udev/rules.d/64-skunk.rules' #allows jcp to run without sudo
sudo udevadm control --reload-rules #alows jcp to run without restart
cd ..


#lz77
echo "\n"
echo "${RED}Building lz77.${NC}\n"
echo "\n"
sleep 1
cd lz77/
gcc lz77.c -o lz77 -O2
cd ..

#copy built binaries to bin folder
echo "\n"
echo "${RED}Copy built binaries to bin folder.${NC}\n"
echo "\n"

mv -v ./bigpemu/ ./bin/
cp -v ./virtualjaguar/virtualjaguar ./bin/
cp -v ./jcp/jcp ./bin/
cp -v ./lz77/lz77 ./bin/
cp -v ./jconverter/converter.py ./bin/
cp -v ./jconverter/rgb2cry.py ./bin/

#make binary linking/unlinking scripts
echo "\n"
echo "${RED}Making linking/unlinking scripts. Placing in bin folder.${NC}\n"
echo "\n"

touch ./bin/link_binaries.sh
touch ./bin/unlink_binaries.sh

echo "#!/bin/bash" >> ./bin/link_binaries.sh

echo "sudo ln -s $INSTALLPATH/bin/bigpemu /usr/bin/bigpemu" >> ./bin/link_binaries.sh
echo "sudo ln -s $INSTALLPATH/bin/jcp /usr/bin/jcp" >> ./bin/link_binaries.sh
echo "sudo ln -s $INSTALLPATH/bin/lz77 /usr/bin/lz77" >> ./bin/link_binaries.sh
echo "sudo ln -s $INSTALLPATH/bin/converter.py /usr/bin/jag-image-converter" >> ./bin/link_binaries.sh
echo "sudo chmod +x /usr/bin/bigpemu" >> ./bin/link_binaries.sh
echo "sudo chmod +x /usr/bin/jcp" >> ./bin/link_binaries.sh
#add rules file that allows the user to invoke jcp without sudo/root permissions.  Confirmed to work with v2 skunkboards and SillyVenture skunkboards
echo "sudo chmod +x /usr/bin/lz77" >> ./bin/link_binaries.sh
echo "sudo chmod +x /usr/bin/jag-image-converter" >> ./bin/link_binaries.sh

echo "#!/bin/bash" >> ./bin/unlink_binaries.sh

echo "sudo rm -v /usr/bin/bigpemu" >> ./bin/unlink_binaries.sh
echo "sudo rm -v /usr/bin/jcp" >> ./bin/unlink_binaries.sh
echo "sudo rm -v /etc/udev/rules.d/64-skunk.rules" >> ./bin/unlink_binaries.sh
echo "sudo rm -v /usr/bin/lz77" >> ./bin/unlink_binaries.sh
echo "sudo rm -v /usr/bin/jag-image-converter" >> ./bin/unlink_binaries.sh


#remove build directores
echo "\n"
echo "${RED}Remove build directores.${NC}\n"
echo "\n"

sudo rm -r ./lz77/
sudo rm -r ./jcp/
sudo rm -r ./jconverter/


#copy binaries and sources to rmac/rln/jlibc/rmvlib toolchain Jaguar directory in the users home directory
echo "\n"
echo "${RED}Copy bin folder with included binaries to toolchain directory $INSTALLPATH${NC}\n"
echo "\n"

cp -ur ./bin/ $INSTALLPATH/
cp -ur ./src/ $INSTALLPATH/


#run linking script to add binaries to path so they can be envoked directly from the command line
echo "\n"
echo "${RED}run linking script to add binarys to path so they can be envoked directly from the command line\n"
echo "\n"

sh "${HOME}/Jaguar/bin/link_binaries.sh"


#backout and delete temp directory
echo "\n"
echo "${RED}Remove temporary directory.${NC}\n"
echo "\n"

sudo rm -r $TMPDIRECTORY/tmp_additional_jaguar_dev_binaries/

echo "\n"
echo "${RED}Finished!${NC} \n\nBinaries are located in your home directory at ${RED}$INSTALLPATH/bin${NC} directory. \nThese binaries are currently not setup to be envoked by name from a terminal.  Navigate to $INSTALLPATH/bin to run a script to enable the user to envoke each binary from a terminal without the need of a filepath to the binary.${NC}\n"

