#!/bin/sh
# =====================================
# iRedMail Silent installation script
# Written by Dale Ryan Aldover
# © 2019
# =====================================

# Font color variable
RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m' # No Color

echo "test.sh executed"
for domain in "$@"
do
	var="$@"
	echo "Arguments found:"
	echo "${GREEN}"${var}${NC}
	ping ${var}
	echo "Done!"
done