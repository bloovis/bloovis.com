---
title: Clonezilla and Windows 7
date: '2023-11-05 04:37:00 +0000'

tags:
- linux
- software
- windows
---

I manage the computers at our local library, and unfortunately, most of
these run Windows -- Windows 7, to be specific.  This operating
system can be terribly slow at times, on our slightly old desktop
computers that use hard disks instead of SSDs.  When booting, it often
takes Windows a minute or two have a fully working desktop, and you
have to watch a spinning hourglass during that time.  Also,
when Windows puts itself to sleep after some idle time, the
wake-up process is so slow and disk-intensive that you might
as well go to lunch while waiting for it.

The big bottleneck here appears to be disk I/O.  So I decided we
needed to upgrade the main computer with an SSD.  This computer boots
Windows 7 by default, but it also has a Linux partition that can be
selected at boot time.  The plan was to use
[Clonezilla](https://clonezilla.org/) to copy the old hard disk to the
SSD.  The SSD would be placed in a USB external drive enclosure during
the clone operation, then swapped with the hard disk inside the
computer.

Clonezilla was easy enough to install on a USB thumb drive.  I
downloaded the [ISO
file](https://clonezilla.org/downloads/download.php?branch=stable),
then used the "USB Image Writer" application in Linux Mint to copy the
ISO onto the thumb drive.  I booted the computer from the thumb
drive, and when Clonezilla reached its first prompt, I plugged
in the SSD (which was now in the USB external enclosure).
I told Clonezilla to do a partition/disk to partition/disk copy.

But then I made a big mistake.  I told Clonezilla to proportionally resize
the partitions on the SSD.  I thought this would be useful,
since the SSD was twice as big as the original hard disk.
But the result was that Windows would not boot, though the Linux
partition did boot correctly.

The fix was to run Clonezilla again, but this time let it copy
the old partition table to the SSD, *without* proportionally
resizing the partitions.  This allowed Windows to boot properly.
At some point, I'll use [gparted](https://gparted.org/)
to increase the partition sizes for both Windows and Linux.
