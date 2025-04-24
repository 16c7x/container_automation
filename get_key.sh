#!/bin/bash

username=""
password=""

while IFS= read -r line; do
  if [ -z "$username" ]; then
    username="$line"
  elif [ -z "$password" ]; then
    password="$line"
    break
  fi
done < ~/.ssh/fortress.key

echo "{\"username\": \"$username\", \"password\": \"$password\"}"