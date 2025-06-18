---
title: Solving pilot-xfer sync problem on Ubuntu Jaunty / Linux Mint 7
date: '2010-03-19 13:25:03 +0000'

tags:
- centro
- linux
- linux mint
- software
- treo
- ubuntu
---
I use pilot-xfer (part of the pilot-link package) to back up the data on my Palm Centro, and occasionally to install files on the Centro.  It's always worked fine on Linux Mint 6.  The only thing I needed to do before running pilot-xfer was load the visor kernel module using this command:

```
sudo modprobe visor
```

But when I switched to a different laptop running Linux Mint 7, pilot-xfer never seemed to be able to connect with the Centro for the second and subsequent attempts after a reboot.  Some poking around revealed that the problem is apparently due to the visor module setting up an incorrect symbolic link for the device `/dev/pilot`.  Normally, after you connect the Centro to the computer with a USB cable and press the hotsync button, `/dev/pilot` should become a symlink that points to `ttyUSB1`.  But I was seeing it point to `ttyUSB0`, which is the wrong device file for the Centro.

I couldn't find an elegant way to fix the problem, so I was forced to come up with a brute force method: before connecting the Centro with the USB cable, remove the visor module and the device symlink:

```
sudo rmmod visor
sudo rm /dev/pilot
```

Then after connecting the Centro, load the visor module again:

```
sudo modprobe visor
```

Note 1: Immediately after you load the visor module, `/dev/pilot` will point to `ttyUSB0`.  That's OK.  After you press the hotsync button, the visor module should change the symlink to point to `ttyUSB1`.  If it doesn't, you'll have to use the brute force "unplug and unload" method I described above.

Note 2: You should always press the hotsync button on the Centro *before* running pilot-xfer.

Note 3: You can eliminate the need to use the -p option with pilot-xfer by setting the environment variable PILOTPORT to `/dev/pilot`.  Putting this line in your `~/.bashrc` (if your shell is bash) will do the trick:

```
export PILOTPORT=/dev/pilot
```
