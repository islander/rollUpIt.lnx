#!/bin/bash 

function main() {

    declare -r local sudoers_file="/etc/sudoers.d/admins.$(hostname)"  
    declare -r local search_useralias="User_Alias"

    if [[ -f $sudoers_file ]]; then
        awk -v "user_name=$1" '/^User_Alias/ {
            print "Adm users are " $0,user_name
            print "\n"
       }' $sudoers_file
    fi
}

main "user_001"
