#!/bin/bash
 
RED='\033[0;31m'
NC='\033[0m' # No Color


echo "\n${NC}This script removes and then updates a current Removers Library tool chain installed with the rmvlib_install.sh script.\nThis assumes scripts assumes that your JAGPATH environment variable is properly setup.\n\nThis will remove and update RMAC, RLN, JLIBC, RMVLIB, and the generic example folder.\nThis does not update any applications that were installed with the additional applications script.${RED}\n\nDo you you wish to continue?  Type: yes/no:${NC}"

read CONTINUE

if [ "$CONTINUE" = "yes" ] || [ "$CONTINUE" = "y" ]
then

echo "${RED}\nRemoving local source folders and lib/include folders for RMAC, RLN, JLIBC, RMVLIB.\n${NC}"

rm -rvf $JAGPATH/src/rmac
rm -rvf $JAGPATH/src/rln
rm -rvf $JAGPATH/src/jlibc
rm -rvf $JAGPATH/src/rmvlib
rm -rvf $JAGPATH/lib/lib/*
rm -rvf $JAGPATH/lib/include/*
rm -rvf $JAGPATH/bin/mac
rm -rvf $JAGPATH/bin/aln
rm -rvf $JAGPATH/example_programs/generic_example

echo  "\n${RED}Copy Temporary Assets Directory${NC}\n"

cp -vr ./assets/generic_example $JAGPATH/example_programs/

echo "${RED}\nDownload latest source code for RMAC, RLN, JLIBC, RMVLIB to local src directory.\n${NC}"

cd $JAGPATH/src

git clone http://shamusworld.gotdns.org/git/rmac
git clone http://shamusworld.gotdns.org/git/rln
git clone https://github.com/theRemovers/jlibc.git
git clone https://github.com/theRemovers/rmvlib.git

echo "${RED}\n\nBegin Building sources\n\n${NC}"

#modify and build rmac 2.0.0
echo  "\n${RED}Building RMAC${NC}\n"
cd rmac
make
cp -vr rmac $JAGPATH/bin/mac #renaming to make more compatible with sebs makefiles
cd $JAGPATH/src

#build rln
echo  "\n${RED}Building RLN${NC}\n"
cd rln
make
cp -vr rln $JAGPATH/bin/aln #renaming to make more compatible with sebs makefiles
cd $JAGPATH/src

#build jlibc
echo  "\n${RED}Building JLIBC${NC}\n"
cd jlibc
make
make install
cd $JAGPATH/src

#build rmvlib
echo  "\n${RED}Building RMVLIB${NC}\n"
cd rmvlib
make
make install

cd $JAGPATH/src 

#copy libgcc.a from m68k-mint-atari tools
echo  "\n${RED}copy libgcc.a from m68k-mint-atari tools into lib folder${NC}\n"
cd $JAGPATH/lib/lib
find /usr/lib/gcc/m68k-atari-mint/ -type f -name "libgcc.a" -exec cp {} ./ \;
cd $JAGPATH

echo  "\n\n${RED}Finished updating Removers Library${NC}\n\n"


else

echo "${NC}Exiting\n\n${NC}"
exit

fi
