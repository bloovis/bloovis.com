---
title: Extracting text from image-only PDF files
date: '2015-05-07 15:28:08 +0000'

tags:
- linux
- linux mint
- software
- ubuntu
---
Sometimes I obtain scanned books in PDF format, in which each page is simply an image, not text.
But it would handy to use OCR to extract the text from these images.
<!--more-->
On Linux, this can be done manually, first by using `gs` (GhostScript) to extract the desired pages to tiff image files, then by using `tesseract`, a high-quality OCR program, to extract the text from the tiff files.  But that's a lot of work when there are many pages to convert.

To make this job a little easier, I wrote a simple script that extracts the text from the pages you specify, and concatenates the text into a single output file.  I've seen at least one script on the web that does something like this, but it creates a tiff file for each page, which can take up a lot of disk space.  This script creates a single tiff file, `/tmp/junk.tiff`.

On Ubuntu or Linux Mint, you should already have `gs`.  You'll probably need to install the `tesseract` package.

Here is the script:

```bash
#!/bin/sh
# Script for converting an image-only PDF to a text file
# This script take 3 arguments:
#     $1 is the first page of the range to extract
#     $2 is the last page of the range to extract
#     $3 is the input file
#     output file will be the input filename with .pdf changed to .txt

first=$1
last=$2
input=$3

if [ -z "$first" -o -z "$last" -o -z "$input" ] ; then
   echo "usage: pdfocr firstpage lastpage inputpdffile"
   exit 1
fi

output=`basename -s .pdf $input`.txt
if [ -f $output ] ; then
  echo "Output file $output already exists.  Will not overwrite."
  exit 1
fi

page=$first
while [ $page -le $last ] ; do
  gs -sDEVICE=tiffg4 -dFirstPage=$page -dLastPage=$page \
     -dNOPAUSE -dBATCH \
     -sOutputFile="/tmp/junk.tiff" -- $input
  tesseract /tmp/junk.tiff stdout | cat >>$output
  let $((page++))
done

rm -f /tmp/junk.tiff
```
