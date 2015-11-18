# Prepares an MMC card with the required partitions to install Chrubuntu.
# These partitions are:
# . boot kernel 
# . rootfs (where Chrubuntu can be installed)
# This script requires the cgpt package (avaliable in Debian based systems).
#
# Arguments:
# 1. target disk
# 2. rootfs partition size in 512 Kb blocks
#
# Usage example: sudo format_mmc.sh /dev/mmcblk1 60335007

target_disk=$1
rootfs_size=$2

echo "Got ${target_disk} as target drive"
echo ""
echo "WARNING! All data on this device will be wiped out! Continue at your own risk!"
echo ""
read -p "Press [Enter] to continue or CTRL+C to quit"

cgpt create ${target_disk}

echo "Creating kernel partition ..."
cgpt add -i 6 -b 64 -s 32768 -S 1 -P 5 -l KERN-A -t "kernel" ${target_disk}

echo "Creating rootfs partition ..."
cgpt add -i 7 -b 32832 -s ${rootfs_size} -l ROOT-A -t "rootfs" ${target_disk}

echo "Done!"
