#!/bin/bash

set -x

sudo apt-get install -y apt-transport-https

cat >/tmp/sources.list << EOF
deb http://mirror.deterlab.net/mirrors/debian/ stretch main contrib non-free
deb-src http://mirror.deterlab.net/mirrors/debian/ stretch main

deb http://mirror.deterlab.net/mirrors/debian-security stretch/updates main
deb-src http://mirror.deterlab.net/mirrors/debian-security stretch/updates main
EOF

sudo cp /tmp/sources.list /etc/apt/sources.list
