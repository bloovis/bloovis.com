---
title: ThinkPad Reliability
date: '2008-02-16 16:28:28 +0000'

tags:
- hardware
- linux
- thinkpad
---
(Note: What follows is purely anecdotal, personal experience.  Don't draw any hard-and-fast conclusions.)

I own four IBM ThinkPads now:

* 380Z: 233 MHz, 96 MB RAM, 4GB disk, 1024x768 screen.  Purchased used in 1999.
* A21m: 750 MHz, 512 MB RAM, 40GB disk, 1024x768 screen.  Purchased new in 2001.
* A30p: 1.2 GHz, 512 MB RAM, 60GB disk, incredible 1600x1200 screen. Purchased used in 2005.
* T40: 1.6 GHz, 1GB RAM, 80GB disk, 1400x1050 screen. Castoff from son, received in 2006.

The two older machines have been very reliable.  The only problem I've had with them was that the disk in the A21m got very noisy after a couple of years, and I replaced it to keep my sanity.  The A21m still runs a relatively recent Linux (PCLinuxOS 2006) quite nicely, and I still use it to watch DVDs and as my emergency backup machine when the T40 is being flaky (see below).  The 380Z is too old to run anything other than Damn Small Linux.

The two newer machines have been much more problematic.

After a year or so, the hard disk in the A30p started reporting errors when it warmed up; I replaced the disk and all was well.  A few months later, the A30p would no longer charge its battery.  A replacement battery didn't help.  A couple of months later the machine started powering off after 15 minutes of use, and soon afterwards refused to power on at all.  A local laptop  repair service was unable to fix the problem.  Earlier this week I ordered a cheap replacement motherboard of unknown condition from an eBay store; I'll report back when I've installed it.

The T40 is my daily use machine, but its hardware is frustratingly flaky.  My son warned me that the machine crashed under Windows XP doing heavy video work, and that the Atheros wireless card was flaky.  He was right, and the machine has the same problems on Linux.  When watching DVDs or big Flash videos, the screen will go blank and the machine will lock up and refuse to reboot until it's cooled down for a few minutes.  The problem is worse when the machine is hot; I was able to get it crash by doing a kernel compile in a terminal window while scrolling in Firefox.

I poked about on the web and found discussions in which other T4x owners complained about exactly the same problem.  It seems that the BGA mounting method used to solder the video chip to the motherboard is not reliable on these machines, and the chip contacts fail when the machine heats up or is flexed.  Because the problem seems to be inherent in the design of the T4x series, I have decided not to go to the trouble of taking it in for repair or replacing the motherboard, which could be quite costly.

The Atheros wireless card in the T40 is unreliable as well.  After some amount of time, it will drop the connection and I'll have to restart it manually.  It's unpredictable but seems worse when it's warm.

The T40 is a lovely machine.  It's fairly powerful and lightweight, and it runs Linux beautifully, but I need something that can be used as a desktop replacement machine for all purposes, not just a portable email device.  If I can't get the A30p with its wonderful display working again, I'll start looking for a replacement for the T40.  In the meantime, the good old A21m will provide service where the T40 falls down.
