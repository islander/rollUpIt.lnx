#!/bin/bash

################################
### Configuring GrayLog2 #######
################################

function preJavaInstallation() {
	debug_prefix="debug: [$0] [ $FUNCNAME[0] ] : "

	installPkg "dirmngr"

	webupd8team_srclist="/etc/apt/sources.list.d/webupd8team-java.list"
	if [ ! -e $webupd8team_srclist ]
	then
		printf "$debug_prefix Add source lists"
		echo "deb http://ppa.launchpad.net/webupd8team/java/ubuntu xenial main" > /etc/apt/sources.list.d/webupd8team-java.list
		echo "deb-src http://ppa.launchpad.net/webupd8team/java/ubuntu xenial main" >> /etc/apt/sources.list.d/webupd8team-java.list
		apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys EEA14886
	else
		printf "$debug_prefix Source list has been updated by webupd8team repository\n"
	fi
}

function installJava() {
debug_prefix="debug: [$0] [ $FUNCNAME[0] ] : "
printf "Entering $debug_prefix\n"

preJavaInstallation
installPkg "oracle-java8-installer" 
}
