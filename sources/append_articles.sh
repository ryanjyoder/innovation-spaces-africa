#!/usr/bin/env bash


function print_front_matter(){
    in_file="$1"

    seen_dashes=false
    while IFS= read -r l; do
        if ( ( ! $seen_dashes ) && [ "$l" == "---" ] ); then
            seen_dashes=true
            continue
        fi
        if ( $seen_dashes && [ "$l" == "---" ] ); then
            seen_dashes=true
            return
        fi
        echo "$l"
    done < "$in_file"
}


function print_content(){
    in_file="$1"

    seen_dashes=0
    while IFS= read -r l; do
        if ( [ "$seen_dashes" == "0" ] && [ "$l" == "---" ] ); then
            seen_dashes=1
            continue
        fi
        if ( [ "$seen_dashes" == "1" ] && [ "$l" == "---" ] ); then
            seen_dashes=2
            continue
        fi

        if [ "$seen_dashes" == "2" ]; then
        echo "$l"
        fi
    done < "$in_file"
}

function add_article_links(){
    page_file="$1"
    links_file="$2"
    temp_file=$(mktemp)

    id=$(print_front_matter "$1" | yq eval '.id' -)

    echo '---' > "$temp_file"
    print_front_matter "$page_file" >> "$temp_file"
    echo "articles:" >> "$temp_file"
    grep -e "^$id"$'\t' "$links_file" |
    awk -F\\t 'NF>2 {
        for(i=3;i<=NF;i++){
            if($i==""){continue;}
            printf("   - \"%s\"\n", $i);
        }
    }' >> "$temp_file"
    echo '---' >> "$temp_file"
    print_content "$page_file" >> "$temp_file"
    mv "$temp_file" "$page_file"
}

process_content(){
    content_dir="$1"
    links_file="$2"

    for page_file in $(find "$content_dir" -name '*index.md'); do
        echo updating: $page_file
        add_article_links "$page_file" "$links_file"
    done

}

process_content "$1" "$2"