#!/bin/bash

RED='\033[0;31m'
NC='\033[0m' # No Color
TMPDIRECTORY=/tmp
INSTALLDIRECTORYNAME='Jaguar'
INSTALLPATH="/home/$USER/$INSTALLDIRECTORYNAME"


echo "\n"
echo "${RED}Installer script for Virtual Jaguar, Seb's Jaguar Image Converter, ray's lz77 Packer, and the latest version of Tursi's JCP.${NC}\nScript last updated 2/25/2020\n"

echo "${RED}Installation requires access to the ubuntu repositories and an internet connection.${NC}\n"

echo "${RED}Sources are pulled from the following locations on the web:\n"

echo "${RED}Virtual Jaguar${NC} - https://github.com/mirror/virtualjaguar\n"
echo "${RED}JCP${NC} - http://www.harmlesslion.com/zips/SKUNKBOARD_FULL_RELEASE.zip\n"
echo "${RED}Seb's Jaguar Image Converter${NC} - http://removers.free.fr/softs/archives/converter-0.1.9.tar.gz\n"
echo "${RED}Ray's lz77 Packer${NC} - http://s390174849.online.de/ray.tscc.de/files/lz77_v13.zip\n${NC}"

echo "Consider supporting these developers and their effors with donation and feeback.\n"


#prerequisites
echo "\n"
echo "${RED}Adding necessary packages for binary building.${NC}\n"
echo "\n"

sudo apt-get install -y make git unzip libsdl1.2-dev qt5-qmake qt5-default qtchooser qtbase5-dev-tools libusb-dev libusb-0.1-4  

#ocaml ocaml-base ocaml-libs ocamlbuild ocaml-findlib libcamlimages-ocaml-dev


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

#virtualjaguar
git clone https://github.com/mirror/virtualjaguar.git
zip ./virtualjaguar
tar -cvf virtualjaguar.tar ./virtualjaguar/
mv -v ./virtualjaguar.tar ./src/other_binaries

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
git clone https://github.com/sbriais/jconverter.git
rm -rv ./jconverter/*.tar*
rm -rv ./jconverter/*.zip
rm -rv ./jconverter/binaries/windowsXP/



#Build Binaries

echo "\n"
echo "${RED}Begin building binaries.${NC}\n"

#virtualjaguar
echo "\n"
echo "${RED}Building virtualjaguar. (THIS USAULLY TAKES A FEW MINUTES).${NC}\n"
echo "\n"
sleep 1
cd ./virtualjaguar
make
cd ..


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


#jag-image-converter
echo "\n"
echo "${RED}Building jag-image-converter.${NC}\n"
echo "\n"
sleep 1
# cd converter
# ocamlbuild -use-ocamlfind -package camlimages converter.native
# cd ..


#copy build binaries to bin folder
echo "\n"
echo "${RED}Copy built binaries to bin folder.${NC}\n"
echo "\n"

cp -v ./virtualjaguar/virtualjaguar ./bin/
cp -v ./jcp/jcp ./bin/
cp -v ./lz77/lz77 ./bin/
cp -v ./jconverter/binaries/linux/converter.opt ./bin/jag-image-converter

#make binary linking/unlinking scripts
echo "\n"
echo "${RED}Making linking/unlinking scripts. Placing in bin folder.${NC}\n"
echo "\n"

touch ./bin/link_binaries.sh
touch ./bin/unlink_binaries.sh

echo "#!/bin/bash" >> ./bin/link_binaries.sh

echo "sudo ln -s $INSTALLPATH/bin/virtualjaguar /usr/bin/virtualjaguar" >> ./bin/link_binaries.sh
echo "sudo ln -s $INSTALLPATH/bin/jcp /usr/bin/jcp" >> ./bin/link_binaries.sh
echo "sudo ln -s $INSTALLPATH/bin/lz77 /usr/bin/lz77" >> ./bin/link_binaries.sh
echo "sudo ln -s $INSTALLPATH/bin/jag-image-converter /usr/bin/jag-image-converter" >> ./bin/link_binaries.sh
echo "sudo chmod +x /usr/bin/virtualjaguar" >> ./bin/link_binaries.sh
echo "sudo chmod +x /usr/bin/jcp" >> ./bin/link_binaries.sh
#add rules file that allows the user to invoke jcp without sudo/root permissions.  Confirmed to work with v2 skunkboards and SillyVenture skunkboards
echo "sudo chmod +x /usr/bin/lz77" >> ./bin/link_binaries.sh
echo "sudo chmod +x /usr/bin/jag-image-converter" >> ./bin/link_binaries.sh

echo "#!/bin/bash" >> ./bin/unlink_binaries.sh

echo "sudo rm -v /usr/bin/virtualjaguar" >> ./bin/unlink_binaries.sh
echo "sudo rm -v /usr/bin/jcp" >> ./bin/unlink_binaries.sh
echo "sudo rm -v /etc/udev/rules.d/64-skunk.rules" >> ./bin/unlink_binaries.sh
echo "sudo rm -v /usr/bin/lz77" >> ./bin/unlink_binaries.sh
echo "sudo rm -v /usr/bin/jag-image-converter" >> ./bin/unlink_binaries.sh


#remove build directores
echo "\n"
echo "${RED}Remove build directores.${NC}\n"
echo "\n"

sudo rm -r ./virtualjaguar/
sudo rm -r ./lz77/
sudo rm -r ./jcp/
sudo rm -r ./converter/


#copy binaries and sources to rmac/rln/jlibc/rmvlib toolchain Jaguar directory in the users home directory
echo "\n"
echo "${RED}Copy bin folder with included binaries to toolchain directory $INSTALLPATH${NC}\n"
echo "\n"

cp -ur ./bin/ $INSTALLPATH/
cp -ur ./src/ $INSTALLPATH/


#backout and delete temp directory
echo "\n"
echo "${RED}Remove temporary directory.${NC}\n"
echo "\n"

sudo rm -r $TMPDIRECTORY/tmp_additional_jaguar_dev_binaries/

#remove uneeded packages
echo "\n"
echo "${RED}Remove uneeded packages.${NC}\n"
echo "\n"

sudo apt-get remove -y libsdl1.2-dev qt5-qmake qt5-default libusb++-dev ocaml* libcamlimages-ocaml* 

echo "\n"
echo "${RED}Finished!${NC} \n\nBinaries are located in your home directory at ${RED}$INSTALLPATH/bin${NC} directory. \nThese binaries are currently not setup to be envoked by name from a terminal.  Navigate to $INSTALLPATH/bin to run a script to enable the user to envoke each binary from a terminal without the need of a filepath to the binary.${NC}\n"

