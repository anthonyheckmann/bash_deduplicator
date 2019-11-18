#!/bin/bash 
# Creates a bunch of folders containing a bunch of random files

folders_to_make=10      #number of top-level random folders
files_per_folder=5      #number of random files in each folder
percent_to_duplicate=20 #percent of files to also make a duplicate copy



declare -a folder_names=()

# Make a number of folders
while [ $folders_to_make -gt 0 ]; do

    #make a folder with name patterned fXXXX
    curr_dir="$(mktemp -d -p . fXXXX)"
    echo $curr_dir
    
    #add this name to a list
    folder_names+=("$curr_dir")
    folders_to_make=$(( $folders_to_make - 1))
done


# go through list of created folders and create random files
for my_folder in "${folder_names[@]}"; do
    
    #We'll create this many files
    count=$files_per_folder
    while [ $count -gt 0 ]; do
        
        # This line `truncate -s` makes sparse files
        #truncate -s "$(( ( RANDOM % 500 )  + 50 ))K" "$(mktemp -p "$my_folder" XXXX.jpg)"
        
        #get a random file name
        temp_name="$(mktemp -p "$my_folder" XXXX.jpg)"
        
        #Copy random bits from urandom between 50 and 500 blocks
        dd if=/dev/urandom count="$(( ( RANDOM % 500 )  + 50 ))" of="$temp_name"
        
        # Some percenttage of the time, make a copy of this folder to a new random name
        if [ $(( RANDOM % 100 )) -lt $percent_to_duplicate ]; then
            cp "$temp_name" "$(mktemp -p "$my_folder" XXXX.jpg)"
            
        fi
        count=$(( $count -1 ))
    done
done
