#/bin/bash

### The cumulusvx image comes with a 4G btrfs 4th partition mounted as root.
### This script expands that partition to the end of the 40G disk associated
### with this image.

# start by deleting the 4th partition
sgdisk -d 4 /dev/vda

# move the gpt data structures to the end of the drive. This is necessary to
# expand the drive beyond its current 4G
sgdisk -e /dev/vda

# create a new 4th partition taking up the maximum available space
sgdisk -n 4:0:0 /dev/vda

# inform the kernel of partition table changes
partprobe

# resize the root filesystem to take up the maximum available space
btrfs filesystem resize max /

# rebalance the filesystem so we don't run out of metadata blocks
btrfs balance start --full-balance /

