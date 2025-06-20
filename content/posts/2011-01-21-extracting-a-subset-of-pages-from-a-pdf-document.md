---
title: Extracting a subset of pages from a PDF document
date: '2011-01-21 16:50:48 +0000'

tags:
- kindle
- linux
- software
---
For an upcoming plane trip, I wanted to extract one chapter from an Intel IA32 Architecture Software Developer manual for reading on my Kindle.  In the past, I would have used [pdftk](http://www.pdflabs.com/tools/pdftk-the-pdf-toolkit/) for this purpose, but this is an old, unsupported tool that cannot handle the AESV2 encryption used in Intel's manuals.  I then tried to use the [Multivalent tools](http://multivalent.sourceforge.net/Tools/index.html), which supposedly contain various PDF manipulation tools, but this package seems to have suffered from software rot, and the supplied .jar file no longer contains the necessary classes.

Finally, I stumbled on this [article in Linux Journal](http://www.linuxjournal.com/content/tech-tip-extract-pages-pdf), which shows how to use gs (Ghostscript) to extract pages.  This works well enough with Intel's manuals, though it does change various Microsoft fonts to their more standard equivalents.  Here's a slightly modified version of the article's script:

```bash
#!/bin/sh

# this script take 3 arguments:
#     $1 is the first page of the range to extract
#     $2 is the last page of the range to extract
#     $3 is the input file
#     output file will be named "inputfile_pXX-pYY.pdf"

first=$1
last=$2
input=$3
if [ -z "$first" -o -z "$last" -o -z "$input" ] ; then
   echo "usage: pdfextract firstpage lastpage inputpdffile"
   exit 1
fi
gs -sDEVICE=pdfwrite -dNOPAUSE -dBATCH -dSAFER \
       -dFirstPage=$first \
       -dLastPage=$last \
       -sOutputFile="${input%.pdf}_p$first-p$last.pdf" \
       $input
```
