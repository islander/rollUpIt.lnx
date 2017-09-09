#!/bin/bash

PATH=/usr/sbin:/sbin:/bin:/usr/bin

############################################
### Configuring Iptables Basic Rules #######
###########################################

set -o errexit
# To be failed when it tries to use undeclare variables
set -o nounset


function configIPTRules() {
    local debug_prefix="debug: [$0] [ $FUNCNAME[0] ] : "
    printf "$debug_prefix enter the function \n"
    
    if [[ -z "$1" || -z "$2" || -z "$3" || -z "$4" || -z "$5" || -z "$6" ]]; then
        printf "$debug_prefix ${RED_ROLLUP_IT} Error: Empty parameters ${END_ROLLUP_IT}"
        exit 1
    fi     
    
    updateIPTRules $1 $2 $3 $4 $5 $6 $7 $8 $9
    

    saveIPTRules
}

#
# arg0 - wan NIC
# arg1 - lan NIC
#
function updateIPTRules() {
    declare -r local wan_nic="$1" 
    declare -r local lan_nic="$2"
    declare -r local wan="$3"
    declare -r local wan_ip="$4"
    declare -r local lan="$5"
    declare -r local lan_ip="$6"
    declare -r local trusted_lan="192.168.0.0/24"

    declare -r local ssh_port="22"
    #
    # delete all existing rules.
    #
    iptables -F
    iptables -t nat -F
    iptables -t mangle -F
    iptables -X

    # Always accept loopback traffic
    iptables -A INPUT -i lo -j ACCEPT

    # Allow established connections, and those not coming from the outside
    iptables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT

    # enable ingoing icmp
    iptables -A INPUT -p icmp --icmp-type 8 -s 0/0 -d $wan_ip -m state --state NEW,ESTABLISHED,RELATED -j ACCEPT
    iptables -A OUTPUT -p icmp --icmp-type 0 -s $wan_ip -d 0/0 -m state --state ESTABLISHED,RELATED -j ACCEPT

    # enable incoming ssh
    iptables -A INPUT -i "$wan_nic" -s "$trusted_lan" -p tcp --dport "$ssh_port" -m conntrack --ctstate NEW -j ACCEPT

    # additional non standard rules
    if [[ -n "$4" && -n "$7" && -n "$8" && -n "$9" ]]; then 
        portForwarding "$1" "$4" "$7" "$8" "$9"
    fi

    iptables -A INPUT -m state --state NEW -i "$wan_nic" -j DROP
    iptables -A FORWARD -i "$wan_nic" -o "$lan_nic" -m state --state ESTABLISHED,RELATED -j ACCEPT

    # Allow outgoing connections from the LAN side.
    iptables -A FORWARD -i "$lan_nic" -o "$wan_nic" -j ACCEPT

    # Masquerade.
    iptables -t nat -A POSTROUTING -o "$wan_nic" -j MASQUERADE

    # Don't forward from the outside to the inside.
    iptables -A FORWARD -i "$wan_nic" -o "$lan_nic" -j REJECT

 
    # default policies for filter tables 
    iptables -P INPUT DROP
    iptables -P FORWARD DROP
    iptables -P OUTPUT ACCEPT

    # Enable routing.
    echo 1 > /proc/sys/net/ipv4/ip_forward
}

function saveIPTRules() {
    local debug_prefix="debug: [$0] [ $FUNCNAME[0] ] : "
    printf "$debug_prefix enter the function \n"

    declare -r local ipt_store_file="/etc/iptables/rules.v4"
    if [[ ! -e "$ipt_store_file" ]]; then
        printf "$debug_prefix ${RED_ROLLUP_IT} Error: there is no the iptables rules store file ${END_ROLLUP_IT}\n"
        exit 1
    fi

    iptables-save > "$ipt_store_file"
}

function portForwarding() {
    declare -r local wan_nic="$1"
    declare -r local wan_ip="$2"
    declare -r local src_port="$3"
    declare -r local dst_ip="$4"
    declare -r local dst_port="$5"

    iptables -t nat -A PREROUTING -i "$wan_nic" -p tcp --dport "$src_port" -j  DNAT --to-destination "$dst_ip":"$dst_port"
}
