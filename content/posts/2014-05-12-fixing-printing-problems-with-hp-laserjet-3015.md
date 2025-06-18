---
title: Fixing printing problems with HP Laserjet 3015
date: '2014-05-12 18:28:49 +0000'

tags:
- linux
- linux mint
- ubuntu
- printers
---
It appears that the HP 3015 printer has bugs in its PostScript interpreter that have been exposed by recent versions of Linux.  Using an ancient version of Linux Mint (from around 2010), the printer worked fine.  But starting with Mint 13 (Ubuntu 12.04), certain PDF files, when printed from "Document Viewer" (evince or atril) would cause the printer to barf and print a page containing an obscure PostScript error message.

This problem started when Ubuntu switched the PDF to PostScript renderer in the print system from Poppler to GhostScript, as described [here](http://ubuntuforums.org/archive/index.php/t-2022997.html).  Fortunately, it is possible switch the renderer back to the old setting, using this command:

```
lpadmin -p PRINTER -o pdftops-renderer-default=pdftops
```

where PRINTER is the actual name of the printer queue, which you can discover using `lpstat -v`.  This fix seems to have worked with the HP 3015, at least in one test file that previously caused it to barf.

*Update*: While the above fix did help somewhat, printing on the 3015 was still excruciatingly slow, sometimes taking 20 minutes to print a page with graphics.  It appears that HP's PostScript implementation is not really usable.  The fix is to switch to using PCL 5, the native printer language of most HP printers.  This can be done by editing the printer properties.  In Linux Mint, click on Menu / Administration / Printing.  Right click on the icon of the printer, select Properties, then press the Change button next to Make and Model.  Press the Forward button to get to the dialog where you can change the printer driver.  Select Gutenprint instead of Postscript and then confirm your choice.
