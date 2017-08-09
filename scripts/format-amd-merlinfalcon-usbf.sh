#!/bin/bash

PATH_PREFIX=`pwd`
TARGET_DEVICE=/dev/sda
DEVICE=""

while getopts ":d:ht:" opt; do
    case $opt in
    d)
        DEVICE=$OPTARG
        ;;
    h)
        echo "format-amd-merlinfalcon-usbf.sh: Populate the ocvdemo to a USB stick"
        echo "Required arguments:"
        echo "  -d DEVICE              Device node of USB stick on the host"
        echo "                         e.g. /dev/sdb"
        echo "                         WARNING!!! please double check this as"
        echo "                         using the incorrect device may cause"
        echo "                         loss of data!"
        echo ""
        echo "Optional arguments:"
        echo "  -t TARGET_DEVICE       Device node of the USB stick on the"
        echo "                         Merlin Falcon target"
        echo "                         Defaults to /dev/sda"
        exit 0
        ;;
    :)
        echo "Option -$OPTARG requires argument" 
        exit 1
        ;;
    \?)
        echo "Invalid option -$OPTARG"
        exit 1
        ;;
    t)
        TARGET_DEVICE=$OPTARG
        ;;
    esac
done

if [ -z ${DEVICE} ]; then
    echo "Please pass a valid device with -d, such as /dev/sde"
    exit 1
fi

# Check for device existance
if [ ! -b $DEVICE ]; then 
    echo "Device $DEVICE does not exist"
    exit 1
fi

# Refresh boot partition from build server
echo "Copying boot partition to scratch area"
mkdir -p ${PATH_PREFIX}/scratch/Downloads/hddimg
rm -rf ${PATH_PREFIX}/scratch/Downloads/hddimg/*
cp -r tmp/work/amdfalconx86-mel-linux/ocvdemo-image/1.0-r0/ocvdemo-image-1.0/hddimg/* ${PATH_PREFIX}/scratch/Downloads/hddimg

# Refresh rootfs from build server
echo "Copying rootfs image to scratch area"
mkdir -p ${PATH_PREFIX}/mnt/remote
#umount /mnt/remote
cp tmp/deploy/images/amdfalconx86/ocvdemo-image-amdfalconx86.ext4 ${PATH_PREFIX}/scratch/Downloads/
mount -o loop ${PATH_PREFIX}/scratch/Downloads/ocvdemo-image-amdfalconx86.ext4 ${PATH_PREFIX}/mnt/remote

mount | grep $DEVICE
if [ $? -eq 0 ]; then
    echo "Unmounting device(s)"
    umount ${DEVICE}
    umount ${DEVICE}1
    umount ${DEVICE}2
fi

echo "Partition device on $DEVICE"
# Wipe out current partition table
dd if=/dev/zero of=$DEVICE bs=512 count=2
sync

# Create the first (BOOT) partition
fdisk $DEVICE <<EOF
n
p
1

+64M
a
1
t
6
w
EOF

sync
sleep 1

# Create the rootfs partition
fdisk $DEVICE <<EOF
n
p
2


w
EOF

sync
sleep 1

# Now format both partitions - this takes some time for larger devices
echo -n "Formating partitions...this may take a long time..."
sudo mkdosfs -n BOOT -S 512 ${DEVICE}1
sudo mkfs.ext3 -L rootfs ${DEVICE}2
echo "Done"
syslinux ${DEVICE}1

# Now populate contents
echo "Populating ${DEVICE}1"
mkdir -p ${PATH_PREFIX}/mnt/boot
mount ${DEVICE}1 ${PATH_PREFIX}/mnt/boot
cp -r ${PATH_PREFIX}/scratch/Downloads/hddimg/* ${PATH_PREFIX}/mnt/boot

# Fix up grub.cfg
echo "Fixing grub configuration"
sed -i "s#/dev/ram0#${TARGET_DEVICE}2#g" ${PATH_PREFIX}/mnt/boot/EFI/BOOT/grub.cfg
sed -i "s#rootwait##g" ${PATH_PREFIX}/mnt/boot/EFI/BOOT/grub.cfg
sed -i "/initrd/d" ${PATH_PREFIX}/mnt/boot/EFI/BOOT/grub.cfg

sync
umount ${DEVICE}1

mkdir -p ${PATH_PREFIX}/mnt/rootfs
mount ${DEVICE}2 ${PATH_PREFIX}/mnt/rootfs

echo "Populating ${DEVICE}2"
cd ${PATH_PREFIX}/mnt/remote
# Check that our rootfs is mounted (on ${PATH_PREFIX}/mnt/remote)
if [ ! -f ./etc/issue ]; then
    echo "Please mount a root file system on ${PATH_PREFIX}/mnt/remote"
    exit 1
fi
tar c * | tar x -C ${PATH_PREFIX}/mnt/rootfs

echo "Syncing file system(s)"
sync

cd -

umount ${DEVICE}2
umount ${PATH_PREFIX}/mnt/remote

echo "Removing temporary files"
rm -rf ${PATH_PREFIX}/mnt
rm -rf ${PATH_PREFIX}/scratch

echo "Done!"

