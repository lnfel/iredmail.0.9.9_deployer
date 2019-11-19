#!/bin/sh
# =====================================
# iRedMail Silent installation script
# Written by Dale Ryan Aldover
# © 2019
# =====================================
# How to use? 

# Unlike the single deploy install.sh file
# that initiates using:
# ./install.sh domainname.com

# This time we will deploy iRedmail
# to multiple servers using:
# ./multi-deploy.sh "$(< file.txt)"
# Where file.txt contains the target domains
# using the format below:
# domain1.tk
# domain2.com
# domain3.win

# iterating through the bash argument is
# achieved by using for loop
# =====================================

# Font color variable
RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m' # No Color

# Script start
# Assign the arguments into an array variable
array="$@"

for domain in $array
do
	HOSTNAME=$domain
	echo "${GREEN}Working on "${HOSTNAME}${NC}

	# Generate ssh keygen
	echo "${GREEN}Generating ssh keys.${NC}"
	ssh-keygen -f /root/.ssh/id_rsa -t rsa -b 2048 -N ''
	# Copy rsa keys to target domain
	echo "${GREEN}Copying rsa keys, please press Enter.${NC}"
	ssh-copy-id root@flashraven.tk

	# Update system
	echo "${GREEN}Performing system update.${NC}"
	ssh root@${HOSTNAME} "apt-get install && apt-get update > /dev/null"

	# Change hostname value
	echo "${GREEN}Setting up "${HOSTNAME}" as hostname.${NC}"
	ssh root@${HOSTNAME} "hostname ${HOSTNAME} && hostname > /dev/null"

	# Copy iRedMail folder
	echo "${GREEN}Copying iRedMail folder.${NC}"
	rsync -r iRedMail-0.9.9 root@${HOSTNAME}:/root > /dev/null

	# Move our config defaults into target hostname's iRedMail folder
	echo "${GREEN}Setting up default config variables.${NC}"
	# Create a copy of config
	cp $PWD/iRedMail-0.9.9/config $PWD/iRedMail-0.9.9/${HOSTNAME}_config > /dev/null
	# Move config copy to target host server then delete duplicate
	rsync -r $PWD/iRedMail-0.9.9/${HOSTNAME}_config root@${HOSTNAME}:/root/iRedMail-0.9.9/config
	if [ "$?" -eq "0" ]
		then
			echo "${GREEN}Deleting duplicate config file.${NC}"
			rm $PWD/iRedMail-0.9.9/${HOSTNAME}_config > /dev/null
			echo "${GREEN}Done setting up default config.${NC}"
		else
			echo "${RED}Config file was not transfered to target host directory!${NC}"
	fi

	# Install iRedMail-0.9.9
	echo "${GREEN}Installing iRedMail-0.9.9...${NC}"
	ssh root@${HOSTNAME} "cd /root/iRedMail-0.9.9/ && AUTO_USE_EXISTING_CONFIG_FILE=y AUTO_INSTALL_WITHOUT_CONFIRM=y AUTO_CLEANUP_REMOVE_SENDMAIL=y AUTO_CLEANUP_REMOVE_MOD_PYTHON=y AUTO_CLEANUP_REPLACE_FIREWALL_RULES=n AUTO_CLEANUP_RESTART_IPTABLES=n AUTO_CLEANUP_REPLACE_MYSQL_CONFIG=y AUTO_CLEANUP_RESTART_POSTFIX=n bash iRedMail.sh"
	# More about above code through the online documentation:
	# https://docs.iredmail.org/unattended.iredmail.installation.html

	# Reboot server after installation
	echo "${GREEN}Done installing iRedMail on ${HOSTNAME}!${NC}"
	echo "${GREEN}Rebooting server.${NC}"
	ssh root@${HOSTNAME} "sudo reboot"
done