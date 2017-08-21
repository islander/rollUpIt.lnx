#!/bin/bash

set -o errexit
set -o nounset
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
    declare -r local config_path="/etc/elasticsearch/elasticsearch.yml" 

#    installGrayLog2 
#    configureElasticSearch "" "" "" 
#    autostartElasticSearch 
    configureGraylog2 "RfynhfDbrfnf"
#    autostartGraylog2    
#    local res=""
#    local ii_status="Status: install ok installed"
#    res="$(dpkg-query -s $1 2>stream_errs.log | grep "$ii_status" || cat stream_errs.log)"
#    echo "$debug_prefix $res"
#    if [[  "$res" == "$ii_status" ]]; then
#        echo "$debug_prefix Package is installed"
#    else
#        echo "$debug_prefix Package is not installed"
#    fi
#   res=""
#   isPkgInstalled "pwgen" res
#   echo "$res" 
}

main "sudo"


