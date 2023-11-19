#!/bin/bash

#Removes all images from PDFs. Used for removing watermarks from SVG based PDFs.

#Only use on copies, not originals, can ruin some PDFs

#Requires cpdf https://www.coherentpdf.com/

OLDIFS="$IFS"
IFS=$'\n'

FILE_PATHS=$(find . -iname "*.pdf" ! -iname "*clean*");

for file_path in $FILE_PATHS; do
    echo "$file_path"
    #Converting PDFs to draft format conveniently removes most watermarks while leaving SVG data alone.
    cpdf -error-on-malformed -draft $file_path -o "${file_path%.*}_clean.pdf";
done

IFS="$OLDIFS"
