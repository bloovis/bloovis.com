---
title: Printing to PDF from Firefox
date: '2008-03-04 21:51:29 +0000'

tags:
- linux
- pclinuxos
- software
---
I recently needed to send my credit report to a landlord, and it seemed as if a PDF file would be the logical choice.  So I needed a way to create a PDF file directly from Firefox, since the credit reporting agency didn't provide an option for creating a PDF.  Fortunately, there is a cups-pdf package that lets you do this.  However, getting it to work in Firefox is not completely obvious.  Here's how to do it in PCLinuxOS 2007:

First, install the cups-pdf package in synaptic (the program labelled "Package Manager" in the toolbar).

Then, as root, restart cups using this command in a Konsole (or other terminal window): `service cups restart`.  (This step may not be necessary, but it doesn't hurt either.)

At this point, the KDE browser, Konqueror, will be able to see the "CUPS-PDF" printer in its Print dialog.  But Konqueror has problems with rendering pages this way, so you'll want to use Firefox instead.  But Firefox won't see the printer.

Back in Firefox, visit the [CUPS configuration page](http://localhost:631).  You'll be asked to provide the root username and password.  Click on the "Administration" tab.  You should see the "Virtual PDF" printer under "New Printers Found".  Click the "Add This Printer" button.  In the "Make/Manufacturer" page, select "Generic".  In the "Model/Driver" page select "Generic PostScript".

Now Firefox should be able to see the CUPS-PDF printer in its Print dialog.

When you print a page using this pseudo-printer, the output goes to a PDF file on your desktop (the `~/Desktop` directory).  There's no easy way to change the directory or filename that cups-pdf uses, so you'll probably want to move or rename the file after it's created.
