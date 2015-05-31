vbutil_arch="arm"
target_rootfs=/dev/mmcblk1p7
target_kern=/dev/mmcblk1p6

current_rootfs="`rootdev -s`"
current_kernfs_num=$((${current_rootfs: -1:1}-1))
current_kernfs=${current_rootfs: 0:-1}$current_kernfs_num

cd /tmp
echo "console=tty1 debug verbose root=${target_rootfs} rootwait rw lsm.module_locking=0" > kernel-config

vbutil_kernel --repack ${target_kern} \
    --oldblob $current_kernfs \
    --keyblock /usr/share/vboot/devkeys/kernel.keyblock \
    --version 1 \
    --signprivate /usr/share/vboot/devkeys/kernel_data_key.vbprivk \
    --config kernel-config \
    --arch $vbutil_arch

