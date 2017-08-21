#!/bin/bash

set -o errexit
#set -o nounset
set -o xtrace

#exec 1>output.log
#exec 2>errors.log

source ../libs/commons.sh
source ../libs/um.sh
source ../libs/configIt.sh

# 1
# test configIt:Configuring Graylogs2
function main() {
    local debug_prefix="debug: [$0] [ $FUNCNAME[0] ] : "
    printf "Entering $debug_prefix\n"

    installGrayLog2 
    configureElasticSearch "" "" "" 
    autoStartElasticSearch 
}

main


