#!/bin/sh

# freebsd-update will list changes with more causing an automation fail
env PAGER=cat sudo freebsd-update fetch install --not-running-from-cron
