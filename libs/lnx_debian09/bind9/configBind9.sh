#!/bin/bash

PATH=/usr/sbin:/sbin:/bin:/usr/bin

############################################
### Configuring Iptables Basic Rules #######
############################################

set -o errexit
# To be failed when it tries to use undeclare variables
set -o nounset
set -o xtrace

function prepare_Bind9_RUI() {
local debug_prefix="debug: [$0] [ $FUNCNAME[0] ] : "
printf "$debug_prefix ${GRN_ROLLUP_IT} ENTER the function ${END_ROLLUP_IT} \n"

    checkConfigFileSet_Bind9_RUI

    if [[ -d "$RSRC_DIR_ROLL_UP_IT/bind9/out/" ]]; then 
        rm -Rf "$RSRC_DIR_ROLL_UP_IT/bind9/out"
    fi 

    if [[ ! -d "$RSRC_DIR_ROLL_UP_IT/bind9/out/" ]]; then 
        sudo -u "likhobabin_im" mkdir -p "$RSRC_DIR_ROLL_UP_IT/bind9/out/zones"
        sudo -u "likhobabin_im" mkdir -p "$RSRC_DIR_ROLL_UP_IT/bind9/out/keys"
    fi 

    declare -rg COMMON_OPTS_TEMPL_BIND_RUI="$RSRC_DIR_ROLL_UP_IT/bind9/named.conf.options.templ"
    declare -rg COMMON_OPTS_BIND_RUI="$RSRC_DIR_ROLL_UP_IT/bind9/named.conf.options"

    declare -rg ZONE_HEAD_TEMPL_BIND_RUI="$RSRC_DIR_ROLL_UP_IT/bind9/named.conf.local.templ"
    declare -rg ZONE_HEAD_BIND_RUI="$RSRC_DIR_ROLL_UP_IT/bind9/named.conf.local"
    
    declare -rg ZONE_OPTS_TEMPL_BIND_RUI="$RSRC_DIR_ROLL_UP_IT/bind9/zone.templ"
    declare -rg ZONE_CONTENT_BIND_RUI="$RSRC_DIR_ROLL_UP_IT/bind9/zone.content"

    declare -rg ZONE_FILE_TEMPL_BIND_RUI="$RSRC_DIR_ROLL_UP_IT/bind9/zones/file-zone.templ"

    declare -rg TAB_SYM_RUI=$'\t'
    declare -rg DTAB_SYM_RUI=$'\t\t'

    #TODO replace user_name with global variable
    if [[ ! -e "$COMMON_OPTS_BIND_RUI" ]]; then 
        sudo -u "likhobabin_im" cp "$COMMON_OPTS_TEMPL_BIND_RUI" "$COMMON_OPTS_BIND_RUI"
    fi

    #TODO replace user_name with global variable
    if [[ ! -e "$ZONE_HEAD_BIND_RUI" ]]; then 
        sudo -u "likhobabin_im" cp "$ZONE_HEAD_TEMPL_BIND_RUI" "$ZONE_HEAD_BIND_RUI"
    fi

printf "$debug_prefix ${GRN_ROLLUP_IT} EXIT the function ${END_ROLLUP_IT} \n"
}

function checkConfigFileSet_Bind9_RUI() {
local debug_prefix="debug: [$0] [ $FUNCNAME[0] ] : "
printf "$debug_prefix ${GRN_ROLLUP_IT} ENTER the function ${END_ROLLUP_IT} \n"

    declare -r local generalCfgFile="/etc/bind/named.conf"
    declare -A local cfgFileList=([0]=".options" [1]=".local" [2]=".default-zones")
    if [[ ! -e "$generalCfgFile" ]]; then
        printf "$debug_prefix ${RED_ROLLUP_IT} No general config file: $generalCfgFile ${END_ROLLUP_IT} \n"
        exit 1
    fi

    for cfgFile_it in ${cfgFileList[@]}; do
        if [[ ! -e "$generalCfgFile$cfgFile_it" ]]; then
            printf "$debug_prefix ${RED_ROLLUP_IT} No general config file: $generalCfgFile$cfgFile_it ${END_ROLLUP_IT} \n"
            exit 1
        fi
    done

printf "$debug_prefix ${GRN_ROLLUP_IT} EXIT the function ${END_ROLLUP_IT} \n"
}

#
# arg0 - ACL name
# arg1[] - ACL value
# isRecursion - true/false
#
function setACL_Bind9_RUI() {
    local debug_prefix="debug: [$0] [ $FUNCNAME[0] ] : "
    printf "$debug_prefix ${GRN_ROLLUP_IT} ENTER the function ${END_ROLLUP_IT} \n"

    if [[ -z "$1" ||  -z "$2" || -z "$3" ]]; then
        printf "$debug_prefix ${RED_ROLLUP_IT} No valid passed parameters ${END_ROLLUP_IT} \n"
        exit 1
    fi
    
    declare -r local acl_name="$1"
    local -n acl_list="$2"
    declare -r local isRecursion="$3"
    declare -A listen_on_list=([0]="$acl_name")
    
    setOptionByTag_Bind9_RUI "<ACL>" acl_list "acl $acl_name" "" "" ""
    setOptionByTag_Bind9_RUI "<LISTEN-ON>" listen_on_list "listen-on" "" ""
    setOptionByTag_Bind9_RUI "<ALLOW-QUERY>" acl_list "allow-query" "" ""
    if [[ "$isRecursion" == "true" ]]; then
        setOptionByTag_Bind9_RUI "<ALLOW-RECURSION>" acl_list "allow-recursion" "" ""
        setOption_Bind9_RUI "recursion" "yes" "$COMMON_OPTS_BIND_RUI"
    fi

    printf "$debug_prefix ${GRN_ROLLUP_IT} EXIT the function ${END_ROLLUP_IT} \n"
}

#
# arg0[] - forwarders
# arg1 - forwardType (first/only)
#
function setForwarders_Bind9_RUI() {
    local debug_prefix="debug: [$0] [ $FUNCNAME[0] ] : "
    printf "$debug_prefix ${GRN_ROLLUP_IT} ENTER the function ${END_ROLLUP_IT} \n"

    if [[ -z "$1" ||  -z "$2" ]]; then
        printf "$debug_prefix ${RED_ROLLUP_IT} No valid passed parameters ${END_ROLLUP_IT} \n"
        exit 1
    fi
    
    local -n forward_list="$1"
    declare -r local forward_type="$2"
    setOptionByTag_Bind9_RUI "<FORWARDERS>" forward_list "forwarders" "" ""
    setOption_Bind9_RUI "forward" "$forward_type" "$COMMON_OPTS_BIND_RUI"
}

#
# arg0[] - forwarders
#
function setTransfers_Bind9_RUI() {
    local debug_prefix="debug: [$0] [ $FUNCNAME[0] ] : "
    printf "$debug_prefix ${GRN_ROLLUP_IT} ENTER the function ${END_ROLLUP_IT} \n"

    if [[ -z "$1" ]]; then
        printf "$debug_prefix ${RED_ROLLUP_IT} No valid passed parameters ${END_ROLLUP_IT} \n"
        exit 1
    fi
    
    local -n transfers="$1"
    setOptionByTag_Bind9_RUI "<ALLOW-TRANSFERS>" transfers "allow-transfers" "" ""
}

#
# arg0 - the option's tag
# arg1[] - the option's values
# arg2 - option name
# arg3 - isAppend
# arg4 - options file path
#
function setOptionByTag_Bind9_RUI() {
    declare -r local opt_tag="$1"
    local -n opt_values="$2"
    declare -r local opt_name="$3"
    declare -r lcoal isAppend=$([[ -z "$4" ]] && echo "false" || echo "$4")
    declare -r local opt_pref="$opt_name { "
    declare -r local opt_file_path=$([[ -z "$5" ]] && echo "$COMMON_OPTS_BIND_RUI" || echo "$5")
    local opt_res=""

    for opt_it in ${opt_values[@]}; do
         opt_res="$opt_res$opt_it; "
    done
    
    printf "$debug_prefix TAG: $opt_tag\n"
    printf "$debug_prefix Opt name: $opt_name\n"
    printf "$debug_prefix Opt values: $opt_res\n"

    declare -r local canAppend="$(grep "^$opt_pref.*" $opt_file_path)"
    printf "$debug_prefix isAppend: $isAppend\n"
    if [[ -n "$isAppend" && -n "$canAppend" && "$isAppend" == "true" ]]; then
            sed -i '/.*'"$opt_pref"'/a \
                '"$opt_res"'' $opt_file_path
    else 
        sed -i '/.*\/\/ *'"$opt_tag"'/a '"$opt_pref"'\
                '"$opt_res"'\
        };' $opt_file_path    
    fi
}

#
# arg0 - option name
# arg1 - option value
# arg2 - options file path
#
function setOption_Bind9_RUI() {
    if [[ ! -e "$3" ]]; then
        printf "$declare_prefix ${RED_ROLLUP_IT} No options file ${END_ROLLUP_IT}\n"
        exit 1
    fi
    declare -r local opt_name="$1"
    declare -r local opt_val=" $2;"
    declare -r local opts_file_path="$3";

    sed -i "0,/.*\/\/ *$opt_name.*/ s/.*\/\/ *$opt_name.*/$opt_name$opt_val/" $opts_file_path
}

#
# arg1 list0 - 1) a zone's name; 2) a zone's file path;  
# arg2 list1 - masters/allow-transfer
# arg3 list2 - allow-update
# arg4 - ns type
# arg5 list3 - zone file parameters
#
function setZoneOptions_Bind9_RUI() {
    local debug_prefix="debug: [$0] [ $FUNCNAME[0] ] : "
    printf "$debug_prefix ${GRN_ROLLUP_IT} ENTER the function ${END_ROLLUP_IT} \n"
    if [[ -z "$1" || -z "$2" || -z "$3" || -z "$4" || -z "$5" ]]; then
        printf "$debug_prefix ${RED_ROLLUP_IT} No options passed ${END_ROLLUP_IT}\n"
        exit 1
    fi


    #TODO replace user_name with global variable
    sudo -u "likhobabin_im" cp "$ZONE_OPTS_TEMPL_BIND_RUI" "$ZONE_CONTENT_BIND_RUI"

    declare -n zone_list_000="$1"
    declare -n zone_list_001="$2"
    declare -n allow_update_keys="$3"
    declare -r local zone_name="${zone_list_000[0]}"
    declare -r local zone_file_path="${zone_list_000[1]}"
    declare -r local ns_type="$4"

    sed -i "0,/.*<ZONE-NAME>.*/ s/<ZONE-NAME>/'"$zone_name"'/" $ZONE_CONTENT_BIND_RUI

    setOption_Bind9_RUI "file" "$zone_file_path" "$ZONE_CONTENT_BIND_RUI"
    if [[ "$ns_type" == "master" ]]; then

        setOption_Bind9_RUI "type" "master" "$ZONE_CONTENT_BIND_RUI"
        setOptionByTag_Bind9_RUI "<MASTERS>" zone_list_001 "masters" \
            "" "$ZONE_CONTENT_BIND_RUI"           

    else if [[ "$ns_type" == "slave" ]]; then

        setOption_Bind9_RUI "type" "master" "$ZONE_CONTENT_BIND_RUI"
        setOptionByTag_Bind9_RUI "<ALLOW-TRANSFER>" zone_list_001 "allow-transfer" "" "$ZONE_CONTENT_BIND_RUI"           

        else 
            printf "$declare_prefix ${RED_ROLLUP_IT} Invalid nameserver type ${END_ROLLUP_IT}\n"
            exit 1
        fi
    fi

    setOptionByTag_Bind9_RUI "<ALLOW-UPDATE>" allow_update_keys "allow-update" "" "$ZONE_CONTENT_BIND_RUI"           

    cat "$ZONE_CONTENT_BIND_RUI" >> "$ZONE_HEAD_BIND_RUI"

    # define the zone 's file 
    declare -r local zone_name_fp="$RSRC_DIR_ROLL_UP_IT/bind9/zones/$zone_name"

    if [[ -e "$zone_name_fp" ]]; then
        rm "$zone_name_fp"
    fi

    sudo -u "likhobabin_im" cp "$ZONE_FILE_TEMPL_BIND_RUI" "$zone_name_fp"  
    local -n zf_parameters="$5"
    declare -r local zone_ttl="${zf_parameters[0]}"
    declare -r local zone_soa_header="${zf_parameters[1]}"
    declare -r local zone_serial_num="${zf_parameters[2]}"
    declare -r local zone_refresh="${zf_parameters[3]}"
    declare -r local zone_retry="${zf_parameters[4]}"
    declare -r local zone_expire="${zf_parameters[5]}"
    declare -r local zone_minimum_ttl="${zf_parameters[6]}"
    declare -r local zone_ns01="${zf_parameters[7]}"
    declare -r local zone_ns02="${zf_parameters[8]}"

    sed -i '/; <TTL>/a \
$TTL '"$zone_ttl"'' "$zone_name_fp"
    
    sed -i '/; <SOA-HEADER>/a \
@'"${DTAB_SYM_RUI}"'IN'"${DTAB_SYM_RUI}"'SOA'"${DTAB_SYM_RUI}"''"$zone_soa_header"' (' "$zone_name_fp"
    
    sed -i '/; <SOA-SERIALNUMBER>/a \
        '"$zone_serial_num"'' "$zone_name_fp"
    
    sed -i '/; <SOA-REFRESH>/a \
        '"$zone_refresh"'' "$zone_name_fp"
    
    sed -i '/; <SOA-RETRY>/a \
        '"$zone_retry"'' "$zone_name_fp"
    
    sed -i '/; <SOA-EXPIRE>/a \
        '"$zone_expire"'' "$zone_name_fp"
    
    sed -i '/; <SOA-MINIMUM-TTL>/a \
        '"$zone_minimum_ttl"' \)' "$zone_name_fp"
    
    sed -i '/; <NS-01>/a \
@'"${DTAB_SYM_RUI}"'IN'"${DTAB_SYM_RUI}"'NS'"${DTAB_SYM_RUI}"''"$zone_ns01"'' "$zone_name_fp"

    sed -i '/; <NS-02>/a \
@'"${DTAB_SYM_RUI}"'IN'"${DTAB_SYM_RUI}"'NS'"${DTAB_SYM_RUI}"''"$zone_ns02"'' "$zone_name_fp"

    # TODO replace with a global var of username
    sudo -u "likhobabin_im" mv "$zone_name_fp" "$RSRC_DIR_ROLL_UP_IT/bind9/out/zones"
}

function post_Bind9_RUI() {
    local debug_prefix="debug: [$0] [ $FUNCNAME[0] ] : "
    printf "$debug_prefix ${GRN_ROLLUP_IT} ENTER the function ${END_ROLLUP_IT} \n"

    # cp "$COMMON_OPTS_BIND_RUI" "$ZONE_HEAD_BIND_RUI" "/etc/bind/"
    mv "$COMMON_OPTS_BIND_RUI" "$ZONE_HEAD_BIND_RUI" "$RSRC_DIR_ROLL_UP_IT/bind9/out/"

    # rm -Rf "$RSRC_DIR_ROLL_UP_IT/bind9/out/"
}
