#!/bin/bash

opts="-volid cidata -joliet -rock"
input="user-data meta-data"

cd fedora27
genisoimage -output fedora27-config.iso $opts $input
mv fedora27-config.iso ../
cd ..
