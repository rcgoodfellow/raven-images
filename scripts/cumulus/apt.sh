#!/bin/sh

cat >> /etc/apt/sources.list <<EOF

#debian repos
deb http://http.us.debian.org/debian jessie main
deb http://http.us.debian.org/debian jessie-backports main
deb http://security.debian.org/ jessie/updates main
EOF

apt update -y
apt install -y python nfs-common
