#!/usr/bin/env bash

INDEX_ID=1
INDEX_HUB_NAME=3
#INDEX_CLOSED=4
INDEX_WEBSITE_URL=5
INDEX_WEBSITE_INACTIVE=6
INDEX_TWITTER_HANDLE=7
INDEX_FACEBOOK_URL=8
INDEX_LINKEDIN=9
INDEX_LAT=10
INDEX_LNG=11
INDEX_ADDRESS=12
INDEX_CITY=13
INDEX_REGION=14
INDEX_COUNTRY=15
INDEX_DESCRIPTION=16
INDEX_EMAIL=17
INDEX_EXCLUDE=19

echoerr() { echo "$@" 1>&2; }

get_column(){
    line="$1"
    index="$2"

    printf '%s' "$line" | awk -F\\t "{print \$$index}"
}

get_name(){
    line="$1"
    get_column "$line" $INDEX_HUB_NAME 
}

get_short_name(){
    line="$1"
    get_name "$line" |
    sed 's/[^a-zA-Z0-9][^a-zA-Z0-9]*/-/g' |
    sed 's/-$//' |
    tr '[:upper:]' '[:lower:]'
}

should_exclude(){
    line="$1"
    get_column "$line" $INDEX_EXCLUDE
}

create_profile(){
    line="$1"
    out_dir="$2"

    exclude=$(should_exclude "$line")
    if [ ! -z  "$exclude" ]; then
        return
    fi

    short_name=$(get_short_name "$line")
    content_dir="$out_dir/content/hub/$short_name/"
    output_file="$content_dir/index.md"
    name=$(get_name "$line")
    hub_id=$(get_column "$line" $INDEX_ID)
    website=$(get_column "$line" $INDEX_WEBSITE_URL)
    website_inactive=$(get_column "$line" $INDEX_WEBSITE_INACTIVE)
    twitter=$(get_column "$line" $INDEX_TWITTER_HANDLE)
    facebook=$(get_column "$line" $INDEX_FACEBOOK_URL)
    linkedin=$(get_column "$line" $INDEX_LINKEDIN)
    lat=$(get_column "$line" $INDEX_LAT)
    lng=$(get_column "$line" $INDEX_LNG)
    address=$(get_column "$line" $INDEX_ADDRESS)
    city=$(get_column "$line" $INDEX_CITY)
    region=$(get_column "$line" $INDEX_REGION)
    country=$(get_column "$line" $INDEX_COUNTRY)
    description=$(get_column "$line" $INDEX_DESCRIPTION)
    email=$(get_column "$line" $INDEX_EMAIL)
    
    mkdir -p "$content_dir"
    echo "---" > "$output_file"
    echo "title: \"$name\"" >> "$output_file"
    echo "date: 2021-06-12T15:35:07-04:00" >> "$output_file"
    echo "draft: true" >> "$output_file"
    echo "id: $hub_id" >> "$output_file"

    echo "website: $website" >> "$output_file"
    echo "website-inactive: $website_inactive" >> "$output_file"
    echo "twitter: $twitter" >> "$output_file"
    echo "facebook: $facebook" >> "$output_file"
    echo "linkedin: $linkedin" >> "$output_file"
    
    echo "location: " >> "$output_file"
    echo "   lat: $lat" >> "$output_file"
    echo "   lng: $lng" >> "$output_file"
    echo '   address: "'"$address"'"' >> "$output_file"
    echo "   city: $city" >> "$output_file"
    echo "   region: $region" >> "$output_file"
    echo "   country: $country" >> "$output_file"
    echo "email: $email" >> "$output_file"
    echo "---" >> "$output_file"
    echo "$description" >> "$output_file"


}

create_profiles(){
    input_file="$1"
    out_dir="$2"

    while IFS="" read -r line || [ -n "$p" ]; do
        create_profile "$line" "$out_dir"
    done < "$input_file"

    echo output $output_dir
}

input_file="$1"
output_dir="$2"

if [ -z "$output_dir" ]; then
    echoerr "Error: Must provide input file and output directory as arguments"
    exit 1
fi

create_profiles "$input_file" "$output_dir"