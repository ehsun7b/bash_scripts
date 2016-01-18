#!/bin/bash

source $(dirname $0)/utils.sh


is_root;ROOT=$?

if (($ROOT == 0))
then
	echo "Run the script as root!"
	exit 1
fi

# directory we expect to contain squid.conf file
SQUID_CONF_DIR="/etc/squid/"
SQUID_CONF_FILE="squid.conf"

if [ -d "$SQUID_CONF_DIR" ]; then
	echo "Checking squid3 ..."
	echo "Squid conf dir: '$SQUID_CONF_DIR'"
	
	if [ -f "$SQUID_CONF_DIR$SQUID_CONF_FILE" ]; then
		TIME=$(date '+%d-%m-%Y_%H-%M')
		cp "$SQUID_CONF_DIR$SQUID_CONF_FILE" "$SQUID_CONF_DIR$SQUID_CONF_FILE.back.$TIME"
		echo "$SQUID_CONF_FILE was copied into $SQUID_CONF_FILE.back.$TIME"
	
		# set squid service run on boot
		chkconfig squid on		
	
		# replacing the http_port value
		echo "%s/http_port 3128/http_port 8080/g
		w
		q" | ex "$SQUID_CONF_DIR$SQUID_CONF_FILE"

		# replacing ACL values
		echo "%s/http_access deny all/http_access allow all/g
		w
		q
		" | ex "$SQUID_CONF_DIR$SQUID_CONF_FILE"
	
		# restart squid
		service squid restart	
	else
		echoe "'$SQUID_CONF_DIR$SQUID_CONF_FILE' not found!"
	fi
	
else
	echo "Directory '$SQUID_CONF_DIR' not found!"
fi
