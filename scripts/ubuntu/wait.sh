#!/bin/bash

set -e
set -x


# disable cloud-init
touch /etc/cloud/cloud-init.disabled

# hack - wait until all the packages are updated
sleep 120

sudo apt-get clean
