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
source ../../libs/lnx_debian09/test_lang.sh

# 1
# test ConfigIt: Iptables
function main() {
    local debug_prefix="debug: [$0] [ $FUNCNAME[0] ]: "
    printf "$debug_prefix enter the function\n"
    printf "$debug_prefix Argument List: $#\n"
    printf "$debug_prefix SUDO_USER: $SUDO_USER\n"
    printf "$debug_prefix LOGNAME: $(logname)\n"

#    sudo -u "$(whoami)" touch test_file.txt

    declare -r local user=$([[ -n "$SUDO_USER" ]] && echo "$SUDO_USER" || echo "$(whoami)")

    printf "$debug_prefix USER: $user\n";

}

main $@

