---
title: Using an Epson Perfection V30 scanner in Linux
date: '2009-10-04 11:03:13 +0000'

tags:
- linux
- linux mint
- ubuntu
---
When I was shopping for an inexpensive flatbed scanner, it was not always easy to figure out which ones would work in Linux.  Many manufacturers use proprietary protocols in their products and generally ignore Linux.  I bought an Epson V30 because it was cheap and because there are drivers available for download [here](http://www.avasys.jp/lx-bin2/linux_e/scan/DL1.do).  The drivers work on Linux Mint 6 (Ubuntu 8.10) or later, and on several other Linux variants.  Unfortunately source code is not provided, so if you don't have one of the popular distributions, you may be out of luck.

One of the things I wanted to do with the V30 was scan books and convert them to plain text (for personal use; I'm not a pirate).  For this I used Tesseract, an open-source OCR package that was developed at HP in the 90s and is now being [maintained by Google](http://code.google.com/p/tesseract-ocr/).  (The package name in Mint / Ubuntu is "tesseract-ocr".)  This program has a slightly funky command line interface (only reads TIFF files; the input filename must end in ".tif", not ".tiff" or anything else; the output filename must be given without an extension).  But it works surprisingly well, and I was able to integrate it into xsane (a decent scan utility) by writing a wrapper shell script that makes its command line interface identical to the gocr program that xsane uses by default.

I experimented with varying the dots per inch when scanning a book, to see how that affected tesseract's error rate.  At 100 DPI, the output was gibberish.  At 200 DPI, the output was nearly perfect, with only about four errors per page that needed to be corrected manually.  At 300 DPI, the output was marginally better, with perhaps one or two fewer errors per page.  As I mentioned, this seems remarkably good.  After I scan a page and convert it to text, I'll fix the obvious errors and remove any end-of-line hyphenation.  Then I'll run aspell on the text to find additional errors.  The most common errors are missing spaces ("ofthe") and "l" change to "1".

Another approach to OCR is to buy the commercial, closed-source [Vuescan](http://www.hamrick.com/).  I owned a copy six years ago, when xsane was not quite up to snuff, and it worked beautifully.  I'm trying the latest trial version, and it has a number of improvements.  The most interesting new feature is the integration of tesseract-ocr.  This saves several steps in the process of scanning text, and the speed-up may be worth the price.

*Update May 2013*: The link to the Epson drivers mentioned above no longer works.  The drivers are now located [here](http://download.ebz.epson.net/dsc/search/01/search/).  Enter the name of the device ("Perfection V30" in this case) and hit the search button.  On the page that appears, click on the Download button for "core package&data package" for Linux, which will eventually take you to the download page for the packages "iscan-data" and "iscan".  You'll also need to do the same thing for the "iscan plugin package" for Linux, which takes you to the download page for the "esci-interpreter" package.  I needed to install all three of these packages on my Linux Mint 13 system, starting with the "iscan-data" package.
