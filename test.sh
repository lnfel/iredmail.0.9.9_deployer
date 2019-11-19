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

# execute this file to tesh multiple-deploy.sh
# ./test.sh "$(< file.txt)"
# Where file.txt contains the target domains
# using the format below:
# domain1.tk
# domain2.com
# domain3.win
# or you can check the args file and use:
# ./test.sh "$(< args)"
# =====================================

# Font color variable
RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m' # No Color

echo "test.sh executed"
# Assign the arguments into an array variable
array="$@"
#for domain in ${1+"$@"}
echo "Domains found:"
echo "${GREEN}"${array}${NC}
for domain in $array
do
	echo $domain
	# Use ping's "count" option (-c COUNT)
	# to send exactly COUNT pings and then terminate automatically.
	# Use ping's "deadline" option (-w DEADLINE)
	# to run for exactly DEADLINE seconds and then terminate automatically.
	ping -c 4 -w 7 $domain
done

echo "Done!"