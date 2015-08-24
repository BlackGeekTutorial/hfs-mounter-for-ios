#!/bin/bash

UNMOUNTRESULT=$( { umount /private/var/mobile/EXT | sed s/Output/Useless/ > outfile; } 2>&1 )

if [[ $UNMOUNTRESULT == *"not currently mounted"* ]]; then
	echo "Device already unmounted :)"
else
	echo "Device unmounted :)"
fi