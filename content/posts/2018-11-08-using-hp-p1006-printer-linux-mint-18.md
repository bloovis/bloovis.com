---
title: Using an HP P1006 printer in Linux Mint 18
date: '2018-11-08 07:47:00 +0000'

tags:
- linux
- linux mint
- thinkpad
- ubuntu
- printers
---

Over the years, one persistent problem with using HP printers in Linux Mint
has been the conflict between the drivers provided by CUPS (the standard Linux printing
system), and HPLIP (the HP software that provides proprietary drivers for some
of the company's printers).  My old P1006 printer (which uses a USB connection) requires the use of HPLIP,
because CUPS does not contain the required drivers.  However, when the printer
is first plugged into a system running Linux Mint (and, presumably, Ubuntu),
CUPS automatically installs its own incorrect driver for the P1006 after a few seconds.  Then if you
run the HPLIP device manager, which installs its own driver, the incorrect CUPS
driver will still be used, and printing from Xreader (a PDF reader)
will not produce correct output.

The fix is to delete the CUPS printer driver before running the HPLIP device manager.
After you plug in the printer, wait a few seconds for CUPS to install its driver.
Then open the CUPS Printers tools (aka system-config-printer, found by searching for "printer"
in the Mint menu).  Find the newly added HP printer, right click on it, and select Delete.
This will remove the incorrect driver.

Then run the HPLIP device manager.  (This is part of the hplip-gui package, and
looks like a little HP logo in the system tray.)  Tell it to add a USB printer,
and it should soon install a working driver.

You can verify that the correct driver is in use by opening the CUPS Printers tool again (see above).
Right click on the printer, and select Properties.  In Settings, the Make and Model field
should include words saying something like "hpcups 3.16.3, requires proprietary plugin".
If the incorrect CUPS driver is being used, this field will not mention "hpcups", but may
include the word "foomatic" somewhere.
