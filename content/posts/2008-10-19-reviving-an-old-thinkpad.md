---
title: Reviving an old ThinkPad with TinyMe 2008
date: '2008-10-19 14:54:58 +0000'

tags:
- linux
- pclinuxos
- software
- thinkpad
---
I bought my first ThinkPad nine years ago, and now have five of them.  Two of them (an A30p and a T40) are hopelessly broken, with system boards that either won't power up or won't stay powered up.  The others are working pretty well, including the oldest one, a model called the 380Z, which despite the name, has no relation to Datsun sports cars.

The 380Z served me well for a couple of years.  It was running Mandrake Linux practically from day one, and was a reliable, non-sleek tank.  Recently I thought it might be fun to update it to a more recent Linux.  But its specs are quite modest by today's standards.  Its power is about 1/10th that of a modern laptop in just about every area: 96 MB of RAM, a 233 MHz Pentium II processor, and a 4 GB hard disk.  Nothing could be done about the RAM, and that's the biggest problem, because most Linux GUIs these days (KDE being my favorite) require about 256 MB at a minimum if you want some memory left over for running a browser.  The hard disk problem solved itself: when I powered the machine on yesterday for the first time in a year, the disk made terrible clunking and seeking noises and the BIOS reported it as dead.  So I swapped in an 80 GB disk from the dead T40.

Now at least the machine could boot and presumably take a new OS installation.  But what to install?  I am a fan of [PCLinuxOS](http://pclinuxos.com/), but it's a bit on the heavy side for such a lightweight machine.  So I tried a cut-down version of this OS called [TinyMe 2008](http://tinymelinux.com/doku.php/).  This distro replaces the lovely but somewhat porky KDE GUI with a lightweight GUI based on various minimalist components (Openbox, LXPanel, Nitrogen, and iDesk).

I ran into a serious problem during installation having to do with the limited RAM on the 380Z.  If a swap partition was not already available on the hard disk, then the live CD installer would eventually crash, apparently due to running out of RAM.  My solution was to create a swap partition manually, enable it, and patch the installer so that it wouldn't die when attempting to mount or unmount the swap partition.

The first step was to create the swap partition.  This was accomplished by running the installer, and telling it to use the entire disk.  The installer created three partitions, one of which was a swap, and then asked me to reboot the system.  I did that, and when the login screen came up, I switched to a text console using Ctrl-Alt-F1, and logged in as root.  I formatted and enabled the swap partition using `mkswap /dev/hda5` and `swapon -a`.  Then I switched back to the login screen using Ctrl-Alt-F7.

After logging in as root in the GUI, I launched a terminal (called Sakura) and edited two of the installer Perl scripts so that it wouldn't die trying to mount or unmount the swap partition.

*   `/usr/lib/libDrakX/fs/mount.pm`: I edited the two lines containing `syscall_('swapon',...)` and `syscall_('swapoff',...)`, changing the `die` calls to `print`.
* `/usr/lib/libDrakX/draklive-install`: I commented out the line containing `fs::mount::swapoff` by prefixing it with a # character.

After these changes, the installer completed successfully without aborting or crashing the system.  The resulting installation is a minimal Linux system that uses Opera as its web browser.  This is certainly a decent alternative to Firefox, but I do miss the AdBlock Plus extension that makes browsing commercial, ad-laden sites more pleasant.  The Orinoco-based wifi card (a Dell TrueMobile 1150 PCMCIA card) is supported and works perfectly with WEP (but probably won't work with WPA, if past experience can be trusted).

The main post-installation problem was that sound didn't work.  The 380Z has an old Plug-And-Play Crystal Sound 423x device that pre-dates PCI.  After a day of Google searching and experimentation, I determined that the ALSA driver (snd-cs4232) would not work, and that I needed to use the older OSS driver (cs4232).  I edited `/etc/modprobe.d/sound` to look like this:
```
alias snd-card-0 cs4232 
alias sound-slot-0 cs4232 
options cs4232 io=530 irq=5 dma=0 dma2=0```
I verified these settings by running the ThinkPad's DOS-based configuration utility, PS2.EXE.  I also found it necessary to run `aumix` after booting to bring up the speaker and PCM levels to audibility.

Another problem with the installation is that graphics acceleration was not enabled; this was very apparent when scrolling or moving windows.  The solution was to run the PCLinuxOS Control Center, select "Hardware" and "Set up the graphical server", and change the resolution bit depth from 24 bits to 16 bits.  This is apparently required to work around a limitation of the NeoMagic graphics chip in the 380Z.
