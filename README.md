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

## 3rd bash task --- github_script.sh 

The script can take GitHub repository URL as argument, e.g:  
`./github_script.sh https://github.com/curl/curl`

If it called without any arguments, then `https://github.com/orkestral/venom` is used by default.

```sh
#Download JSON file with pull requests info 
curl   -H "Accept: application/vnd.github.v3+json"   https://api.github.com/repos/orkestral/venom/pulls > ./test.json
```

`jq` command allows to get requiring part of json file.

Сonstruction `[ -z "$(jq '.[].number' test.json)" ]` returns true if string length from `.[].number` == 0. If true runs `printf` command , else runs remaining part.

`jq '.[].user.login' test.json | sort | uniq -c | awk '{if ($1 > 1) print $2}'` shows users that have more than 1 pull request.

Next if conidition `if [ -z "$(jq '.[].labels[].name' test.json)" ]; then` checks if there are PRs with labels also using _-z_ key

```sh
# `sed 's/\"//g'` cuts out the quotes
jq '.[] | .user.login + " " + .labels[].name' test.json | sed 's/\"//g' | sort | uniq -c | awk '{print "User", $2 , "has", $1, "PR with label"  }'
```

This command gets logins and labels names in 2 column and print number of labels for each user

```sh
jq '.[] | (.number|tostring) + " " +  .user.login' test.json | sed 's/\"//g' | sort | awk '{print "User" , $2, "with PR number" , $1}'
```
This command shows sorted PR numbers with users logins

## Ansible task 

**Structure of ansible role**

```
│   play.yml
│   hosts.yml    
│
└───roles
     └───flask
          └───defaults
          │      main.yml   
          └───files
          │      flaskapp.py
          └───handlers
          │      main.yml
          └───tasks  
          │      main.yml
          └───templates 
                 pyton_flask.service.j2
                 sshd_config.j2  

```

To start ansible role need to launch playbook _play.yml_ with command `ansible-playbook play.yml -i hosts.yml`.






