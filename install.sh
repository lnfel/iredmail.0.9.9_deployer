#!/bin/sh
# =====================================
# iRedMail Silent installation script
# Written by Dale Ryan Aldover
# © 2019
# =====================================
# IMPORTANT!
# after cloning or pulling the repo
# make sure to run chmod on the followin files:
# install.sh, multi-deploy.sh, test.sh, args
# Ex. chmod 755 install.sh

# How to use? Simply run the command in
# the following format:
# ./install.sh domainname.com
# Ex. ./install.sh sushikick.tk
# =====================================

# Font color variable
RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m' # No Color

# Script start
HOSTNAME=$1
echo "Working on "${HOSTNAME}

# Commented line below is used for testing only
#if [ "$HOSTNAME" = sushipunch.tk ]; then
#  printf '%s\n' "on the right host"
#else
#  printf '%s\n' "uh-oh, not on foo"
#fi

# Install sshpass

# Before running the script make sure to create the file:
# /var/tmp/ssh-pass.sh
# inside that file, input:
# #!/bin/sh                                                                    
# echo "$PASS"
# below is the automated process
# Create the file
#touch /var/tmp/ssh-pass.sh
# Add text to specific line
#sed -i '1i #\!/usr/bin/expect' /var/tmp/ssh-pass.sh
#sed -i '2i \spawn ssh-copy-id -o StrictHostKeyChecking=no $argv' /var/tmp/ssh-pass.sh
#sed -i 2d spawn ssh-copy-id -o StrictHostKeyChecking=no $argv /var/tmp/ssh-pass.sh
#sed -i '3i expect "password:"' /var/tmp/ssh-pass.sh
#sed -i '4i send ""' /var/tmp/ssh-pass.sh
#sed -i '5i expect eof' /var/tmp/ssh-pass.sh

#chmod 755 /var/tmp/ssh-pass.sh

#sed -i '1i #\!/bin/sh' /var/tmp/ssh-pass.sh
#sed -i '2i echo "smtp123"' /var/tmp/ssh-pass.sh

# Generate ssh keygen
ssh-keygen -f /root/.ssh/id_rsa -t rsa -b 2048 -N ''
# Copy the generated key to target server
#PASS="$1" SSH_ASKPASS="/var/tmp/ssh-pass.sh" setsid -w ssh-copy-id -i /root/.ssh/id_rsa "$2"@"$4" -p "$3"
#PASS="smtp123" SSH_ASKPASS="/var/tmp/ssh-pass.sh" setsid -w ssh-copy-id -i /root/.ssh/id_rsa root@flashraven.tk -p "22"

#/var/tmp/./ssh-pass.sh
#sshpass -p "smtp123" ssh-copy-id -o StrictHostKeyChecking=no root@flashraven.tk
#sshpass -f /var/tmp/sshpass ssh-copy-id -o StrictHostKeyChecking=no root@flashraven.tk
ssh-copy-id root@flashraven.tk
# ssh into the server to test the key

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
#ssh root@${HOSTNAME} "sed -i -e '1d' /etc/hostname"
ssh root@${HOSTNAME} "sed -i '1d' /etc/hostname"
# Now replace it with something else
echo "Saving..."
#ssh root@${HOSTNAME} "echo '${HOSTNAME}' > /etc/hostname"
ssh root@${HOSTNAME} 'sed -i "1i ${HOSTNAME}"' /etc/hostname

# Copy iRedMail folder
echo 'Copying iRedMail folder'
rsync -r iRedMail-0.9.9 root@${HOSTNAME}:/root > /dev/null

# Move our config defaults into target hostname's iRedMail folder
echo "Setting up default config variables"
# Create a copy of config
cp $PWD/iRedMail-0.9.9/config $PWD/iRedMail-0.9.9/${HOSTNAME}_config > /dev/null
#sed -i s/univposts.com/${HOSTNAME}/g $PWD/iRedMail/${HOSTNAME}_config
# Move config copy to target host server then delete duplicate
rsync -r $PWD/iRedMail-0.9.9/${HOSTNAME}_config root@${HOSTNAME}:/root/iRedMail-0.9.9/config
if [ "$?" -eq "0" ]
then
	echo "Deleting duplicate config file"
	rm $PWD/iRedMail-0.9.9/${HOSTNAME}_config > /dev/null
	echo "${GREEN}Done setting up default config${NC}"
else
  echo "config file was not transfered to target host directory"
fi

 # Install iRedMail-0.9.9
 echo "Installing iRedMail-0.9.9..."
 ssh root@${HOSTNAME} "cd /root/iRedMail-0.9.9/ && AUTO_USE_EXISTING_CONFIG_FILE=y AUTO_INSTALL_WITHOUT_CONFIRM=y AUTO_CLEANUP_REMOVE_SENDMAIL=y AUTO_CLEANUP_REMOVE_MOD_PYTHON=y AUTO_CLEANUP_REPLACE_FIREWALL_RULES=n AUTO_CLEANUP_RESTART_IPTABLES=n AUTO_CLEANUP_REPLACE_MYSQL_CONFIG=y AUTO_CLEANUP_RESTART_POSTFIX=n bash iRedMail.sh"
 # More about above code through the online documentation:
 # https://docs.iredmail.org/unattended.iredmail.installation.html

 # Reboot server after installation
 echo "${GREEN}Done installing iRedMail on ${HOSTNAME}!${NC}"
 echo "Rebooting server"
 ssh root@${HOSTNAME} "sudo reboot"