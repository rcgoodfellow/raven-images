#!/bin/bash

cat > /etc/sudoers.d/root-group <<EOF
%root ALL=(ALL) NOPASSWD: ALL
%rvn ALL=(ALL) NOPASSWD: ALL
EOF
