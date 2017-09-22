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
    local debug_prefix="debug: [$0] [ $FUNCNAME[0] ]: "
    printf "$debug_prefix enter the function\n"
    printf "$debug_prefix Argument List: $#\n"

    clearFwState

    declare -r FTP_DATA_PORT_RUI="20"

    defineFwConstants "eth1" "172.16.102.0/24" "172.16.102.11"
#    ipset create OUT_TCP_FWPORTS bitmap:port range 1-4000
#    ipset add OUT_TCP_FWPORTS "$FTP_DATA_PORT_RUI"

#    testIpset 
}

main $@

