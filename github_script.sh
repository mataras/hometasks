#!/bin/bash

curl   -H "Accept: application/vnd.github.v3+json"   https://api.github.com/repos/orkestral/venom/pulls > ./test.json

if [ -z "$(jq '.[].number' test.json)" ]; then
  printf "There is no pull requests in this repo"

else

  printf "The most productive contributors: %s\n"
  jq '.[].user.login' test.json | sort | uniq -c | awk '{if ($1 > 1) print $2}'
  
  if [ -z "$(jq '.[].labels[].name' test.json)" ]; then
    printf "\n There are no pull requests with labels"
  else
    printf "\n"
    jq '.[] | .user.login + " " + .labels[].name' test.json | sed 's/\"//g' | sort | uniq -c | awk '{print "User", $2 , "has", $1, "PR with label"  }'
  fi
  printf "\n"
  jq '.[] | (.number|tostring) + " " +  .user.login' test.json | sed 's/\"//g' | sort | awk '{print "User" , $2, "with PR number" , $1}' 
  
fi

rm test.json
