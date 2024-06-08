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

run_server_v3() {
    iperf3 -s -J
}

run_server_v2() {
    iperf -s
}

#run_server_v3
run_server_v2