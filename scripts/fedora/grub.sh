#!/bin/bash

set -e

cat > /etc/default/grub <<EOF
GRUB_DEFAULT=0
# Supress a countdown
GRUB_HIDDEN_TIMEOUT_QUIET=true
GRUB_TIMEOUT=4
GRUB_DISTRIBUTOR="$(sed 's, release .*$,,g' /etc/system-release)"
GRUB_DISABLE_RECOVERY="true"

# DETERism: testbed/tmcd/freebsd/slicefix checks for COM2 images
# by grepping for "serial --unit=1".  We will default grub to COM1 and
# put the unit in the proper place for compatibility with slicefix if
# it gets changed (like a creating a custom image from a COM2 node).
GRUB_CMDLINE_LINUX_DEFAULT="net.ifnames=0 biosdevname=0 console=tty0 console=ttyS0,115200n8"
GRUB_CMDLINE_LINUX=""
GRUB_TERMINAL="serial"
GRUB_SERIAL_COMMAND="serial --unit=0 --speed=115200 --word=8 --parity=no --stop=1"
EOF

# Make sure to install to a partition in case Emulab/DETER is still nuking MBR
grub2-mkconfig -o /boot/grub2/grub.cfg


uuid=$(cat /proc/cmdline | grep -Po 'UUID=\K([0-9a-f\-]+)')
grub2-install --force "/dev/disk/by-uuid/$uuid"
