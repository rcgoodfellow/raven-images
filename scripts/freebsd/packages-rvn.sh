#!/bin/sh

TARGETS="curl python"
sudo ASSUME_ALWAYS_YES=yes pkg install ${TARGETS}
