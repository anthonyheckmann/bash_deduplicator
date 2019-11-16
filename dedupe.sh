#!/usr/bin/env bash
# File deduplicator lovingly written in Bash
#
# `rdfind` and `fdupes` are existing utilites that work well and 
# achive a better result


# This is a set of 
# shellcheck source=main.sh
. main.sh






#make a hiddenfolder if it doesnt exist
cd "$arg_d"
info "$(pwd)"


declare STORE_FOLDER=".dedupe"
declare ROOT_PATH
if test -e "$STORE_FOLDER" && test -d "$STORE_FOLDER"; then
    info "$STORE_FOLDER existed"

else
    info "Making $STORE_FOLDER"
    mkdir -p "$STORE_FOLDER/hashes"
    mkdir -p "$STORE_FOLDER/files"
fi
ROOT_PATH="$(pwd)/$STORE_FOLDER"

#grab all files TODO: tweak this to be faster, or more selective
FILES_THAT_EXIST=$(find . -type f -not -path " '*$STORE_FOLDER*' " -and -not -path '*\/.*' -and -not -name '*.bak~') #NOTE, will mess up if file names contain newlines
#NOTE, could also use lsattr -R to find extended attributes

#HASH each file

#NOTE parallels or xargs speed this up
for file in $FILES_THAT_EXIST; do
    sum=$(sha1sum -b "$file" | grep -oE '^[a-f0-9]+')
    touch "$ROOT_PATH/hashes/$sum"
    if test ! -e  "$ROOT_PATH/files/$sum"; then
        ln "$file" "$ROOT_PATH/files/$sum"
        #TODO: Add these to task queue and perform at end
        #TOOD: Need tmp files then
    else
        info "file $file already present as hash $sum"
        #check they have same size
        size1=$(stat -c %s "$file")
        size2=$(stat -c %s "$ROOT_PATH/files/$sum")
        if test "$size1" = "$size2"; then 
            mv "$file" "$file.bak~"             #Make backup
            ln "$ROOT_PATH/files/$sum" "$file"  #Link hashed store to old filename NOTE: destroys timestamp
            rm -f "$file.bak~"                  #Remove backup
        else
            alert "File $file had a matching hash $sum, but was a different size"
        fi
    fi
            chmod -w "$file"                    #Remove permissions NOTE: Not very sophisticated

done