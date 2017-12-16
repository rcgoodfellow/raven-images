#!/usr/bin/env bash

set -e
set -x

# We create filesystem labels in preseed.cfg for Ubutnu.  We should
# maintain the same labels if we end up making a CentOS packerized
# image.

uuid=$(cat /proc/cmdline | grep -Po 'UUID=\K([0-9a-f\-]+)')
tune2fs -c 0 "/dev/disk/by-uuid/$uuid"
