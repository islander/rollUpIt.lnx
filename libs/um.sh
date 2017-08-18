#!/bin/bash

#set -e

function rollUpIt()
{
debug_prefix="debug: [$0] [ $FUNCNAME[0] ] : "
printf "$debug_prefix enter the function \n"
printf "$debug_prefix [$1] parameter #1 \n"
printf "$debug_prefix [$2] parameter #2 \n"

if [ -z "$1" -o -z "$2" ]
then
	printf "$debug_prefix No parameters passed into the function\n"
	exit 1
fi

debian_version=$(find /etc/ -type f -name debian_version | xargs cut -d . -f1)

if [ -n "$debian_version" -a "$debian_version" -ge 8 ]
then	
	printf "$debug_prefix Debian version is $debian_version\n"
	prepareSkel
	installDefPkgSuit
	createAdmUser $1 $2
	prepareSudoersd $1
else
	printf "$debug_prefix Can't run scripts there is no suitable distibutive version\n"
fi
}

function prepareSkel()
{
debug_prefix="debug: [$0] [ $FUNCNAME[0] ] : "
printf "$debug_prefix enter the function \n"
	if [ -n "$SKEL_DIR_ROLL_UP_IT" ] && [ -d "$SKEL_DIR_ROLL_UP_IT" ]
	then
		printf "$debug_prefix Skel dir existst: $SKEL_DIR_ROLL_UP_IT \n"
		find /etc/skel/ -mindepth 1 -maxdepth 1 | xargs rm -Rf
		rsync -rtvu --delete $SKEL_DIR_ROLL_UP_IT/ /etc/skel
	else
		printf "$debug_prefix Skel dir doesn't exist\n"
		exit 1;
	fi
}

function prepareSudoersd()
{
debug_prefix="debug: [$0] [ $FUNCNAME[0] ] : "
printf "$debug_prefix enter the function \n"
if [ -z "$1" ]
then
	printf "$debug_prefix No user name specified [$1] \n"
	exit 1;
fi

sudoers_file="/etc/sudoers.d/admins.`hostname`"
sudoers_add="
User_Alias	LOCAL_ADM_GROUP = $1

# Run any command on any hosts but you must log in
# %ALIAS|NAME% %WHERE%=(%WHO%)%WHAT%

LOCAL_ADM_GROUP ALL=ALL
"
if [ ! -f $sudoers_file ]
then
	touch $sudoers_file
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
	isExist=$(getent shadow | cut -d : -f1 | grep $1)
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
		errs=$(echo "$1:$2" | chpasswd 2>&1 1>/dev/null)
		if [ -n "$errs" ]
		then
			printf "$debug_prefix Can't set password to the user: [ $errs ] \n"	

			printf "$debug_prefix Delete the user \n"
			userdel -r $1

			exit 1;
		else
			isSudo=$(getent group | cut -d : -f1 |  grep sudo)
			isWheel=$(getent group | cut -d : -f1 | grep wheel)

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

function installDefPkgSuit()
{
debug_prefix="debug: [$0] [ $FUNCNAME[0] ] : "
pkg_list=('sudo' 'tmux' 'vim' 'nethogs') 
res=""
errs=""

apt-get -y update

for i in "${pkg_list[@]}"
do
printf "$debug_prefix Current element is $i \n"

isPkgInstalled $i res
if [ "$res" == "false" ]
then
	printf "$debug_prefix [ $i ] is not installed \n"
	errs="$(apt-get -y install $i 2>&1 > /dev/null)"
	
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

apt-get -y dist-upgrade
}