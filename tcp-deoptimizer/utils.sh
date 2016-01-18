#!/bin/bash

echoe (){
	echo "$(tput setaf 1)$@$(tput sgr0)"
}

is_root() {
	local USER=$(whoami)
	#echo $USER
	if [ "$USER" == "root" ]
	then
		return 1
	else 
		return 0
	fi
}

:<<'END'
is_root;root=$?

if (($root == 0))
then
	echo "Is root"
else
	echo "is NOT root"
fi
END


