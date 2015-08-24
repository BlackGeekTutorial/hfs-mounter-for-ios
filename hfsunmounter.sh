#!/bin/bash

UNMOUNTRESULT="$(umount /private/var/mobile/EXT)"

if [[ $UNMOUNTRESULT == *"not currently mounted"* ]]; then
	echo "Device already unmounted :)"
else
	echo "Device unmounted :)"
fi