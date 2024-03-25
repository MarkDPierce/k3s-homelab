#!/bin/bash

if [ -f "/usr/local/bin/k3s-uninstall.sh" ]
then
cd /usr/local/bin/
k3s-killall.sh
k3s-uninstall.sh
fi

if [ -f "/usr/local/bin/k3s-agent-uninstall.sh" ]
then
cd /usr/local/bin/
k3s-agent-uninstall.sh
fi

rm -rf /var/lib/rancher /etc/rancher /var/lib/longhorn /etc/cni/ /opt/cni /var/lib/cni