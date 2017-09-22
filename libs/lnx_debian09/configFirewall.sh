#!/bin/bash

PATH=/usr/sbin:/sbin:/bin:/usr/bin

############################################
### Configuring Iptables Basic Rules #######
############################################

set -o errexit
# To be failed when it tries to use undeclare variables
set -o nounset

function installFw() {
    installPkg "ipset" "" "" ""
    installPkg "iptables-persistent" "" "" ""
}

function testIpset() {
    declare -rg FTP_DATA_PORT_RUI="20"
    declare -rg FTP_CMD_PORT_RUI="21"
    ipset create OUT_TCP_FW_PORTS bitmap:port range 1-4000
    ipset add OU_TCP_FWPORTS "$FTP_DATA_PORT_RUI"
    ipset add OU_TCP_FWPORTS "$FTP_CMD_PORT_RUI"
}

function configFwRules() {
    local debug_prefix="debug: [$0] [ $FUNCNAME[0] ] : "
    printf "$debug_prefix enter the function \n"
    
    if [[ -z "$1" || -z "$2" || -z "$3" ]]; then
        printf "$debug_prefix ${RED_ROLLUP_IT} Error: Empty parameters ${END_ROLLUP_IT}"
        exit 1
    fi     
    
    clearFwState    
    defineFwConstants "$1" "$2" "$3" ""
    setCommonFwRules 

}

#
# arg0 - wlan nic
# arg1 - wlan ip
#
function defineFwConstants() {
    local debug_prefix="debug: [$0] [ $FUNCNAME[0] ] : "
    printf "$debug_prefix enter the function \n"
    
    if [[ -z "$1" || -z "$2" || -z "$3" ]]; then
        printf "$debug_prefix ${RED_ROLLUP_IT} Error: Empty parameters ${END_ROLLUP_IT}"
        exit 1
    fi    

    # -rg - global readonly
    declare -rg WAN_NIC_RUI="$1"
    declare -rg WAN_ADDR_RUI="$2"
    declare -rg WAN_GW_RUI="$3"
    declare -rg TRUSTED_WAN_ADDR_RUI=$([ -z "$4"] && echo "192.168.0.0/24" || echo "$4")

    ipset create OUT_TCP_FW_PORTS bitmap:port range 1-4000
    ipset create OUT_UDP_FW_PORTS bitmap:port range 1-4000
    ipset create IN_UDP_FW_PORTS bitmap:port range 1-4000
    ipset create IN_TCP_FW_PORTS bitmap:port range 1-4000
    ipset create OUT_TCP_FWR_PORTS bitmap:port range 1-4000
    ipset create OUT_UDP_FWR_PORTS bitmap:port range 1-4000
    ipset create IN_TCP_FWR_PORTS bitmap:port range 1-4000
    ipset create IN_UDP_FWR_PORTS bitmap:port range 1-4000

    # FTP
    declare -rg FTP_DATA_PORT_RUI="20"
    declare -rg FTP_CMD_PORT_RUI="21"

    # ------- MAIL PORTS ------------ 
    # SMTP
    declare -rg SMTP_PORT_RUI="25"
    # Secured SMTP
    declare -rg SSMTP_PORT_RUI="465"
    ipset add OUT_TCP_FW_PORTS $SMTP_PORT_RUI
    ipset add OUT_TCP_FWR_PORTS "$SMTP_PORT_RUI"
    ipset add OUT_TCP_FW_PORTS "$SSMTP_PORT_RUI"
    ipset add OUT_TCP_FWR_PORTS "$SSMTP_PORT_RUI"
   
    # POP3
    declare -rg POP3_PORT_RUI="110"
    ipset add OUT_TCP_FW_PORTS "$POP3_PORT_RUI"
    ipset add OUT_TCP_FWR_PORTS "$POP3_PORT_RUI"
    # Secured POP3
    declare -rg SPOP3_PORT_RUI="995"
    ipset add OUT_TCP_FW_PORTS "$SPOP3_PORT_RUI"
    ipset add OUT_TCP_FWR_PORTS "$SPOP3_PORT_RUI"
    # IMAP
    declare -rg IMAP_PORT_RUI="143"
    ipset add OUT_TCP_FW_PORTS "$IMAP_PORT_RUI"
    ipset add OUT_TCP_FWR_PORTS "$IMAP_PORT_RUI"
    # Secured IMAP
    declare -rg SIMAP_PORT_RUI="993"
    ipset add OUT_TCP_FW_PORTS "$SIMAP_PORT_RUI"
    ipset add OUT_TCP_FWR_PORTS "$SIMAP_PORT_RUI"
    
    # ------- HTTP/S PORTS ------------ 
    declare -rg HTTP_PORT_RUI="80"
    ipset add OUT_TCP_FW_PORTS "$HTTP_PORT_RUI"
    ipset add OUT_TCP_FWR_PORTS "$HTTP_PORT_RUI"
    declare -rg HTTPS_PORT_RUI="443"
    ipset add OUT_TCP_FW_PORTS "$HTTPS_PORT_RUI"
    ipset add OUT_TCP_FWR_PORTS "$HTTPS_PORT_RUI"

    # ------- Kerberous Port ----------
    declare -rg KERB_PORT_RUI="88"
    ipset add OUT_TCP_FW_PORTS "$KERB_PORT_RUI"
    ipset add OUT_TCP_FWR_PORTS "$KERB_PORT_RUI"

    # ------- DHCP Ports:udp ----------
    declare -rg DHCP_SRV_PORT_RUI="67"
    declare -rg DHCP_CLIENT_PORT_RUI="68"

    # ------- DNS port:udp/tcp ------------
    declare -rg DNS_PORT_RUI="53"
    # open dns    
    ipset add OUT_TCP_FW_PORTS "$DNS_PORT_RUI"
    ipset add OUT_UDP_FW_PORTS "$DNS_PORT_RUI"
    ipset add OUT_TCP_FWR_PORTS "$DNS_PORT_RUI"
    ipset add OUT_UDP_FWR_PORTS "$DNS_PORT_RUI"

    # ------- SNMP ports:udp/tcp ------------
    declare -rg SNMP_AGENT_PORT_RUI="161"
    ipset add OUT_TCP_FW_PORTS "$SNMP_AGENT_PORT_RUI"
    ipset add OUT_UDP_FW_PORTS "$SNMP_AGENT_PORT_RUI"
    ipset add OUT_TCP_FWR_PORTS "$SNMP_AGENT_PORT_RUI"
    ipset add OUT_UDP_FWR_PORTS "$SNMP_AGENT_PORT_RUI"
    declare -rg SNMP_MGMT_PORT_RUI="162"

    # ------- LDAP ports ----------------
    declare -rg LDAP_PORT_RUI="389"
    declare -rg SLDAP_PORT_RUI="636"

    # ------- OpenVPN ports ------------
    declare -rg UOVPN_PORT_RUI="1194" # udp
    declare -rg TOVPN_PORT_RUI="443" # tcp

    # ------- RDP ports ------------
    declare -rg RDP_PORT_RUI="3389"
    ipset add OUT_TCP_FWR_PORTS "$RDP_PORT_RUI"
    ipset add OUT_UDP_FWR_PORTS "$RDP_PORT_RUI"
    
    # ------- SSH ports ------------
    declare -rg SSH_PORT_RUI="22"
    ipset add OUT_TCP_FW_PORTS "$SSH_PORT_RUI"
#    ipset add IN_TCP_FW_PORTS "$SSH_PORT_RUI"
}

function clearFwState() {
    local debug_prefix="debug: [$0] [ $FUNCNAME[0] ] : "
    #
    # delete all existing rules.
    #
    iptables -F
    iptables -t nat -F
    iptables -t mangle -F
    iptables -t raw -F
    iptables -X
    iptables -Z
 
    ipset flush
    ipset destroy
}


#
# arg0 - wan NIC
# arg1 - lan NIC
#
function setCommonFwRules() {

    printf "$debug_prefix Variable WAN_ADDR_RUI is $WAN_ADDR_RUI \n"
    # Always accept loopback traffic
    iptables -A INPUT -i lo -j ACCEPT

    # Allow established connections, and those not coming from the outside
    iptables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT

    # ------ ICMP rules -----------------------------------------------------
    iptables -A OUTPUT -p icmp --icmp-type echo-request -m state --state NEW -j ACCEPT
    iptables -A OUTPUT -p icmp --icmp-type echo-reply -m state --state NEW -j ACCEPT
    iptables -A INPUT -p icmp --icmp-type 8 -s 0/0 -d "$WAN_ADDR_RUI" -m state --state ESTABLISHED,RELATED -j ACCEPT
    pingOfDeathProtection

    portScanProtection

#    syncFloodProtection

    portForwarding 

    # all established/related connections from the local system (the router's os) are permited
    iptables -A OUTPUT -m state --state ESTABLISHED,RELATED -j ACCEPT

    openFilterOutputPorts

    # enable incoming ssh
    iptables -A INPUT -i "$WAN_NIC_RUI" -s "$TRUSTED_WAN_ADDR_RUI" -p tcp --dport "$SSH_PORT_RUI" -m conntrack --ctstate NEW -j ACCEPT

    iptables -A INPUT -m state --state NEW -i "$WAN_NIC_RUI" -j DROP
    # Masquerade.
    iptables -t nat -A POSTROUTING -o "$WAN_NIC_RUI" -j MASQUERADE
 
    # default policies for filter tables 
    iptables -P INPUT DROP
    iptables -P FORWARD DROP
    iptables -P OUTPUT DROP

    # Enable routing.
    echo 1 > /proc/sys/net/ipv4/ip_forward
}

function portScanProtection() {
    iptables -N PORTSCAN
    iptables -A PORTSCAN -p tcp --tcp-flags ACK,FIN FIN -j DROP
    iptables -A PORTSCAN -p tcp --tcp-flags ACK,PSH PSH -j DROP
    iptables -A PORTSCAN -p tcp --tcp-flags ACK,URG URG -j DROP
    iptables -A PORTSCAN -p tcp --tcp-flags FIN,RST FIN,RST -j DROP
    iptables -A PORTSCAN -p tcp --tcp-flags SYN,FIN SYN,FIN -j DROP
    iptables -A PORTSCAN -p tcp --tcp-flags SYN,RST SYN,RST -j DROP
    iptables -A PORTSCAN -p tcp --tcp-flags ALL ALL -j DROP
    iptables -A PORTSCAN -p tcp --tcp-flags ALL NONE -j DROP
    iptables -A PORTSCAN -p tcp --tcp-flags ALL FIN,PSH,URG -j DROP
    iptables -A PORTSCAN -p tcp --tcp-flags ALL SYN,FIN,PSH,URG -j DROP
    iptables -A PORTSCAN -p tcp --tcp-flags ALL SYN,RST,ACK,FIN,URG -j DROP
    iptables -A INPUT -p tcp -j PORTSCAN
    # TODO to know flag "-f"
#    iptables -A INPUT -f -j DROP
    iptables -A INPUT -p tcp ! --syn -m state --state NEW -j DROP
    iptables -A FORWARD -p tcp ! --syn -m state --state NEW -j DROP 
}

function pingOfDeathProtection() {
    # protects from PING of death
    iptables -N PING_OF_DEATH
    iptables -A PING_OF_DEATH -p icmp --icmp-type echo-request -m hashlimit --hashlimit 1/s --hashlimit-burst 10 --hashlimit-htable-expire 300000 --hashlimit-mode srcip --hashlimit-name t_PING_OF_DEATH -j RETURN
    iptables -A PING_OF_DEATH -j DROP
    iptables -A INPUT -p icmp --icmp-type echo-request -j PING_OF_DEATH
}


function syncFloodProtection() {
    iptables -A INPUT -p tcp -sync -m tbf ! --tbf 1/s --tbf-deep 15 --tbf-mode srcip --tbf-name SYNC_FLOOD -j DROP
    iptables -A INPUT -p tcp --dport "$SSH_PORT_RUI"-sync -m tbf ! --tbf 2/h --tbf-deepa 15 --tbf-mode srcip --tbf-name SSH_DOS -j DROP
}

function saveFwState() {
    local debug_prefix="debug: [$0] [ $FUNCNAME[0] ] : "
    printf "$debug_prefix enter the function \n"

    declare -r local ipt_store_file="/etc/iptables/rules.v4"
    if [[ ! -e "$ipt_store_file" ]]; then
        printf "$debug_prefix ${RED_ROLLUP_IT} Error: there is no the iptables rules store file ${END_ROLLUP_IT}\n"
        exit 1
    fi

    iptables-save > "$ipt_store_file"
}

#
# arg0 - vlan nic 
# arg1 - vlan ip
# arg2 - vlan gw
# arg3 - tcp ipset out forward ports
# arg4 - udp ipset out forward ports
# arg7 - online/offline - there is /isn't WAN access
#
function addFwLAN() {
    local debug_prefix="debug: [$0] [ $FUNCNAME[0] ] : "

    declare -r local lan_nic="$1"
    declare -r local lan_addr="$2"
    declare -r local lan_gw=$([ -z "$3" ] && echo "10.10.0.1" || echo "$3")
    declare -r local out_tcp_port_set=$([ -z "$4" ] && echo "OUT_TCP_FWR_PORTS" || echo "$4")
    declare -r local out_udp_port_set=$([ -z "$5" ] && echo "OUT_UDP_FWR_PORTS" || echo "$5")

    iptables -A FORWARD -p icmp --icmp-type echo-reply -m state --state NEW -j ACCEPT
    iptables -A FORWARD -p icmp --icmp-type echo-request -i "$lan_nic" -o "$WAN_NIC_RUI" -m state --state NEW,ESTABLISHED,RELATED -j ACCEPT

    iptables -A FORWARD -m state --state NEW -i "$WAN_NIC_RUI" -o "$lan_nic" -j DROP
    iptables -A FORWARD -i "$WAN_NIC_RUI" -o "$lan_nic" -m state --state ESTABLISHED,RELATED -j ACCEPT

    iptables -A FORWARD -i "$lan_nic" -o "$WAN_NIC_RUI" -d "$WAN_ADDR_RUI" -s "$lan_addr" -p tcp -m set --match-set "$out_tcp_port_set" dst -m state --state NEW -j ACCEPT
    iptables -A FORWARD -i "$lan_nic" -o "$WAN_NIC_RUI" -d "$WAN_ADDR_RUI" -s "$lan_addr" -p udp -m set --match-set "$out_udp_port_set" dst -m state --state NEW -j ACCEPT
}

function openFilterOutputPorts() {
    local debug_prefix="debug: [$0] [ $FUNCNAME[0] ] : "

    iptables -A OUTPUT -p tcp -m set --match-set OUT_TCP_FW_PORTS dst -m state --state NEW -j ACCEPT
    iptables -A OUTPUT -p udp -m set --match-set OUT_UDP_FW_PORTS dst -m state --state NEW -j ACCEPT
}

function portForwarding() {
    local debug_prefix="debug: [$0] [ $FUNCNAME[0] ] : "
    printf "$debug_prefix enter the function \n"
    
    declare -r local src_port="$SSH_PORT_RUI"
    declare -r local dst_ip="10.10.0.21"
    declare -r local dst_port="2222"

    iptables -t nat -A PREROUTING -i "$WAN_NIC_RUI" -d "$dst_ip" -p tcp --dport "$src_port" -j  DNAT --to-destination "$dst_ip":"$dst_port"
    iptables -A FORWARD -i "$WAN_NIC_RUI" -d "$dst_ip" -p tcp --dport "$dst_port" -j ACCEPT
}
