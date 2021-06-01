#!/usr/bin/env bash

curl https://www.afrilabs.com/our-hubs-1/  | 
grep ActivSpaces | sed 's/.*maps(\(.*\))\.data(.*/\1/' | 
jq -r '.places[] | [ .id, .title, .location.lat, .location.lng, .address, .location.city, .location.state, .location.country, (.content | gsub("\n";" ")) ] | @csv' |
sed -e 's///g'

