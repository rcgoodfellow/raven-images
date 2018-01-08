#!/bin/sh

cat <<EOF > /tmp/ROUTER
include GENERIC
ident ROUTER

options		MROUTING		#frisbee
EOF

sudo cp /tmp/ROUTER /usr/src/sys/amd64/conf/

cd /usr/src
sudo make buildkernel KERNCONF=ROUTER -j16
sudo make installkernel KERNCONF=ROUTER
sudo make delete-old
sudo make delete-old-libs
sudo make cleanworld
sudo make clean
sudo rm -rf /boot/kernel.old

