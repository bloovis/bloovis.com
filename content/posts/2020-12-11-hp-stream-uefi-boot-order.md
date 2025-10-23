---
title: Fixing UEFI boot order on HP Stream 14
date: '2020-12-11 08:51:00 +0000'

tags:
- linux
- software
- linux mint
- ubuntu
- windows
---

I'm in the process of installing Linux Mint 19 on our little library's
several Windows computers.  The latest candidate was an HP Stream 14,
a small, lightweight laptop that is crippled in various ways, so I
wouldn't recommended it except as a cheap toy.
I was finally able to get Mint and Windows 10 to dual-boot successfully,
but it took a day's worth of internet searching combined with lots of
trial and error.
<!--more-->

The Stream 14 is crippled in these ways:

* It is missing an ethernet port, which is a problem if you care about the lack of security in wi-fi.
* It has an SSD, but its capacity is very small: 60 GB, 41 GB of which is taken up by Windows 10 (but see the note at the end of this post).
* Its BIOS does not let you change the UEFI boot order, forcing Windows to boot by default.

The last of these problems is the most serious of the three;
fortunately there is a solution, described below.  But the first step
was to install Mint.  In order to do that, I had to enter the BIOS at
startup by hitting the Esc key rapidly until a simple menu was
displayed, then hitting F10 entered the BIOS.  In the boot options, I
disabled Secure Boot, enabled Legacy Support, and moved the USB Hard
Disk up to the top of the boot order.  Then I was able to boot Mint
from a USB stick.

The installation of Mint went successfully, but upon restarting the system,
the Grub menu did not appear.  Instead, the system booted straight into Windows 10.
I was able to boot Mint by the usual frantic pressing of the Esc key on power-up,
hitting F9 to get to a UEFI boot menu, and then selecting "ubuntu", which was
the second item on this menu.

I then tried restarting the computer and entering the BIOS to see if I could
change the UEFI boot order.  The BIOS tricks you into thinking you can do this
if you select "OS Boot Manager" in the boot order options.  This
displays the same two options that you see in the Esc-F9 startup boot options:
Windows and Ubuntu.  But it's not possible to move Ubuntu to the top of the list.

The HP support forums were useless in solving this problem.  Apparently
the HP employees answering the questions in those forums are trained
monkeys working from scripts, and do not actually understand how their
computers work.

I found the solution in the first answer to [this forum post](https://askubuntu.com/questions/244261/how-do-i-get-my-hp-laptop-to-boot-into-grub-from-my-new-efi-file).
The solution was to boot Linux and overwrite Microsoft's UEFI boot loader with the Ubuntu one.
I did this using these commands as root:

```
cd /boot/efi/EFI
cp Microsoft/Boot/bootmgfw.efi Microsoft/bootmgfw.efi
cp ubuntu/grubx64.efi Microsoft/Boot/bootmgfw.efi
```

After running `update-grub`, the Grub menu now appeared upon restarting the laptop.  But then
Windows would not boot; when the Windows option was selected in the Grub menu,
the Grub menu simply reappeared.  The solution for this was described in an answer
to the aforementioned forum post.

First, copy the Windows-specific menuentry in `/boot/grub/grub.cfg` and append it to the file
`/etc/grub.d/40_custom`.  Edit the `chainloader` path so that it
looks like `/EFI/Microsoft/bootmgfw.efi` (i.e., delete the `Boot/` segment of the path).
Change the label for the entry to something like 'Windows 10 Hack', to distinguish
it from the existing Windows entry.  Finally, run `update-grub`.

If you update Windows 10 later, you will need to repeat the three commands
shown above for overwriting Microsoft's UEFI boot loader.

{{< callout type="info" >}}
It turns out that the large amount of space used by Windows on this
particular machine was due to the presence of Faronics Deep Freeze.  This is a terrible
piece of software that attempts to provide some kind of protection from system-level
changes on Windows.  It slowed down the machine so much as to make it nearly
unusable.  Once I uninstalled Deep Freeze (a non-trivial task), I found it had
left a 19 GB file in the Windows root directory called `persis0.dsk`.  Windows
would not let me delete this file, because it was being used by `svchost.exe`.
I was forced to use Linux to delete the file.
{{< /callout >}}
