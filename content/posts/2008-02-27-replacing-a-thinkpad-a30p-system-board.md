---
title: Replacing a ThinkPad A30p system board
date: '2008-02-27 14:33:05 +0000'

tags:
- hardware
- thinkpad
---
Last year my ThinkPad A30p started failing to charge its battery, after I'd left the machine on the shelf for a few months.  I thought that maybe the battery had died from neglect, but a replacement battery purchased on eBay also had the same problem.  So the system board (AKA motherboard) seemed to be at fault.  But at least the machine worked when it was connected to AC power.  Then a month or so later, it powered off spontaneously after 15 minutes of use, and after that it was completely dead.

I took the machine to a laptop repair shop in Santa Clara that advertises heavily on eBay.  After a month and a half of waiting, I finally called them back.  Apparently they had written down my phone number incorrectly and had left a message with the wrong phone number.  They told me they couldn't repair the system board or find a replacement, so there was no charge for service.  I showed up at the shop a week later to pick up the machine.  I was kept waiting in the rather dirty lobby for 40 minutes before a technician brought out the machine.

I was puzzled by the long wait, but I figured it out later: apparently, the technician had to put the machine back together hastily to return it to me.  A week later, when I took the machine apart to replace the system board with one I had bought on eBay, I discovered the following problems:

* There were at least a dozen screws missing, including all the screws on the CPU fan assembly.
* The removal lever on the floppy drive had been installed incorrectly, leaving the floppy drive jammed in place.
* The "keyboard CRU", an insulating support device that fits between the keyboard and system board, was missing.
* One of the two wi-fi antenna wires coming from the LCD had been cut.
* The PCMCIA assembly was not plugged all the way into its connector on the system board.

The moral of this sad tale: do all the work yourself.  This turned out not to be as difficult as I had imagined.  IBM's service manuals, available online, are excellent, and have detailed drawings, instructions, and parts lists.  Replacing the motherboard was tedious, because it involved removing just about every other component in the machine first, but it was a straightforward task.  I spent three hours on the job because I had never done this kind of repair before.  The hardest part was unjamming the floppy drive; I managed to get it out after removing the keyboard bezel, by lifting the drive up and distorting its enclosing Ultrabay cage slightly, while simultaneously pulling the drive out.  When I reassembled the machine, I made sure the floppy drive's removal lever was hooked up correctly.

My efforts were successful: the cheap ($30) system board I bought on eBay, which had been advertised as being in an unknown and non-guaranteed condition, works perfectly.  Mepis Linux 6.5 (which I'd installed just before the machine died) booted with no problems.  Even the wi-fi, about which I was worried because of the cut antenna cable, is fine (I'm typing this using the repaired machine on a wi-fi connection).
