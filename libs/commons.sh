#!/bin/bash

set -o errexit
# To be failed when it tries to use undeclare variables
set -o nounset

function isPwdMatching()
{
local debug_prefix="debug: [$0] [ $FUNCNAME[0] ] : "
printf "$debug_prefix enter the function \n"
printf "$debug_prefix [$1] parameter #1 \n"

local passwd="$1"

# Regexpression definition
# special characters
sch_regexp='^.*[!@#$^\&\*]{1,12}.*$'
# must be a length
len_regexp='^.{6,20}$'
# denied special characters
denied_sch_regexp='^.*[\s.;:]+.*$'

local isMatching=$2
declare -i iocal count=0
if [[ -n $passwd ]]; then
	if [[ $passwd =~ $len_regexp ]]; then
		count=count+1
		printf "$debug_prefix The string [$pwd] ge 6 len \n"
	else
		printf "$debug_prefix Start matching \n"
	fi
	if [[ $passwd =~ [[:alnum:]] ]]; then
		((count++))
		printf "$debug_prefix The string [$pwd] contains alpha-num  \n"
	fi
	if [[ $passwd =~ $sch_regexp ]]; then
		((count++))
		printf "$debug_prefix The string [$pwd] contains special chars  \n" 
	fi
    if  [[ ! $passwd =~ $denied_sch_regexp ]];	then
		((count++))
		printf "$debug_prefix The string [$pwd] doesn't contain the denied special chars: [.;:] \n" 
	fi
	printf "$debug_prefix Count is $count \n"
	if [[ $count -eq 4 ]]; then
		printf "$debug_prefix The string is mathching the regexp \n"
		eval $isMatching="true"
    else 
        printf "$debug_prefix The string is not matching the regexp. Count [$count]\n"
	fi
else 
	printf "$debug_prefix Pwd is empty\n"
fi
}

function isPkgInstalled()
{
local debug_prefix="debug: [$0] [ $FUNCNAME[0] ] : "
printf "$debug_prefix enter the function \n"
printf "$debug_prefix [$1] parameter #1 \n"
printf "$debug_prefix [$2] parameter #2 \n"

if [[ -n $1 ]]; then
	declare -r local ii_status="Status: install ok installed"
	local isInstalled=$2
	pkg_res="`dpkg-query -s $1 2>/dev/null | grep -n "$ii_status"`"
	
	if [[ -n "$pkg_res" ]]; then
		eval $isInstalled="true"
	else
		eval $isInstalled="false"
	fi
else
	printf "$debug_prefix no package name passed \n"
fi
}

function installPkg() {
local debug_prefix="debug: [$0] [ $FUNCNAME[0] ] : "
if [[ -z $1 ]]; then
	printf "$debug_prefix Package name has not been passed\n"
	exit 1;
fi

if [[ -v $2 && -n "$2" ]]; then
	# calling prepare function
	printf "$debug_prefix Calling prepare function: [$2] \n"
	local prep_func_out="$($2)"
	if [[ -n "$prep_func_out" ]]; then
		printf "$debug_prefix Prepare function output [ $prep_func_out ]\n"
	fi
fi

if [[ "$2" == "q" ]]; then	
	apt-get -y update
else
	apt-get update
fi

local res=""
local errs=""
isPkgInstalled $1 res
if [[ "$res" == "false" ]]; then	
	printf "$debug_prefix [ $1 ] will be installed\n"

	if [[ "$2" == "q" ]]; then 	
		apt-get -y install $1 2>stream_errs.log
	else
		apt-get install $1 2>stream_errs.log
	fi

	if [[ -e stream_errs.log ]]; then
		errs=$(cat "$(pwd)/stream_errs.log") 
	fi

	if [[ -n "$errs" ]]; then 
		printf "$debug_prefix Package [ $1 ] can't be installed\n"
		printf "Errors: <<<<<< \n $errs \n <<<<<"		
	else
		printf "$debug_prefix Package [ $1 ] has been successfully installed\n"
	fi
else
    printf "$debug_prefix Package [$1] is installed\n"
fi

if [[ "$2" == "q" ]]; then 	
    apt-get -y update
else
	apt-get update
fi
}

#
# 
# pf - processing file
# sf - search field
# fv - a new field value
# dm - fields delimeter
#
function setField() {
    local debug_prefix="debug: [$0] [ $FUNCNAME[0 ] : "
    declare -r local pf="$1"
    declare -r local sf="$2"
    declare -r local fv="$3"
    declare -r local dm="$([ -z "$4" ] && echo ": " || echo "$4" )"

    if [[ -z "$pf" || -z "$sf" || -z "$fv" ]]; then 
         printf "$debug_prefix Empty passed parameters\n"
         exit 1
    fi

    if [[ ! -e "$pf" ]]; then
        printf  "$debug_prefix No processing file\n"
        exit 1 
    fi
    declare -r local replace_str="$sf$dm$fv"
    sed -i "s/.*$sf.*$/$replace_str/" $pf
}

