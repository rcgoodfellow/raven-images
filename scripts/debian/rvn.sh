#!/bin/bash

set -e
set -x

export DEBIAN_FRONTEND=noninteractive

sudo apt-get update -y
sudo apt-get install -y \
	vim-nox emacs-nox tmux \
	bash-completion \
	ssh tree nfs-common python

sudo apt-get autoremove
sudo apt-get clean
sudo apt-get autoclean
