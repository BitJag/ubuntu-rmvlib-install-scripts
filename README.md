# Introduction
These scripts were put together to make building and installing a specific Atari Jaguar development environment more conveinient. They were also created as way of retracing my steps in the future in case I need to build/install a specific tool or application included in these scripts.

There are no guarantees provided when you use this script.  These scripts will probably break and cease to work as packages update or disappear from the Ubuntu repositories over time.  Or build processes and source files for tools/applications change.

The only updates you can expect from me for these scripts are if and when I feel that I need to update them, but feel free to leave an issue in the tracker. I will do my best to help. Or, feel free to alter the script for your own needs.

# RMAC/JLINKER/JLIBC/RMVLIB Installer Script
(rmvlib_installer.sh &  rmvlib_uninstaller.sh)

## About
This script will install a working Atari Jaguar development environment, based on JLIBC and the Remover's Library, on a linux machine with access to the Ubuntu repositories.

________________

## Installed Development Tools
The following tools will be built and installed to **<user's home folder>/Jaguar/**.

### GCC M68000 Cross Compiler
Cross Motorola 68000 C cross compiler.

source: http://vincent.riviere.free.fr/soft/m68k-atari-mint

### RMAC
A modern version of Atari's old Madmac assembler. Created by Reboot.

source: http://shamusworld.gotdns.org/git/rmac

### JLINKER
A modern version of Atari's old ALN linker. Created by Seb.

source: https://github.com/sbriais/jlinker

### JLIBC
The Remover's standard C library.

source: https://github.com/sbriais/jlibc

### RMVLIB
The Remover's C library for C functions specific to Atari Jaguar developement.

source: https://github.com/sbriais/rmvlib

________________

## Requirements
Linux with an internet connection and access to the Ubuntu repositories using apt/apt-get. This script has only been tested on Kubuntu 19.10 (2/26/2020).  Again, if you have access to the Ubuntu repositores there shouldn't be any issues accessing the packages needed (barring any future updates to necessary packages that could potential break this script).

If you are on another non-buntu distribution, you can attempt to manually installing the needed packages. Open up the *rmvlib_installer.sh* script in a text editor and refer to any lines that invoke *apt-get*.

________________

## Installing
Execute the install script, in a linux terminal, from wherever you have placed the script and the other contents of the archive. With the following command:

    sh ./rmvlib_install.sh

The script will as for root permissions to install necessary repositories and packages.

After the script finishes, navigate to the the following location in your
home folder and run the make command.

    cd ~/Jaguar/example_programs/example1
    make
    
If you don't get any errors while compiling and linking the example program, everything should be built/installed correctly.

## Uninstall
If you make changes to the script, and/or you have run this installer script before, **it is suggested that you run the uninstall script** before re-running the installer script. Navigate to the location of the uninstall script and run the followint command:

    sh ./rmvlib_uninstall.sh
    
### Debugging Scripts
If you run into a problems, use the following command instead to dump the output of the script as it runs.  You can then review the log to see where it is getting stuck.  **Be sure to run the uninstaller script before running the following command**.

    sh ./rmvlib_install.sh 2>&1 build.log
________________
## Notes
JLINKER requires at least ocaml version 4.08.0 in order to build.  This script downloads the source for this version of ocaml builds and installs.  It then removes ocaml completely. If you had ocaml installed before running this script, you may need to reinstall ocaml afterwards, or alter the script to avoid installing/uninstall ocaml during execution.

The example program is a reworked version of Seb's example which can be found here. 

https://github.com/sbriais/jagexamples

Notable changes were to *MakeFile*, which were just redifining paths to point to RMAC, JLINKER, and the Atari Mint Cross Compiler.
________________
________________

#Additional Jaguar Development Binaries Linux Installer
(additional_jaguar_development_binaries_installer.sh)
## About
This script installs additional binaries to accomadate Atari Jaguar development on Linux.  **This script is meant to be run after the rmac/jlinker/jlibc/rmvlib installation script and will fail otherwise**.
________________
## Included Applications
The following apps will be built and installed to **<user's home folder>/Jaguar/bin/** directory in the current user's Home folder.

### virutaljaugar
Atari Jaguar emulator for running programs from your computer. 

source: https://github.com/mirror/virtualjaguar

### jcp
Used to control a Skunkboard cart. With a Skunkboard and jcp you can easily send your .cof or .rom files to your Jaguar to test on real hardware.

source: http://www.harmlesslion.com/zips/SKUNKBOARD_FULL_RELEASE.zip

### lz77
A packing routine for data used in your programs.  Spefically, data packed with lz77 can be unpacked in your C code with the lz77_unpack() function. See Remover's Library documentation/source files for more details.

source: http://s390174849.online.de/ray.tscc.de/files/lz77_v13.zip

### jag-image-converter
Used to convert tga,png,gif,etc... formats to formats compatible with the Remover's library and the Jaguar.

source: http://removers.free.fr/softs/archives/converter-0.1.9.tar.gz
________________
## Installing
To run this script, open up a terminal, navigate to the location of the script, and then run the script with the following command:

    sh ./additional_tools_install.sh
    
### Debugging Script
If you run into a problems, use the following command instead to dump the output of the script as it runs.  You can then review the log to see where it is getting stuck.

    sh ./additional_tools_install.sh 2>&1 build.log
    
________________
## Invoking Applications From Terminal
After installation, you may want to invoke these programs by name from the terminal in order to run them.  Two scripts have been added to **<user's home folder>/Jaguar/bin/** .  Navigate to **<user's home folder>/Jaguar/bin/**, and run the following commands to link or unlink the binaries from /usr/bin/:

    sh ./link_binaries.sh
    sh ./unlink_binaries.sh
    
________________
## Notes
The Seb's jag-image-converter requires ocaml version 4.05.0 in order to build.  As of 2/26/2020, it will fail to build with any newer version of ocaml installed from source or the Ubuntu repositories.  In the future you may need to build ocaml version 4.05.0 from source in order to properly build this program.
