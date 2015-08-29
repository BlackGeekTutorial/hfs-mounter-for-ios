#!/bin/bash

# This is my little tool to mount HFS, HFSX and HFS+ devices plugged in ANY iPad with ANY iOS version.
# Just plug your USB/SD Card in with the Apple Camera Connection Kit and wait for the "Unsupported device" message on your screen. Then, run 'hfsmounter.sh' from root user in Terminal.

iscmdfound () {
CLITOOL=$( { $1 | sed s/Output/Useless/ > outfile; } 2>&1 )
if [[ $CLITOOL == *"command not found"* ]]; then
    echo "ERROR: Command not found: '$1'. Exiting with failure status now."
    exit 1
fi
}

show () {
if [ "$1" == "-v" ]; then
    echo "$2"
fi
}

iscmdfound df
iscmdfound umount
iscmdfound mount
iscmdfound grep
iscmdfound mount_hfs

if [ "$(id -u)" != "0" ]; then
    echo -en '\E[47;31m'"\033[1m>>> ERROR: This script must be executed with root privileges! Re-run it by typing: su -c hfsunmounter.sh <<<\033[0m"; echo ""
    exit 1
fi

echo ""; echo "Welcome to hfs mounter for iOS"
show "$1" "Use -v argument for verbose output"
echo ""
show "$1" "Processing default iOS mount path..."

for d in /private/var/mnt/mount*; do
    umount $d > /dev/null 2>&1
done

show "$1" "Checking if this is a developer device..."

DEVELOPER="$(df /Developer)"
if [[ $DEVELOPER == *"disk0"* ]]; then
    show "$1" "Your device is not in developer mode."
    developermode=false
else
    show "$1" "Developer partition detected. You're device is in developer mode."
    developermode=true
fi

show "$1" "Creating mounting point..."; show "$1" ""

mkdir "/var/mobile/EXT" > /dev/null 2>&1
umount "/var/mobile/EXT" > /dev/null 2>&1

for i in /dev/disk*; do
    show "$1" "Checking disk: $i ..."
   
    if [ "$developermode" = true ] ; then
        if [[ $DEVELOPER == *"$i"* ]]; then
            show "$1" "This device is used by Xcode. Skipping..."; show "$1" ""
continue
        fi
    fi
   
    if mount | grep "$i" > /dev/null; then
        show "$1" "This device is used by the system. Skipping..."; show "$1" ""
continue
    fi

    mount_hfs "$i" "/var/mobile/EXT" > /dev/null 2>&1
   
    MOUNTPOINT="$(df /private/var/mobile/EXT)"
   
    if ! [[ $MOUNTPOINT == *"disk0"* ]]; then
        echo ""; echo ""
        echo -en '\E[47;32m'"\033[1m>>> Device has been successfully mounted in: '/var/mobile/EXT' <<<\033[0m"; echo ""
break
    else
        show "$1" "Not the right one. Skipping..."; show "$1" ""
    fi
	
done

if [[ "$(df /private/var/mobile/EXT)" == *"disk0"* ]]; then
echo -en '\E[47;31m'"\033[1m>>> ERROR: No device has been mounted <<<\033[0m"; echo ""
fi