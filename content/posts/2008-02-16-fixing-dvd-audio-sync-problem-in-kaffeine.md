---
title: Fixing DVD audio sync problem in Kaffeine
date: '2008-02-16 20:13:37 +0000'

tags:
- linux
- mepis
- pclinuxos
- software
---
Both PCLinuxOS 2006 and Mepis 6.5 come with a wonderful media player called Kaffeine.  I especially like being able to customize the toolbars.  I've added buttons to go backwards and forwards by 20 seconds, which is great for those times when you miss some important bit of dialog.

But Kaffeine, as shipped with these two older versions of Linux, has a serious problem when viewing DVDs: the sound is not synchronized with the video, and appears to be off by as much as a quarter of a second.  There is a control for adjusting the sync, but it's difficult to get just right and it requires fiddling with each new DVD.

After the usual poking about with Google, I discovered that the problem is due to a bug in the underlying video engine, Xine, and in particular, a library called libxine.  The bug was present in version 1.14 of the library as shipped with these two distros, and fixed in version 1.16.  So the solution was to download the source for the library and build it myself.

I found the source for libxine on the [xine download page](http://xinehq.de/index.php/download).  The file I downloaded, `xine-lib-1.1.4.tar.bz2`, is no longer available, but I would guess that later versions would also work.  The numbering scheme is confusing; version 1.1.4 of the source is used to build version 1.16 of the binary library.

Once I had the source code, I unpacked it and built and installed the library using the following commands:
```
tar xvfj xine-lib-1.1.4.tar.bz2
cd xine-lib-1.1.4
./configure --prefix=/usr
make
make install # run this as root```
After that, the audio sync problem was gone.

On both of these systems, I had to install some X11 development packages (header files and libraries) before libxine would build.  I have forgotten exactly which packages these were, but clues can be gotten by looking at the compiler error messages, and seeing which header files are missing.  I installed these extra packages from synaptic, the standard package management program on both systems.
