#!/bin/bash

# The Trap to delete ./test.json on exit from the script 
# even if an error occurred during execution or a user aborts the script manually
trap "rm -f ./test.json" EXIT SIGINT SIGQUIT SIGKILL SIGTERM

# If there is 1 or more argument and first argument is not empty - treat first argument as GitHub repo URL
# Otherwise use default values
if [ ${#@} -ge 1 ] && [ -n $1 ]; 
  then 
    user_name=$(echo "$1" | cut -d'/' -f4);
    repo_name=$(echo "$1" | cut -d'/' -f5);
  else
    user_name="orkestral"
    repo_name="venom"
fi

api_pulls_url="https://api.github.com/repos/${user_name}/${repo_name}/pulls?per_page=100&page=1"

curl -s  -H "Accept: application/vnd.github.v3+json"   "$api_pulls_url" > ./test.json

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