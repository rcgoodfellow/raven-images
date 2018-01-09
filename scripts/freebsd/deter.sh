#!/bin/sh

set -e
set -x

cat << EOF > /tmp/fbsd.conf
custom: {
	url: "https://fbsd-build.deterlab.net/11amd64-deter",
	enabled: yes
}
EOF

sudo cp /tmp/fbsd.conf /etc/pkg/FreeBSD.conf

sudo pkg install -y deter-common deter-boss deter-users

