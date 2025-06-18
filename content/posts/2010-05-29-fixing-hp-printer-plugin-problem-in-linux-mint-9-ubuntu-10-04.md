---
title: Fixing HP printer plugin problem in Linux Mint 9 / Ubuntu 10.04
date: '2010-05-29 19:50:33 +0000'

tags:
- linux
- linux mint
- thinkpad
- ubuntu
- printers
---
I upgraded one of my ThinkPads from Linux Mint 7 to Linux Mint 9 today, and discovered that I was no longer able to use my HP P1006 printer.  The HP printer tool (hp-toolbox) detected the printer correctly, downloaded the appropriate plugin, but then couldn't install the plugin.  Running the tool from the command line didn't give any extra information.  This is a [known bug](https://bugs.launchpad.net/ubuntu/+source/hplip/+bug/546809) in Ubuntu 10.04.

The solution is to download and build the HP printer package (known as hplip) from source.  The complete instructions are [here](http://hplipopensource.com/hplip-web/install/manual/distros/ubuntu.html).  I had to install the following extra packages before the configure and make steps would succeed: libjpeg-dev, libsnmp-dev, libcups2-dev, libusb-dev, python-dev, libsane-dev, and libcupsimage2-dev.
