#!/bin/bash

function flushNetworks() {
	for d in $(find /sys/class/net -type l ! -name lo -printf "%f\n") ; do
		printf "$d \n"
	done
}
