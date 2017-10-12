#!/bin/bash

set -o errexit
set -o xtrace
set -o nounset

exec 2>stderr.log

source ../../../libs/addColors.sh
source ../../../libs/addVars.sh
source ../../../libs/lnx_debian09/commons.sh
source ../../../libs/lnx_debian09/sm.sh
source ../../../libs/lnx_debian09/bind9/configBind9.sh

function main() {
local debug_prefix="debug: [$0] [ $FUNCNAME[0] ] : "
printf "$debug_prefix ${GRN_ROLLUP_IT} ENTER the function ${END_ROLLUP_IT} \n"
    
    prepare_Bind9_RUI
    setCommonOptions_Bind9_RUI "master"
    
    declare -r local zone_000_name="workhorse.local"
    declare -A local zone_000_list_000=([0]="$zone_000_name" [1]="\/etc\/bind\/zones\/$zone_000_name")
    declare -A local zone_000_allow_transfers=([0]="10.10.0.0.3")
    declare -A local zone_000_allow_update=([0]="key local-dnsupdater")
    
    declare -A local zone_000_param_list=( 
        # TTL
        [0]="4H" 
        # SOA header 
        [1]="ns1.$zone_000_name.\tadmin@$zone_000_name." 
        # Serial Number
        [2]="1" 
        # Refresh
        [3]="4H"
        # Retry
        [4]="3600"
        # Expire
        [5]="4H" 
        # Minimum TTL
        [6]="4H" 
        # NS01
        [7]="ns01" 
        # NS02
        [8]="ns02" 
        )

    
    declare -r local zone_001_name="0.10.10.in-addr.arpa"
    declare -A local zone_001_list_000=([0]="$zone_001_name" [1]="\/etc\/bind\/zones\/$zone_001_name")
    declare -A local zone_001_allow_transfers=([0]="10.10.0.0.3")
    declare -A local zone_001_allow_update=([0]="key local-dnsupdater")
    declare -A local zone_001_param_list=( 
        # TTL
        [0]="3600" 
        # SOA header 
        [1]="ns1.$zone_000_name.\tadmin@$zone_000_name." 
        # Serial Number
        [2]="0" 
        # Refresh
        [3]="3600" 
        # Retry
        [4]="900" 
        # Expire
        [5]="4H" 
        # Minimum TTL
        [6]="3600" 
        # NS01
        [7]="ns01" 
        # NS02
        [8]="ns02" 
        )

    setZoneOptions_Bind9_RUI zone_000_list_000 zone_000_allow_transfers \
        zone_000_allow_update "master" zone_000_param_list

    setZoneOptions_Bind9_RUI zone_001_list_000 zone_001_allow_transfers \
        zone_001_allow_update "master" zone_001_param_list

    post_Bind9_RUI
    

printf "$debug_prefix ${GRN_ROLLUP_IT} ENTER the function ${END_ROLLUP_IT} \n"
}

#
# arg0 - master/slave
#
function setCommonOptions_Bind9_RUI() {
local debug_prefix="debug: [$0] [ $FUNCNAME[0] ] : "
printf "$debug_prefix ${GRN_ROLLUP_IT} ENTER the function ${END_ROLLUP_IT} \n"

    declare -r local ns_type=$([[ -z "$1" ]] && echo "master" || echo "slave")
    declare -A local acl_list_001=([0]="192.168.0.1/16" [1]="10.10.10.0/16" [2]="172.16.0.0/24")
    declare -A local acl_list_002=([0]="192.168.2.1/16")
    declare -A local acl_list_003=([0]="192.168.3.1/16")
    declare -A local forwarders_list=([0]="192.168.0.10" [1]="192.168.0.11")
    declare -r local acl_name="branch01"
    declare -r lcoal isRecursion="true"

    setACL_Bind9_RUI "$acl_name" acl_list_001 "$isRecursion" 
    setForwarders_Bind9_RUI forwarders_list  "first"
    setOption_Bind9_RUI "directory" "\/var\/\bind\/cache" "$COMMON_OPTS_BIND_RUI"
    if [[ "$ns_type" == "master" ]]; then
        declare -A local transfers_list=([0]="10.10.0.3")
        setTransfers_Bind9_RUI transfers_list
    else
        declare -A local transfers_none=([0]="none")
        setTransfers_Bind9_RUI transfers_none
    fi

printf "$debug_prefix ${GRN_ROLLUP_IT} ENTER the function ${END_ROLLUP_IT} \n"
}

main  