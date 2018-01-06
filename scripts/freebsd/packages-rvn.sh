#!/bin/sh

TARGETS="curl python2"
sudo ASSUME_ALWAYS_YES=yes pkg install ${TARGETS}
