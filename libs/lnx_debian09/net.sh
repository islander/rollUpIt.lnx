#!/bin/bash

set -o errexit
set -o nounset

function flushNetwork_NET_RUI() {
	for d in $(find /sys/class/net/ -type l ! -name lo -printf "%f\n"); do
		ip addr flush $d &
      	done
}

