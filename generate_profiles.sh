#!/usr/bin/env bash

echoerr() { echo "$@" 1>&2; }


create_profiles(){
    input_file="$1"
    output_dir="$2"

    while IFS="" read -r p || [ -n "$p" ]; do
        printf '%s\n' "$p"
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