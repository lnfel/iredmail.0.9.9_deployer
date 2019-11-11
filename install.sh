#!/bin/sh
# =====================================
# iRedMail Silent installation script
# Written by Dale Ryan Aldover
# © 2019
# =====================================
# How to use? Simply run the command in
# the following format:
# ./install.sh domainname.com
# Ex. ./install.sh sushikick.tk
# =====================================

HOSTNAME=$1
echo "Working on "${HOSTNAME}

# Commented line below is used for testing only
#if [ "$HOSTNAME" = sushipunch.tk ]; then
#  printf '%s\n' "on the right host"
#else
#  printf '%s\n' "uh-oh, not on foo"
#fi

# Update system
#ssh root@${HOSTNAME} "mkdir test" > /dev/null
echo "Performing system update."
ssh root@${HOSTNAME} "apt-get install && apt-get update"

