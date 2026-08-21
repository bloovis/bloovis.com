---
title: Calibre and MTP vs. KDE
date: '2026-08-21'
comments: false
tags:
- linux
- software
---

[Calibre](https://calibre-ebook.com/) is a feature-rich ebook manager
that can connect to many different kinds of ebook readers,
including Android devices that use
[MTP](https://en.wikipedia.org/wiki/Media_Transfer_Protocol) for file access.
I recently ran into a problem where KDE locks an MTP device and prevents Calibre from using it.

<!--more-->

The first time you connect an MTP ebook device when Calibre is running, it will recognize
the device and ask if you want Calibre to manage it.  That all works very nicely.

The problem comes in if you use Dolphin, the KDE file manager, to access files on that device.
After that, Calibre will not be able to detect or use the device.
The problem and a workaround are mentioned
[here](https://discussion.fedoraproject.org/t/how-to-tell-kde-to-release-an-mtp-device/69037).

First, verify the problem by using the `mtp-detect` command.  It will issue the following error message:

```
libusb_claim_interface() reports device is busy, likely in use by GVFS or KDE MTP device handling alreadyLIBMTP PANIC: Unable to initialize device
```

The temporary fix is stop the `kiod` process (which could be named `kiod5` or `kiod6`) by running this command:

```
systemctl --user stop dbus-:1.2-org.kde.kmtpd5@0.service
```

The exact name of the service may be different.  To determine the name, use this command:

```
systemctl --user status | grep -B 1 kiod
```

The output should contain two lines that look like this:

```
│ ├─dbus-:1.2-org.kde.kmtpd5@0.service
│ │ └─32221 /usr/libexec/kf6/kiod6
```

This tells you that `kiod6` was started by the `dbus-:1.2-org.kde.kmtpd5@0.service`, so that
is the service that needs to be stopped.
