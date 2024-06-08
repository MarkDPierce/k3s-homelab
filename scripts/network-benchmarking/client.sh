#!/bin/bash

# Check for iperf
if [ ! `which iperf` ]; then
  printf "Installing iperf...\n"
  apt-get install -y iperf
  printf "Install complete!\n\n"
fi

# Check for iperf3
if [ ! `which iperf3` ]; then
  printf "Installing iperf3...\n"
  apt-get install -y iperf3
  printf "Install complete!\n\n"
fi


run_client_generic_v2() {
    if [ $# -ne 2 ]; then
        echo "Usage: run_client_generic <REMOTE_HOST> <DURATION>"
        return 1
    fi

    local REMOTE_HOST=$1
    local DURATION=$2

    iperf -c $REMOTE_HOST -i 1 -t $DURATION
}

REMOTE_HOST='192.168.178.101'

run_client_generic_v2 $REMOTE_HOST 30