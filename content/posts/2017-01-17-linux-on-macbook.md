---
title: Linux Mint on a 2008 Macbook
date: '2017-01-17 17:34:00 +0000'

tags:
- linux
- software
- linux mint
- mac
---

I have access to an old (2008) white Macbook that is not being used due to
the age of its operating system.  New versions of Firefox can't be installed
on this machine without an operating system upgrade, and the upgrade path
for old MacBooks doesn't appear to be free or easy.  So I decided to
see if I could install Linux Mint 17 (LTS) on the MacBook.  Supposedly
it was possible, but I wanted to see for myself.

<!--more-->

### Readying Mac OS

The first step in making the MacBook ready was to shrink the existing
Mac OS partition.  First I deleted some extremely large video files,
freeing up about 20 GB of disk space.  Then I ran the Disk Utility,
which you can find under Applications / Utilities in a Finder window.
After I selected the hard disk itself (not the partition labelled "Macintosh HD"),
I selected the Partition tab.  This brought up a graphical representation
of the disk.  Resizing the Macintosh HD partition required grabbing the
lower right corner of its rectangular representation and dragging it upwards.
I left about 30 GB free for Linux; not much for a real installation, but
the most the small hard disk could afford.

After I pressed Apply, Disk Utility spent quite a long time resizing the partition.
My first few attempts failed with an "out of disk space" error.  I was forced
to increase the size of the partition to about twice its actual usage
(that is, the partion was using about 35 GB of space but I was forced to
resize it to 70 GB).  I am not sure why Disk Utility required this wastage,
but perhaps it works by copying files to the unused part of the partition.

In any case, once the Macintosh HD partition was resized, I was able
to create three new partitions: one for swap of about 4 GB, one for
the Linux system (/) of about 10 GB, and one for home directories
(/home) of about 20 GB.  The creation of partitions was a bit tricky
and required manually entering sizes instead of using the mouse drag
technique.  I let the Disk Utility format the new partitions as Mac OS
Extended (the only allowed choice); Linux would reformat those
partitions later.

The final step performed in Mac OS was to install the [rEFInd boot manager](http://www.rodsbooks.com/refind/).
This program recognizes multiple operating system and allows the
user to select the one to boot upon power up.  After I downloaded the rEFInd zip file
to the Desktop, I opened a Terminal (in Applications / Utilities), and ran these commands to install it:

```
cd Desktop
unzip refind-bin-0-10.4.zip
cd refind-bin-0.10.4
./refind-install
```

### Creating a Linux installation USB key

On a Linux Mint 17 system, I created an installation USB key using the
MintStick (USB Image Writer) utility and telling it to use a Mint 17 Mate Edition
ISO that I had previously downloaded.  The utility appeared to hang
for a minute after its progress bar showed that it was 100% complete.
Eventually it responded and reported that it was done, asking me to
hit an OK button to exit.

(Note: It was important to use MintStick instead of Unetbootin, my previous
favorite live USB disk creator.  When I used a USB key created by
Unetbootin on the MacBook, it either didn't boot reliably, or
when it was done installing Mint on the MacBook, it wasn't able
to install a boot loader.  After wasting a day on this problem,
I learned that MintStick was the answer.)

### Installing Linux

I shut down the MacBook completely and inserted the USB key.  Then I held
down the "Option" key while powering on the MacBook.  Eventually an onscreen
selection was presented, allowing me to boot either the hard disk or the 
USB key.  Selecting the USB key brought up the usual Mint GRUB menu,
and hitting Enter booted Mint.  (Running from the USB key on the Mac
seemed much slower than on a ThinkPad, so I had to be patient while waiting
for the system to come up.)

After booting, I ran the Mint installer and answered the usual questions
about the location and keyboard type.  Then I selected "Something Else"
when the installer asked about how to the install and partition the system.
This brought up a partitioning dialog where I could select the partitions
that I had created in MacOS, and tell Linux how they were to be used:

* the 4 GB partition was to be a swap file
* the 10 GB partition was to be formatted as ext4 and mounted as `/`.
* the 20 GB partition was to be formatted as ext4 and mounted as `/home`.

In this same dialog, I also told the installer to put the boot loader
on the 10 GB '/' partition (`/dev/sda4` on my system, but will
probably have a different name on your system).

After I told the installer to go ahead, it began copying files.

(At this point, some users might run into a problem.  By default, the
Linux installation system doesn't have a driver for the Broadcom wi-fi chip
used on MacBooks, so it can't download language pack files after
the main system is installed.  You can skip this step, but it's better
to use an ethernet connection to allow network access.  Most home wi-fi
routers have at least one available ethernet port, so you should
be able to connect the MacBook to the router with an ethernet cable.
The wi-fi problem will be solved after Linux is installed, so
the ethernet workaround is only temporary.)

After Linux is installed, you can reboot the system.  This is best
done by doing a shutdown (Menu / Quit / Shut Down).  Remove the USB
key and power the MacBook back up.  You should see the rEFInd boot menu,
with a row of icons showing the available operating systems.  On my
system, sometimes I see a GRUB menu instead of rEFInd; I'm not sure
how the system determines which one will appear.  In either case,
you'll have the ability to select either Mac OS or Linux Mint for
booting.

### Enabling Wi-Fi

After rebooting into the newly installed Linux Mint, I installed the
Broadcom wi-fi driver.  Mint comes with a Driver Manager tool that can
install the Broadcom driver, but my attempt at using this tool was not
successful: it appeared to hang with the `aptd` program using a fair
amount of CPU (as reported by `top`).

Instead, I was able to install the driver manually from the USB key.
I plugged in the key, and when a window opened showing its contents, I
navigated to `pool/main/b/bcmwl`.  There was one file in that directory,
with a long name starting with `bcmwl-kernel-source`.
Double-clicking on that file brought up GDebi package installer.
It complained that I should be installing the package from other sources,
but I ignored the complaint and told it to proceed.

Once the driver was installed, I had to reboot the system to get the
driver to load and allow wi-fi to be available in the Network Manager.

(There may be a way to load the driver without a reboot, but I wasn't
able to figure it out, and my attempts to do a `modprobe wl` resulted
in `dmesg` reporting something about the driver tainting the kernel.
So the reboot seemed to be the simplest answer.)

### System update

Once Mint was installed, I did a full update to ensure that the latest
security patches and fixes were present.  I did this by clicking on
the Update Manager icon on the lower right side of the screen (it
looks like a lower case "i" in a shield when there are updates
available).  The full update took about 15 minutes on my very slow DSL
connection.


### Trackpad issues

One thing that I find annoying about Linux on this particular MacBook is the lack
of a middle mouse button.  This button is useful in the cut-and-paste shortcut
that is unique to X Windows based systems like Linux: after selecting some text,
pressing the middle mouse button pastes the text.  The Mouse preference dialog
in the Control Center allows you to enable taps on the mouse pad,
and apparently a tap with two fingers is interpreted as a right button
click.  But I could not get a middle button click out of the trackpad despite
enabling its emulation with a three-finger tap; perhaps the trackpad
on this old MacBook doesn't support that gesture.
