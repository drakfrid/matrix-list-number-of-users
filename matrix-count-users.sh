#!/bin/bash

# Lists the number of registered users on a Matrix homeserver according to
# https://matrix-org.github.io/synapse/develop/admin_api/user_admin_api.html#list-accounts
# Version 1.1, 2022-02-20

echo "Please enter your admin access token"
read -s TOKEN
if [[ -z "$TOKEN" ]]
then
  while [[ -z "$TOKEN" ]]
  do
    echo "No admin access token entered"
    echo "Please enter your admin access token"
    read -s TOKEN
  done
fi

echo "Please enter your homeserver URL (e.g. matrix.example.com)"
read -s HOMESERVER
if [[ -z "$HOMESERVER" ]]
then
  while [[ -z "$HOMESERVER" ]]
  do
    echo "No admin access token entered"
    echo "Please enter your admin access token"
    read -s HOMESERVER
  done
fi

users=$(curl --silent -H "Authorization: Bearer $TOKEN" \
"https://$HOMESERVER/_synapse/admin/v2/users?from=0&limit=100000&guests=false")

if [[ "$users" =~ "M_UNKNOWN_TOKEN" ]]
then
  echo "ERROR: Invalid access token"
  exit 1
elif [[ "$users" =~ "error" ]]
then
  echo "ERROR: An error occured"
  echo $users
exit 2
fi

numberOfUsers=$(echo "$users" | tail -c 8 | grep -Eo "[0-99999]+")

echo "There are" $numberOfUsers "users on $HOMESERVER (non-deactivated) \
as of" $(date)
echo "There are" $numberOfUsers "users on $HOMESERVER (non-deactivated) \
as of" $(date) >> users.txt
