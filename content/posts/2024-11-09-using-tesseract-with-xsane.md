---
title: Using tesseract with xsane
date: '2024-11-09 11:59:00 +0000'

tags:
- software
- linux
---

Xsane is the standard image scanning program for Linux Mint.  One useful
feature is the ability to convert a scanned image to text.  After you
scan an image, use "ABCDEF" button in the Viewer to save the image
as a text file.  By default, Xsane uses a program called `gocr` to
for the OCR conversion.  Because I prefer to use tesseract for OCR,
I wrote a small wrapper script to emulate the behavior of gocr.  Then in
xsane Preferences / Setup, in the OCR tab, I changed the OCR command
to the full path of my script.

I'm pretty sure this used to work in older versions of Linux Mint,
but in Mint 21, tesseract now hangs when invoked this way from xsane.
I finally found a [tesseract issue report](https://github.com/tesseract-ocr/tesseract/issues/898#issuecomment-315202167)
that gives the solution: you must use `OMP_THREAD_LIMIT=1` before
invoking tesseract.  This can be done either using an export before invoking
tesseract, or as a prefix to the tesseract command.

There are many xsane-to-tesseract scripts on the internet; here is mine:

```ruby
#!/usr/bin/env ruby

$VERBOSE = true

require 'getoptlong'

outfile = nil
infile = nil
$verbose = true

def usage
  puts "usage: ocr.real -i [ image.tif | image.png ] -o output.txt"
  exit 1
end

def dprint(str)
  if $verbose
    puts str
  end
end

opts = GetoptLong.new(
  [ '-q', GetoptLong::NO_ARGUMENT ],
  [ '-o', GetoptLong::REQUIRED_ARGUMENT ],
  [ '-i', GetoptLong::REQUIRED_ARGUMENT ]
)

opts.each do |opt, arg|
  case opt
  when '-o'
    outfile = arg
  when '-i'
    infile = arg
  when '-q'
    $verbose = false
  end
end

if !infile
  dprint "input file #{infile} not specified"
  usage
end

if !outfile
  dprint "output file not specified"
  usage
end

if outfile =~ /(.*)\.txt$/
  outfile = $1
else
  dprint "output file must have .txt extension"
  usage
end

dprint "tesseract #{infile} #{outfile}"
system("OMP_THREAD_LIMIT=1 tesseract #{infile} #{outfile}\n")
```
