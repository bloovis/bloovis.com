---
title: Disabling multiple downloads in apt
date: '2016-02-06 08:16:00 +0000'

tags:
- linux
- linux mint
- ubuntu
---
The apt-based package managers and update managers in Ubuntu and Linux Mint will open multiple connections
to repository servers in order to download several packages simultaneously.  Unfortunately, the multiple connections
cause our old DSL modem (a Westell 6100) to hang.  At a former workplace, similar problems
occurred with the corporate firewall.
<!--more-->

The fix is decribed in [this post](http://askubuntu.com/questions/88731/can-the-update-manager-download-only-a-single-package-at-a-time).
As root, create the file `/etc/apt/apt.conf.d/75download` with the following single line:

```
Acquire::Queue-Mode "access";
```

Then the package managers will attempt to download only one file at a
time, reducing the stress on the DSL modem.  The downside is that
downloads will be slightly slower, but since our DSL connection is
already quite slow, this is barely noticeable, and certainly preferable
to constantly having to reset the modem during software updates.
