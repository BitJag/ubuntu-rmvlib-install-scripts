#!/bin/bash
 
RED='\033[0;31m'
NC='\033[0m' # No Color
INSTALLDIRECTORYNAME='Jaguar'
INSTALLPATH="/home/$USER/$INSTALLDIRECTORYNAME"

sudo apt install -y git make build-essential

#add m68k-mint-atari cross compiler from ppa for Ubuntu installs
echo "\n${RED}Adding Repository For Cross Compiler Tools for Ubuntu Installation${NC}\n"
sudo add-apt-repository -y ppa:vriviere/ppa
sudo apt-get update -y
echo  "\n${RED}Installing Cross Compiler Tools & GIT${NC}\n"
sudo apt-get install -y gcc-m68k-atari-mint
sudo apt-get install -y cross-mint-essential

#setup our folders for our tools and build environment path
echo  "\n${RED}Adding Tools Directory${NC}\n"

mkdir -vp $INSTALLPATH
mkdir -vp $INSTALLPATH/bin
mkdir -vp $INSTALLPATH/example_programs
mkdir -vp $INSTALLPATH/lib
mkdir -vp $INSTALLPATH/lib/lib
mkdir -vp $INSTALLPATH/lib/include
mkdir -vp $INSTALLPATH/src

echo  "\n${RED}Copy Temporary Assets Directory${NC}\n"
cp -vr ./assets $INSTALLPATH
cd $INSTALLPATH/

echo  "\n${RED}Setting Environment Variable JAGPATH${NC}\n"
export JAGPATH=$INSTALLPATH #export for the session the script is running so libraries install correctly
echo "export JAGPATH=$INSTALLPATH" | sudo tee -a /etc/environment 

echo  "\n${RED}Downloading RMAC/RLN Source From GIT Repositories${NC}\n"
cd $INSTALLPATH/src
git clone http://shamusworld.gotdns.org/git/rmac
git clone http://shamusworld.gotdns.org/git/rln
echo  "\n${RED}Downloading jlibc/rmvlib Libraries From GIT Repositories${NC}\n"
git clone https://github.com/sbriais/jlibc.git
git clone https://github.com/sbriais/rmvlib.git

echo "${RED}\n\nBegin Building sources\n\n${NC}"

#modify and build rmac 2.0.0
echo  "\n${RED}Building RMAC${NC}\n"
cd rmac
make
cp -vr rmac $INSTALLPATH/bin/mac #renaming to make more compatible with sebs makefiles
cd $INSTALLPATH/src

#patching and building rln
echo  "\n${RED}Building RLN${NC}\n"
cd rln
make
cp -vr rln $INSTALLPATH/bin/aln #renaming to make more compatible with sebs makefiles
cd $INSTALLPATH/src

#modify and build jlibc
echo  "\n${RED}Building JLIBC${NC}\n"
cd jlibc
make
make install
cd $INSTALLPATH/src

#modify and build rmvlib
echo  "\n${RED}Building RMVLIB${NC}\n"
cd rmvlib
make
make install
cd $INSTALLPATH/src 

#copy libgcc.a from m68k-mint-atari tools
echo  "\n${RED}copy libgcc.a from m68k-mint-atari tools into lib folder${NC}\n"
cd $INSTALLPATH/lib/lib
find /usr/lib/gcc/m68k-atari-mint/ -type f -name "libgcc.a" -exec cp {} ./ \;
cd $INSTALLPATH

echo  "\n${RED}copy example program${NC}\n"
mv -v ./assets/generic_example ./example_programs/
rm -rv ./assets

echo  "\n${RED}Finished installing Removers Library${NC}\n"
echo  "\n\n${RED}Logout/Restart Computer So New Environment Variable Can Take Effect${NC}\n\n"

