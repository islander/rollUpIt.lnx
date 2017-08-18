#! /bin/bash

set -o errexit
set -o nounset
set -o xtrace

source $(pwd)/libs/net.sh

function main() {
    flushNetwork
}

main
