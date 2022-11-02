#!/bin/bash

# run wg-easy app using node
echo "Running wg-easy in background"
cd /opt/adwireguard && exec node server.js &

# run AdGuardHome in background
echo "Running AdGuardHome in background"
cd /opt/adwireguard && ./AdGuardHome --no-check-update -c "/opt/adguardhome/conf/AdGuardHome.yaml" -w "/opt/adguardhome/work" -h "0.0.0.0"
