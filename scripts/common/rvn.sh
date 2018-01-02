#!/bin/sh

set -e
set -x

date | sudo tee /etc/rvn_build_time

mkdir -p /home/rvn/.ssh
curl -fsSLo /home/rvn/.ssh/authorized_keys http://mirror.deterlab.net/rvn/rvn.pub
chmod 700 /home/rvn/.ssh/
chmod 600 /home/rvn/.ssh/authorized_keys
chown -R rvn:rvn /home/rvn
