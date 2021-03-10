#!/bin/bash

listip=$(netstat -tunapl | awk -v name=$1 '$0~name {print $5}' | cut -d: -f1 | sort | uniq -c | sort | tail -n5 | grep -oP '(\d+\.){3}\d+')

function address {
for ip in $listip ; do whois $ip | awk -F':' '/^Organization/{print $2}/^Address/{print $2; print "";}' ; done
}

function count {
for ip in $listip ; do whois $ip | awk -F':' '/^Organization/{print $2}' >> output ;done
cat output | sort | uniq -c | awk -F'    ' '{print $3, "has", $2, "connections" }' 
rm output
}

count
address
