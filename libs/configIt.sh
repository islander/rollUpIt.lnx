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

function preMongoDBInstallation() {
	debug_prefix="debug: [$0] [ $FUNCNAME[0] ] : "

	mongodb_srclist="/etc/apt/sources.list.d/mongodb.list"
	if [ ! -e $mongodb_srclist ]
	then
		printf "$debug_prefix Add source lists"
		echo "deb http://ftp.debian.org/debian jessie-backports main" > /etc/apt/sources.list.d/mongodb.list
        apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 0C49F3730359A14518585931BC711F9BA15703C6lse
		printf "$debug_prefix Source list has been updated by mongodb repository\n"
	fi
}

function installMongoDB() {
debug_prefix="debug: [$0] [ $FUNCNAME[0] ] : "
printf "Entering $debug_prefix\n"

preMongoDBInstallation
installPkg "mongodb-org"
}

function preElasticSearchInstallation() {
	debug_prefix="debug: [$0] [ $FUNCNAME[0] ] : "
    printf "Entering $debug_prefix\n"

	elasticsrch_srclist="/etc/apt/sources.list.d/elasticsearch-2.x.list"
	if [ ! -e $elasticsrch_srclist ]
	then
		printf "$debug_prefix Add source lists"
		echo "deb http://packages.elastic.co/elasticsearch/2.x/debian stable main" > /etc/apt/sources.list.d/elasticsearch-2.x.list
        wget -qO - https://packages.elastic.co/GPG-KEY-elasticsearch | sudo apt-key add - 
	else
		printf "$debug_prefix Source list has been updated by elasticsearch repository\n"
	fi
}

function installElasticSearch() {
	debug_prefix="debug: [$0] [ $FUNCNAME[0] ] : "
    printf "Entering $debug_prefix\n"
    
    preElasticSearchInstallation
    installPkg "elasticsearch"
}

function preGraylog2Installation() {
    installJava
    installMongoDB
    installElasticSearch
}

function installGraylog2() {
	debug_prefix="debug: [$0] [ $FUNCNAME[0] ] : "
    printf "Entering $debug_prefix\n"
    
    preGraylog2Installation

    res=""
    isPkgInstalled "graylog-server" res

    if [ "$res" == "true" ]
    then
        printf "$debug_prefix Graylog2 has been already installed [ $rea ]\n"
        exit 1
    fi
    if [ ! -d /usr/local/src/graylog2-src ] 
    then
        mkdir /usr/local/src/graylog2-src
        cd /usr/local/src/graylog2-src
    else
        printf "$debug_prefix It seems Graylog2 has been already installed\n"
        exit 1
    fi

    installPkg "apt-transport-https"
    wget https://packages.graylog2.org/repo/packages/graylog-2.0-repository_latest.deb
    dpkg -i graylog-2.0-repository_latest.deb
    installPkg "graylog-server"
    rm -f /etc/init/graylog-server.override
}
