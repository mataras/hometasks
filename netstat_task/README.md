##  1st bash task --- netstat_script.sh
```sh
listip=$(netstat -tunapl | awk -v name=$1 '$0~name {print $5}' | cut -d: -f1 | sort | uniq -c | sort | tail -n5 | grep -oP '(\d+\.){3}\d+')
```

* Variable _listip_ contains uniq IP adresses
* _Netstat_ command shows extended output about our connections
* _awk_ reads output from _netstat_ and prints only IP adresses. This construction `-v name=$1 '$0~name` allows to use positional arguments
* Next commands cut out ports and leave only uniq IP adresses

```sh
#This function shows organisations and adresses
function address {
for ip in $listip ; do whois $ip | awk -F':' '/^Organization/{print $2}/^Address/{print $2; print "";}' ; done
}
```

```sh
#This function shows count of connections of each organizatio
function count {
for ip in $listip ; do whois $ip | awk -F':' '/^Organization/{print $2}' >> output ;done
cat output | sort | uniq -c | awk -F'    ' '{print $3, "has", $2, "connections" }'
rm output
}
```


