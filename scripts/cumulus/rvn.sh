#!/bin/sh

useradd -d /home/rvn -G sudo -s /bin/bash rvn 
echo "rvn:rvn" | chpasswd
usermod -aG cumulus rvn

