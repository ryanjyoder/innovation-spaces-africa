#!/usr/bin/env bash

nonce=$(curl -s https://catalytic-africa.com/hubsnetworks/ | grep cart_canal_vars | sed 's/.*cart_canal_vars = \(.*\);.*/\1/' | jq -r .nonce)

IFS=$'\n'
for line in $(curl -s https://catalytic-africa.com/hubsnetworks/ | grep '<option' |  sed 's/.*option value="\([0-9]*\)">\(.*\)<.*/\1:\2/' ); do
    n=$(echo $line | sed 's/\(.*\):.*/\1/')
    country=$(echo $line | sed 's/.*:\(.*\)/\1/')

    for city_line in $(curl -s 'https://catalytic-africa.com/wp-admin/admin-ajax.php' -X POST --data-raw 'action=canal_catalyticafrica_Country&post_id='$n'&cart_canal_nonce='$nonce --output - |  grep option| sed 's/.*<option value="\([0-9]*\)">\(.*\)<\/option.*/\1:\2/'); do
    n_city=$(echo $city_line | sed 's/\(.*\):.*/\1/')
    city=$(echo $city_line | sed 's/.*:\(.*\)/\1/')
#echo :$n_city: :$n_city: :$city: :$country: $city_line
    
    for l in $(curl -s 'https://catalytic-africa.com/wp-admin/admin-ajax.php' -X POST  --data-raw 'action=canal_catalyticafrica_data&Country_id='$n'&city_id='$n_city'&tax_networks_id=16&cart_canal_nonce='$nonce  --output - | grep '<h2>' | sed 's/.*<a href="\(.*\)" target.*>\(.*\)<\/a>.*/\1\t\2/' ); do
    echo -e "$country\t$city\t$l"
done
done
done

