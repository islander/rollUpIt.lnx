#!/bin/bash 

function main() {

#    declare -r local sudoers_file="/etc/sudoers.d/admins.$(hostname)"  
#    declare -r local search_useralias="User_Alias"
#
#    if [[ -f $sudoers_file ]]; then
#        awk -v "user_name=$1" '/^User_Alias/ {
#            print "Adm users are " $0,user_name
#            print "\n"
#       }' $sudoers_file
#    fi

    declare -r local total_mem_kb="$(cat /proc/meminfo | awk '/MemTotal/ { print $2 }')" 
    declare -r local es_heap=$(( total_mem_kb / (1024 * 3) ))
    echo "ES_HEAP is $es_heap mb Total Memory $total_mem_kb"

}

main
