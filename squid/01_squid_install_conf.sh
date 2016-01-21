#!/bin/bash

PACKAGE_NAME="squid"
PACK_QUERY_RESULT=$(rpm -qa $PACKAGE_NAME)

# directory we expect to contain squid.conf file
SQUID_CONF_DIR="/etc/squid/"
SQUID_CONF_FILE="squid.conf"

if [[ $PACK_QUERY_RESULT == *"$PACKAGE_NAME"* ]]
then
	echo "$PACKAGE_NAME is already installed" 1>&2
	exit 1
else
	echo "$PACKAGE_NAME is not installed yet! Try to install $PACKAGE_NAME..."
	sudo yum -y install $PACKAGE_NAME


	if [ -d "$SQUID_CONF_DIR" ]; then
		echo "Checking squid3 ..."
		echo "Squid conf dir: '$SQUID_CONF_DIR'"
	
		if [ -f "$SQUID_CONF_DIR$SQUID_CONF_FILE" ]; then
			TIME=$(date '+%d-%m-%Y_%H-%M')
			sudo cp "$SQUID_CONF_DIR$SQUID_CONF_FILE" "$SQUID_CONF_DIR$SQUID_CONF_FILE.back.$TIME"
			echo "$SQUID_CONF_FILE was copied into $SQUID_CONF_FILE.back.$TIME"
	
			# set squid service run on boot
			#sudo chkconfig squid on		
	
			# replacing the http_port value
			#sudo echo "%s/http_port 3128/http_port 8080/g
			#w
			#q" | ex "$SQUID_CONF_DIR$SQUID_CONF_FILE"

			# replacing ACL values
			#sudo echo "%s/http_access deny all/http_access allow all/g
			#w
			#q
			#" | ex "$SQUID_CONF_DIR$SQUID_CONF_FILE"
			TARGET_KEY="http_port"
			REPLACEMENT_VALUE="8080"
			sudo sed -c -i "s/\($TARGET_KEY * *\).*/\1$REPLACEMENT_VALUE/" $SQUID_CONF_DIR$SQUID_CONF_FILE

			
			OLD_VALUE="http_access deny all"			
			NEW_VALUE="http_access allow all"
			sudo sed  -i "/$OLD_VALUE/c\\$NEW_VALUE" $SQUID_CONF_DIR$SQUID_CONF_FILE
				
			# restart squid
			sudo service squid restart	
		else
			echo "'$SQUID_CONF_DIR$SQUID_CONF_FILE' not found!" 1>&2
			exit 2
		fi
	
	else
		echo "Directory '$SQUID_CONF_DIR' not found!" 1>&2
		exit 3
	fi
	
fi

