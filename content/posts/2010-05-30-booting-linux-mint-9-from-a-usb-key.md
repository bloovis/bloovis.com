---
title: Booting Linux Mint 9 from a USB key
date: '2010-05-30 23:39:24 +0000'

tags:
- linux
- linux mint
- ubuntu
---
I just spent many hours getting a 4GB USB key into a state where it can be used to boot Linux Mint 9 (based on Ubuntu 10.04).  Here are some notes on the problems I had to solve.

In the past, I've used [unetbootin](http://unetbootin.sourceforge.net/) to create bootable USB keys.  When I did this with the Linux Mint 9 ISO image, the resulting USB key booted up just fine, but the installer application hung when trying to run the partition editor.  I narrowed this down to an assertion failure in libparted.  Apparently it doesn't like the geometry on some USB keys.  This is a [known bug](https://bugs.launchpad.net/ubuntu/+source/gparted/+bug/545911).

Fortunately, the ThinkPad R61 has a CD drive, so I created a CD from the ISO image and booted that.  Then after installing Mint 9 on the hard disk and booting that, I was able to create a bootable USB key that didn't crap out in the installer.  I did this by using Mint 9's built-in Startup Disk Creator, which is in the main Menu under Administration.  I told it to erase the entire USB key, which apparently reconfigured its partition table into a form that libparted liked.  I verified this by rebooting the R61 with the USB key and running gparted.

The next set of problems came when I tried booting an older ThinkPad R50p with the USB key.  As in all recent ThinkPads, you can choose the boot device by pressing the blue ThinkVantage or Access IBM button at startup, then pressing F12.  But on the R50p, the USB key wasn't shown as a boot device.  I ran Setup (IBM's term for BIOS configuration), and in the Startup screen I tried to enable the USB HDD device.  This didn't work; the machine just beeped at me.  After a long bout of head-scratching, I finally figured out that Setup doesn't allow more than eight boot devices to be enabled.  I disabled a couple of useless boot devices (e.g., HDD1 and USB Floppy), and then I could enable the USB key.

Finally the USB key would start to boot on the R50p.  But after the Linux Mint logo came up, the machine hung with the hard disk light on solid.  I rebooted from the USB key and selected the recovery mode boot option in Grub (I forget the exact name for it).  Then I was able to see the last error message at the hang.  It was an I/O error accessing the fd0 device, which is the floppy.  More headscratching and Google searching revealed that I needed to disable the floppy device in Setup.

Now I was able to get past the hang on booting from the USB key, but then X refused to run, displaying a dialog box saying that it was going to run in low graphics mode.  This turned out to be a problem with the kernel mode setting (KMS) feature of recent Ubuntu releases.  Apparently this is a very bleeding-edge method of determining graphics card type, and it doesn't appear to work on older machines.  The fix was to provide the **nomodeset** kernel parameter when booting.  I did this by hitting Enter when the Grub menu came up, then hitting Enter again to edit the kernel command line.  I add the nomodeset parameter and pressed Enter a couple of more times to boot.  This time the system was able to boot to a good desktop, though the Mint logo didn't appear during the early boot stages.
