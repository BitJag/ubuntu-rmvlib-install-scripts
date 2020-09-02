#!/bin/bash
 
RED='\033[0;31m'
NC='\033[0m' # No Color


echo "\n${NC}This script removes and then updates a current Removers Library tool chain installed with the rmvlib_install.sh script.\nThis assumes that your toolchain folder is still located in the default location, which is <your home folder>/Jaguar. \n\nThis includes RMAC, RLN, JLIBC, RMVLIB${RED}\n\nDo you you wish to continue?  Type: yes/no:${NC}"

read CONTINUE

if [ "$CONTINUE" = "yes" ] || [ "$CONTINUE" = "y" ]
then

echo "${RED}\nRemoving local source folders and lib/include folders for RMAC, RLN, JLIBC, RMVLIB.\n${NC}"

rm -rv $HOME/Jaguar/src/rmac
rm -rv $HOME/Jaguar/src/rln
rm -rv $HOME/Jaguar/src/jlibc
rm -rv $HOME/Jaguar/src/rmvlib
rm -rv $HOME/Jaguar/lib/lib
rm -rv $HOME/Jaguar/lib/include

echo  "\n${RED}Copy Temporary Assets Directory${NC}\n"

cp -vr ./assets $HOME/Jaguar

echo "${RED}\nDownload latest source code for RMAC, RLN, JLIBC, RMVLIB to local src directory.\n${NC}"

cd $HOME/Jaguar/src

git clone http://shamusworld.gotdns.org/git/rmac
git clone http://shamusworld.gotdns.org/git/rln
git clone https://github.com/sbriais/jlibc.git
git clone https://github.com/sbriais/rmvlib.git

echo "${RED}\nRun any patches in temp assets direction on sources.\n${NC}"

cd rmac
#Patch rmac
patch -p1 -i $HOME/Jaguar/assets/patch_files/9-2-2020_rmac.patch
cd $HOME/Jaguar/src

echo "${RED}\n\nBegin Building sources\n\n${NC}"

#modify and build rmac 2.0.0
echo  "\n${RED}Building RMAC${NC}\n"
cd rmac
make
cd $HOME/Jaguar/src

#patching and building rln
echo  "\n${RED}Building RLN${NC}\n"
cd rln
make
cd $HOME/Jaguar/src

#modify and build jlibc
echo  "\n${RED}Building JLIBC${NC}\n"
cd jlibc
sed -i '/MADMAC=/c\MADMAC=$(JAGPATH)/src/rmac/rmac' Makefile.config #change makefile.config to point to our new rmac
sed -i '/OSUBDIRS=/c\OSUBDIRS=ctype' Makefile #don't build documentation
make
make install
cd $HOME/Jaguar/src

#modify and build rmvlib
echo  "\n${RED}Building RMVLIB${NC}\n"
cd rmvlib
#change makefiles
sed -i '/MADMAC=/c\MADMAC=$(JAGPATH)/src/rmac/rmac' Makefile.config #change makefile.config to point to our new rmac
sed -i '/OSUBDIRS=/c\OSUBDIRS=' Makefile #don't build documentation
make
make install

cd $HOME/Jaguar/src 

#copy libgcc.a from m68k-mint-atari tools
echo  "\n${RED}copy libgcc.a from m68k-mint-atari tools into lib folder${NC}\n"
cd $HOME/Jaguar/lib/lib
cp -v /usr/lib/gcc/m68k-atari-mint/4.6.4/libgcc.a ./
cd $HOME/Jaguar


echo  "\n${RED}Remove Temporary Assets Directory${NC}\n"
rm -rv ./assets

echo  "\n\n${RED}Finished updating Removers Library${NC}\n\n"


else

echo "${NC}Exiting\n\n${NC}"
exit

fi
