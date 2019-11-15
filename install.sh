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
ssh root@${HOSTNAME} "apt-get install && apt-get update > /dev/null"

# Change hostname value
echo "Setting up "${HOSTNAME}" as hostname."
# Change the Linux hostname
ssh root@${HOSTNAME} "hostname ${HOSTNAME} && hostname > /dev/null"

echo "Editing file: /etc/hostname"
# Change hostname permanently on a Debian/Ubuntu Linux
# sed | stream editor for filtering and transforming text
# -i[SUFFIX] | edit files in place
# -e script | add the script to the commands to be executed
# 1d | will remove the first line of the input file
# Simply put, we're removing the first line on specified file
ssh root@${HOSTNAME} "sed -i -e '1d' /etc/hostname"
# Now replace it with something else
echo "Saving..."
ssh root@${HOSTNAME} "echo '${HOSTNAME}' > /etc/hostname"

# Copy iRedMail folder
echo 'Copying iRedMail folder...'
rsync -r iRedMail-0.9.9 root@${HOSTNAME}:/root > /dev/null

# Move our config defaults into target hostname's iRedMail folder
echo "Setting up default config variables..."
# Create a copy of config
cp $PWD/iRedMail-0.9.9/config $PWD/iRedMail-0.9.9/${HOSTNAME}_config > /dev/null
#sed -i s/univposts.com/${HOSTNAME}/g $PWD/iRedMail/${HOSTNAME}_config
# Move config copy to target host server then delete duplicate
rsync -r $PWD/iRedMail-0.9.9/${HOSTNAME}_config root@${HOSTNAME}:/root/iRedMail-0.9.9/config
rm $PWD/iRedMail-0.9.9/${HOSTNAME}_config