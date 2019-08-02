#!/bin/bash

for filepath in $@
do
    echo "Processing file $filepath"

    # Get the file name without path and extension:
    # (https://stackoverflow.com/a/2664746/1018176)
    filename=${filepath##*/}  # trim longest match from beginning, a/b/c/file.ext -> file.ext
    objectname=${filename%%.*}  # trim longest match from end, file.ext -> file

    # Replace all occurrences of "solid <something>" and "endsolid <something>"
    # with "solid $objectname" and "endsolid $objectname", respectively:
    sed -ri "s|^((end)?solid).*|\1 $objectname|" $filepath
done
