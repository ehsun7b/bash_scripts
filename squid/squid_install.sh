#!/bin/bash

source $(dirname $0)/utils.sh


is_root;ROOT=$?

if (($ROOT == 0))
then
	echo "Run the script as root!"
	exit 1
fi

PACKAGE_NAME="squid"
PACK_QUERY_RESULT=$(rpm -qa $PACKAGE_NAME)


if [[ $PACK_QUERY_RESULT == *"$PACKAGE_NAME"* ]]
then
	echo "$PACKAGE_NAME is already installed"
else
	echo "$PACKAGE_NAME is not installed yet! Try to install $PACKAGE_NAME..."
	yum -y install $PACKAGE_NAME
   # yum install glibc-static
fi
