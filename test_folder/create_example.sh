#!/bin/bash 


folders_to_make=10
declare -a folder_names=()
true
while [ $folders_to_make -gt 0 ]; do
    curr_dir="$(mktemp -d -p . fXXXX)"
    echo $curr_dir
    folder_names+=("$curr_dir")
    folders_to_make=$(( $folders_to_make - 1))
done

for my_folder in "${folder_names[@]}"; do
    #create
    count=5
    while [ $count -gt 0 ]; do
        #truncate -s "$(( ( RANDOM % 500 )  + 50 ))K" "$(mktemp -p "$my_folder" XXXX.jpg)"
        temp_name="$(mktemp -p "$my_folder" XXXX.jpg)"
        dd if=/dev/urandom count="$(( ( RANDOM % 500 )  + 50 ))" of="$temp_name"
        if [ $(( RANDOM % 100 )) -lt 10 ]; then
            cp "temp_name" "$(mktemp -p "$my_folder" XXXX.jpg)"
            true
        fi
        count=$(( $count -1 ))
    done
done