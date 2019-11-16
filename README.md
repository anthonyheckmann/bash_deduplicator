# File deduplicator

This script `dedupe.sh` can take a specified folder containing duplicates, detect them, and replace them with hardlinks. Other utilities
exist that do this, but this one is mine.

## Usage

    ./dedupe.sh -d <target folder>


## Better Usage

Set `./dedupe.sh` as a `cron` job, to automate

## Limitations
- sha1 is somewhat slow
- no function to delete or prune orphaned files
- no support for Copy-on-write: writes affect all duplicates
- File additions or deletion, require slow scan of all files, or specifying a date range to scan.

## Improvements To Do

- add extended attributes to files to help speed re-scans. A utility like `xattr` would allow attaching hash to each file
- Use a COW supporting FS to provide these dedupliation features natively
- 

## Testing

    cd test_folder
    ./create_example.sh
    cd ..
    ./dedupe.sh -d ./test_folder/   #Perform dedupe
    du -d1 -h ./test_folder/    #See that little space is used
    ls -la ./test_folder/*/*    #See that all files have a least 2 pointers eg.

### Example of `ls`

```
-r-------- 2 anthonyheckmann anthonyheckmann  56832 Nov 15 19:55 fxzLc/AxA4.jpg
-r-------- 3 anthonyheckmann anthonyheckmann 155648 Nov 15 19:55 fxzLc/Jtt8.jpg
-r-------- 2 anthonyheckmann anthonyheckmann  90112 Nov 15 19:55 fxzLc/ShoM.jpg
-r-------- 3 anthonyheckmann anthonyheckmann 155648 Nov 15 19:55 fxzLc/VTA0.jpg
-r-------- 2 anthonyheckmann anthonyheckmann 139264 Nov 15 19:40 fydf4/3Cgp.jpg
-r-------- 2 anthonyheckmann anthonyheckmann 202240 Nov 15 19:40 fydf4/9CjH.jpg
-r-------- 2 anthonyheckmann anthonyheckmann 114176 Nov 15 19:40 fydf4/MblF.jpg
-r-------- 2 anthonyheckmann anthonyheckmann 154112 Nov 15 19:40 fydf4/rYs2.jpg
-r-------- 2 anthonyheckmann anthonyheckmann  26624 Nov 15 19:40 fydf4/TCYj.jpg
```