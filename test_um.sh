#!/bin/bash

set -o errexit
set -o xtrace
set -o nounset

source $(pwd)/libs/commons.sh
source $(pwd)/libs/um.sh
source $(pwd)/libs/um.sh

function main() {
declare -r RSRC_DIR_ROLL_UP_IT="$(pwd)/resources"
declare -r SKEL_DIR_ROLL_UP_IT="$RSRC_DIR_ROLL_UP_IT/skeleton"

# 0
#pkg=$1
#res="empty"
#
#isPkgInstalled $pkg res
#printf "Package $pkg is installed: $res"
#

# 1
# prepareSkel

# 2
# installDefPkgSuit

# 3
#declare -r user="test001"
#declare -r pwd="KLKLK@aLK100"
#rollUpIt $user $pwd
#
# 4
prepareSudoersd "user_001"

# 5
#isMatchingRes="false"
#pwd="1234567"
#isPwdMatching $pwd isMatchingRes
#
#printf "Result isMatchingiRes is $isMatchingRes \n"
#if [ "$isMatchingRes" == "true" ]
#then
#	printf "The pwd is matching \n"
#else
#	printf "The pwd is not matching \n"
#fi
#
#printf "\n"
}

main 
