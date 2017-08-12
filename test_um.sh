#!/bin/bash

RSRC_DIR_ROLL_UP_IT="$(pwd)/resources"
SKEL_DIR_ROLL_UP_IT="$RSRC_DIR_ROLL_UP_IT/skeleton"
source $(pwd)/libs/um.sh


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
#user="test001"
#pwd="123"
#createAdmUser $user $pwd

# 4
# prepareSudoersd

# 5
rollUpIt "likhobabin_im" "LIM@qxF29y2ol*"

# 6
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
