## 3rd bash task --- github_script.sh

```sh
#Download JSON file with pull requests info
curl   -H "Accept: application/vnd.github.v3+json"   https://api.github.com/repos/orkestral/venom/pulls > ./test.json
```

`jq` command allows to get requiring part of json file.

Сonstruction `[ -z "$(jq '.[].number' test.json)" ]` returns true if string length from `.[].number` == 0. If true runs `printf` command , else runs remaining                            part.

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


