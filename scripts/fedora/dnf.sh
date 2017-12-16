#!/bin/bash

dnf update
dnf install -y vim-minimal emacs-nox tmux

systemctl enable sshd.service
