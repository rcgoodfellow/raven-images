#!/bin/bash

opts="-volid cidata -joliet -rock"
input="user-data meta-data"

cd ubuntu1604
genisoimage -output ubuntu-1604-config.iso $opts $input
mv ubuntu-1604-config.iso ../
cd ..
