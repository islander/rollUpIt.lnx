#!/bin/bash

# exec 1>output.log
# exec 2>errors.log

source $(pwd)/libs/commons.sh
source $(pwd)/libs/um.sh
source $(pwd)/libs/configIt.sh
# 1
# test configIt:Configuring Graylogs2

debug_prefix="debug: [$0] [ $FUNCNAME[0] ] : "
printf "Entering $debug_prefix\n"

installJava