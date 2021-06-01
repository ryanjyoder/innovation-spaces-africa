#!/usr/bin/env bash

function get_name(){
    cat  ./html/$1.html | grep '<h2>' | sed 's/.*<h2>\(.*\)<\/h2>/\1/'
}

function get_description(){
    cat html/$1.html | grep '<p><b>' | sed 's/.*<p><b>\(.*\)<\/b><\/p>/\1/' | sed 's/<br>//'

}

function get_email(){
    cat html/$1.html| grep 'title="E-mail"' | sed 's/.*"mailto:\([^"]*\)".*/\1/'
}

function get_facebook_url(){
    cat html/$1.html | grep 'title="Facebook"' | sed 's/.*<a href="\([^"]*\)"[^>]* title="Facebook".*/\1/'
}

function get_website_url(){
    cat html/$1.html | grep 'title="Site Internet"' | sed 's/.*<a href="\([^"]*\)".* title="Site Internet">.*/\1/'
}

function get_address(){
    cat html/$1.html | grep 'td style="text-align: right;">' | grep '</td>'  | sed 's/.*>\(.*\)<.*/\1/'
}

mkdir -p html
curl -s https://www.africinnov.com/fr/annuaire > html/index.html

for u in $(cat html/index.html | grep https://www.africinnov.com/fr/annuaire/ | sed 's/.*"https:\/\/www.africinnov.com\/fr\/annuaire\/\([^"]*\)".*/\1/' | sort | uniq ); do
    curl -s https://africinnov.com/fr/annuaire/$u > html/$u.html
    name=$(get_name $u)
    email=$(get_email $u)
    facebook=$(get_facebook_url $u)
    website=$(get_website_url $u)
    address=$(get_address $u)
    description=$(get_description $u)
    echo "\"$name\",\"$website\",\"$facebook\",\"$address\",\"$email\",\"$description\""

done