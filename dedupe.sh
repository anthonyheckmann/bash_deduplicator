#!/usr/bin/env bash
# File deduplicator lovingly written in Bash
#
# `rdfind` and `fdupes` are existing utilites that work well and 
# achive a better result
# A fs like ZFS, or Btfs could easily deduplicate these files automatically and support more features
# LIMITATIONS:
# File creation times become locked to time on first discovered file, among duplicated
# While deletion is ok, writing to a file would change all current duplicates (ZFS or Btfs would be much better)
# Speed is slow since all files are enumerated

# This loades a set of boilerplate logging functions
# shellcheck source=main.sh
. main.sh





#change to root folder
cd "$arg_d"


#Declare a hidden folder name to hold hashed files
declare STORE_FOLDER=".dedupe"
declare ROOT_PATH

#If hidden storage folder already exist, log it
if test -e "$STORE_FOLDER" && test -d "$STORE_FOLDER"; then
    info "$STORE_FOLDER existed"

else #if it doesn't, create along with some subfolders
    info "Making $STORE_FOLDER"
    mkdir -p "$STORE_FOLDER/hashes" #just to store hash values, not used yet
    mkdir -p "$STORE_FOLDER/files"  #used to store links named after hash value
fi
ROOT_PATH="$(pwd)/$STORE_FOLDER"

#grab all files names TODO: tweak this to be faster, or more selective
FILES_THAT_EXIST=$(find . -type f -not -path " '*$STORE_FOLDER*' " -and -not -path '*\/.*' -and -not -name '*.bak~') #NOTE, will mess up if file names contain newlines
#NOTE, could also use lsattr -R to find extended attributes



#FOR each files, hash it
#NOTE parallels or xargs speed this up
for file in $FILES_THAT_EXIST; do
    sum=$(sha1sum -b "$file" | grep -oE '^[a-f0-9]+')

    #Record that file was scanned NOTE: Not used yet
    touch "$ROOT_PATH/hashes/$sum"

    # Also check if a stored file with hash name exists. If not, create it
    # By hardlinking
    if test ! -e  "$ROOT_PATH/files/$sum"; then
        ln "$file" "$ROOT_PATH/files/$sum"
        #TODO: These tasks could be queued at performed at end, or interactively
    else
        #Here a duplicate file has been detected since its hash is also an existing, cached file
        info "file $file already present as hash $sum"
        
        #let check they have same size
        size1=$(stat -c %s "$file")
        size2=$(stat -c %s "$ROOT_PATH/files/$sum")
        #if they do, make a backup, delete the duplicate and replace with a hardlink
        if test "$size1" = "$size2"; then 
            mv "$file" "$file.bak~"             #1 Make backup
            ln "$ROOT_PATH/files/$sum" "$file"  #2 Link hashed store to old filename NOTE: destroys timestamp
            rm -f "$file.bak~"                  #3 Remove backup
        else
            #We reach here if there is a hash collision or other weird problem
            alert "File $file had a matching hash $sum, but was a different size"
        fi
    fi
            #make the file read-only to discourage writing
            chmod -w "$file"                    #Remove write permissions NOTE: Not very sophisticated

done