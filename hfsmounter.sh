#!/bin/bash

echo ""
echo "Welcome to hfs mounter for iOS"
echo ""

echo "Creating mounting point..."
mkdir "/var/mobile/EXT" > /dev/null 2>&1
umount "/var/mobile/EXT" > /dev/null 2>&1
echo ""

for i in /dev/disk*s*;
do

   echo "Checking disk: $i ..."
if mount | grep "$i" > /dev/null; then
echo "This device is used by the system. Skipping..."
echo ""
else


   mount_hfs "$i" "/var/mobile/EXT" > /dev/null 2>&1
   
   if mount | grep "$i" > /dev/null; then
echo ""
echo ""
echo -en '\E[47;32m'"\033[1m>>> Device has been successfully mounted in: '/var/mobile/EXT' <<<\033[0m"; echo ""
    break
else
    echo "Not the right one. Skipping..."
echo ""
fi
fi
   done