#/bin/bash

# make sure cloud init does not run in the future
touch /etc/cloud/cloud-init.disabled

cat > /etc/sysconfig/network-scripts/ifcfg-eth0 <<EOF
DEVICE=eth0
BOOTPROTO=dhcp
ONBOOT=yes
EOF

