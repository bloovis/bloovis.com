---
title: Disable low toner error in Brother printer
date: '2018-04-24 14:46:00 +0000'

tags:
- printers
- crapification of everything
---
Our library has a Brother MFC-8950DW laser printer / copier device that
started complaining recently about its toner cartridge being low on toner.
The cartridge was nearly new and the print quality was still quite good.
Then a couple of days ago, the printer stopped printing, saying
that we needed to replace the cartridge.  This was clearly ridiculous.
After some poking around I found this video
that showed how to disable the low toner error and get thousands more
pages out of the cartridge:

{{< youtube PK9qUeH1AVU >}}

Here's what to do:

1. Remove the toner cartridge.  This requires removing its carrier and
then extracting the cartridge from the carrier.

2. Notice that there is a small clear plastic lens on the right side of the
cartridge.  The printer shines a laser beam through this hole, and if the beam
emerges on the left side of the cartridge, the printer
assumes that the toner level is low.

3. Place a small piece of duct tape over the lens and reinstall the cartridge.
The low toner error should be gone.

I filed this note under "crapification of everything" because it's
another example of how making a device "smart" has actually made it
stupider.  The user can no longer decide when to replace the toner
cartridge based on print quality.  The printer now makes this decision
on its own, and worse yet, refuses to function once it has made this
erroneous decision.
