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
source ../../libs/lnx_debian09/configGraylog2.sh

# 1
# test configIt:Configuring Graylogs2
function main() {
    local debug_prefix="debug: [$0] [ $FUNCNAME[0] ] : "
    printf "Entering $debug_prefix\n"
    declare -r local config_path="/etc/elasticsearch/elasticsearch.yml" 

#    installGraylog2 
#    configureElasticSearch "" "" "" 
#    autostartElasticSearch
#    sleep 10
    fixGraylogMapping 
#    configureGraylog2 "12345678"
#    autostartGraylog2    
#    postClean
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

main 


