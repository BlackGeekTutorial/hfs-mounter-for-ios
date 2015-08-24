#!/bin/bash


iscmdfound () {

CLITOOL=$( { $1 | sed s/Output/Useless/ > outfile; } 2>&1 )
if [[ $CLITOOL == *"command not found"* ]]; then
    echo "ERROR: Command not found: '$1'. Exiting with failure status now."
exit
fi

}

iscmdfound umount


UNMOUNTRESULT=$( { umount /private/var/mobile/EXT | sed s/Output/Useless/ > outfile; } 2>&1 )

if [[ $UNMOUNTRESULT == *"not currently mounted"* ]]; then
	echo "Device already unmounted :)"
else
	echo "Device unmounted :)"
fi