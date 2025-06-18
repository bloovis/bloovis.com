---
title: Fixing jerky video in DVDs
date: '2008-03-01 02:04:00 +0000'

tags:
- linux
- mepis
- pclinuxos
- software
---
On my ThinkPad A30p, watching a DVD with Kaffeine often results in very uneven, jerky video.  This has been a problem with both PCLinuxOS 2007 and Mepis 6.5.  The cause appears to be an obscure kernel bug that disables DMA on the CD-ROM drive.  The fix is to run the following command as root after Kaffeine has started:

    hdparm -d1 /dev/cdrom

It doesn't work to enable DMA before starting Kaffeine (it's enabled by default when the system boots).  It has to be done after Kaffeine has opened the DVD and started to display its menus, and it has to be done with each new DVD.  It's not a big nuisance, but you can create an icon on the desktop to make it a little easier:

* As root, edit `/etc/sudoers` and add a line like the following:

    `bloovis    localhost = NOPASSWD: /sbin/hdparm`

  Be sure to change `bloovis` to your actual user name.

* Create a desktop "link to application", where the command to run is:

    `sudo hdparm -d1 /dev/cdrom`

Curiously, this problem doesn't occur on my other Thinkpads (A21m, T40) even when running the same versions of Linux.
