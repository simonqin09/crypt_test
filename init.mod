#!/bin/busybox sh

PATH=/sbin:/bin:/usr/sbin:/usr/bin

/bin/busybox --install /bin

mkdir -p /proc /sys
mount -t proc proc /proc
mount -t sysfs sysfs /sys
mkdir -p /dev/pts
mount -t devpts devpts /dev/pts
mount -t devtmpfs udev /dev
echo /bin/mdev > /proc/sys/kernel/hotplug
mdev -s
mkdir -p /mnt/rootfs
cryptsetup luksOpen --key-file key /dev/mmcblk0p2 rootfs
mount /dev/mapper/rootfs /mnt/rootfs
cd /mnt/rootfs
mount --move /sys sys
mount --move /proc proc
mount --move /dev dev
exec switch_root -c /dev/console /mnt/rootfs /sbin/init
