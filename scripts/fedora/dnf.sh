#!/bin/bash

dnf update
dnf install -y \
  vim-minimal emacs-nox tree tmux nfs-utils \
  python libselinux-python \
  nfs-utils

systemctl enable sshd.service
