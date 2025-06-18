---
title: Fixing unresponsive wifi on ThinkPad X200s running Linux Mint 13
date: '2013-04-19 16:28:27 +0000'

tags:
- linux
- linux mint
- thinkpad
- ubuntu
---
I upgraded the OS on a ThinkPad X200s from Linux Mint 10 to Linux Mint 13 (which is based on Ubuntu 12.04), and noticed that the wifi adapter no longer worked properly.  It was able to obtain an IP address from a router, but attempts to send or receive data failed.  This problem, as usual, is discussed on [various](http://ubuntuforums.org/showthread.php?t=1978457) [forums](https://bugzilla.redhat.com/show_bug.cgi?id=785239), and is due to a bug in Intel's wifi driver.

To determine whether the machine uses the buggy Intel driver, do this in a terminal session:

```
lsmod | grep iwlwifi
```

The temporary fix, which will not survive a reboot, is:

<pre class="brush: plain">sudo rmmod iwlwifi
sudo modprobe iwlwifi 11n_disable=1
</pre>

If that works, apply the permanent solution.  Become root with `sudo su`.  Create the file `/etc/modprobe.d/iwlwifi-disable11n.conf` with the following one-line contents: 

```
options iwlwifi 11n_disable=1
```
