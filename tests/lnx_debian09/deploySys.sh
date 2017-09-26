#!/bin/bash

set -o errexit
set -o xtrace
set -o nounset

source ../../libs/addColors.sh
source ../../libs/addVars.sh
source ../../libs/lnx_debian09/commons.sh
source ../../libs/lnx_debian09/sm.sh
source ../../libs/lnx_debian09/sm.sh

function main() {
local debug_prefix="debug: [$0] [ $FUNCNAME[0] ] : "
printf "$debug_prefix ${GRN_ROLLUP_IT} ENTER the function ${END_ROLLUP_IT} \n"
    
    if [[ -z "$1" || -z "$2" ]]; then
        printf "$debug_prefix ${red_rollup_it} Error: empty parameters ${end_rollup_it}"
        exit 1
    fi     

    declare -r local user="$1"
    declare -r local pwd="$2"

    rollUpIt $user $pwd

printf "$debug_prefix ${GRN_ROLLUP_IT} ENTER the function ${END_ROLLUP_IT} \n"
}

main $@ 
