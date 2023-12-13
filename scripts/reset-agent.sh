#!/bin/bash
/usr/local/bin/k3s-agent-uninstall.sh
rm -rf /var/lib/rancher/k3s
rm -rf /etc/rancher/k3s
rm -f /usr/local/bin/k3s-uninstall.sh
