# Introduction
These scripts were put together to make building and installing a specific Atari Jaguar development environment more conveinient. They were also created as way of retracing my steps in the future in case I need to build/install a specific tool or application included in these scripts.

There are no guarantees provided when you use this script.  These scripts will probably break and cease to work as packages update or disappear from the Ubuntu repositories over time.  Or build processes and source files for tools/applications change.

The only updates you can expect from me for these scripts are if and when I feel that I need to update them, but feel free to leave an issue in the tracker. I will do my best to help. Or, feel free to alter the script for your own needs.

# RMAC/RLN/JLIBC/RMVLIB Installer Script
(rmvlib_install.sh &  rmvlib_uninstall.sh)

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

### RLN
A modern version of Atari's old ALN linker. Created by Reboot.

source: http://shamusworld.gotdns.org/git/rln

### JLIBC
The Remover's standard C library.

source: https://github.com/theRemovers/jlibc

### RMVLIB
The Remover's C library for C functions specific to Atari Jaguar developement.

source: https://github.com/theRemovers/rmvlib

________________

## Requirements
Linux with an internet connection and access to the Ubuntu repositories using apt/apt-get. This script has only been tested on Kubuntu 20.04 LTS (5/2/2022) & Kubuntu 22.04 LTS (5/2/2022).  Again, if you have access to the Ubuntu repositores there shouldn't be any issues accessing the packages needed (barring any future code or name updates/changes to necessary packages that could potentially break this script).

If you are on another non-buntu distribution, you can attempt to manually installing the needed packages. Open up the *rmvlib_installer.sh* script in a text editor and refer to any lines that invoke *apt-get*.

________________

## Installing
Execute the install script, in a linux terminal, from wherever you have placed the script and the other contents of the archive. With the following command:

    sh ./rmvlib_install.sh

The script will ask for root permissions to install neccessary repositories and packages.

After the script finishes, and before you can build the example program, ***reboot your system or logout of your user and log back in***.  This will ensure that the new $JAGPATH environment variable is loaded from /etc/environment, allowing the current Makefile.config file to properly build the example program.  After logout/reboot, navigate to the following location in your home folder and run the make command.

    cd ~/Jaguar/example_programs/generic_example
    make
    
If you don't get any errors while compiling and linking the example program, everything should be built/installed correctly for the Jaguar development environment.

If you want to test more example programs.  Seb of the Removers has a repository (linked below) with all of his example files showcasing most of the functions in the Remover's Library.  In order to properly build these examples with the development environment setup by this script, you will need to adjust the makefile's slightly.  Make sure that paths are pointing to the correct bianaries in the Jaguar/bin folder, and the inlclude and lib folders locating in Jaguar/lib

source: https://github.com/theRemovers/jagexamples


## Updating
rmvlib_update.sh will remove the source trees for RMAC, RLN, JLIBC and RMVLIB, download and rebuild them with out removing any other files/folders you may have added to the default toolchain directory, located in your home folder in the Jaguar folder.  Make sure you download the latest copy of this repository, as the update may rely on files in the assets directory of this repository.

    sh ./rmvlib_update.sh

## Uninstall
If you make changes to the script, and/or you have run this installer script before, **you should run the uninstall script** before re-running the installer script. Navigate to the location of the uninstall script and run the following command:

    sh ./rmvlib_uninstall.sh
    
**IMPORTANT**

Because the uninstall script completely erases the Jaguar folder in your home folder, **be sure that you have backuped up any code/files/folders that you may have added while using this toolchain**. Any code/assets will be erased if your projects are in this folder.  The way the development environment is isntall allows the user to build from anywhere on their system. Pick another location other than the ~/Jaguar to do your development in to avoid losing your work.
    
### Debugging Scripts
If you run into problems running the script, use the following command instead to dump the output of the script as it runs.  You can then review the log to see where it is getting stuck.  **Be sure to run the uninstaller script before running the following command**.

    sh ./rmvlib_install.sh 2>&1 build.log
    
________________
________________

# Additional Jaguar Development Binaries Linux Installer
(additional_tools_install.sh)

## About
This script installs additional binaries to accomadate Atari Jaguar development on Linux.  **This script is meant to be run after the rmac/jlinker/jlibc/rmvlib installation script and will fail otherwise**.
________________
## Included Applications
The following apps will be built and installed to **<user's home folder>/Jaguar/bin/** directory in the current user's Home folder. This script will also install some additional packages to run the tools, most notably Wine to run the BigPEmu Atari Jaguar emulator.

### BigPEmu
Atari Jaguar emulator for running programs from your computer. 

source: https://www.richwhitehouse.com/jaguar/index.php?content=download

### jcp
Used to control a Skunkboard cart. With a Skunkboard and jcp you can easily send your .cof or .rom files to your Jaguar to test on real hardware.

source: http://www.harmlesslion.com/zips/SKUNKBOARD_FULL_RELEASE.zip

### lz77
A packing routine for data used in your programs.

source: http://s390174849.online.de/ray.tscc.de/files/lz77_v13.zip

### jag-image-converter (converter.py)
Used to convert some common image formates to formats compatible with the Remover's library and the Jaguar.

source: https://github.com/sbriais/jconverter
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
If you are having trouble using JCP from commandline after running the link_binaries.sh script, try running the command with sudo. For exampele, to reset the Jaguar use "sudo jcp -r" (without quotes).  Typically you shouldn't need sudo to do this, as there is a rules file that is created when JCP is linked to /usr/bin, but it is possible that the rule implemented doesn't cover all variations of the skunkboard out there.  If you find yourself in this situation, leave an issue in the issue tracker here on github, and we can quickly resolve this issue.
