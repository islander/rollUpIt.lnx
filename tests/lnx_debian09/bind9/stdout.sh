debug: [./deployBind9.sh] [ main[0] ] :  [1;32m ENTER the function [0m 
debug: [./deployBind9.sh] [ prepare_Bind9_RUI[0] ] :  [1;32m ENTER the function [0m 
debug: [./deployBind9.sh] [ checkConfigFileSet_Bind9_RUI[0] ] :  [1;32m ENTER the function [0m 
debug: [./deployBind9.sh] [ checkConfigFileSet_Bind9_RUI[0] ] :  [1;32m EXIT the function [0m 
debug: [./deployBind9.sh] [ prepare_Bind9_RUI[0] ] :  [1;32m EXIT the function [0m 
debug: [./deployBind9.sh] [ setCommonOptions_Bind9_RUI[0] ] :  [1;32m ENTER the function [0m 
debug: [./deployBind9.sh] [ setACL_Bind9_RUI[0] ] :  [1;32m ENTER the function [0m 
debug: [./deployBind9.sh] [ setACL_Bind9_RUI[0] ] :  TAG: <ACL>
debug: [./deployBind9.sh] [ setACL_Bind9_RUI[0] ] :  Opt name: acl branch01
debug: [./deployBind9.sh] [ setACL_Bind9_RUI[0] ] :  Opt values: 192.168.0.1/16; 10.10.10.0/16; 172.16.0.0/24; 
debug: [./deployBind9.sh] [ setACL_Bind9_RUI[0] ] :  isAppend: false
debug: [./deployBind9.sh] [ setACL_Bind9_RUI[0] ] :  TAG: <LISTEN-ON>
debug: [./deployBind9.sh] [ setACL_Bind9_RUI[0] ] :  Opt name: listen-on
debug: [./deployBind9.sh] [ setACL_Bind9_RUI[0] ] :  Opt values: branch01; 
debug: [./deployBind9.sh] [ setACL_Bind9_RUI[0] ] :  isAppend: false
debug: [./deployBind9.sh] [ setACL_Bind9_RUI[0] ] :  TAG: <ALLOW-QUERY>
debug: [./deployBind9.sh] [ setACL_Bind9_RUI[0] ] :  Opt name: allow-query
debug: [./deployBind9.sh] [ setACL_Bind9_RUI[0] ] :  Opt values: 192.168.0.1/16; 10.10.10.0/16; 172.16.0.0/24; 
debug: [./deployBind9.sh] [ setACL_Bind9_RUI[0] ] :  isAppend: false
debug: [./deployBind9.sh] [ setACL_Bind9_RUI[0] ] :  TAG: <ALLOW-RECURSION>
debug: [./deployBind9.sh] [ setACL_Bind9_RUI[0] ] :  Opt name: allow-recursion
debug: [./deployBind9.sh] [ setACL_Bind9_RUI[0] ] :  Opt values: 192.168.0.1/16; 10.10.10.0/16; 172.16.0.0/24; 
debug: [./deployBind9.sh] [ setACL_Bind9_RUI[0] ] :  isAppend: false
debug: [./deployBind9.sh] [ setACL_Bind9_RUI[0] ] :  [1;32m EXIT the function [0m 
debug: [./deployBind9.sh] [ setForwarders_Bind9_RUI[0] ] :  [1;32m ENTER the function [0m 
debug: [./deployBind9.sh] [ setForwarders_Bind9_RUI[0] ] :  TAG: <FORWARDERS>
debug: [./deployBind9.sh] [ setForwarders_Bind9_RUI[0] ] :  Opt name: forwarders
debug: [./deployBind9.sh] [ setForwarders_Bind9_RUI[0] ] :  Opt values: 192.168.0.10; 192.168.0.11; 
debug: [./deployBind9.sh] [ setForwarders_Bind9_RUI[0] ] :  isAppend: false
debug: [./deployBind9.sh] [ setCommonOptions_Bind9_RUI[0] ] :  ns_type: slave
debug: [./deployBind9.sh] [ setCommonOptions_Bind9_RUI[0] ] :   [1;32m Choose SLAVE [0m 
debug: [./deployBind9.sh] [ setTransfers_Bind9_RUI[0] ] :  [1;32m ENTER the function [0m 
debug: [./deployBind9.sh] [ setTransfers_Bind9_RUI[0] ] :  allow-transfers : "none"
debug: [./deployBind9.sh] [ setTransfers_Bind9_RUI[0] ] :  TAG: <ALLOW-TRANSFER>
debug: [./deployBind9.sh] [ setTransfers_Bind9_RUI[0] ] :  Opt name: allow-transfer
debug: [./deployBind9.sh] [ setTransfers_Bind9_RUI[0] ] :  Opt values: "none"; 
debug: [./deployBind9.sh] [ setTransfers_Bind9_RUI[0] ] :  isAppend: false
debug: [./deployBind9.sh] [ setCommonOptions_Bind9_RUI[0] ] :  [1;32m ENTER the function [0m 
debug: [./deployBind9.sh] [ setZoneOptions_Bind9_RUI[0] ] :  [1;32m ENTER the function [0m 
debug: [./deployBind9.sh] [ setZoneOptions_Bind9_RUI[0] ] :  TAG: <MASTERS>
debug: [./deployBind9.sh] [ setZoneOptions_Bind9_RUI[0] ] :  Opt name: masters
debug: [./deployBind9.sh] [ setZoneOptions_Bind9_RUI[0] ] :  Opt values: 10.10.0.0.3; 
debug: [./deployBind9.sh] [ setZoneOptions_Bind9_RUI[0] ] :  isAppend: false
debug: [./deployBind9.sh] [ setZoneOptions_Bind9_RUI[0] ] :  TAG: <ALLOW-UPDATE>
debug: [./deployBind9.sh] [ setZoneOptions_Bind9_RUI[0] ] :  Opt name: allow-update
debug: [./deployBind9.sh] [ setZoneOptions_Bind9_RUI[0] ] :  Opt values: key; local-dnsupdater; 
debug: [./deployBind9.sh] [ setZoneOptions_Bind9_RUI[0] ] :  isAppend: false
debug: [./deployBind9.sh] [ packZoneFile_Bind9_RUI[0] ] :  [1;32m ENTER the function [0m 
debug: [./deployBind9.sh] [ setZoneOptions_Bind9_RUI[0] ] :  [1;32m ENTER the function [0m 
debug: [./deployBind9.sh] [ setZoneOptions_Bind9_RUI[0] ] :  TAG: <MASTERS>
debug: [./deployBind9.sh] [ setZoneOptions_Bind9_RUI[0] ] :  Opt name: masters
debug: [./deployBind9.sh] [ setZoneOptions_Bind9_RUI[0] ] :  Opt values: 10.10.0.0.3; 
debug: [./deployBind9.sh] [ setZoneOptions_Bind9_RUI[0] ] :  isAppend: false
debug: [./deployBind9.sh] [ setZoneOptions_Bind9_RUI[0] ] :  TAG: <ALLOW-UPDATE>
debug: [./deployBind9.sh] [ setZoneOptions_Bind9_RUI[0] ] :  Opt name: allow-update
debug: [./deployBind9.sh] [ setZoneOptions_Bind9_RUI[0] ] :  Opt values: key; local-dnsupdater; 
debug: [./deployBind9.sh] [ setZoneOptions_Bind9_RUI[0] ] :  isAppend: false
debug: [./deployBind9.sh] [ packZoneFile_Bind9_RUI[0] ] :  [1;32m ENTER the function [0m 
debug: [./deployBind9.sh] [ post_Bind9_RUI[0] ] :  [1;32m ENTER the function [0m 
debug: [./deployBind9.sh] [ main[0] ] :  [1;32m ENTER the function [0m 
