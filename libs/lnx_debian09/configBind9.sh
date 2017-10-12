#!/bin/bash

PATH=/usr/sbin:/sbin:/bin:/usr/bin

#################################
### Configuring DNS Bind9 #######
#################################

set -o errexit
# To be failed when it tries to use undeclare variables
set -o nounset

function installBind9() {
    local debug_prefix="debug: [$0] [ $FUNCNAME[0] ] : "
    printf "$debug_prefix ${GRN_ROLLUP_IT} ENTER the function ${END_ROLLUP_IT} \n"
    
    installPkg "bind9"
    installPkg "bind9-doc"

    printf "$debug_prefix ${GRN_ROLLUP_IT} EXIT the function ${END_ROLLUP_IT} \n"
}
