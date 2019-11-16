# Deduped photo folders


## From the *brief*


### Requirements
1. The "user interface" of the shared image repository must not change:
  - Users can still upload images and organize them however they want.
  - Users can re-arrange, delete, etc.
  - If a user put an image in a folder it can't disappear or move somewhere else.
2. The script needs to be run regularly, not just once.
3. No loss or corruption of information.
4. No specific language requirement.
5. Needs to deal with millions of images.
6. Note any limitations.
7. Add comments explaining how it all works.
### Gotchas:

1. Many different phones and cameras are being uploaded, so one IMG01234.JPG is not
the same as another (you can't just go by the file name).
2. Between runs of the program, someone might re-upload and create duplicates of
images that have already been linked together.
3. There might be damaged images and those might also be duplicated.
4. Subsequent runs must avoid creating "splits", where groups of duplicates are not
merged.

### Hints:
1. Someone may have processed a group of pictures (like resize or red-eye removal), so
everything about the image might be the same (file name, meta-data, modification
date, etc.) except the image itself is different.

## My ideas

### Hash files


### Copy to a hidden folder

### replace w/ symlink






### Hueristics
- run on change/ inotify
- store in quick-to-lookup folder / files
- store hash as file attributes
- store list of linked files as attribute?
  - maybe can just search for matching inode