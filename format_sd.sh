# Brainded formatting of SD in /dev/mmcblk0
# Assumes SD is 32 Gb and all space is to be used
# Needs lot of expansion to become generic

# target_disk=$1
target_disk="/dev/mmcblk0"
echo "Got ${target_disk} as target drive"
echo ""
echo "WARNING! All data on this device will be wiped out! Continue at your own risk!"
echo ""
read -p "Press [Enter] to continue or CTRL+C to quit"

cgpt create /dev/mmcblk0

echo "Creating kernel partition ..."
cgpt add -i 6 -b 64 -s 32768 -S 1 -P 5 -l KERN-A -t "kernel" ${target_disk}

echo "Creating rootfs partition ..."
cgpt add -i 7 -b 32832 -s 60335007 -l ROOT-A -t "rootfs" ${target_disk}

echo "Done!"
