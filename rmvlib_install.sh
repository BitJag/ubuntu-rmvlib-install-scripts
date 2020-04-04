#!/bin/bash
 
RED='\033[0;31m'
NC='\033[0m' # No Color

echo "\nEnter the number for which Linux distribution will you be installing on:\n1) Ubuntu\n2) Debian 9"
 
 
read CHOICE

if [ $CHOICE -ne 1 ] && [ $CHOICE -ne 2 ]
then
    
    echo "\nInvalid OS selection, exiting...\n"
    exit 1
    
fi
 
if [ $CHOICE = 1 ]
then

    #add m68k-mint-atari cross compiler from ppa for Ubuntu installs
    echo "\n${RED}Adding Repository For Cross Compiler Tools for Ubuntu Installation${NC}\n"
    sudo add-apt-repository -y ppa:vriviere/ppa
    sudo apt-get update -y
    echo  "\n${RED}Installing Cross Compiler Tools & GIT${NC}\n"
    sudo apt-get install -y gcc-m68k-atari-mint
    sudo apt-get install -y cross-mint-essential
    
fi

sudo apt install -y git make build-essential

#setup our folders for our tools and build environment path
echo  "\n${RED}Adding Tools Directory${NC}\n"

mkdir -v $HOME/Jaguar
mkdir -v $HOME/Jaguar/example_programs
mkdir -v $HOME/Jaguar/lib
mkdir -v $HOME/Jaguar/lib/lib
mkdir -v $HOME/Jaguar/lib/include
mkdir -v $HOME/Jaguar/src

echo  "\n${RED}Copy Temporary Assets Directory${NC}\n"

cp -vr ./assets $HOME/Jaguar

cd $HOME/Jaguar/

echo  "\n${RED}Setting Environment Variable JAGPATH${NC}\n"


export JAGPATH=/home/$USER/Jaguar #export for the session the script is running so libraries install correctly

echo "export JAGPATH=/home/$USER/Jaguar" | sudo tee -a /etc/environment 
 
if [ $CHOICE = 2 ]
then

    #download tools
    echo  "\n${RED}Downloading, extracting, and linking m68k cross-compiler toolchain for Debian 9 Installation${NC}\n"

    wget https://tho-otto.de/download/mint/binutils-2.33.1-mint-20200102-bin-linux.tar.xz
    wget https://tho-otto.de/download/mint/gcc-4.6.4-mint-20170518-bin-linux.tar.xz

    tar xvf binutils-2.33.1-mint-20200102-bin-linux.tar.xz
    tar xvf gcc-4.6.4-mint-20170518-bin-linux.tar.xz

    sudo ln -sf $HOME/Jaguar/usr/bin/m68k-atari-mint-gcc /usr/bin/m68k-atari-mint-gcc
    sudo ln -sf $HOME/Jaguar/usr/bin/m68k-atari-mint-ar /usr/bin/m68k-atari-mint-ar
    cp $HOME/Jaguar/usr/lib64/gcc/m68k-atari-mint/4.6.4/libgcc.a $HOME/Jaguar/lib/lib/libgcc.a

    rm binutils-2.33.1-mint-20200102-bin-linux.tar.xz
    rm gcc-4.6.4-mint-20170518-bin-linux.tar.xz

fi

echo  "\n${RED}Downloading RMAC/RLN Source From GIT Repositories${NC}\n"

cd $HOME/Jaguar/src

git clone http://shamusworld.gotdns.org/git/rmac
git clone http://shamusworld.gotdns.org/git/rln
# git clone https://github.com/ocaml/ocaml.git
# git clone https://github.com/sbriais/jlinker.git
echo  "\n${RED}Downloading jlibc/rmvlib Libraries From GIT Repositories${NC}\n"
git clone https://github.com/sbriais/jlibc.git
git clone https://github.com/sbriais/rmvlib.git

#modify and build rmac 2.0.0
echo  "\n${RED}Building RMAC${NC}\n"

cd rmac

sed -i '/_attr = cursect | D/c\*a_attr = DEFINED;' expr.c #manual alteration to rmac to make it properly compile display.s, sound.s and paula.s in rmvlib.

make

cd $HOME/Jaguar/src

#patching and building rln
echo  "\n${RED}Building RLN${NC}\n"
cd rln
make
cd $HOME/Jaguar/src

#building ocaml and jlinker
# echo  "\n${RED}Building latest version of ocaml in order to build jlinker.  (THIS WILL TAKE A FEW MINUTES)${NC}\n"

# cd ocaml

# ./configure
# make -j$(nproc)
# sudo make install

# cd $HOME/Jaguar/src

# echo  "\n${RED}Building jlinker${NC}\n"

# cd jlinker

# make
# mv jlinker.native ./jlinker
# make clean

# cd $HOME/Jaguar/src

#clean up - delete ocaml

# sudo rm -rv /usr/local/lib/ocaml/
# sudo rm -rv /usr/local/bin/ocaml*
# sudo rm -rv /usr/local/man/man1/
# sudo rm -rv ./ocaml/

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

    #fix display.s
cd display
sed -i 's/10-\*/10-pc1/g' display.s
sed -i '/-pc1/i\\tpc1=\*' display.s

sed -i 's/40-\*/40-pc2/g' display.s
sed -i '/-pc2/i\\tpc2=\*' display.s
cd ..

    #fix sound.s
cd sound
sed -i 's/-\*/-pc1/g' sound.s 
sed -i '/-pc1/i\\tpc1=\*' sound.s
    #fix paula.s
sed -i 's/-\*/-pc1/g' paula.s 
sed -i '/padding_/i\\tpc1=\*' paula.s
cd ..

    #change makefiles
sed -i '/MADMAC=/c\MADMAC=$(JAGPATH)/src/rmac/rmac' Makefile.config #change makefile.config to point to our new rmac
sed -i '/OSUBDIRS=/c\OSUBDIRS=' Makefile #don't build documentation
make
make install

cd $HOME/Jaguar/src 

if [ $CHOICE = 1 ]
then

    #copy libgcc.a from m68k-mint-atari tools
    echo  "\n${RED}copy libgcc.a from m68k-mint-atari tools into lib folder${NC}\n"

    cd $HOME/Jaguar/lib/lib

    cp -v /usr/lib/gcc/m68k-atari-mint/4.6.4/libgcc.a ./
    
fi

cd $HOME/Jaguar

echo  "\n${RED}copy libgcc.a from m68k-mint-atari tools into lib folder${NC}\n"

mv -v ./assets/generic_example ./example_programs/
rm -rv ./assets

echo  "\n${RED}Finished installing Removers Library${NC}\n"
echo  "\n\n${RED}Logout/Restart Computer So New Environment Variable Can Take Effect${NC}\n\n"

