#!/bin/bash

#set -e

function rollUpIt()
{
debug_prefix="debug: [$0] [ $FUNCNAME[0] ] : "
printf "$debug_prefix enter the function \n"
printf "$debug_prefix [$1] parameter #1 \n"
printf "$debug_prefix [$2] parameter #2 \n"
	
	prepareSkel
	installDefPkgSuit
	createAdmUser $1 $2
	prepareSudoers
}

function prepareSkel()
{
debug_prefix="debug: [$0] [ $FUNCNAME[0] ] : "
printf "$debug_prefix enter the function \n"
printf "$debug_prefix [SKELETON_DIR] $SKEL_DIR_ROLL_UP_IT \n"

	if [ -n "$SKEL_DIR_ROLL_UP_IT" ] && [ -d "$SKEL_DIR_ROLL_UP_IT" ]
	then
		printf "$debug_prefix Skel dir existst: $SKEL_DIR_ROLL_UP_IT \n"
#		find $SKEL_DIR_ROLL_UP_IT -mindepth 1 -maxdepth 1 | xargs cp -rvtf /etc/skel
		find /etc/skel/ -mindepth 1 -maxdepth 1 | xargs rm -Rf
		rsync -rtvu --delete $SKEL_DIR_ROLL_UP_IT/ /etc/skel
	else
		printf "$debug_prefix Skel dir doesn't exist\n"
		exit 1;
	fi
}

function prepareSudoers()
{
sudoers_file="/etc/sudoers.d/admins.`hostname`"
sudoers_add="
User_Alias	LOCAL_ADM_GROUP = $1

# Run any command on any hosts but you must log in
# %ALIAS|NAME% %WHERE%=(%WHO%)%WHAT%

LOCAL_ADM_GROUP ALL=ALL
"
if [ ! -f $sudoers_dir ]
then
	mkdir $sudoers_file
	echo "$sudoers_add" > $sudoers_file
fi
}

function createAdmUser()
{
debug_prefix="debug: [$0] [ $FUNCNAME[0] ] : "
printf "$debug_prefix Enter the function \n"
printf "$debug_prefix [$1] parameter #1 \n"
printf "$debug_prefix [$2] parameter #2 \n"
errs=""

if [ -n "$1" ] && [ -n "$2" ]
then
	isExist=$(getent shadow | cut -d : -f1 | grep -e $1)
	printf "debug: [ $isExist ] "
	if [ -n "$isExist" ]
	then
		printf "$debug_prefix The user exists \n"
		exit 1;
	fi

	# check passwd matching

	isMatchingRes="false"
	isPwdMatching $2 isMatchingRes	
	if [[ "isMatchingRes" == "false" ]];
	then
		printf "$debug_prefix Can't create the user: Password does not match the regexp \n"	
		exit 1;	
	fi
	
	printf "debug: [ $0 ] There is no [ $1 ] user, let's create him \n"
	errs="$(adduser $1 --gecos "$1" --disabled-password 2>&1 1>/dev/null)"
	if [ -n "$errs" ]
	then
		printf "$debug_prefix Can't create the user: [ $errs ]"		
		exit 1;
	else
		errs=$((echo "$1:$2" | chpasswd) 2>&1 1>/dev/null)
		if [ -n "$errs" ]
		then
			printf "$debug_prefix Can't set password to the user: [ $errs ] \n"	

			printf "$debug_prefix Delete the user \n"
			userdel -r $1

			exit 1;
		else
			isSudo=$(getent group | cut -d : -f1 |  grep -e "sudo")
			isWheel=$(getent group | cut -d : -f1 | grep -e "wheel")

			if [ -n "$isSudo" ] && [ -n "$isWheel" ]
			then
				printf "$debug_prefix Add the user to "sudo" and "wheel" groups \n"	
				usermod -aG wheel,sudo $1
			elif [ -n "$isSudo" ]
			then
				printf "$debug_prefix Add the user to "sudo" group ONLY \n"	
				groupadd wheel
				usermod -aG sudo,wheel $1
			elif [ -n "$isWheel" ]
			then
				printf "$debug_prefix Add the user to "wheel" group ONLY: run installDefPkgSuit  \n"	
				usermod -aG wheel $1
			elif [ ! -n "$isSudo" && ! -n "isWheel" ] 
			then
				printf "$debug_prefix There is no "wheel", no "sudo" group \n"	
				printf "$debug_prefix "isWheel" [ $isWheel ], "isSudo" [ $isSudo ] \n"	
				exit 1;
			fi
		fi
	fi
else
	printf "no parameters for creating user \n"
	exit 1;
fi
}

function isPwdMatching()
{
debug_prefix="debug: [$0] [ $FUNCNAME[0] ] : "
printf "$debug_prefix enter the function \n"
printf "$debug_prefix [$1] parameter #1 \n"

pwd="$1"

# Regexpression definition
# special characters
sch_regexp='^.*[!@#$^\&\*]{1,12}.*$'
# must be a length
len_regexp='^.{6,12}$'
# denied special characters
denied_sch_regexp='^.*[\s.;:]+.*$'

local isMatching=$2
count=0
if [ -n $pwd ] 
then
	if [[ $pwd =~ $len_regexp ]];
	then
		((count++))
		printf "$debug_prefix The string [$pwd] ge 6 len \n"
	fi
	if [[ $pwd =~ [[:alnum:]] ]];
	then
		((count++))
		printf "$debug_prefix The string [$pwd] contains alpha-num  \n"
	fi
	if [[ $pwd =~ $sch_regexp ]];
	then
		((count++))
		printf "$debug_prefix The string [$pwd] contains special chars  \n" 
	fi
	if  [[ ! $pwd =~ $denied_sch_regexp ]];
	then
		((count++))
		printf "$debug_prefix The string [$pwd] doesn't contain the denied special chars: [.;:] \n" 
	fi
	printf "$debug_prefix Count is $count \n"
	if [ $count -eq 4 ]
	then
		printf "$debug_prefix The string is mathching the regexp \n"
		eval $isMatching='true'
	fi
fi
}

function isPkgInstalled()
{
debug_prefix="debug: [$0] [ $FUNCNAME[0] ] : "
printf "$debug_prefix enter the function \n"
printf "$debug_prefix [$1] parameter #1 \n"
printf "$debug_prefix [$2] parameter #2 \n"

if [ -n $1 ]
then
	ii_status="Status: install ok installed"
	local isInstalled=$2
	pkg_res="`dpkg-query -s $1 2>/dev/null | grep -n "$ii_status"`"
	
	if [ -n "$pkg_res" ]
	then
		eval $isInstalled='true'
	else
		eval $isInstalled='false'
	fi
else
	printf "$debug_prefix no package name passed \n"
fi
}

function installDefPkgSuit()
{
debug_prefix="debug: [$0] [ $FUNCNAME[0] ] : "
pkg_list=('sudo' 'tmux' 'vim' 'nethogs') 
res=""
errs=""

apt-get update

for i in "${pkg_list[@]}"
do
printf "$debug_prefix Current element is $i \n"

isPkgInstalled $i res
if [ "$res" == "false" ]
then
	printf "$debug_prefix [ $i ] is not installed \n"
	errs="$(apt-get install $i 2>&1 > /dev/null)"
	
	printf "$debug_prefix Errors [ $errs ] \n"
	if [ -n "$errs" ]
	then
		printf "$debug_prefix Can't install $i . Error log is $errs \n"
	else
		printf "$debug_prefix [ $i ] is successfully installed \n" 
	fi
else
	printf "$debug_prefix [ $i ] is installed \n"
fi
done

apt-get dist-upgrade
}
