#!/bin/bash

source $(dirname $0)/utils.sh


is_root;ROOT=$?

if (($ROOT == 0))
then
	echoe "Run the script as root!"
	exit 1
fi

NIC="enp0s3"

#tc qdisc add dev $NIC root netem delay 0ms
tc qdisc change dev $NIC root netem delay 100ms 10ms 25%
tc qdisc change dev $NIC root netem loss 10% 25%
