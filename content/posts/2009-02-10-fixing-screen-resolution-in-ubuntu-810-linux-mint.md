---
title: Fixing screen resolution in Linux Mint 6 / Ubuntu 8.10
date: '2009-02-10 05:46:12 +0000'

tags:
- linux
- linux mint
- ubuntu
---
I installed Linux Mint on my parents' computer today, replacing Mandrake 10.2.  (Yes, grandparents can use Linux.)  This older computer has a motherboard with a built-in VGA adapter by Trident, connected to an ancient CRT display with a maximum resolution of 1024x768.  But for some reason, Linux Mint set the resolution to 800x600, and the Screen Resolution tool in the Control Center would not allow it to be set higher.

After some Google searching, I came across some Ubuntu forum posts that suggested various fixes that did not work, or which required programs that were not available on the live CD.  Finally, the thing that worked was quite simple: I edited `/etc/X11/xorg.conf`, and in the "Monitor" section added the following line:

```

After restarting X with Ctrl-Alt-Backspace and logging back in, the Screen Resolution tool now showed a number of newly available screen resolutions, including the desired 1024x768.  Apparently, the Trident display driver (or some other piece of X) wasn't able to detect the monitor capabilities automatically (perhaps due to the monitor's extreme antiquity), and the new line in `xorg.conf` provided just enough of the required information.
