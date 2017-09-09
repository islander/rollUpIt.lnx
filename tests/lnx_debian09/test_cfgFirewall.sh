#!/bin/bash

set -o errexit
set -o nounset
set -o xtrace

# exec 1>stdout.log
exec 2>stderr.log

source ../../libs/addColors.sh
source ../../libs/addVars.sh
source ../../libs/lnx_debian09/commons.sh
source ../../libs/lnx_debian09/sm.sh
source ../../libs/lnx_debian09/configFirewall.sh

# 1
# test ConfigIt: Iptables
function main() {
    local debug_prefix="debug: [$0] [ $FUNCNAME[0] ] : "
    printf "Entering $debug_prefix\n"

    configIPTRules "eth1" "eth0" \
        "172.16.102.0/24" "172.16.102.11" \
        "10.10.0.0/24" "10.10.0.1" \
        "2211" "10.10.0.21" "22"
}

main 

