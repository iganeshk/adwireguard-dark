#!/bin/bash

cd /opt/adwireguard

# run AdGuardHome in background
echo "Running AdGuardHome in background"
./AdGuardHome --no-check-update -c "/opt/adwireguard/conf/AdGuardHome.yaml" -w "/opt/adwireguard/work" -h "0.0.0.0" &

# run wg-easy app using node
echo "Running wg-easy in background"
exec node server.js
