#!/bin/bash

set -o errexit
set -o nounset
set -o xtrace

#exec 1>stdout.log 
exec 2>stderr.log

source libs/addColors.sh
source libs/addVars.sh
source libs/lnx_debian09/commons.sh
source libs/lnx_debian09/sm.sh
source libs/lnx_debian09/configFirewall.sh

# 1
# test configFirewall.sh
function main() {
    local debug_prefix="debug: [$0] [ $FUNCNAME[0] ]: "
    printf "$debug_prefix enter the function\n"
    printf "$debug_prefix Argument List: $#\n"

    if [[ $# -eq 0 ]]; then
        printf "$debug_prefix Start configuring the firewall...\n"

                installFw_FW_RUI

                configFwRules_FW_RUI "enp0s3" "10.0.2.0/24" "10.0.2.15" "10.0.2.0/24"
                # LAN
                addFwLAN_FW_RUI "enp0s8" "172.16.76.0/23" "" "" "" ""
                # DMZ
                addFwLAN_FW_RUI "enp0s8" "192.168.77.0/27" "" "" "" ""

                saveFwState_FW_RUI

        printf "$debug_prefix ...End configuring the firewall\n"
   else
        case $1 in 
            undo)
                printf "$debug_prefix The first argument is $1\n"
                clearFwState_FW_RUI
                saveFwState_FW_RUI
            ;;

            *)
              printf "$debug_prefix Invalid arguments!!!\n"
            ;;

        esac 
    fi
}

main $@

