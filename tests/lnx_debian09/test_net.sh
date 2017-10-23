#! /bin/bash

set -o errexit
set -o nounset
set -o xtrace

source ../../libs/lnx_debian09/net.sh

function main() {
    flushNetwork_NET_RUI
}

main
