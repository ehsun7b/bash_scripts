#!/bin/bash

source $(dirname $0)/utils.sh


is_root;ROOT=$?

if (($ROOT == 0))
then
	echo "Run the script as root!"
	exit 1
fi

service squid stop
yum -y remove squid

