#!/bin/bash


cat > /etc/sudoers.d/root-group <<EOF
#
# Emulab add users with sudo to the group root
#
%root ALL=(ALL) NOPASSWD: ALL
EOF
