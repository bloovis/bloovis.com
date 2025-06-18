---
title: Using a Linux laptop as a router
date: '2014-10-14 14:06:59 +0000'

tags:
- android
- linux
- linux mint
- ubuntu
---

Despite the governor's promise that every house in Vermont would have
broadband by the end of 2013, our little rural village still has
nothing besides satellite and very flaky cell service.  Consequently,
we have been using an Android cell phone (a Nexus One) as our internet
connection for the last couple of years. <!--more--> Because the cell signal is
so weak here, the phone sits in a Wilson Electronics "Sleek", which is
a cradle that acts as a signal amplifier.  The Sleek is connected by a
20 foot coax cable to an exterior antenna, a Wilson Electronics 301141
Outdoor SignalBoost mounted to the side of the house facing the
nearest cell tower.  This combination brings the signal strength up to
a level where a 3G connection can be made.  The limiting factor is the
reliability of the AT&T service, which is extremely poor during
daylight hours.  AT&T's network appears to be severely overloaded,
probably due to the huge number of people addicted to their iPhones
and Facebook.  At night the service is usable, and that's when we try
to use the internet most.

The Nexus One works fine as a wifi router, but it would be nice to
eliminate the use of wifi in the house entirely, and switch to a wired
(ethernet) network, for various reasons, including security and
reliability.  But this would require that the Nexus One be tethered to
some device using a USB cable.  This works fine with a laptop running
Linux, but not with the rather old LinkSys WRT54GL router we have
lying around.

So the obvious answer is: use the laptop (running Linux Mint 17) as a
router, bridging its ethernet port with the USB-tethered Nexus One.
After some web searching for "Linux router" and head-scratching over
some rather complicated solutions using scripts that configure IP
tables, a dead-simple solution popped up.  It turns out that Network
Manager, the default network configuration tool in Linux Mint, has a
way to share a network connection with other computers.  Edit the
desired connection (a wired ethernet connection in my case), and in
the IPV4 tab, set the Method dropdown to "Shared to other computers."
This turns the ethernet port into a NAT/DHCP router.  I tested it by
connecting a second laptop (also running Linux Mint 17) with a
crossover ethernet cable, and it successfully obtained an IP address
from the first laptop.  Now both computers are using the tethered
Nexus One as their internet connection to the outside world.

The next step will be to add a switch and some ethernet cabling so
that the network can reach a laptop and printer on the other side of
the house from the Nexus One and its booster cradle. 
