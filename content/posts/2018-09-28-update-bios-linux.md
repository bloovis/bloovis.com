---
title: Updating ThinkPad BIOS from Linux
date: '2018-09-28 11:42:00 +0000'

tags:
- linux
- thinkpad
- software
- linux mint
- ubuntu
---

Updating a ThinkPad BIOS usually involves booting a floppy or CD-ROM
containing PC-DOS and an update program, or running a Windows-only
updater.  Neither of these is an option on a machine like my
ThinkPad X200s, which has no floppy or CD drives, and is running
Linux only.

The various options available to Linux users 
are discussed in the [ThinkWiki BIOS upgrade page](https://www.thinkwiki.org/wiki/BIOS_Upgrade).
The one option that worked for me in the X200s case is
to [boot the CD-based updater using Grub2](https://www.thinkwiki.org/wiki/BIOS_Upgrade#GRUB2:_booting_CD_Image).

First, I downloaded the latest CD-based BIOS updater from the link
on the [ThinkWiki BIOS Upgrade Downloads page](https://www.thinkwiki.org/wiki/BIOS_Upgrade_Downloads).
In the case of the X200s, the bootable CD updater file was called `6duj48us.iso`
and was found [here](https://download.lenovo.com/ibmdl/pub/pc/pccbbs/mobiles/6duj48us.iso).

Then I logged in as root (using `sudo su`) and performed the following steps:

    apt-get install grub-imageboot
    cp 6duj48us.iso /boot/images
    update-grub

After rebooting, I realized that I needed to force the Grub menu to appear at boot time.  (The menu
was invisible because this machine had no other operating systems
when I installed Mint.  If your machine dual boots Windows and Linux with Grub, you
should not have to perform these steps.)  As root, I edited the file `/etc/default/grub`,
and commented out the line containing `GRUB_HIDDEN_TIMEOUT` so that it looked
like this:

    #GRUB_HIDDEN_TIMEOUT=0

Finally, I ran `update-grub` and rebooted.  This time the Grub menu appeared,
and I was able to select `6duj48us.iso` for booting.
