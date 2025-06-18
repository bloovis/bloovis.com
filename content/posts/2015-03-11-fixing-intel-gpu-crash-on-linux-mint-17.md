---
title: Fixing Intel GPU crash on Linux Mint 17
date: '2015-03-11 16:09:03 +0000'

tags:
- linux
- linux mint
- thinkpad
- ubuntu
---
The older ThinkPad I'm using now has an Intel 965 graphics processor,
and is running Linux Mint 17.1.  Today I decided to try installing
Google Chrome because of a Firefox problem I was having with a
particular web site's buggy Javascript.  When I visited the Chrome
site, the screen went black. <!--more--> The system still seemed to be
responsive, and I was able to reboot it using Ctrl-Alt-Del (which
brings up a shutdown dialog) and Alt-S (which selects Shut Down). 

After rebooting, I took a look at `/var/log/syslog``` and saw that there had been a GPU hang.  Some web searching led me to a [known bug](https://bugs.freedesktop.org/show_bug.cgi?id=80568) that described the problem and some workarounds.  I pieced together the solution from several comments on the bug: it involves installing a 3.19 Ubuntu kernel and a cutting edge X server.

First, fetch and install a recent kernel (note that the wget commands are split into two lines for clarity):

```
mkdir /tmp/kernel
cd /tmp/kernel

wget http://kernel.ubuntu.com/~kernel-ppa/mainline/v3.19.3-vivid/\
linux-headers-3.19.3-031903-generic_3.19.3-031903.201503261036_amd64.deb
wget http://kernel.ubuntu.com/~kernel-ppa/mainline/v3.19.3-vivid/
linux-headers-3.19.3-031903_3.19.3-031903.201503261036_all.deb
wget http://kernel.ubuntu.com/~kernel-ppa/mainline/v3.19.3-vivid/\
linux-image-3.19.3-031903-generic_3.19.3-031903.201503261036_amd64.deb

sudo dpkg -i linux-image*
sudo dpkg -i linux-headers*
```

Then install the cutting edge X server:

```
sudo apt-add-repository ppa:xorg-edgers/ppa
sudo apt-get update
sudo apt-get dist-upgrade
```

Finally, reboot the system and verify that you are running kernel 3.19 and Mesa 10.6:

```
uname -r
dpkg -l libgl1-mesa-dri
```

After this, visiting the Chrome site should not cause the screen to go black.
