#!/bin/bash

echo ""; echo "Welcome to hfs mounter for iOS"; echo ""

echo "Processing default iOS mount path..."
for d in /var/mnt/mount*
do 
	umount $d > /dev/null 2>&1
done

echo "Checking if this is a developer device..."
DEVELOPER="$(df /Developer)"
if [[ $DEVELOPER == *"disk0"* ]]; then
	echo "Your device is not in developer mode."
	developermode=false
else
	echo "Developer partition detected. You're device is in developer mode."
	developermode=true
fi

echo "Creating mounting point..."; echo ""
mkdir "/var/mobile/EXT" > /dev/null 2>&1
umount "/var/mobile/EXT" > /dev/null 2>&1

for i in /dev/disk*;
do

	echo "Checking disk: $i ..."
   
	if [ "$developermode" = true ] ; then
		if [[ $DEVELOPER == *"$i"* ]]; then
			echo "This device is used by Xcode. Skipping..."; echo ""
continue
		fi
	fi
   
	if mount | grep "$i" > /dev/null; then
		echo "This device is used by the system. Skipping..."; echo ""
continue
	fi

	mount_hfs "$i" "/var/mobile/EXT" > /dev/null 2>&1
   
	MOUNTPOINT="$(df /var/mobile/EXT)"
   
	if ! [[ $MOUNTPOINT == *"disk0"* ]]; then
		echo ""; echo ""
		echo -en '\E[47;32m'"\033[1m>>> Device has been successfully mounted in: '/var/mobile/EXT' <<<\033[0m"; echo ""
break
	else
    	echo "Not the right one. Skipping..."; echo ""
	fi
	
done