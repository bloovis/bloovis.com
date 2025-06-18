---
title: Koha, Mint 19, and silent printing
date: '2020-10-24 12:53:00 +0000'

tags:
- linux
- software
- linux mint
- epson
- koha
---

The [Koha manual](https://koha-community.org/manual/19.05/en/html/hardware.html)
describes how to tell Firefox to not display a print dialog
box when printing a slip on a receipt printer.  But those instructions are
specific to Firefox on Windows.  I'm in the process of replacing our library's
Windows 7 installations with Linux Mint 19.3, and I found that I
I had to do things slightly differently on Linux.

The first step was to install printer drivers.  Our library uses an
Epson TM-88IV receipt printer.  The Linux drivers for this obsolete
printer can be found [here](https://download.epson-biz.com/modules/pos/index.php?page=single_soft&cid=5012&pcat=3&pid=30).
After unpacking the file (using `tar xvfz`), the `install.sh` script must be run as root.
When the script prompts for a distribution name, select the latest one from the list
offered, even if it might be very old.  For example, the latest Ubuntu listed is 9.04,
but that one works for any more recent version of Ubuntu or Mint.

Then the printer needs to have a few things changed in its configuration.
Go to Menu / Administration / Printers, then right click over the receipt printer
and select Properties.  In Job Options, turn off "Scale to fit".  Then under
Text Options a bit farther down, set the left, right, and bottom margins to 0.
Set the top margin to a small number like 0.1; if it is 0, the top line of
a printed receipt might be partially cut off.

Finally, some configuration changes need to be made in Firefox.  It's best
to do this in a profile other than the default; refer to
[this guide](https://support.mozilla.org/en-US/kb/profile-manager-create-remove-switch-firefox-profiles)
to see how to create a separate profile for Koha.

First, try printing a slip in Koha for a patron. When the print dialog pops up, 
select the Epson printer as the Destination.  Then make the following changes to the margins:

* Top: 0.1
* Bottom: 0
* Left: 0
* Right: 0

Then unselect "Print headers and footers".  Finally, click on Print.
The slip should be readable (i.e., the print is not too small), and
it should be cut off at the bottom without any extra space. 

Now visit the page `about:config`, and answer yes to the nagging question
about the dangers.  In the search box, enter `print.always_print_silent`.
If there is no such preference, create it as a boolean. Set it to true.

Another non-obvious change might need to be made in `about:config`.  Enter
`print_printer` in the search box.  This field should contain the
*exact* name of your receipt printer, as shown in the Printers tool
mentioned above.  If it does not, you'll need to enter it manually.
In the case of our Epson printer, this field contained
`Epson-TM-BA-Thermal`.  Without this configuration parameter, Firefox will print silently
(i.e., without a print dialog) as expected, but will ignore all of the printer
configurations, so that the printed slip is scaled so small as to
be unreadable.

As a result of all these changes, you should be able to print a slip in Koha
without a print dialog, and with no space-wasting margins.
