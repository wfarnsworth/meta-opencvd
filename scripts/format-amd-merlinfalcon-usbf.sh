#!/bin/bash

# Comment out this line to use this script directly on local build machine
REMOTE_BUILD_MACHINE=chris@speedy:

if [ -z $1 ]; then
    echo "Please enter a valid device, such as /dev/sde"
    exit 1
fi
DEVICE=$1

# Check for device existance
if [ ! -b $DEVICE ]; then 
    echo "Device $DEVICE does not exist"
    exit 1
fi

# Refresh boot partition from build server
rm -rf /scratch/Downloads/hddimg/*
scp -r $REMOTE_BUILD_MACHINE/scratch/working/2014.12/build_merlinf_ocv/tmp/work/amdfalconx86-mel-linux/ocvdemo-image/1.0-r0/ocvdemo-image-1.0/hddimg/* /scratch/Downloads/hddimg

# Refresh rootfs from build server
umount /mnt/remote
scp $REMOTE_BUILD_MACHINE/scratch/working/2014.12/build_merlinf_ocv/tmp/deploy/images/amdfalconx86/ocvdemo-image-amdfalconx86.ext3 /scratch/Downloads/
mount -o loop /scratch/Downloads/ocvdemo-image-amdfalconx86.ext3 /mnt/remote

mount | grep $DEVICE
if [ $? -eq 0 ]; then
    echo "Unmounting device(s)"
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

# Create the rootfs partition
fdisk $DEVICE <<EOF
n
p
2


w
EOF

# Now format both partitions - this takes some time for larger devices
echo -n "Formating partitions...this may take a long time..."
sudo mkdosfs -n BOOT -S 512 ${DEVICE}1
sudo mkfs.ext3 -L rootfs ${DEVICE}2
echo "Done"
syslinux ${DEVICE}1

# Now populate contents
echo "Populating ${DEVICE}/1"
mount ${DEVICE}1 /mnt/boot
cp -r /scratch/Downloads/hddimg/* /mnt/boot
sync
umount ${DEVICE}1

mount ${DEVICE}2 /mnt/rootfs
echo "Populating ${DEVICE}/2"
cd /mnt/remote
# Check that our rootfs is mounted (on /mnt/remote)
if [ ! -f ./etc/issue ]; then
    echo "Please mount a root file system on /mnt/remote"
    exit 1
fi
tar c * | tar x -C /mnt/rootfs
echo "Syncing file system(s)"
sync
umount ${DEVICE}2
echo "Done!"
