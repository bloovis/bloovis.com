---
title: Linux on Lenovo Ideapad 3
date: '2021-02-10 20:14:00 +0000'

tags:
- linux
- software
- linux mint
- ubuntu
- windows
---

I was asked to install Linux alongside Windows 10 on a new Lenovo Ideapad 3.
There were several problems to solve: getting Windows setup to not require a Microsoft
account, fixing the boot-related options in the BIOS,
finding a working version of Linux Mint, and getting the touchpad to work.

<!--more-->

The Ideapad 3 is another modern laptop that is crippled by the lack of
an ethernet port.  This forced me to enable wi-fi on my home router so
that I could have a network connection during the installation of both
Windows and Linux.  (Another option would have been to use a USB-to-ethernet
adapter.)

But having a network available is actually a problem during the initial
setup of Windows.  After you tell the setup program about your network,
it asks you to log in with a Microsoft
account, and hitting the back button doesn't help.  The solution is
to disable wi-fi in your router, then hit the back button.  Then
setup will skip the Microsoft account login screen.

The next problem to solve is teaching the BIOS to boot from a USB
stick containing a live Linux distribution.  On the Ideapad, the
way to do this is not quite obvious.  Power off the machine,
plug in the USB stick, then power on the machine and enter the BIOS
by hitting F2 when the Lenovo logo appears on the screen.
In the BIOS security settings, disable Secure Boot.  Then in the
Boot page, enable Legacy Mode and move the USB stick up to the
top of the boot order.  Then hit F10 to save the new settings, and
the machine should boot from the USB stick.  Apparently you have
to change the boot order in the BIOS every time you want to boot from a USB stick,
because the setting doesn't seem to survive a power cycle or
a removal of the stick.

At first I tried booting Linux Mint 19 (Mate edition) from the USB stick.  But it
was extremely slow, taking many seconds to draw anything
on the screen or respond to a keystroke.  The touchpad didn't work, either,
so I had to shut down the machine using the keyboard (Ctrl-Alt-Del, then Alt-S).

I then tried booting Linux Mint 20 (Mate again).  This worked much better, and
there were no performance problems.  But the touchpad still didn't
work.  I found a number of solutions on the web, some of which
were very complicated (building a new kernel, or setting up a systemd service
to blacklist a certain touchpad driver).  The simple solution that finally worked
for me is described in this video (*update*: video is no longer available):

{{< youtube ZFs8rsTVLtc >}}

To save you the time needed to watch the maker of this video slowly type
commands, here's what you need to do:

First, in order to test whether the solution will actually work,
reboot from the USB stick, and when the Grub menu appears, hit the 'e'
key to edit the kernel command line.  Use the cursor keys to move
to a point after the `splash` parameter, and enter the parameters
`i8042.nopnp=1 pci=nocrs`.  Then hit F10 to boot Linux.

Assuming that this fix worked, go ahead and install Linux Mint
alongside Windows.  Reboot the machine, removing the USB stick when prompted.  When the
Grub menu appears, apply the temporary fix again as described above,
so that the touchpad will work on the new installation.

After Linux boots you'll
need to make the touchpad fix permanent.  Edit the file `/etc/default/grub` using
sudo and an editor (e.g., `sudo nano /etc/default/grub`).  Find the
line that looks like this:

```
GRUB_CMDLINE_LINUX=""
```

and change it to look like this:

```
GRUB_CMDLINE_LINUX="i8042.nopnp=1 pci=nocrs"
```

Save the file and exit the editor.  Then run `sudo update-grub` to install the
change permanently.
