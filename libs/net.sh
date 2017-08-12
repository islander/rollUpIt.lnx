#!/bin/bash

function flushNetwork() {
	for d in $(find /sys/class/net/ -type l ! -name lo -printf "%f\n"); do
		printf "Debug Network dev is $d \n"
		ip addr flush $d &
      	done
}

