---
title: Linux Mint 19 on HP Notebook 17z-ca000
date: '2020-05-27 08:51:00 +0000'

tags:
- linux
- software
- linux mint
- ubuntu
---

I was asked to install Linux on four newish HP notebooks with 17 inch screens.
These machines came with Windows 10, so it was necessary to do a dual-boot
installation.  The three major problems with these HP machines were:

* getting the machine to boot from a Linux Mint bootable USB thumb drive
* a Realtek wi-fi device whose driver was not built into the Linux kernel
* Secure Boot preventing the Realtek driver from loading

<!--more-->

In order to boot from a USB device on the HP, it was necessary to change
the boot order in the BIOS.  Pressing F10 after power-on will enter
the BIOS, and from there you can navigate to "System Configuration',
and then to "Boot Options", where you can change the boot order.  I put the "USB Disk"
device at the top of the boot list for both UEFI and Legacy, just to
be safe.

After installing Linux Mint side by side with Windows (using ethernet as the
network device), I found that
there was no wi-fi device available.  The HP uses a wi-fi device by
Realtek whose driver is not built into the kernel.  Fortunately, Mint
has a device driver management tool that uses DKMS (dynamic kernel
module support) to build and install such device drivers.  When I ran
this tool on the HP, it reported that there was a Realtek RTL8821ce
device driver that could be installed.  I told it to install the
driver, and it managed to complete the compilation of the driver
module, but reported a failure when trying to load the module.

When I manually tried to load the module using `modprobe rtl8821ce`,
modprobe printed an error message about "required key not available".
This error is due to the machine's use of the so-called "Secure Boot"
feature.  The solution I chose was to disable Secure Boot, which I did
by booting back into the BIOS, as described above.  In the boot
options, I enabled "Legacy Support", which also disabled "Secure Boot".
After that, Linux was able to load the Realtek driver automatically.
Windows continued to load successfully after this change, despite the
BIOS warning me that it might fail.
