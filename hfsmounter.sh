#!/bin/bash

echo ""; echo "Welcome to hfs mounter for iOS"

if ! [ "$1" == "-v" ]; then
    echo "Use -v argument for verbose output"
fi

echo ""

if [ "$1" == "-v" ]; then
    echo "Processing default iOS mount path..."
fi

for d in /var/mnt/mount*; do
    umount $d > /dev/null 2>&1
done

if [ "$1" == "-v" ]; then
    echo "Checking if this is a developer device..."
fi

DEVELOPER="$(df /Developer)"
if [[ $DEVELOPER == *"disk0"* ]]; then
    if [ "$1" == "-v" ]; then
        echo "Your device is not in developer mode."
    fi
    developermode=false
else
    if [ "$1" == "-v" ]; then
        echo "Developer partition detected. You're device is in developer mode."
    fi
    developermode=true
fi

if [ "$1" == "-v" ]; then
    echo "Creating mounting point..."; echo ""
fi

mkdir "/var/mobile/EXT" > /dev/null 2>&1
umount "/var/mobile/EXT" > /dev/null 2>&1

for i in /dev/disk*; do
    if [ "$1" == "-v" ]; then
        echo "Checking disk: $i ..."
    fi
   
    if [ "$developermode" = true ] ; then
        if [[ $DEVELOPER == *"$i"* ]]; then
            if [ "$1" == "-v" ]; then
                echo "This device is used by Xcode. Skipping..."; echo ""
            fi
continue
        fi
    fi
   
    if mount | grep "$i" > /dev/null; then
        if [ "$1" == "-v" ]; then
            echo "This device is used by the system. Skipping..."; echo ""
        fi
continue
    fi

    mount_hfs "$i" "/var/mobile/EXT" > /dev/null 2>&1
   
    MOUNTPOINT="$(df /var/mobile/EXT)"
   
    if ! [[ $MOUNTPOINT == *"disk0"* ]]; then
        echo ""; echo ""
        echo -en '\E[47;32m'"\033[1m>>> Device has been successfully mounted in: '/var/mobile/EXT' <<<\033[0m"; echo ""
break
    else
        if [ "$1" == "-v" ]; then
            echo "Not the right one. Skipping..."; echo ""
        fi
    fi
	
done