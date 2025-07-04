---
title: Printing USPS Click-N-Ship labels in Firefox on Linux
date: '2009-06-11 21:05:30 +0000'

tags:
- linux
- software
---

I use the USPS web site to print shipping labels, and each time I
upgrade to a new version of Firefox or Linux, I always run into the
same problem: printing labels doesn't work.  As soon as I click the
Pay and Print button, Firefox goes into some kind of infinite loop
reading data from the USPS web site, and the PDF file containing the
label is never seen.

The fix is to change how PDFs are handled by Firefox so that Adobe
Reader is started as a separate process, rather than as an embedded
window inside Firefox.  Here's how to do that in version 3.0 of
Firefox:

Open Edit / Preferences, then click on the Applications tab.  Enter
PDF in the search box; a single entry with Content Type of "PDF
document" should be displayed.  Change the Action to "Use Adobe
Reader"; make sure you don't select "Use Adobe Reader (in Firefox)"
accidentally.
