#!/bin/bash


iscmdfound () {

CLITOOL=$( { $1 | sed s/Output/Useless/ > outfile; } 2>&1 )
if [[ $CLITOOL == *"command not found"* ]]; then
    echo "ERROR: Command not found: '$1'. Exiting with failure status now."
exit
fi

}

iscmdfound umount

if [ "$(id -u)" != "0" ]; then
    echo -en '\E[47;31m'"\033[1m>>> ERROR: This script must be executed with root privileges! Re-run it by typing: su -c hfsunmounter.sh <<<\033[0m"; echo ""
    exit 1
fi


UNMOUNTRESULT=$( { umount /private/var/mobile/EXT | sed s/Output/Useless/ > outfile; } 2>&1 )

if [[ $UNMOUNTRESULT == *"not currently mounted"* ]]; then
	echo "Device already unmounted :)"
else
	echo "Device unmounted :)"
fi